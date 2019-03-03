module TokensBase where

-- -----------------------------------------------------------------------------
-- Custom Alex wrapper code, incorporate Int into Alex monad such that we carry the offset of the error all the way to the end
-- Based off Alex monad wrapper
import           Control.Applicative as App (Applicative (..))

import qualified Data.Bits
import           Data.Char           (ord)
import           Data.Word           (Word8)

alex_tab_size :: Int
alex_tab_size = 8

-- | Encode a Haskell String to a list of Word8 values, in UTF8 format.
utf8Encode :: Char -> [Word8]
utf8Encode = map fromIntegral . go . ord
  where
    go oc
      | oc <= 0x7f = [oc]
      | oc <= 0x7ff =
        [0xc0 + (oc `Data.Bits.shiftR` 6), 0x80 + oc Data.Bits..&. 0x3f]
      | oc <= 0xffff =
        [ 0xe0 + (oc `Data.Bits.shiftR` 12)
        , 0x80 + ((oc `Data.Bits.shiftR` 6) Data.Bits..&. 0x3f)
        , 0x80 + oc Data.Bits..&. 0x3f
        ]
      | otherwise =
        [ 0xf0 + (oc `Data.Bits.shiftR` 18)
        , 0x80 + ((oc `Data.Bits.shiftR` 12) Data.Bits..&. 0x3f)
        , 0x80 + ((oc `Data.Bits.shiftR` 6) Data.Bits..&. 0x3f)
        , 0x80 + oc Data.Bits..&. 0x3f
        ]

type Byte = Word8

-- -----------------------------------------------------------------------------
-- The input type
type AlexInput
   = ( AlexPosn -- current position,
     , Char -- previous char
     , [Byte] -- pending bytes on current char
     , String -- current input string
      )

alexGetByte :: AlexInput -> Maybe (Byte, AlexInput)
alexGetByte (p, c, b:bs, s) = Just (b, (p, c, bs, s))
alexGetByte (_, _, [], []) = Nothing
alexGetByte (p, _, [], c:s) =
  let p' = alexMove p c
      (b:bs) = utf8Encode c
   in p' `seq` Just (b, (p', c, bs, s))

ignorePendingBytes :: AlexInput -> AlexInput
ignorePendingBytes (p, c, _ps, s) = (p, c, [], s)

alexInputPrevChar :: AlexInput -> Char
alexInputPrevChar (_p, c, _bs, _s) = c

-- -----------------------------------------------------------------------------
-- Token positions
-- `Posn' records the location of a token in the input text.  It has three
-- fields: the address (number of chacaters preceding the token), line number
-- and column of a token within the file. `start_pos' gives the position of the
-- start of the file and `eof_pos' a standard encoding for the end of file.
-- `move_pos' calculates the new position after traversing a given character,
-- assuming the usual eight character tab stops.
data AlexPosn =
  AlexPn !Int
         !Int
         !Int
  deriving (Eq, Show)

alexStartPos :: AlexPosn
alexStartPos = AlexPn 0 1 1

alexMove :: AlexPosn -> Char -> AlexPosn
alexMove (AlexPn a l c) '\t' =
  AlexPn
    (a + 1)
    l
    (((c + alex_tab_size - 1) `div` alex_tab_size) * alex_tab_size + 1)
alexMove (AlexPn a l _) '\n' = AlexPn (a + 1) (l + 1) 1
alexMove (AlexPn a l c) _ = AlexPn (a + 1) l (c + 1)

-- -----------------------------------------------------------------------------
-- Default monad
data AlexState = AlexState
  { alex_pos   :: !AlexPosn -- position at current input location
  , alex_inp   :: String -- the current input
  , alex_chr   :: !Char -- the character before the input
  , alex_bytes :: [Byte]
  , alex_scd   :: !Int -- the current startcode
  }

-- Compile with -funbox-strict-fields for best results!
-- | inpNL, input new line if input does not end with a newline
inpNL :: String -> String
inpNL s = reverse $ inpNLR s []

inpNLR :: String -> String -> String
inpNLR s r =
  case s of
    "\n" -> '\n' : r
    []   -> '\n' : r
    h:t  -> inpNLR t (h : r)

runAlex' :: String -> Alex a -> Either (String, Int) a
runAlex' s (Alex f) =
  snd <$>
  f (AlexState
       { alex_pos = alexStartPos
       , alex_inp = s
       , alex_chr = '\n'
       , alex_bytes = []
       , alex_scd = 0
       })

-- | Wrapper for runAlex' to process output through inpNL and also initialize AlexUserState
runAlex :: String -> Alex a -> Either (String, Int) a
runAlex s = runAlex' (inpNL s)

newtype Alex a = Alex
  { unAlex :: AlexState -> Either (String, Int) (AlexState, a)
  }

instance Functor Alex where
  fmap = fmap

instance Applicative Alex where
  pure a = Alex $ \s -> Right (s, a)
  fa <*> a = fa <*> a

instance Monad Alex where
  m >>= k = Alex $ \s -> either Left (\(s', a) -> unAlex (k a) s') (unAlex m s)
  return = App.pure

alexGetInput :: Alex AlexInput
alexGetInput =
  Alex $ \s@AlexState { alex_pos = pos
                      , alex_chr = c
                      , alex_bytes = bs
                      , alex_inp = inp__
                      } -> Right (s, (pos, c, bs, inp__))

alexSetInput :: AlexInput -> Alex ()
alexSetInput (pos, c, bs, inp__) =
  Alex $ \s ->
    case s {alex_pos = pos, alex_chr = c, alex_bytes = bs, alex_inp = inp__} of
      state__@AlexState {} -> Right (state__, ())

alexError :: (String, Int) -> Alex a
alexError = Alex . const . Left

alexGetStartCode :: Alex Int
alexGetStartCode = Alex $ \s@AlexState {alex_scd = sc} -> Right (s, sc)

alexSetStartCode :: Int -> Alex ()
alexSetStartCode sc = Alex $ \s -> Right (s {alex_scd = sc}, ())

-- -----------------------------------------------------------------------------
-- Useful token actions
type AlexAction result = AlexInput -> Int -> Alex result

-- perform an action for this token, and set the start code to a new value
andBegin :: AlexAction result -> Int -> AlexAction result
andBegin action code input__ len = do
  alexSetStartCode code
  action input__ len

token :: (AlexInput -> Int -> token) -> AlexAction token
token t input__ len = return (t input__ len)
