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



scanToP :: (Show a, Eq a) => Alex a -> (String -> Either String a)
scanToP f s = runAlex s f

-- eComb :: [(String, Expr)] -> [(String, Expr)]
-- eComb baseL =
--   baseL ++
--   map (\(s, e) -> ('+' : s, Unary Pos e)) baseL ++
--   map (\(s, e) -> ("+      \n" ++ s, Unary Pos e)) baseL ++
--   map (\(s, e) -> ('-' : s, Unary Neg e)) baseL ++
--   map (\(s, e) -> ('!' : s, Unary Not e)) baseL ++
--   map (\(s, e) -> ('^' : s, Unary BitComplement e)) baseL ++
--   map (\(s, e) -> ('(' : s ++ ")", e)) baseL ++
--   map (\(s, e) -> ("len (" ++ s ++ ")", LenExpr e)) baseL ++
--   map (\(s, e) -> ("cap (" ++ s ++ ")", CapExpr e)) baseL ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ "||" ++ s2, Binary e1 Or e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ "&&" ++ s2, Binary e1 And e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ "==" ++ s2, Binary e1 D.EQ e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ "!=" ++ s2, Binary e1 NEQ e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ "<" ++ s2, Binary e1 D.LT e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ "<=" ++ s2, Binary e1 LEQ e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ ">" ++ s2, Binary e1 D.GT e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ ">=" ++ s2, Binary e1 GEQ e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ "+" ++ s2, Binary e1 (Arithm Add) e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ "-" ++ s2, Binary e1 (Arithm Subtract) e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ "*" ++ s2, Binary e1 (Arithm Multiply) e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ "/" ++ s2, Binary e1 (Arithm Divide) e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ "%" ++ s2, Binary e1 (Arithm Remainder) e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ "|" ++ s2, Binary e1 (Arithm BitOr) e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ "^" ++ s2, Binary e1 (Arithm BitXor) e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ "&" ++ s2, Binary e1 (Arithm BitAnd) e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ "&^" ++ s2, Binary e1 (Arithm BitClear) e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ "<<" ++ s2, Binary e1 (Arithm ShiftL) e2))
--     (cartP baseL baseL) ++
--   map
--     (\((s1, e1), (s2, e2)) -> (s1 ++ ">>" ++ s2, Binary e1 (Arithm ShiftR) e2))
--     (cartP baseL baseL)

-- eComb' :: [(String, Expr)]
-- eComb' = eComb eBase

-- expectT :: [(String, Either String Type)]
-- expectT = map (strData (Right $ Type)) idNames

-- expectE :: [(String, Either String Expr)]
-- expectE = map (\(s, e) -> (s, Right e)) eComb'

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
