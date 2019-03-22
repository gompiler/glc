module Scanner
  ( lexer
  , scanT
  , scanP
  , scanC
  , putExit
  , putSucc
  , prettify
  , humanize
  , T.Token(..)
  , T.InnerToken(..)
  , T.AlexPosn(..)
  , T.alexError
  , T.runAlex
  , T.runAlex'
  , T.Alex
  , errODef
  ) where

import           System.Exit
import           System.IO

import           Base

-- Helper functions for scanning using tokens and also pass relevant things to parser
import qualified TokenGen    as T

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

-- | Like prettify but more human readable for compile errors
humanize :: T.InnerToken -> String
humanize t =
  case t of
    T.TBreak          -> "break"
    T.TChan           -> "chan"
    T.TConst          -> "const"
    T.TContinue       -> "continue"
    T.TDefault        -> "default"
    T.TDefer          -> "defer"
    T.TElse           -> "else"
    T.TFallthrough    -> "fallthrough"
    T.TFor            -> "for"
    T.TFunc           -> "func"
    T.TGo             -> "go"
    T.TGoto           -> "goto"
    T.TIf             -> "if"
    T.TImport         -> "import"
    T.TInterface      -> "interface"
    T.TMap            -> "map"
    T.TPackage        -> "package"
    T.TRange          -> "range"
    T.TReturn         -> "return"
    T.TSelect         -> "select"
    T.TStruct         -> "struct"
    T.TSwitch         -> "switch"
    T.TComma          -> ","
    T.TDot            -> "."
    T.TColon          -> ":"
    T.TSemicolon      -> ";"
    T.TLParen         -> "("
    T.TRParen         -> ")"
    T.TLSquareB       -> "["
    T.TRSquareB       -> "]"
    T.TLBrace         -> "{"
    T.TRBrace         -> "}"
    T.TPlus           -> "+"
    T.TMinus          -> "-"
    T.TTimes          -> "*"
    T.TDiv            -> "/"
    T.TMod            -> "%"
    T.TAssn           -> "="
    T.TGt             -> ">"
    T.TLt             -> "<"
    T.TNot            -> "!"
    T.TEq             -> "=="
    T.TNEq            -> "!="
    T.TGEq            -> ">="
    T.TLEq            -> "<="
    T.TAnd            -> "&&"
    T.TOr             -> "||"
    T.TLAnd           -> "&"
    T.TLOr            -> "|"
    T.TLXor           -> "&"
    T.TLeftS          -> "<<"
    T.TRightS         -> ">>"
    T.TLAndNot        -> "&^"
    T.TIncA           -> "+="
    T.TDIncA          -> "-="
    T.TMultA          -> "*="
    T.TDivA           -> "/="
    T.TModA           -> "%="
    T.TLAndA          -> "&="
    T.TLOrA           -> "|="
    T.TLXorA          -> "^="
    T.TLeftSA         -> "<<="
    T.TRightSA        -> ">>="
    T.TLAndNotA       -> "&^="
    T.TRecv           -> "->"
    T.TDeclA          -> ":="
    T.TLdots          -> "..."
    T.TVar            -> "var"
    (T.TDecVal _)     -> "int"
    (T.TOctVal _)     -> "int"
    (T.THexVal _)     -> "int"
    (T.TFloatVal _)   -> "float"
    (T.TRuneVal _)    -> "rune"
    (T.TStringVal _)  -> "string"
    (T.TRStringVal _) -> "string"
    (T.TIdent s)      -> "identifier " ++ s
    T.TCase           -> "case"
    T.TPrint          -> "print"
    T.TPrintln        -> "println"
    T.TType           -> "type"
    T.TAppend         -> "append"
    T.TLen            -> "len"
    T.TCap            -> "cap"
    T.TInc            -> "++"
    T.TDInc           -> "--"
    T.TEOF            -> "EOF" -- error "TEOF should not be converted into a string"

-- |prettyPrint calls prettify on a list of tokens and then prints each one one a new line
prettyPrint :: [T.InnerToken] -> IO ()
prettyPrint = mapM_ (putStrLn . prettify)

-- | scan', the main scan function. Takes input String and runs it through a recursive loop that keeps processing it through the alex Monad
scan' :: String -> Glc' [T.InnerToken]
scan' s =
  T.runAlex s $ do
    let loop tokl = do
          (T.Token _ tok) <- T.alexMonadScan
          if tok == T.TEOF
            then return tokl
            else loop (tok : tokl)
    loop []

-- | Helper to process offsets
scan :: String -> Either ErrorMessage [T.InnerToken]
scan s = either (Left . errODef s) Right (scan' s)

-- | Passes input to error bundle
errODef :: String -> ErrorMessage' -> ErrorMessage
errODef input err = err input

scanT :: String -> Either ErrorMessage [T.InnerToken]
scanT s = fmap reverse (scan s)

-- | putExit: function to output to stderr and exit with return code 1
putExit :: ErrorMessage -> IO ()
putExit err = hPrint stderr err >> exitFailure

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

lexer :: (T.Token -> T.Alex a) -> T.Alex a
lexer s = T.alexMonadScan >>= s
