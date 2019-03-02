{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE TypeSynonymInstances #-}

module Base
  ( SpecBuilder(..)
  , Data.Text.Text
  , Data.Text.unpack
  , NeatInterpolation.text
  , o
  , module ErrorBundle
  , sndConvert
  , fstConvert
  , pairConvert
  , strData
  , Stringable(..)
  , Parsable(..)
  , strData'
  , cartP
  , module Test.Hspec
  , module Test.QuickCheck
  , toRetL
  , qcGen
  ) where

import Control.Monad (unless)

import Control.Applicative
import Data
import qualified Data.Either as Either
import Data.List.NonEmpty (NonEmpty(..), fromList)
import Data.Text (Text, unpack)
import ErrorBundle
import NeatInterpolation
import Parser (pDec, pE, pEl, pIDecl, pId, pPar, pSig, pStmt, pT, pTDecl)
import qualified Parser (parse)
import Scanner (Alex(..), runAlex)
import Test.Hspec
import Test.QuickCheck

o :: Offset
o = Offset 0

class Stringable a where
  toString :: a -> String

instance Stringable String where
  toString = id

instance Stringable Text where
  toString = unpack

-- | Relatively complex base expectation
-- Suffix is a tag for the description
-- Expectation maps the input to an expectation
-- Title maps the input to a string (prefix of description)
-- Name refers to tag from Parsable
-- Inputs refers to list of inputs
-- Note that the last two entries are type ambiguous, which is why we need to specify them
-- We order the parameters this way to avoid rewriting them 
expectBase :: (HasCallStack) => String -> (s -> Expectation) -> (s -> String) -> String -> [s] -> SpecWith ()
expectBase suffix expectation title name inputs = describe (name ++ " " ++ suffix) $ mapM_ expect inputs
  where
    expect input = it (show $ lines $ title input) $ expectation input

expectPassBase :: (Parsable a, Stringable s) => String -> (s -> Either String a) -> [s] -> SpecWith ()
expectPassBase tag parse =
  expectBase
    "success"
    (\s ->
       case parse s of
         Left error ->
           expectationFailure $ "Expected parse success on:\n\n" ++ toString s ++ "\n\n, but failed with\n\n" ++ error
         _ -> return ())
    toString
    tag

expectFailBase :: (Parsable a, Stringable s) => String -> (s -> Either String a) -> [s] -> SpecWith ()
expectFailBase tag parse =
  expectBase
    "success"
    (\s ->
       case parse s of
         Right ast ->
           expectationFailure $
           "Expected parse failure on:\n\n" ++ toString s ++ "\n\n, but succeeded with\n\n" ++ show ast
         _ -> return ())
    toString
    tag

expectAstBase :: (Parsable a, Stringable s) => String -> [(s, a)] -> SpecWith ()
expectAstBase =
  expectBase
    "ast"
    (\(s, e) ->
       unless (parse s == Right e) . expectationFailure $
       "Invalid ast for:\n\n" ++ toString s ++ "\n\n, expected\n\n" ++ show e)
    (toString . fst)

class (Show a, Eq a) =>
      Parsable a
  where
  tag :: String
  parse :: Stringable s => s -> Either String a
  parse s = parse' $ toString s
  parse' :: String -> Either String a
  placeholder :: a
  expectPass :: Stringable s => [s] -> SpecWith ()
  expectFail :: Stringable s => [s] -> SpecWith ()
  expectAst :: Stringable s => [(s, a)] -> SpecWith ()

instance Parsable Program where
  tag = "program"
  parse' = Parser.parse
  placeholder = Program {package = "temp", topLevels = []}
  expectPass = expectPassBase (tag @Program) (parse @Program)
  expectFail = expectFailBase (tag @Program) (parse @Program)
  expectAst = expectAstBase (tag @Program)

instance Parsable Stmt where
  tag = "stmt"
  parse' = scanToP pStmt
  placeholder = blank
  expectPass = expectPassBase (tag @Stmt) (parse @Stmt)
  expectFail = expectFailBase (tag @Stmt) (parse @Stmt)
  expectAst = expectAstBase (tag @Stmt)

instance Parsable TopDecl where
  tag = "topDecl"
  parse' = scanToP pTDecl
  placeholder = TopDecl $ VarDecl [placeholder]
  expectPass = expectPassBase (tag @TopDecl) (parse @TopDecl)
  expectFail = expectFailBase (tag @TopDecl) (parse @TopDecl)
  expectAst = expectAstBase (tag @TopDecl)

instance Parsable Signature where
  tag = "signature"
  parse' = scanToP pSig
  placeholder = Signature (Parameters placeholder) Nothing
  expectPass = expectPassBase (tag @Signature) (parse @Signature)
  expectFail = expectFailBase (tag @Signature) (parse @Signature)
  expectAst = expectAstBase (tag @Signature)

instance Parsable [ParameterDecl] where
  tag = "parameterDecls"
  parse' = scanToP pPar
  placeholder = [ParameterDecl placeholder placeholder]
  expectPass = expectPassBase (tag @[ParameterDecl]) (parse @[ParameterDecl])
  expectFail = expectFailBase (tag @[ParameterDecl]) (parse @[ParameterDecl])
  expectAst = expectAstBase (tag @[ParameterDecl])

instance Parsable Type' where
  tag = "type"
  parse' = scanToP pT
  placeholder = (o, Type $ Identifier o "temp")
  expectPass = expectPassBase (tag @Type') (parse @Type')
  expectFail = expectFailBase (tag @Type') (parse @Type')
  expectAst = expectAstBase (tag @Type')

instance Parsable Decl where
  tag = "decl"
  parse' = scanToP pDec
  placeholder = VarDecl [placeholder]
  expectPass = expectPassBase (tag @Decl) (parse @Decl)
  expectFail = expectFailBase (tag @Decl) (parse @Decl)
  expectAst = expectAstBase (tag @Decl)

instance Parsable [Expr] where
  tag = "exprs"
  parse' = scanToP pEl
  placeholder = [placeholder]
  expectPass = expectPassBase (tag @[Expr]) (parse @[Expr])
  expectFail = expectFailBase (tag @[Expr]) (parse @[Expr])
  expectAst = expectAstBase (tag @[Expr])

instance Parsable Expr where
  tag = "expr"
  parse' = scanToP pE
  placeholder = Lit $ StringLit o Raw "`temp`"
  expectPass = expectPassBase (tag @Expr) (parse @Expr)
  expectFail = expectFailBase (tag @Expr) (parse @Expr)
  expectAst = expectAstBase (tag @Expr)

instance Parsable VarDecl' where
  tag = "varDecl"
  parse' = scanToP pIDecl
  placeholder = VarDecl' placeholder (Right $ placeholder :| [])
  expectPass = expectPassBase (tag @VarDecl') (parse @VarDecl')
  expectFail = expectFailBase (tag @VarDecl') (parse @VarDecl')
  expectAst = expectAstBase (tag @VarDecl')

instance Parsable (NonEmpty Identifier) where
  tag = "ids"
  parse' s = fromList <$> scanToP pId s
  placeholder = Identifier o "temp" :| []
  expectPass = expectPassBase (tag @(NonEmpty Identifier)) (parse @(NonEmpty Identifier))
  expectFail = expectFailBase (tag @(NonEmpty Identifier)) (parse @(NonEmpty Identifier))
  expectAst = expectAstBase (tag @(NonEmpty Identifier))

scanToP :: (Show a, Eq a) => Alex a -> (String -> Either String a)
scanToP f s = runAlex s f

pairConvert :: (a -> a') -> (b -> b') -> [(a, b)] -> [(a', b')]
pairConvert f1 f2 = map (\(a, b) -> (f1 a, f2 b))

fstConvert :: (a -> a') -> [(a, b')] -> [(a', b')]
fstConvert f = pairConvert f id

sndConvert :: (b -> b') -> [(a, b)] -> [(a, b')]
sndConvert = pairConvert id

class SpecBuilder a where
  expectation :: a -> SpecWith ()
  specAll :: String -> [a] -> SpecWith ()
  specAll name items = describe name $ mapM_ expectation items

-- | Generate Either given a string and feed this to constructor
strData :: String -> (String -> a) -> (String, a)
strData s constr = (s, constr s)

strData' :: (String -> a) -> String -> (String, a)
strData' constr s = (s, constr s)

-- | Cartesian product of two lists
cartP :: [a] -> [b] -> [(a, b)]
cartP = liftA2 (,)

toRetL :: Monad m => a -> m [a]
toRetL e = return [e]

qcGen :: (Show a, Testable prop) => String -> Bool -> Gen a -> (a -> prop) -> SpecWith (Arg Property)
qcGen desc verb g p =
  it desc $
  property $
  if verb
    then verbose (forAll g p)
    else forAll g p