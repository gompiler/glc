module ParserSpec
  ( spec
  ) where

import           Base
import           Data               as D
import           Parser
import           Scanner
import           Test.Hspec

import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NonEmpty

{-# ANN module "HLint: ignore Redundant do" #-}

-- | Spec template listing some expected tests; not yet implemented
spec :: Spec
spec = do
  describe "parseId" $ do
    mapM_ (specWithG $ scanToP pId) expectId
    mapM_ (specWithG $ scanToP pE) expectE
    -- mapM_ (specWithG $ scanToP pT) expectT
    
scanToP :: (Show a, Eq a) => Alex a -> (String -> Either String a)
scanToP f s = runAlex s f

idNames :: [String]
idNames = ["testid", "identttt", "_"]

expectId :: [(String, Either String (NonEmpty Identifier))]
expectId =
  map (strData' (\id -> Right $ NonEmpty.fromList $ [id])) idNames ++
  [ ("a, b, dddd", Right (NonEmpty.fromList ["a", "b", "dddd"]))
  , ("_, _,_", Right (NonEmpty.fromList ["_", "_", "_"]))
  , ( "weirdsp, _   ,aacing" , Right (NonEmpty.fromList ["weirdsp", "_", "aacing"]))
  ]

-- | Base expression list
eBase :: [(String, Expr)]
eBase =
  [ ("01249148", Lit $ IntLit Decimal "01249148")
  , ("000123022", Lit $ IntLit Octal "000123022")
  , ("0xfffff", Lit $ IntLit Hexadecimal "0xfffff")
  , ("0XffFf12", Lit $ IntLit Hexadecimal "0XffFf12")
  , ("123", Lit $ IntLit Decimal "123")
  , ("000000123", Lit $ IntLit Octal "000000123")
  , ("000000124", Lit (IntLit Octal "000000124"))
  , ("00.00124", Lit (FloatLit 1.24e-3))
  , ("1.00124", Lit (FloatLit 1.00124))
  , ("1.1", Lit (FloatLit 1.1))
  -- , ("1.", Lit (FloatLit 1))
  , ("1.0", Lit (FloatLit 1.0))
  -- , (".0", Lit (FloatLit 0.0))
  , ("'D'", Lit $ RuneLit 'D')
  -- , ("identf", Var "identf")
  , ("'\\n'", Lit $ RuneLit '\n')
  , ("\"aaaaaaaaax\"", Lit (StringLit Interpreted "\"aaaaaaaaax\""))
  , ("`aaaaaaaaax`", Lit (StringLit Raw "`aaaaaaaaax`"))
  ]

eComb :: [(String, Expr)] -> [(String, Expr)]
eComb baseL =
  baseL ++
  map (\(s, e) -> ('+' : s, Unary Pos e)) baseL ++
  map (\(s, e) -> ("+      \n" ++ s, Unary Pos e)) baseL ++
  map (\(s, e) -> ('-' : s, Unary Neg e)) baseL ++
  map (\(s, e) -> ('!' : s, Unary Not e)) baseL ++
  map (\(s, e) -> ('^' : s, Unary BitComplement e)) baseL ++
  map (\(s, e) -> ('(' : s ++ ")", e)) baseL ++
  map (\(s, e) -> ("len (" ++ s ++ ")", LenExpr e)) baseL ++
  map (\(s, e) -> ("cap (" ++ s ++ ")", CapExpr e)) baseL ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ "||" ++ s2, Binary e1 Or e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ "&&" ++ s2, Binary e1 And e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ "==" ++ s2, Binary e1 D.EQ e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ "!=" ++ s2, Binary e1 NEQ e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ "<" ++ s2, Binary e1 D.LT e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ "<=" ++ s2, Binary e1 LEQ e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ ">" ++ s2, Binary e1 D.GT e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ ">=" ++ s2, Binary e1 GEQ e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ "+" ++ s2, Binary e1 (Arithm Add) e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ "-" ++ s2, Binary e1 (Arithm Subtract) e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ "*" ++ s2, Binary e1 (Arithm Multiply) e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ "/" ++ s2, Binary e1 (Arithm Divide) e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ "%" ++ s2, Binary e1 (Arithm Remainder) e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ "|" ++ s2, Binary e1 (Arithm BitOr) e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ "^" ++ s2, Binary e1 (Arithm BitXor) e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ "&" ++ s2, Binary e1 (Arithm BitAnd) e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ "&^" ++ s2, Binary e1 (Arithm BitClear) e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ "<<" ++ s2, Binary e1 (Arithm ShiftL) e2))
    (cartP baseL baseL) ++
  map
    (\((s1, e1), (s2, e2)) -> (s1 ++ ">>" ++ s2, Binary e1 (Arithm ShiftR) e2))
    (cartP baseL baseL)

eComb' :: [(String, Expr)]
eComb' = eComb eBase

-- expectT :: [(String, Either String Type)]
-- expectT = map (strData (Right $ Type)) idNames

expectE :: [(String, Either String Expr)]
expectE = map (\(s, e) -> (s, Right e)) eComb'

intExamples =
  [ "0"
  , "1"
  , "-123"
  , "1234567890"
  , "42"
  , "0600"
  , "0xBadFace"
  , "170141183460469231731687303715884105727"
  ]

floatExamples =
  [ ".1234567890"
  , "0."
  , "72.40"
  , "072.40"
  , "2.71828"
  , "1.e+0"
  , "6.67428e-11"
  , "1E6"
  , ".25"
  , ".12345E+5"
  ]

runeExamples =
  ['a', 'b', 'c', '\a', '\b', '\f', '\n', '\r', '\t', '\v', '\\', '\'', '\"']
