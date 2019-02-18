module TokensSpec
  ( spec
  ) where

import           Scanner
import           Test.Hspec

spec :: Spec
spec = describe "scan" $ do mapM_ specWithScanT expectScanT

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
  , (")", Right ([TRParen]))
  , ("[", Right ([TLSquareB]))
  , ("]", Right ([TRSquareB]))
  , ("{", Right ([TLBrace]))
  , ("}", Right ([TRBrace]))
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
               -- ("12947631951", Right([TDecVal "12947631951"])),
               -- ("003777", Right([TOctVal "003777"])),
               -- ("0xCAFEBABE", Right([THexVal "0xCAFEBABE"])),
               -- ("0XCAFEBABE", Right([THexVal "0XCAFEBABE"])),
               -- ("0xcAFEbABE", Right([THexVal "0xcAFEbABE"])),
               -- ("0xcafebabe", Right([THexVal "0xcafebabe"])),
               -- ("0XcAFEbABE", Right([THexVal "0XcAFEbABE"])),
               -- ("0Xcafebabe", Right([THexVal "0Xcafebabe"])),
               -- ("\"teststring\"", Right([TStringVal "\"teststring\""])),
               -- ("`teststring`", Right([TRStringVal "`teststring`])),
  , ("help", Right ([TIdent "help"]))
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
  , ("'a'", Right ([TRuneVal 'a']))
  , ("", Right ([]))
  , ("\n", Right ([]))
  , ("\r", Right ([]))
               -- This will have to change if we change error printing
  , ( "''"
    , Left
        ("Error: lexical error at line 1, column 3. Previous character: '\\\'', current string: "))
  , ("var", Right ([TVar]))
  ]
-- expectScanP :: [(String, String, Either String [InnerToken])]
-- expectScanP = [("Prints tBREAK tSEMICOLON when given `break`")]
