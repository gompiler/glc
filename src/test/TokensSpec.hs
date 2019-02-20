module TokensSpec
  ( spec
  ) where

import           Scanner
import           Test.Hspec

spec :: Spec
spec = describe "scan" $ do
  specWithScanT (";", Right([TSemicolon]))
  -- Uncomment this when semicolon insertion is implemented
  -- mapM_ specWithScanT expectScanT

-- | Generate a SpecWith using the scan function
specWithScanT :: (String, Either String [InnerToken]) -> SpecWith ()
specWithScanT (input, output) =
  it ("returns " ++ show output ++ " when given `" ++ input ++ "`") $
  scanT input `shouldBe` output

expectScanT :: [(String, Either String [InnerToken])]
expectScanT =
  [ ("break", Right ([TBreak, TSemicolon]))
  , ("break;", Right ([TBreak, TSemicolon]))
  , ("break ;", Right ([TBreak, TSemicolon]))
  , ("chan", Right ([TChan]))
  , ("const", Right ([TConst]))
  , ("continue", Right ([TContinue, TSemicolon]))
  , ("continue;", Right ([TContinue, TSemicolon]))
  , ("default", Right ([TDefault]))
  , ("defer", Right ([TDefer]))
  , ("else", Right ([TElse]))
  , ("fallthrough", Right ([TFallthrough, TSemicolon]))
  , ("fallthrough;", Right ([TFallthrough, TSemicolon]))
  , ("for", Right ([TFor]))
  , ("func", Right ([TFunc]))
  , ("go", Right ([TGo]))
  , ("goto", Right ([TGoto]))
  , ("if", Right ([TIf]))
  , ("import", Right ([TImport]))
  , ("interface", Right ([TInterface]))
  , ("map", Right ([TMap]))
  , ("package", Right ([TPackage]))
  , ("range", Right ([TRange]))
  , ("return", Right ([TReturn, TSemicolon]))
  , ("return;", Right ([TReturn, TSemicolon]))
  , ("select", Right ([TSelect]))
  , ("struct", Right ([TStruct]))
  , ("switch", Right ([TSwitch]))
  , (",", Right ([TComma]))
  , (".", Right ([TDot]))
  , (":", Right ([TColon]))
  , (";", Right ([TSemicolon]))
  , (";;;", Right ([TSemicolon, TSemicolon, TSemicolon]))
  , ("(", Right ([TLParen]))
  , (")", Right ([TRParen, TSemicolon]))
  , ("[", Right ([TLSquareB]))
  , ("]", Right ([TRSquareB, TSemicolon]))
  , ("{", Right ([TLBrace]))
  , ("}", Right ([TRBrace, TSemicolon]))
  , ("+", Right ([TPlus]))
  , ("-", Right ([TMinus]))
  , ("*", Right ([TTimes]))
  , ("/", Right ([TDiv]))
  , ("%", Right ([TMod]))
  , ("=", Right ([TAssn]))
  , (">", Right ([TGt]))
  , ("<", Right ([TLt]))
  , ("!", Right ([TNot]))
  , ("==", Right ([TEq]))
  , ("!=", Right ([TNEq]))
  , (">=", Right ([TGEq]))
  , ("<=", Right ([TLEq]))
  , ("&&", Right ([TAnd]))
  , ("||", Right ([TOr]))
  , ("&", Right ([TLAnd]))
  , ("|", Right ([TLOr]))
  , ("^", Right ([TLXor]))
  , ("<<", Right ([TLeftS]))
  , (">>", Right ([TRightS]))
  , ("&^", Right ([TLAndNot]))
  , ("+=", Right ([TIncA]))
  , ("-=", Right ([TDIncA]))
  , ("*=", Right ([TMultA]))
  , ("/=", Right ([TDivA]))
  , ("%=", Right ([TModA]))
  , ("&=", Right ([TLAndA]))
  , ("|=", Right ([TLOrA]))
  , ("^=", Right ([TLXorA]))
  , ("<<=", Right ([TLeftSA]))
  , (">>=", Right ([TRightSA]))
  , ("&^=", Right ([TLAndNotA]))
  , ("<-", Right ([TRecv]))
  , (":=", Right ([TDeclA]))
  , ("...", Right ([TLdots]))
               -- Need to merge first before these are valid
               -- ("12947631951", Right([TDecVal "12947631951", TSemicolon])),
               -- ("003777", Right([TOctVal "003777", TSemicolon])),
               -- ("0xCAFEBABE", Right([THexVal "0xCAFEBABE", TSemicolon])),
               -- ("0XCAFEBABE", Right([THexVal "0XCAFEBABE", TSemicolon])),
               -- ("0xcAFEbABE", Right([THexVal "0xcAFEbABE", TSemicolon])),
               -- ("0xcafebabe", Right([THexVal "0xcafebabe", TSemicolon])),
               -- ("0XcAFEbABE", Right([THexVal "0XcAFEbABE", TSemicolon])),
               -- ("0Xcafebabe", Right([THexVal "0Xcafebabe", TSemicolon])),
               -- ("\"teststring\"", Right([TStringVal "\"teststring\"", TSemicolon])),
               -- ("`teststring`", Right([TRStringVal "`teststring`, TSemicolon])),
  , ("1.23", Right ([TFloatVal 1.23, TSemicolon]))
  , ("help", Right ([TIdent "help", TSemicolon]))
  , ("case", Right ([TCase]))
  , ("print", Right ([TPrint]))
  , ("println", Right ([TPrintln]))
  , ("type", Right ([TType]))
  , ("append", Right ([TAppend]))
  , ("len", Right ([TLen]))
  , ("cap", Right ([TCap]))
  , ("++", Right ([TInc, TSemicolon]))
  , ("++;", Right ([TInc, TSemicolon]))
  , ("--", Right ([TDInc, TSemicolon]))
  , ("--;", Right ([TDInc, TSemicolon]))
  , ("'a'", Right ([TRuneVal 'a', TSemicolon]))
  , ("", Right ([]))
  , ("\n", Right ([]))
  , ("\r", Right ([]))
  , ("// This is a comment", Right ([]))
  , ("//* Block comment //*", Right ([]))
  , ("a //* Block \n //*", Right ([TIdent "a", TSemicolon]))
               -- This will have to change if we change error printing
  , ( "''"
    , Left
        ("Error: lexical error at line 1, column 3. Previous character: '\\\'', current string: "))
  , ("var", Right ([TVar]))
  ]
-- expectScanP :: [(String, String, Either String [InnerToken])]
-- expectScanP = [("Prints tBREAK tSEMICOLON when given `break`")]
