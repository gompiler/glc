{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module ParserSpec
  ( spec
  ) where

import           Base
import           Data               as D
import           Parser
import           Scanner
import qualified TokensSpec         as T

import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NonEmpty
import           Data.List.Split    (splitOn)

{-# ANN module "HLint: ignore Redundant do" #-}

-- | Spec template listing some expected tests; not yet implemented
spec :: Spec
spec = do
  describe "Identifiers" $ do
    -- No more single ident productions for Idents non-term
    -- qcGen
      -- "single ident"
      -- False
      -- T.genId
      -- (\x -> scanToP pId x == (Right $ NonEmpty.fromList [x]))
    qcGen
      "ident list"
      False
      (genCommaList T.genId)
      (\x -> scanToP pId x == (Right $ reverse $ map (Identifier o) (splitOn "," x)))
  describe "Expressions" $ do
    qcGen
      "basic expressions"
      False
      genEBase
      (\(s, out) -> scanToP pE s == (Right out))
    qcGen
      "binary expressions"
      False
      genEBin
      (\(s, out) -> scanToP pE s == (Right out))
    qcGen
      "unary expressions"
      False
      genEUn
      (\(s, out) -> scanToP pE s == (Right out))
    specOne ("05.ffield", Right (Lit (FloatLit o 5.0)) :: Either String Expr)
    -- specAll "Types" (sndConvert Right expectT :: [(String, Either String (Offset, Type))])
  -- specAll
  --   "Expression Lists"
  --   (sndConvert Right expectEL :: [(String, Either String [Expr])])
  -- -- specAll "Inner declarations" ((sndConvert Right expectIDecl) :: [(String, Either String [VarDecl'])])
  -- describe "Declarations" $ do
  --   it "int = 5" $
  --     scanToP pDecB "int = 5" `shouldBe` (Left "")
--      Right (Left (Type (Identifier o "int"), [Lit (IntLit o Decimal "5")]))

  -- describe "Declarations" $ -- DeclBody
  --  do
  --   it "int" $ scanToP pDecB "int" `shouldBe` Right (Left (Type "int", []))
  --   it " = 3" $
  --     scanToP pDecB " = 3" `shouldBe`
  --     Right (Right (Lit (IntLit Decimal "3") :| []))
  --   it " = 3" $
  --     scanToP pDecB " = 3" `shouldBe`
  --     Right (Right (Lit (IntLit Decimal "3") :| []))
  --      -- InnerDecl
  --   it "a = 3;" $
  --     scanToP pIDecl "a = 3;" `shouldBe`
  --     Right (VarDecl' ("a" :| []) (Right (Lit (IntLit Decimal "3") :| [])))
  --   it "a,b = 3, 4;" $
  --     scanToP pIDecl "a,b = 3, 4;" `shouldBe`
  --     Right
  --       (VarDecl'
  --          ("a" :| ["b"])
  --          (Right (Lit (IntLit Decimal "3") :| [Lit (IntLit Decimal "4")])))
  --      -- Decl
  --   it "var a = 3;" $
  --     scanToP pDec "var a = 3;" `shouldBe`
  --     Right
  --       (VarDecl [VarDecl' ("a" :| []) (Right (Lit (IntLit Decimal "3") :| []))])
  --   it "var (a = 3; b = 4;);" $
  --     scanToP pDec "var (a = 3; b = 4;);" `shouldBe`
  --     Right
  --       (VarDecl
  --          [ VarDecl' ("a" :| []) (Right (Lit (IntLit Decimal "3") :| []))
  --          , VarDecl' ("b" :| []) (Right (Lit (IntLit Decimal "4") :| []))
  --          ])
  --   specOne
  --     ( "type (num int;);"
  --     , Right (TypeDef [TypeDef' "num" (Type "int")]) :: Either String Decl)
  --   specOne
  --     ( "type a int;"
  --     , Right (TypeDef [TypeDef' "a" (Type "int")]) :: Either String Decl)
  --   specOne
  --     ( "type xxy struct{ a, b int; c string; };"
  --     , Right
  --         (TypeDef
  --            [ TypeDef'
  --                "xxy"
  --                (StructType
  --                   [ FieldDecl ("a" :| ["b"]) (Type "int")
  --                   , FieldDecl ("c" :| []) (Type "string")
  --                   ])
  --            ]) :: Either String Decl)
  --   specOne
  --     ( "type xxy struct{ a, b int; c string; };"
  --     , Right
  --         (TypeDef
  --            [ TypeDef'
  --                "xxy"
  --                (StructType
  --                   [ FieldDecl ("a" :| ["b"]) (Type "int")
  --                   , FieldDecl ("c" :| []) (Type "string")
  --                   ])
  --            ]) :: Either String Decl)
  --   specOne
  --     ( "type (a int; b int; c float64;);"
  --     , Right
  --         (TypeDef
  --            [ TypeDef' "a" (Type "int")
  --            , TypeDef' "b" (Type "int")
  --            , TypeDef' "c" (Type "float64")
  --            ]) :: Either String Decl)
  --   specOne
  --     ( "type (a int; c struct { l, z bool; };);"
  --     , Right
  --         (TypeDef
  --            [ TypeDef' "a" (Type "int")
  --            , TypeDef'
  --                "c"
  --                (StructType [FieldDecl ("l" :| ["z"]) (Type "bool")])
  --            ]) :: Either String Decl)
  --   specOne
  --     ( "type (num [5]int;);"
  --     , Right
  --         (TypeDef
  --            [ TypeDef'
  --                "num"
  --                (ArrayType (Lit (IntLit Decimal "5")) (Type "int"))
  --            ]) :: Either String Decl)
  --      -- Params
  --   specOne
  --     ( "a int"
  --     , Right [ParameterDecl ("a" :| []) (Type "int")] :: Either String [ParameterDecl])
  --   specOne
  --     ( "a int, b int, c string"
  --     , Right
  --         [ ParameterDecl ("a" :| []) (Type "int")
  --         , ParameterDecl ("b" :| []) (Type "int")
  --         , ParameterDecl ("c" :| []) (Type "string")
  --         ] :: Either String [ParameterDecl])
  --   specOne
  --     ( "a int, b, c string"
  --     , Right
  --         [ ParameterDecl ("a" :| []) (Type "int")
  --         , ParameterDecl ("b" :| ["c"]) (Type "string")
  --         ] :: Either String [ParameterDecl])
  --   specOne
  --     ( "a, b int, c string"
  --     , Right
  --         [ ParameterDecl ("a" :| ["b"]) (Type "int")
  --         , ParameterDecl ("c" :| []) (Type "string")
  --         ] :: Either String [ParameterDecl])
  --   specOne
  --     ( "a, b, c int"
  --     , Right [ParameterDecl ("a" :| ["b", "c"]) (Type "int")] :: Either String [ParameterDecl])
  --      -- Signature
  --   specOne
  --     ( "(l [5]b, a, b, c int, d, e, f string, g float64)"
  --     , Right
  --         (Signature
  --            (Parameters
  --               [ ParameterDecl
  --                   ("l" :| [])
  --                   (ArrayType (Lit (IntLit Decimal "5")) (Type "b"))
  --               , ParameterDecl ("a" :| ["b", "c"]) (Type "int")
  --               , ParameterDecl ("d" :| ["e", "f"]) (Type "string")
  --               , ParameterDecl ("g" :| []) (Type "float64")
  --               ])
  --            Nothing) :: Either String Signature)
  --   specOne
  --     ( "(l []b, a, b, c int, d, e, f string, g float64) [2]vv"
  --     , Right
  --         (Signature
  --            (Parameters
  --               [ ParameterDecl ("l" :| []) (SliceType (Type "b"))
  --               , ParameterDecl ("a" :| ["b", "c"]) (Type "int")
  --               , ParameterDecl ("d" :| ["e", "f"]) (Type "string")
  --               , ParameterDecl ("g" :| []) (Type "float64")
  --               ])
  --            (Just (ArrayType (Lit (IntLit Decimal "2")) (Type "vv")))) :: Either String Signature)
  --      -- Stmt
  --   specOne ("var a = 5;", Right (Declare (VarDecl [VarDecl' ("a" :| []) (Right (Lit (IntLit Decimal "5") :| []))])) :: Either String Stmt)
  --      -- BlockStmt
  --      -- FuncDecl
  --      -- TopDecl
  --   specOne
  --     ( "var a int;"
  --     , Right (TopDecl (VarDecl [VarDecl' ("a" :| []) (Left (Type "int", []))])) :: Either String TopDecl)
  --   specOne
  --     ( "type (num int;);"
  --     , Right (TopDecl $ TypeDef [TypeDef' "num" (Type "int")]) :: Either String TopDecl)
  --   specAll "Programs" (sndConvert Right programE :: [(String, Either String Program)])
  --   specOne ( "package main; func zzzz(a int){}", Right (Program {package = "main", topLevels = [TopFuncDecl (FuncDecl "zzzz" (Signature (Parameters [ParameterDecl ("a" :| []) (Type "int")]) Nothing) (BlockStmt []))]}) :: Either String Program)
  --   specOne ( "package main; func main(){ func lll(ggg){} }", Left "" :: Either String Program)
  --   specAll "Invalid Programs" (sndConvert Left programEL :: [(String, Either String Program)])

programMain :: [(String, FuncBody)]
programMain = [ ("", (BlockStmt []))]
              -- ,("var a = !!!!!! false;", (BlockStmt [Declare (VarDecl [VarDecl' (Identifier o "a" :| []) (Right (Unary Not (Unary Not (Unary Not (Unary Not (Unary Not (Unary Not (Var "false")))))) :| []))])]))]

programMainL :: [(String, String)]
programMainL = [ ("", "")
               , ("var a = !!!!!! false;", "")]

programE :: [(String, Program)]
programE = map (\(s,body) -> ("package main; func main(){" ++ s ++ "}", Program {package = "main", topLevels = [TopFuncDecl (FuncDecl (Identifier o "main") (Signature (Parameters []) Nothing) body)]})) programMain

programEL :: [(String, String)]
programEL = map (\(s, err) -> ("package main; func main(){" ++ s ++ "}", err)) programMainL

instance SpecBuilder String (Either String Program) () where
  expectation input output =
    it (show $ lines input) $ parse input `shouldBe` output

instance SpecBuilder String (Either String Stmt) () where
  expectation input output =
    it (show $ lines input) $ scanToP pStmt input `shouldBe` output

instance SpecBuilder String (Either String TopDecl) () where
  expectation input output =
    it (show $ lines input) $ scanToP pTDecl input `shouldBe` output

instance SpecBuilder String (Either String Signature) () where
  expectation input output =
    it (show $ lines input) $ scanToP pSig input `shouldBe` output

instance SpecBuilder String (Either String [ParameterDecl]) () where
  expectation input output =
    it (show $ lines input) $ scanToP pPar input `shouldBe` output

instance SpecBuilder String (Either String (Offset, Type)) () where
  expectation input output =
    it (show $ lines input) $ scanToP pT input `shouldBe` output

instance SpecBuilder String (Either String Decl) () where
  expectation input output =
    it (show $ lines input) $ scanToP pDec input `shouldBe` output

instance SpecBuilder String (Either String [Expr]) () where
  expectation input output =
    it (show $ lines input) $ scanToP pEl input `shouldBe` output

instance SpecBuilder String (Either String Expr) () where
  expectation input output =
    it (show $ lines input) $ scanToP pE input `shouldBe` output

instance SpecBuilder String (Either String VarDecl') () where
  expectation input output =
    it (show $ lines input) $ scanToP pIDecl input `shouldBe` output

genCommaList ::
     Gen String -- ^ What we will be comma separating
  -> Gen String
genCommaList f =
  oneof
    [ f >>= \s1 -> f >>= \s2 -> return $ s1 ++ ',' : s2
    , (++) <$> f <*> genCommaList f
    ]

genEBase :: Gen (String, Expr)
genEBase =
  oneof
    [ T.genId >>= \s -> return (s, Var $ Identifier o s)
    , T.genNum >>= \s -> return (s, Lit $ IntLit o Decimal s)
    , T.genOct >>= \s -> return (s, Lit $ IntLit o Octal s)
    , T.genHex >>= \s -> return (s, Lit $ IntLit o Hexadecimal s)
    , ((arbitrary :: Gen Float) `suchThat` \f -> f > 0.0 && f > 0.1) >>= \f ->
        return (show f, Lit $ FloatLit o f)
    , T.genChar' >>= \c -> return ('\'' : c : "'", Lit $ RuneLit o c)
    , T.genString >>= \s -> return (s, Lit $ StringLit o Interpreted s)
    , T.genRString >>= \s -> return (s, Lit $ StringLit o Raw s)
    ]

genEBin :: Gen (String, Expr)
genEBin = do
  (s1, e1) <- genEBase
  (s2, e2) <- genEBase
  (sop, op) <-
    elements
      [ ("||", Or)
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
      , (">>", Arithm ShiftR)
      ]
  return (s1 ++ sop ++ s2, Binary o op e1 e2)

genEUn1 :: Gen (String, Expr)
genEUn1 = do
  (s, e) <- genEBase
  (sop, op) <-
    elements [("+", Pos), ("-", Neg), ("!", Not), ("^", BitComplement)]
  return (sop ++ s, Unary o op e)

genEUn2 :: Gen (String, Expr)
genEUn2 = do
  (s, e) <- genEBase
  (sop, op) <- elements [("len (", LenExpr), ("cap (", CapExpr)]
  return (sop ++ s ++ ")", op o e)

genEUn :: Gen (String, Expr)
genEUn =
  frequency
    [ (4, genEUn1)
    , (2, genEUn2)
    , (1, genEBase >>= \(s, e) -> return ('(' : s ++ ")", e))
    , ( 1
      , T.genId >>= \id1 ->
          T.genId >>= \id2 -> return (id1 ++ '.' : id2, Selector o (Var $ Identifier o id1) $ Identifier o id2))
    ]

genE :: Gen (String, Expr)
genE = oneof [genEBase, genEUn, genEBin]

-- expectT :: [(String, (Offset, Type))]
-- expectT =
--   [ strData "wqiufhiwqf" (o, Type . Identifier o)
--   , strData "int" (o, (Type . Identifier o))
--   , ("(float64)", (o, Type $ Identifier o "float64"))
--   , ("[22]int", (o, ArrayType (Lit $ IntLit o Decimal "22") (Type $ Identifier o "int")))
--   , ("[]int", (o, SliceType (Type $ Identifier o "int")))
--   ]

-- genETypeBase :: Gen (String, Type)
-- genETypeBase = oneof [T.genId >>= genEBase >>= \i -> "[" ++  ++ "] " ++ id, ArrayType ]
expectEL :: [(String, [Expr])]
expectEL =
  [ ("123, 888", (Lit $ IntLit o Decimal "123") : [Lit $ IntLit o Decimal "888"])
  , ("123, 88.8", (Lit $ IntLit o Decimal "123") : [Lit $ FloatLit o 88.8])
  ]

-- expectDecl :: [(String, Decl)]
-- expectDecl = [ ("var a = 34", (VarDecl [VarDecl' (NonEmpty "a") ()]))
--            ]
-- expectIDecl :: [(String, VarDecl')]
-- expectIDecl = [ ("= 5", VarDecl' (Left (Type "aaaaa")) (NonEmpty $ Lit $ IntLit Decimal "123"))]
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
