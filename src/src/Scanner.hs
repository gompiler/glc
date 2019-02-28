module Scanner
  ( showError
  , getPos
  , happyError
  , lexer
  , scanT
  , scanP
  , scanC
  , putExit
  , putSucc
  , prettify
  , T.Token(..)
  , T.InnerToken(..)
  , T.AlexPosn(..)
  , T.alexError
  , T.runAlex
  , T.Alex
  ) where

import           System.Exit
import           System.IO

-- Helper functions for scanning using tokens and also pass relevant things to parser
import qualified Tokens      as T

-- |prettify, takes a token and turn it into a string representing said token
-- Also makes the tokens look like the expected tTYPE format
prettify :: T.InnerToken -> String
prettify t =
  case t of
    T.TBreak          -> "tBREAK"
    T.TChan           -> "tCHAN"
    T.TConst          -> "tCONST"
    T.TContinue       -> "tCONTINUE"
    T.TDefault        -> "tDEFAULT"
    T.TDefer          -> "tDEFER"
    T.TElse           -> "tELSE"
    T.TFallthrough    -> "tFALLTHROUGH"
    T.TFor            -> "tFOR"
    T.TFunc           -> "tFUNC"
    T.TGo             -> "tGO"
    T.TGoto           -> "tGOTO"
    T.TIf             -> "tIF"
    T.TImport         -> "tIMPORT"
    T.TInterface      -> "tINTERFACE"
    T.TMap            -> "tMAP"
    T.TPackage        -> "tPACKAGE"
    T.TRange          -> "tRANGE"
    T.TReturn         -> "tRETURN"
    T.TSelect         -> "tSELECT"
    T.TStruct         -> "tSTRUCT"
    T.TSwitch         -> "tSWITCH"
    T.TComma          -> "tCOMMA"
    T.TDot            -> "tDOT"
    T.TColon          -> "tCOLON"
    T.TSemicolon      -> "tSEMICOLON"
    T.TLParen         -> "tLPAREN"
    T.TRParen         -> "tRPAREN"
    T.TLSquareB       -> "tLBRACKET"
    T.TRSquareB       -> "tRBRACKET"
    T.TLBrace         -> "tLBRACE"
    T.TRBrace         -> "tRBRACE"
    T.TPlus           -> "tPLUS"
    T.TMinus          -> "tMINUS"
    T.TTimes          -> "tTIMES"
    T.TDiv            -> "tDIV"
    T.TMod            -> "tREM"
    T.TAssn           -> "tASSIGN"
    T.TGt             -> "tGREATER"
    T.TLt             -> "tLESS"
    T.TNot            -> "tBANG"
    T.TEq             -> "tEQUALS"
    T.TNEq            -> "tNOTEQUALS"
    T.TGEq            -> "tGREATEREQUALS"
    T.TLEq            -> "tLESSEQUALS"
    T.TAnd            -> "tAND"
    T.TOr             -> "tOR"
    T.TLAnd           -> "tBWAND"
    T.TLOr            -> "tBWOR"
    T.TLXor           -> "tBWXOR"
    T.TLeftS          -> "tLSHIFT"
    T.TRightS         -> "tRSHIFT"
    T.TLAndNot        -> "tBWANDNOT"
    T.TIncA           -> "tPLUSASSIGN"
    T.TDIncA          -> "tMINUSASSIGN"
    T.TMultA          -> "tTIMESASSIGN"
    T.TDivA           -> "tDIVASSIGN"
    T.TModA           -> "tREMASSIGN"
    T.TLAndA          -> "tBWANDASSIGN"
    T.TLOrA           -> "tBWORASSIGN"
    T.TLXorA          -> "tBWXORASSIGN"
    T.TLeftSA         -> "tLSHIFTASSIGN"
    T.TRightSA        -> "tRSHIFTASSIGN"
    T.TLAndNotA       -> "tBWANDNOTASSIGN"
    T.TRecv           -> "tARROW"
    T.TDeclA          -> "tDEFINE"
    T.TLdots          -> "tELLIPSIS"
    T.TVar            -> "tVAR"
    (T.TDecVal s)     -> "tINTVAL(" ++ s ++ ")"
    (T.TOctVal s)     -> "tINTVAL(" ++ s ++ ")"
    (T.THexVal s)     -> "tINTVAL(" ++ s ++ ")"
    (T.TFloatVal f)   -> "tFLOATVAL(" ++ show f ++ ")"
    (T.TRuneVal c)    -> "tRUNEVAL(" ++ show c ++ ")"
    (T.TStringVal s)  -> "tSTRINGVAL(" ++ s ++ ")"
    (T.TRStringVal s) -> "tSTRINGVAL(" ++ s ++ ")"
    (T.TIdent s)      -> "tIDENTIFIER(" ++ s ++ ")"
    T.TCase           -> "tCASE"
    T.TPrint          -> "tPRINT"
    T.TPrintln        -> "tPRINTLN"
    T.TType           -> "tTYPE"
    T.TAppend         -> "tAPPEND"
    T.TLen            -> "tLEN"
    T.TCap            -> "tCAP"
    T.TInc            -> "tINC"
    T.TDInc           -> "tDEC"
    T.TEOF            -> error "TEOF should not be converted into a string"

-- |prettyPrint calls prettify on a list of tokens and then prints each one one a new line
prettyPrint :: [T.InnerToken] -> IO ()
prettyPrint = mapM_ (putStrLn . prettify)

-- | Custom definition of alexMonadScan to modify the error message with more info
alexMonadScan :: T.Alex T.Token
alexMonadScan = do
  inp__ <- T.alexGetInput
  sc <- T.alexGetStartCode
  case T.alexScan inp__ sc of
    T.AlexEOF -> T.alexEOF
    T.AlexError (T.AlexPn _ line column, prev, _, s) ->
      T.alexError $
      "Error: lexical error at line " ++
      show line ++
      ", column " ++
      show column ++
      ". Previous character: " ++ show prev ++ ", current string: " ++ s
    T.AlexSkip inp__' _len -> do
      T.alexSetInput inp__'
      alexMonadScan
    T.AlexToken inp__' len action -> do
      T.alexSetInput inp__'
      action (T.ignorePendingBytes inp__) len

-- | scan, the main scan function. Takes input String and runs it through a recursive loop that keeps processing it through the alex Monad
scan :: String -> Either String [T.InnerToken]
scan s =
  T.runAlex s $ do
    let loop tokl = do
          (T.Token _ tok) <- alexMonadScan
          if tok == T.TEOF
            then return tokl
            else loop (tok : tokl)
    loop []

scanT :: String -> Either String [T.InnerToken]
scanT s = fmap reverse (scan s)

-- | putExit: function to output to stderr and exit with return code 1
putExit :: String -> IO ()
putExit err = hPutStrLn stderr err >> exitFailure

-- | putSucc: output to stdin and exit with success
putSucc :: String -> IO ()
putSucc s = putStrLn s >> exitSuccess

-- | Print result of scan, i.e. tokens or error
scanP :: String -> IO ()
scanP s =
  either putExit (\tl -> prettyPrint (reverse tl) >> exitSuccess) (scan s)

-- | Check for error, if none will print OK
scanC :: String -> IO ()
scanC s = either putExit (const $ putStrLn "OK" >> exitSuccess) (scan s)

-- | showError will be passed to happyError and will define behavior on parser errors
showError :: (Show a, Show b) => (a, b, Maybe String) -> T.Alex c
showError (l, c, _) =
  T.alexError
    ("Error: parsing error at line " ++ show l ++ " column " ++ show c)

getPos :: T.Alex T.AlexPosn
getPos = T.Alex (\s -> Right (s, T.alex_pos s))

happyError :: T.Alex a
happyError = do
  (T.AlexPn _ l c) <- getPos
  showError (l, c, Nothing)

lexer :: (T.Token -> T.Alex a) -> T.Alex a
lexer s = alexMonadScan >>= s
