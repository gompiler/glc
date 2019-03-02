{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TypeSynonymInstances  #-}

module TokensSpec
  ( spec
  , genId
  , genNum
  , genHex
  , genOct
  , genFloat
  , genChar
  , genChar'
  , genString
  , genRString
  ) where

import           Base
import           Scanner

spec :: Spec
spec = do
  specAll "scanner success" scanSuccess
  specAll "scanner failures" scanFailure
  describe "extra scanner tests" $
    qcGen "semicolon insertion" False genSemiI (\x -> scanT (x ++ "/* \n */") == scanT (x ++ ";"))

genId' :: Gen String
genId' = oneof [choose ('A', 'Z') >>= toRetL, (:) <$> choose ('A', 'Z') <*> genId']

genId :: Gen String
genId =
  frequency [(30, genId'), (1, return "_")]

genNum :: Gen String
genNum = -- Ensure no octal
  oneof [choose ('8', '9') >>= toRetL, (:) <$> choose ('0', '9') <*> genNum]

genHex' :: Gen String
genHex' =
  oneof
    [ choose ('0', '9') >>= toRetL
    , choose ('a', 'f') >>= toRetL
    , choose ('A', 'F') >>= toRetL
    , (:) <$> choose ('0', '9') <*> genHex'
    , (:) <$> choose ('a', 'f') <*> genHex'
    , (:) <$> choose ('A', 'F') <*> genHex'
    ]

genHex :: Gen String
genHex = genHex' >>= (\l -> elements ['x', 'X'] >>= \x -> return $ '0' : x : l)

genOct' :: Gen String
genOct' = oneof [choose ('0', '7') >>= toRetL, (:) <$> choose ('0', '7') <*> genOct']

genOct :: Gen String
genOct = genOct' >>= \s -> return $ '0':s

genFloat :: Gen String
genFloat = do
  n1 <- genNum
  n2 <- genNum
  return $ n1 ++ '.' : n2

genChar' :: Gen Char -- 92 = \, 34 = ", 39 = ', 32 - 126 is space to ~, most "normal" characters
genChar' =
  choose (32, 126) `suchThat` (\i -> not $ i == 92 || i == 34 || i == 39) >>=
  (return . toEnum :: Int -> Gen Char)

genRChar' :: Gen Char -- 96 = `
genRChar' =
  choose (32, 126) `suchThat` (not . (==) 96) >>=
  (return . toEnum :: Int -> Gen Char)

genChar :: Gen String
genChar = genChar' >>= \s -> return $ '\'' : s : ['\'']

genString' :: Gen String
genString' = oneof [genChar' >>= toRetL, (:) <$> genChar' <*> genString']

genString :: Gen String
genString = genString' >>= \s -> return $ '\"' : s ++ "\""

genRString' :: Gen String
genRString' = oneof [genRChar' >>= toRetL, (:) <$> genRChar' <*> genRString']

genRString :: Gen String
genRString = genRString' >>= \s -> return $ '`' : s ++ "`"

genSemiI :: Gen String
genSemiI =
  oneof
    [ elements
        [ "break"
        , "continue"
        , "fallthrough"
        , "return"
        , "++"
        , "--"
        , ")"
        , "]"
        , "}"
        ]
    , genId
    , genNum
    , genHex
    , genOct
    , genFloat
    , genChar
    , genString
    , genRString
    ]

instance SpecBuilder (String, [InnerToken]) where
  expectation (input, expected) = it (show $ lines input) $ scanT input `shouldBe` Right expected

instance SpecBuilder (String, String) where
  expectation (input, failure) = it (show $ lines input) $ scanT input `shouldBe` Left failure

--scanInputs = sndConvert Right scanSuccess ++ sndConvert Left scanFailure

scanSuccess :: [(String, [InnerToken])]
scanSuccess =
  [ (";", [TSemicolon])
  , ("break", [TBreak, TSemicolon])
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
  , ("continue", [TContinue, TSemicolon])
  , ("continue\n", [TContinue, TSemicolon])
  , ("continue;", [TContinue, TSemicolon])
  , ("default", [TDefault])
  , ("defer", [TDefer])
  , ("else", [TElse])
  , ("fallthrough", [TFallthrough, TSemicolon])
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
  , ("return", [TReturn, TSemicolon])
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
  , (")", [TRParen, TSemicolon])
  , (")\n", [TRParen, TSemicolon])
  , (");\n", [TRParen, TSemicolon])
  , ("[", [TLSquareB])
  , ("]", [TRSquareB, TSemicolon])
  , ("]\n", [TRSquareB, TSemicolon])
  , ("];\n", [TRSquareB, TSemicolon])
  , ("{", [TLBrace])
  , ("}", [TRBrace, TSemicolon])
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
  , ("12947631951", [TDecVal "12947631951", TSemicolon])
  , ("12947631951\n", [TDecVal "12947631951", TSemicolon])
  , ("12947631951;\n", [TDecVal "12947631951", TSemicolon])
  , ("003777", [TOctVal "003777", TSemicolon])
  , ("0xCAFEBABE", [THexVal "0xCAFEBABE", TSemicolon])
  , ("0XCAFEBABE", [THexVal "0XCAFEBABE", TSemicolon])
  , ("0xcAFEbABE", [THexVal "0xcAFEbABE", TSemicolon])
  , ("0xcafebabe", [THexVal "0xcafebabe", TSemicolon])
  , ("0XcAFEbABE", [THexVal "0XcAFEbABE", TSemicolon])
  , ("0Xcafebabe", [THexVal "0Xcafebabe", TSemicolon])
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
  , ("\"teststring\"", [TStringVal "\"teststring\"", TSemicolon])
  , ("\"teststring\\n\"", [TStringVal "\"teststring\\n\"", TSemicolon])
  , ("\"teststring\"\n", [TStringVal "\"teststring\"", TSemicolon])
  , ("\"teststring\\n\"\n", [TStringVal "\"teststring\\n\"", TSemicolon])
  , ("\"teststring\"\n", [TStringVal "\"teststring\"", TSemicolon])
  , ("`teststring`", [TRStringVal "`teststring`", TSemicolon])
  , ("`teststring`\n", [TRStringVal "`teststring`", TSemicolon])
  , ("`teststring`;\n", [TRStringVal "`teststring`", TSemicolon])
  , ("1.23", [TFloatVal 1.23, TSemicolon])
  , ("1.23\n", [TFloatVal 1.23, TSemicolon])
  , ("1.23; \n", [TFloatVal 1.23, TSemicolon])
  , ("1.", [TFloatVal 1.0, TSemicolon])
  , (".1", [TFloatVal 0.1, TSemicolon])
  , ("help\n", [TIdent "help", TSemicolon])
  , ("help;\n", [TIdent "help", TSemicolon])
  , ("help ;\n", [TIdent "help", TSemicolon])
  , ("help \n", [TIdent "help", TSemicolon])
  , ("case", [TCase])
  , ("print", [TPrint])
  , ("println", [TPrintln])
  , ("type", [TType])
  , ("append", [TAppend])
  , ("len", [TLen])
  , ("cap", [TCap])
  , ("++", [TInc, TSemicolon])
  , ("++\n", [TInc, TSemicolon])
  , ("++;", [TInc, TSemicolon])
  , ("--", [TDInc, TSemicolon])
  , ("--\n", [TDInc, TSemicolon])
  , ("--;", [TDInc, TSemicolon])
  , ("'a'", [TRuneVal 'a', TSemicolon])
  , ("'a'\n", [TRuneVal 'a', TSemicolon])
  , ("", [])
  , ("\n", [])
  , ("\r", [])
  , ("// This is a comment", [])
  , ("/* Block comment */", [])
  , ("a /* Block \n */", [TIdent "a", TSemicolon])
  , ("+ /* Block \n */", [TPlus])
  , ("var", [TVar])
  , ("break varname;", [TBreak, TIdent "varname", TSemicolon])
  , ("break varname\n", [TBreak, TIdent "varname", TSemicolon])
  , ("break varname;\n", [TBreak, TIdent "varname", TSemicolon])
  , ("break varname \n", [TBreak, TIdent "varname", TSemicolon])
  , ("break +\n", [TBreak, TPlus])
  , ("testid", [TIdent "testid", TSemicolon])
  , ("identttt", [TIdent "identttt", TSemicolon])
  , ("_", [TIdent "_", TSemicolon])
  , ("a, b, dddd", [TIdent "a", TComma, TIdent "b", TComma, TIdent "dddd", TSemicolon])
  , ( "weirdsp, _   ,aacing"
    , [TIdent "weirdsp", TComma, TIdent "_", TComma, TIdent "aacing", TSemicolon])
  , ( "weirdsp, _   \n,aacing"
    , [ TIdent "weirdsp"
      , TComma
      , TIdent "_"
      , TSemicolon
      , TComma
      , TIdent "aacing"
      , TSemicolon
      ])
  , ("`\"`", [TRStringVal "`\"`", TSemicolon])
  , ("`\'`", [TRStringVal "`\'`", TSemicolon])
  , ("`\\z`", [TRStringVal "`\\z`", TSemicolon])
  , ("\"'\"", [TStringVal "\"'\"", TSemicolon])
  , ("\"\"", [TStringVal "\"\"", TSemicolon])
  , ("``", [TRStringVal "``", TSemicolon])
  , ("\"\\n\"", [TStringVal "\"\\n\"", TSemicolon])
  , ("'\\a'", [TRuneVal '\a', TSemicolon])
  , ("'\\b'", [TRuneVal '\b', TSemicolon])
  , ("'\\f'", [TRuneVal '\f', TSemicolon])
  , ("'\\n'", [TRuneVal '\n', TSemicolon])
  , ("'\\r'", [TRuneVal '\r', TSemicolon])
  , ("'\\t'", [TRuneVal '\t', TSemicolon])
  , ("'\\v'", [TRuneVal '\v', TSemicolon])
  , ("'\\\\'", [TRuneVal '\\', TSemicolon])
  , ( unpack
        [text|
             "\""
        |]
    , [TStringVal "\"\\\"\"", TSemicolon])
  , ( unpack
        [text|
             '\''
        |]
    , [TRuneVal '\'', TSemicolon])
  , ( unpack
        [text|
          +   /* Multiline to simulate
          a new line */
        |]
    , [TPlus])
  , ( unpack
        [text|
          fallthrough   /* New line after comment */

        |]
    , [TFallthrough, TSemicolon])
  , ( unpack
        [text|
          ++   /* New line after comment
          and inside comment*/

        |]
    , [TInc, TSemicolon])
  , ( unpack
        [text|
          )   ;   /* New line after comment
          and inside comment*/

        |]
    , [TRParen, TSemicolon])
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
scanFailure =
  [ ( "''"
    , "Error: lexical error at 1:2:\n  |\n1 | ''\n  |  ^\n\n")
  ]
