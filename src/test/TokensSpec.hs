{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TypeSynonymInstances  #-}

module TokensSpec
  ( spec
  ) where

import           Base
import           Scanner

spec :: Spec
spec = specAll "scanner" scanInputs

instance SpecBuilder String (Either String [InnerToken]) () where
  expectation input output = it (show $ lines input) $ scanT input `shouldBe` output

scanInputs = specConvert Right scanSuccess ++ specConvert Left scanFailure

scanSuccess :: [(String, [InnerToken])]
scanSuccess =
  [ (";", [TSemicolon])
  , ("break", [TBreak])
  , ("break\n", [TBreak, TSemicolon])
  , ("break\r", [TBreak, TSemicolon])
  , ("break;", [TBreak, TSemicolon])
  , ("break;\n", [TBreak, TSemicolon])
  , ("break\n;", [TBreak, TSemicolon, TSemicolon])
  , ("break ;", [TBreak, TSemicolon])
  , ("break \n", [TBreak, TSemicolon])
  , ("break \n;", [TBreak, TSemicolon, TSemicolon])
  , ("chan", [TChan])
  , ("const", [TConst])
  , ("continue", [TContinue])
  , ("continue\n", [TContinue, TSemicolon])
  , ("continue;", [TContinue, TSemicolon])
  , ("default", [TDefault])
  , ("defer", [TDefer])
  , ("else", [TElse])
  , ("fallthrough", [TFallthrough])
  , ("fallthrough\n", [TFallthrough, TSemicolon])
  , ("fallthrough;\n", [TFallthrough, TSemicolon])
  , ("for", [TFor])
  , ("func", [TFunc])
  , ("go", [TGo])
  , ("goto", [TGoto])
  , ("if", [TIf])
  , ("import", [TImport])
  , ("interface", [TInterface])
  , ("map", [TMap])
  , ("package", [TPackage])
  , ("range", [TRange])
  , ("return", [TReturn])
  , ("return\n", [TReturn, TSemicolon])
  , ("return;\n", [TReturn, TSemicolon])
  , ("select", [TSelect])
  , ("struct", [TStruct])
  , ("switch", [TSwitch])
  , (",", [TComma])
  , (".", [TDot])
  , (":", [TColon])
  , (";", [TSemicolon])
  , (";;;", [TSemicolon, TSemicolon, TSemicolon])
  , ("(", [TLParen])
  , (")", [TRParen])
  , (")\n", [TRParen, TSemicolon])
  , (");\n", [TRParen, TSemicolon])
  , ("[", [TLSquareB])
  , ("]", [TRSquareB])
  , ("]\n", [TRSquareB, TSemicolon])
  , ("];\n", [TRSquareB, TSemicolon])
  , ("{", [TLBrace])
  , ("}", [TRBrace])
  , ("}\n", [TRBrace, TSemicolon])
  , ("};\n", [TRBrace, TSemicolon])
  , ("+", [TPlus])
  , ("-", [TMinus])
  , ("*", [TTimes])
  , ("/", [TDiv])
  , ("%", [TMod])
  , ("=", [TAssn])
  , (">", [TGt])
  , ("<", [TLt])
  , ("!", [TNot])
  , ("==", [TEq])
  , ("!=", [TNEq])
  , (">=", [TGEq])
  , ("<=", [TLEq])
  , ("&&", [TAnd])
  , ("||", [TOr])
  , ("&", [TLAnd])
  , ("|", [TLOr])
  , ("^", [TLXor])
  , ("<<", [TLeftS])
  , (">>", [TRightS])
  , ("&^", [TLAndNot])
  , ("+=", [TIncA])
  , ("-=", [TDIncA])
  , ("*=", [TMultA])
  , ("/=", [TDivA])
  , ("%=", [TModA])
  , ("&=", [TLAndA])
  , ("|=", [TLOrA])
  , ("^=", [TLXorA])
  , ("<<=", [TLeftSA])
  , (">>=", [TRightSA])
  , ("&^=", [TLAndNotA])
  , ("<-", [TRecv])
  , (":=", [TDeclA])
  , ("...", [TLdots])
  , ("12947631951", [TDecVal "12947631951"])
  , ("12947631951\n", [TDecVal "12947631951", TSemicolon])
  , ("12947631951;\n", [TDecVal "12947631951", TSemicolon])
  , ("003777", [TOctVal "003777"])
  , ("0xCAFEBABE", [THexVal "0xCAFEBABE"])
  , ("0XCAFEBABE", [THexVal "0XCAFEBABE"])
  , ("0xcAFEbABE", [THexVal "0xcAFEbABE"])
  , ("0xcafebabe", [THexVal "0xcafebabe"])
  , ("0XcAFEbABE", [THexVal "0XcAFEbABE"])
  , ("0Xcafebabe", [THexVal "0Xcafebabe"])
  , ("003777\n", [TOctVal "003777", TSemicolon])
  , ("0xCAFEBABE\n", [THexVal "0xCAFEBABE", TSemicolon])
  , ("0XCAFEBABE\n", [THexVal "0XCAFEBABE", TSemicolon])
  , ("0xcAFEbABE\n", [THexVal "0xcAFEbABE", TSemicolon])
  , ("0xcafebabe\n", [THexVal "0xcafebabe", TSemicolon])
  , ("0XcAFEbABE\n", [THexVal "0XcAFEbABE", TSemicolon])
  , ("0Xcafebabe\n", [THexVal "0Xcafebabe", TSemicolon])
  , ("003777;\n", [TOctVal "003777", TSemicolon])
  , ("0xCAFEBABE;\n", [THexVal "0xCAFEBABE", TSemicolon])
  , ("0XCAFEBABE;\n", [THexVal "0XCAFEBABE", TSemicolon])
  , ("0xcAFEbABE;\n", [THexVal "0xcAFEbABE", TSemicolon])
  , ("0xcafebabe;\n", [THexVal "0xcafebabe", TSemicolon])
  , ("0XcAFEbABE;\n", [THexVal "0XcAFEbABE", TSemicolon])
  , ("0Xcafebabe;\n", [THexVal "0Xcafebabe", TSemicolon])
  , ("\"teststring\"", [TStringVal "\"teststring\""])
  , ("\"teststring\\n\"", [TStringVal "\"teststring\\n\""])
  , ("\"teststring\"\n", [TStringVal "\"teststring\"", TSemicolon])
  , ("\"teststring\\n\"\n", [TStringVal "\"teststring\\n\"", TSemicolon])
  , ("\"teststring\"\n", [TStringVal "\"teststring\"", TSemicolon])
  , ("`teststring`", [TRStringVal "`teststring`"])
  , ("`teststring`\n", [TRStringVal "`teststring`", TSemicolon])
  , ("`teststring`;\n", [TRStringVal "`teststring`", TSemicolon])
  , ("1.23", [TFloatVal 1.23])
  , ("1.23\n", [TFloatVal 1.23, TSemicolon])
  , ("1.23; \n", [TFloatVal 1.23, TSemicolon])
  , ("1.", [TFloatVal 1.0])
  , (".1", [TFloatVal 0.1])
  , ("help\n", [TIdent "help", TSemicolon])
  , ("help;\n", [TIdent "help", TSemicolon])
  , ("help ;\n", [TIdent "help", TSemicolon])
  , ("help \n",  ([TIdent "help", TSemicolon]))
  , ("case", [TCase])
  , ("print", [TPrint])
  , ("println", [TPrintln])
  , ("type", [TType])
  , ("append", [TAppend])
  , ("len", [TLen])
  , ("cap", [TCap])
  , ("++", [TInc])
  , ("++\n", [TInc, TSemicolon])
  , ("++;", [TInc, TSemicolon])
  , ("--", [TDInc])
  , ("--\n", [TDInc, TSemicolon])
  , ("--;", [TDInc, TSemicolon])
  , ("'a'", [TRuneVal 'a'])
  , ("'a'\n", [TRuneVal 'a', TSemicolon])
  , ("", [])
  , ("\n", [])
  , ("\r", [])
  , ("// This is a comment", [])
  , ("/* Block comment */", [])
  , ("a /* Block \n */",  ([TIdent "a", TSemicolon]))
  , ("var", [TVar])
  , ("break varname;", [TBreak, TIdent "varname", TSemicolon])
  , ("break varname\n", [TBreak, TIdent "varname", TSemicolon])
  , ("break varname;\n", [TBreak, TIdent "varname", TSemicolon])
  , ("break varname \n", [TBreak, TIdent "varname", TSemicolon])
  , ("break +\n", [TBreak, TPlus])
  , ("testid",  [TIdent "testid"])
  , ("identttt", [TIdent "identttt"])
  , ("_", [TIdent "_"])
  , ("a, b, dddd", [TIdent "a", TComma, TIdent "b", TComma, TIdent "dddd"])
  , ("weirdsp, _   ,aacing", [TIdent "weirdsp", TComma, TIdent "_", TComma, TIdent "aacing"])
  , ("weirdsp, _   \n,aacing", [TIdent "weirdsp", TComma, TIdent "_", TSemicolon, TComma, TIdent "aacing"])
  , ("`\"`",  [TRStringVal "`\"`"])
  , ("`\'`",  [TRStringVal "`\'`"])
  , ("`\\z`",  [TRStringVal "`\\z`"])
  , ("\"'\"",  [TStringVal "\"'\""])
  , ("\"\"",  [TStringVal "\"\""])
  , ("``",  [TRStringVal "``"])
  , ("\"\\n\"",  [TStringVal "\"\\n\""])
  , ("'\\a'",  [TRuneVal '\a'])
  , ("'\\b'",  [TRuneVal '\b'])
  , ("'\\f'",  [TRuneVal '\f'])
  , ("'\\n'",  [TRuneVal '\n'])
  , ("'\\r'",  [TRuneVal '\r'])
  , ("'\\t'",  [TRuneVal '\t'])
  , ("'\\v'",  [TRuneVal '\v'])
  , ("'\\\\'",  [TRuneVal '\\'])
  , ( unpack
        [text|
            /* Long block comment
            here's another line
            and another
            */
          |]
    , [])
  , ( unpack
        [text|
            /* Long block comment no new line */
          |]
    , [])
  , ( unpack
        [text|
            // Short comments
            // More
          |]
    , [])
  , ( unpack
        [text|
            break /* Multiline to simulate
            a new line */
          |]
    , [TBreak, TSemicolon])
  ]

scanFailure :: [(String, String)]
scanFailure = [("''", "Error: lexical error at line 1, column 2. Previous character: '\\\'', current string: '")]
