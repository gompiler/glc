module Scanner (P, thenP, returnP, showError, getPos, happyError, lexer, scanP, scanC, putExit, prettify, T.Token(..), T.InnerToken(..), T.AlexPosn(..), T.alexError, T.runAlex, T.Alex) where

-- Helper functions for scanning using tokens and also pass relevant things to parser

import qualified Tokens as T
import System.Exit
import System.IO

-- TODO: Finish implementing prettify

-- |prettify, takes a token and turn it into a string representing said token
-- Also makes the tokens look like the expected tTYPE format
prettify :: T.InnerToken -> String
prettify t = case t of
  T.TColon         -> "tCOLON"
  T.TSemicolon     -> "tSEMICOLON"
  T.TLParen        -> "tLEFTPAREN"
  T.TRParen        -> "tRIGHTPAREN"
  T.TLBrace        -> "tLEFTBRACE"
  T.TRBrace        -> "tRIGHTBRACE"
  T.TPlus          -> "tPLUS"
  T.TMinus         -> "tMINUS"
  T.TTimes         -> "tTIMES"
  T.TDiv           -> "tDIV"
  T.TAssn          -> "tASSIGN"
  T.TGt            -> "tGREATER"
  T.TLt            -> "tLESS"
  T.TNot           -> "tBANG"
  T.TEq            -> "tEQUALS"
  T.TNEq           -> "tNOTEQUALS"
  T.TGEq           -> "tGREATEREQUALS"
  T.TLEq           -> "tLESSEQUALS"
  T.TAnd           -> "tAND"
  T.TOr            -> "tOR"
  T.TVar           -> "tVAR"
  T.TIf            -> "tIF"
  T.TElse          -> "tELSE"
  T.TPrint         -> "tPRINT"
  (T.TIntVal i)    -> "tINTVAL(" ++ show i ++ ")"
  (T.TFloatVal f)  -> "tFLOATVAL(" ++ show f ++ ")"
  (T.TStringVal s) -> "tSTRINGVAL(" ++ s ++ ")"
  (T.TIdent s)     -> "tIDENT(" ++ s ++ ")"
  T.TEOF           -> error "TEOF should not be converted into a string"

-- |prettyPrint calls prettify on a list of tokens and then prints each one one a new line
prettyPrint :: [T.InnerToken] -> IO ()
prettyPrint tList = mapM_ (putStrLn . prettify) tList

-- | Custom definition of alexMonadScan to modify the error message with more info
alexMonadScan = do
  inp__ <- T.alexGetInput
  sc <- T.alexGetStartCode
  case T.alexScan inp__ sc of
    T.AlexEOF -> T.alexEOF
    T.AlexError (T.AlexPn _ line column,prev,_,s) -> T.alexError $ "Error: lexical error at line " ++ show line ++ ", column " ++ show column ++ ". Previous character: " ++ show prev ++ ", current string: " ++ s
    T.AlexSkip  inp__' _len -> do
        T.alexSetInput inp__'
        alexMonadScan
    T.AlexToken inp__' len action -> do
        T.alexSetInput inp__'
        action (T.ignorePendingBytes inp__) len

-- | scan, the main scan function. Takes input String and runs it through a recursive loop that keeps processing it through the alex Monad
-- Note that it is possible here to get a T.TInvalidI in the T.InnerToken list, so it must be accounted for in other functions that use scan's output
scan :: String -> Either String [T.InnerToken]
scan s = T.runAlex s $ do let loop tokl =
                                do (T.Token _ tok) <- alexMonadScan;
                                     if tok == T.TEOF then return tokl
                                     else loop (tok:tokl)
                          loop []

-- | putExit: function to output to stderr and exit with return code 1
putExit :: String -> IO ()
putExit err = do hPutStrLn stderr err
                 exitFailure

-- | Print result of scan, i.e. tokens or error
scanP :: String -> IO ()
scanP s = either putExit (\tl -> (putStrLn $ show $ reverse tl) >> exitSuccess) (scan s)
                            -- Pretty print tokens once implemented
                            -- prettyPrint $ reverse tl >>

-- | Check for error, if none will print OK
scanC :: String -> IO ()
scanC s = either putExit (\tl -> putStrLn "OK" >> exitSuccess) (scan s)

-- | Monad types/functions to allow the scanner to interface with the parser
type P a = T.Alex a

thenP :: P a -> (a -> P b) -> P b
thenP = (>>=)

returnP :: a -> P a
returnP = return

-- | showError will be passed to happyError and will define behavior on parser errors
showError :: (Show a, Show b) => (a, b, Maybe String) -> T.Alex c
showError (l, c, s) = T.alexError ("Error: parsing error at line " ++ show l ++ " column " ++ show c)

getPos :: T.Alex T.AlexPosn
getPos = T.Alex (\s -> Right (s, T.alex_pos s))

happyError :: P a
happyError = do
  (T.AlexPn _ l c) <- getPos
  showError (l, c, Nothing)

lexer :: (T.Token -> P a) -> P a
lexer s = alexMonadScan >>= s
