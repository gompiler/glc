{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
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
  , strData'
  , cartP
  , module Test.Hspec
  , module Test.QuickCheck
  , toRetL
  , qcGen
  ) where

import           Control.Applicative
import           Data
import           Data.List.NonEmpty  (NonEmpty (..), fromList)
import           Data.Text           (Text, unpack)
import           ErrorBundle
import           NeatInterpolation
import           Parser              (pDec, pE, pEl, pId, pIDecl, pPar, pSig,
                                      pStmt, pT, pTDecl, parse)
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

class (Show a, Eq a) =>
      Parsable a
  where
  tag :: a -> String
  parse :: String -> Either String a
  placeholder :: a

instance Parsable Program where
  tag = const "program"
  parse = Parser.parse
  placeholder = Program {package = "temp", topLevels = []}

instance Parsable Stmt where
  tag = const "stmt"
  parse = scanToP pStmt
  placeholder = blank

instance Parsable TopDecl where
  tag = const "topDecl"
  parse = scanToP pTDecl
  placeholder = TopDecl $ VarDecl [placeholder]

instance Parsable Signature where
  tag = const "signature"
  parse = scanToP pSig
  placeholder = Signature (Parameters placeholder) Nothing

instance Parsable [ParameterDecl] where
  tag = const "parameterDecls"
  parse = scanToP pPar
  placeholder = [ParameterDecl placeholder placeholder]

instance Parsable Type' where
  tag = const "type"
  parse = scanToP pT
  placeholder = (o, Type $ Identifier o "temp")

instance Parsable Decl where
  tag = const "decl"
  parse = scanToP pDec
  placeholder = VarDecl [placeholder]

instance Parsable [Expr] where
  tag = const "exprs"
  parse = scanToP pEl
  placeholder = [placeholder]

instance Parsable Expr where
  tag = const "expr"
  parse = scanToP pE
  placeholder = Lit $ StringLit o Raw "`temp`"

instance Parsable VarDecl' where
  tag = const "varDecl"
  parse = scanToP pIDecl
  placeholder = VarDecl' placeholder (Right $ placeholder :| [])

instance Parsable (NonEmpty Identifier) where
  tag = const "ids"
  parse s = fmap fromList $ scanToP pId s
  placeholder = Identifier o "temp" :| []

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
