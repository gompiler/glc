{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes           #-}

module ParserSpec
  ( spec
  ) where

import           Base
import           Data               as D
import           Parser
import           Scanner
import qualified TokensSpec as T

import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NonEmpty
import Data.List.Split (splitOn)

{-# ANN module "HLint: ignore Redundant do" #-}

-- | Spec template listing some expected tests; not yet implemented
spec :: Spec
spec = do
  describe "Identifiers" $ do
    qcGen "single ident" False T.genId (\x -> (scanToP pId x) == (Right $ NonEmpty.fromList $ [x]))
    qcGen "ident list" False (genCommaList T.genId) (\x -> (scanToP pId x) == (Right $ NonEmpty.fromList $ splitOn "," x))
  describe "Expressions" $ do
    qcGen "basic expressions" False genEBase (\(s, out) -> (scanToP pE s) == (Right $ out))
    qcGen "binary expressions" False genEBin (\(s, out) -> (scanToP pE s) == (Right $ out))
    qcGen "unary expressions" False genEUn (\(s, out) -> (scanToP pE s) == (Right $ out))
  specAll "Types" ((specConvert Right expectT) :: [(String, Either String Type)])
  
instance SpecBuilder String (Either String Type) () where
  expectation input output =
    it (show $ lines input) $ scanToP pT input `shouldBe` output
  
genCommaList :: Gen String -- ^ Generator we use to generate things in between commas
             -> Gen String
genCommaList f = oneof [f >>= \s1 -> f >>= \s2 -> return $ s1 ++ ',':s2, (++) <$> f <*> genCommaList f]

genEBase :: Gen (String, Expr)
genEBase = oneof [
  -- (T.genId >>= \s -> return (s, Var s))
                  (T.genNum >>= \s -> return (s, Lit $ IntLit Decimal s))
                  , (T.genOct >>= \s -> return (s, Lit $ IntLit Octal s))
                  , (T.genHex >>= \s -> return (s, Lit $ IntLit Hexadecimal s))
                  -- Don't test negative floats or small floats, as those will be in scientific notation
                  , (((arbitrary :: Gen Float) `suchThat` \f ->  f > 0.0 && f > 0.1 ) >>= \f -> return (show f, Lit $ FloatLit f))
                  , (T.genChar' >>= \c -> return ('\'':c:"'", Lit $ RuneLit c))
                  , (T.genString >>= \s -> return (s, Lit $ StringLit Interpreted s))
                  , (T.genRString >>= \s -> return (s, Lit $ StringLit Raw s))]

genEBin :: Gen (String, Expr)
genEBin = do
  (s1,e1) <- genEBase
  (s2,e2) <- genEBase
  (sop, op) <- elements [("||", Or)
                        , ("&&", And)
                        , ("==", D.EQ)
                        , ("!=", NEQ)
                        , ("<", D.LT)
                        , ("<=", LEQ)
                        , (">", D.GT)
                        , (">=", GEQ)
                        , ("+", Arithm Add)
                        , ("-", Arithm Subtract)
                        , ("*", Arithm Multiply)
                        , ("/", Arithm Divide)
                        , ("%", Arithm Remainder)
                        , ("|", Arithm BitOr)
                        , ("^", Arithm BitXor)
                        , ("&", Arithm BitAnd)
                        , ("&^", Arithm BitClear)
                        , ("<<", Arithm ShiftL)
                        , (">>", Arithm ShiftR)]
  return $ 
    (s1 ++ sop ++ s2, Binary e1 op e2)

genEUn1 :: Gen (String, Expr)
genEUn1 = do
  (s,e) <- genEBase
  (sop, op) <- elements [("+", Pos)
                        ,("-", Neg)
                        ,("!", Not)
                        ,("^", BitComplement)
                        ]
  return $ (sop ++ s, Unary op e)
  
genEUn2 :: Gen (String, Expr)
genEUn2 = do
  (s,e) <- genEBase
  (sop, op) <- elements [("len (", LenExpr)
                        ,("cap (", CapExpr)
                        ]
  return $ (sop ++ s ++ ")", op e)

genEUn :: Gen (String, Expr)
genEUn = frequency [(4, genEUn1), (2, genEUn2), (1, genEBase >>= \(s, e) -> return $ ('(':s ++ ")", e))]

expectT :: [(String, Type)]
expectT = [ (strData "wqiufhiwqf" (Type))
          , (strData "int" (Type))
          , ("(float64)", (Type "float64"))
          , ("[22]int", (ArrayType (Lit $ IntLit Decimal "22") (Type "int")))
          , ("[]int", (SliceType (Type "int")))
          ]

-- genETypeBase :: Gen (String, Type)
-- genETypeBase = oneof [T.genId >>= genEBase >>= \i -> "[" ++  ++ "] " ++ id, ArrayType ]

scanToP :: (Show a, Eq a) => Alex a -> (String -> Either String a)
scanToP f s = runAlex s f

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
