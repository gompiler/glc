{-# LANGUAGE QuasiQuotes #-}

module TokensSpec
  ( spec
  ) where

import CommonTest
import           Data.Text         (Text, unpack)
import           NeatInterpolation
import           Scanner
import           Test.Hspec

spec :: Spec
spec =
  describe "scanT" $ do
    specWithG scanT  (";", Right ([TSemicolon]))
    mapM_ (specWithG scanT) expectScanT

expectScanT :: [(String, Either String [InnerToken])]
expectScanT =
  [ ("break", Right [TBreak])
  , ("break\n", Right [TBreak, TSemicolon])
  , ("break\r", Right [TBreak, TSemicolon])
  , ("break;", Right [TBreak, TSemicolon])
  , ("break;\n", Right [TBreak, TSemicolon])
  , ("break\n;", Right [TBreak, TSemicolon, TSemicolon])
  , ("break ;", Right [TBreak, TSemicolon])
  , ("break \n", Right [TBreak, TSemicolon])
  , ("break \n;", Right [TBreak, TSemicolon, TSemicolon])
  , ("chan", Right [TChan])
  , ("const", Right [TConst])
  , ("continue", Right [TContinue])
  , ("continue\n", Right [TContinue, TSemicolon])
  , ("continue;", Right [TContinue, TSemicolon])
  , ("default", Right [TDefault])
  , ("defer", Right [TDefer])
  , ("else", Right [TElse])
  , ("fallthrough", Right [TFallthrough])
  , ("fallthrough\n", Right [TFallthrough, TSemicolon])
  , ("fallthrough;\n", Right [TFallthrough, TSemicolon])
  , ("for", Right [TFor])
  , ("func", Right [TFunc])
  , ("go", Right [TGo])
  , ("goto", Right [TGoto])
  , ("if", Right [TIf])
  , ("import", Right [TImport])
  , ("interface", Right [TInterface])
  , ("map", Right [TMap])
  , ("package", Right [TPackage])
  , ("range", Right [TRange])
  , ("return", Right [TReturn])
  , ("return\n", Right [TReturn, TSemicolon])
  , ("return;\n", Right [TReturn, TSemicolon])
  , ("select", Right [TSelect])
  , ("struct", Right [TStruct])
  , ("switch", Right [TSwitch])
  , (",", Right [TComma])
  , (".", Right [TDot])
  , (":", Right [TColon])
  , (";", Right [TSemicolon])
  , (";;;", Right [TSemicolon, TSemicolon, TSemicolon])
  , ("(", Right [TLParen])
  , (")", Right [TRParen])
  , (")\n", Right [TRParen, TSemicolon])
  , (");\n", Right [TRParen, TSemicolon])
  , ("[", Right [TLSquareB])
  , ("]", Right [TRSquareB])
  , ("]\n", Right [TRSquareB, TSemicolon])
  , ("];\n", Right [TRSquareB, TSemicolon])
  , ("{", Right [TLBrace])
  , ("}", Right [TRBrace])
  , ("}\n", Right [TRBrace, TSemicolon])
  , ("};\n", Right [TRBrace, TSemicolon])
  , ("+", Right [TPlus])
  , ("-", Right [TMinus])
  , ("*", Right [TTimes])
  , ("/", Right [TDiv])
  , ("%", Right [TMod])
  , ("=", Right [TAssn])
  , (">", Right [TGt])
  , ("<", Right [TLt])
  , ("!", Right [TNot])
  , ("==", Right [TEq])
  , ("!=", Right [TNEq])
  , (">=", Right [TGEq])
  , ("<=", Right [TLEq])
  , ("&&", Right [TAnd])
  , ("||", Right [TOr])
  , ("&", Right [TLAnd])
  , ("|", Right [TLOr])
  , ("^", Right [TLXor])
  , ("<<", Right [TLeftS])
  , (">>", Right [TRightS])
  , ("&^", Right [TLAndNot])
  , ("+=", Right [TIncA])
  , ("-=", Right [TDIncA])
  , ("*=", Right [TMultA])
  , ("/=", Right [TDivA])
  , ("%=", Right [TModA])
  , ("&=", Right [TLAndA])
  , ("|=", Right [TLOrA])
  , ("^=", Right [TLXorA])
  , ("<<=", Right [TLeftSA])
  , (">>=", Right [TRightSA])
  , ("&^=", Right [TLAndNotA])
  , ("<-", Right [TRecv])
  , (":=", Right [TDeclA])
  , ("...", Right [TLdots])
  , ("12947631951", Right [TDecVal "12947631951"])
  , ("12947631951\n", Right [TDecVal "12947631951", TSemicolon])
  , ("12947631951;\n", Right [TDecVal "12947631951", TSemicolon])
  , ("003777", Right [TOctVal "003777"])
  , ("0xCAFEBABE", Right [THexVal "0xCAFEBABE"])
  , ("0XCAFEBABE", Right [THexVal "0XCAFEBABE"])
  , ("0xcAFEbABE", Right [THexVal "0xcAFEbABE"])
  , ("0xcafebabe", Right [THexVal "0xcafebabe"])
  , ("0XcAFEbABE", Right [THexVal "0XcAFEbABE"])
  , ("0Xcafebabe", Right [THexVal "0Xcafebabe"])
  , ("003777\n", Right [TOctVal "003777", TSemicolon])
  , ("0xCAFEBABE\n", Right [THexVal "0xCAFEBABE", TSemicolon])
  , ("0XCAFEBABE\n", Right [THexVal "0XCAFEBABE", TSemicolon])
  , ("0xcAFEbABE\n", Right [THexVal "0xcAFEbABE", TSemicolon])
  , ("0xcafebabe\n", Right [THexVal "0xcafebabe", TSemicolon])
  , ("0XcAFEbABE\n", Right [THexVal "0XcAFEbABE", TSemicolon])
  , ("0Xcafebabe\n", Right [THexVal "0Xcafebabe", TSemicolon])
  , ("003777;\n", Right [TOctVal "003777", TSemicolon])
  , ("0xCAFEBABE;\n", Right [THexVal "0xCAFEBABE", TSemicolon])
  , ("0XCAFEBABE;\n", Right [THexVal "0XCAFEBABE", TSemicolon])
  , ("0xcAFEbABE;\n", Right [THexVal "0xcAFEbABE", TSemicolon])
  , ("0xcafebabe;\n", Right [THexVal "0xcafebabe", TSemicolon])
  , ("0XcAFEbABE;\n", Right [THexVal "0XcAFEbABE", TSemicolon])
  , ("0Xcafebabe;\n", Right [THexVal "0Xcafebabe", TSemicolon])
  , ("\"teststring\"", Right [TStringVal "\"teststring\""])
  , ("\"teststring\\n\"", Right [TStringVal "\"teststring\\n\""])
  , ("\"teststring\"\n", Right [TStringVal "\"teststring\"", TSemicolon])
  , ("\"teststring\\n\"\n", Right [TStringVal "\"teststring\\n\"", TSemicolon])
  , ("\"teststring\"\n", Right [TStringVal "\"teststring\"", TSemicolon])
  , ("`teststring`", Right [TRStringVal "`teststring`"])
  , ("`teststring`\n", Right [TRStringVal "`teststring`", TSemicolon])
  , ("`teststring`;\n", Right [TRStringVal "`teststring`", TSemicolon])
  , ("1.23", Right [TFloatVal 1.23])
  , ("1.23\n", Right [TFloatVal 1.23, TSemicolon])
  , ("1.23; \n", Right [TFloatVal 1.23, TSemicolon])
  , ("help\n", Right [TIdent "help", TSemicolon])
  , ("help;\n", Right [TIdent "help", TSemicolon])
  , ("help ;\n", Right [TIdent "help", TSemicolon])
  -- , ("help \n", Right ([TIdent "help", TSemicolon]))
  , ("case", Right [TCase])
  , ("print", Right [TPrint])
  , ("println", Right [TPrintln])
  , ("type", Right [TType])
  , ("append", Right [TAppend])
  , ("len", Right [TLen])
  , ("cap", Right [TCap])
  , ("++", Right [TInc])
  , ("++\n", Right [TInc, TSemicolon])
  , ("++;", Right [TInc, TSemicolon])
  , ("--", Right [TDInc])
  , ("--\n", Right [TDInc, TSemicolon])
  , ("--;", Right [TDInc, TSemicolon])
  , ("'a'", Right [TRuneVal 'a'])
  , ("'a'\n", Right [TRuneVal 'a', TSemicolon])
  , ("", Right [])
  , ("\n", Right [])
  , ("\r", Right [])
  , ("// This is a comment", Right [])
  , ("/* Block comment */", Right [])
  , ("a /* Block \n */", Right ([TIdent "a", TSemicolon]))
               -- This will have to change if we change error printing
  , ("''", Left "Error: lexical error at line 1, column 3. Previous character: '\\\'', current string: ")
  , ("var", Right [TVar])
  , ("break varname;", Right [TBreak, TIdent "varname", TSemicolon])
  , ("break varname\n", Right [TBreak, TIdent "varname", TSemicolon])
  , ("break varname;\n", Right [TBreak, TIdent "varname", TSemicolon])
  , ("break varname \n", Right [TBreak, TIdent "varname", TSemicolon])
  , ("break +\n", Right [TBreak, TPlus])
  , ("testid", Right [TIdent "testid"])
  , ("identttt", Right[TIdent "identttt"])
  , ("_", Right[TIdent "_"])
  , ("a, b, dddd", Right[TIdent "a", TComma, TIdent "b", TComma, TIdent "dddd"])
  , ("weirdsp, _   ,aacing", Right[TIdent "weirdsp", TComma, TIdent "_", TComma, TIdent "aacing"])
  , ("weirdsp, _   \n,aacing", Right[TIdent "weirdsp", TComma, TIdent "_", TSemicolon, TComma, TIdent "aacing"])
  , ( unpack
        [text|
          /* Long block comment
          here's another line
          and another
          */
        |]
    , Right [])
  , ( unpack
        [text|
          /* Long block comment no new line */
        |]
    , Right [])
  , ( unpack
        [text|
          // Short comments
          // More
        |]
    , Right [])
  , ( unpack
        [text|
          break /* Multiline to simulate
          a new line */
        |]
    , Right [TBreak, TSemicolon])
  ]
-- expectScanP :: [(String, String, Either String [InnerToken])]
-- expectScanP = [("Prints tBREAK tSEMICOLON when given `break`")]
