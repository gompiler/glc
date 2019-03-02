{-# LANGUAGE AllowAmbiguousTypes   #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeApplications      #-}
{-# LANGUAGE TypeSynonymInstances  #-}

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

import           Control.Applicative
import           Data
import qualified Data.Either         as Either
import           Data.List.NonEmpty  (NonEmpty (..), fromList)
import           Data.Text           (Text, unpack)
import           ErrorBundle
import           NeatInterpolation
import           Parser              (pDec, pE, pEl, pIDecl, pId, pPar, pSig,
                                      pStmt, pT, pTDecl)
import qualified Parser              (parse)
import           Scanner             (Alex (..), runAlex)
import           Test.Hspec
import           Test.QuickCheck

o :: Offset
o = Offset 0

class Stringable a where
  toString :: a -> String

instance Stringable String where
  toString = id

instance Stringable Text where
  toString = unpack

expectPassBase :: (Parsable a, Stringable s) => String -> (String -> Either String a) -> [s] -> SpecWith ()
expectPassBase name parse inputs = describe (name ++ " success") $ mapM_ (expect . toString) inputs
  where
    expect input = it (show $ lines input) $ parse input `shouldSatisfy` Either.isRight

class (Show a, Eq a) =>
      Parsable a
  where
  tag :: String
  parse :: Stringable s => s -> Either String a
  parse s = parse' $ toString s
  parse' :: String -> Either String a
  placeholder :: a
  expectPass :: Stringable s => [s] -> SpecWith ()

instance Parsable Program where
  tag = "program"
  parse' = Parser.parse
  placeholder = Program {package = "temp", topLevels = []}
  expectPass = expectPassBase (tag @Program) (parse @Program)

instance Parsable Stmt where
  tag = "stmt"
  parse' = scanToP pStmt
  placeholder = blank
  expectPass = expectPassBase (tag @Stmt) (parse @Stmt)

instance Parsable TopDecl where
  tag = "topDecl"
  parse' = scanToP pTDecl
  placeholder = TopDecl $ VarDecl [placeholder]
  expectPass = expectPassBase (tag @TopDecl) (parse @TopDecl)

instance Parsable Signature where
  tag = "signature"
  parse' = scanToP pSig
  placeholder = Signature (Parameters placeholder) Nothing
  expectPass = expectPassBase (tag @Signature) (parse @Signature)

instance Parsable [ParameterDecl] where
  tag = "parameterDecls"
  parse' = scanToP pPar
  placeholder = [ParameterDecl placeholder placeholder]
  expectPass = expectPassBase (tag @[ParameterDecl]) (parse @[ParameterDecl])

instance Parsable Type' where
  tag = "type"
  parse' = scanToP pT
  placeholder = (o, Type $ Identifier o "temp")
  expectPass = expectPassBase (tag @Type') (parse @Type')

instance Parsable Decl where
  tag = "decl"
  parse' = scanToP pDec
  placeholder = VarDecl [placeholder]
  expectPass = expectPassBase (tag @Decl) (parse @Decl)

instance Parsable [Expr] where
  tag = "exprs"
  parse' = scanToP pEl
  placeholder = [placeholder]
  expectPass = expectPassBase (tag @[Expr]) (parse @[Expr])

instance Parsable Expr where
  tag = "expr"
  parse' = scanToP pE
  placeholder = Lit $ StringLit o Raw "`temp`"
  expectPass = expectPassBase (tag @Expr) (parse @Expr)

instance Parsable VarDecl' where
  tag = "varDecl"
  parse' = scanToP pIDecl
  placeholder = VarDecl' placeholder (Right $ placeholder :| [])
  expectPass = expectPassBase (tag @VarDecl') (parse @VarDecl')

instance Parsable (NonEmpty Identifier) where
  tag = "ids"
  parse s = fromList <$> scanToP pId s
  placeholder = Identifier o "temp" :| []
  expectPass = expectPassBase (tag @(NonEmpty Identifier)) (parse @(NonEmpty Identifier))

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
