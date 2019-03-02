{-# LANGUAGE AllowAmbiguousTypes   #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeApplications      #-}

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
  , scanToP
  ) where

import           Control.Applicative
import           Control.Monad       (unless)
import           Data
import qualified Data.Either         as Either
import           Data.List           (intercalate)
import           Data.List.NonEmpty  (NonEmpty (..), fromList)
import           Data.Text           (Text, unpack)
import           ErrorBundle
import           NeatInterpolation
import           Parser              (pDec, pE, pEl, pIDecl, pId, pPar, pSig,
                                      pStmt, pT, pTDecl)
import qualified Parser              (parse)
import           Prettify
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
           expectationFailure $ "Expected parse success on:\n\n" ++ toString s ++ "\n\nbut failed with\n\n" ++ error
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
           "Expected parse failure on:\n\n" ++ toString s ++ "\n\nbut succeeded with\n\n" ++ show ast
         _ -> return ())
    toString
    tag

expectAstBase :: (Parsable a, Stringable s) => String -> [(s, a)] -> SpecWith ()
expectAstBase =
  expectBase
    "ast"
    (\(s, e) ->
       case parse s of
         Left err ->
           expectationFailure $
           "Invalid ast for:\n\n" ++ toString s ++ "\n\nexpected\n\n" ++ show e ++ "\n\nbut failed with\n\n" ++ err
         Right a ->
           unless (e == a) . expectationFailure $
           "Invalid ast for:\n\n" ++ toString s ++ "\n\nexpected\n\n" ++ show e ++ "\n\nbut got\n\n" ++ show a)
    (toString . fst)

expectPrettyInvarBase ::
     (Parsable a, Prettify a, Stringable s) => String -> (String -> Either String a) -> [s] -> SpecWith ()
expectPrettyInvarBase tag parse =
  expectBase "pretty invar" (\s -> either expectationFailure (const $ return ()) (multiPass $ toString s)) toString tag
  where
    multiPass input = do
      ast1 <- parse input
      let pretty1 = prettify ast1
      ast2 <- parse pretty1
      let pretty2 = prettify ast2
      case (ast1 == ast2, pretty1 == pretty2) of
        (False, _) -> Left $ "AST mismatch: First\n\n" ++ show ast1 ++ "\n\nSecond\n\n" ++ show ast2
        (_, False) -> Left $ "Prettify mismatch: First\n\n" ++ pretty1 ++ "\n\nSecond\n\n" ++ pretty2
        _ -> Right ast2

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
  expectPrettyInvar :: Stringable s => [s] -> SpecWith ()

instance Parsable Program where
  tag = "program"
  parse' = Parser.parse
  placeholder = Program {package = "temp", topLevels = []}
  expectPass = expectPassBase (tag @Program) (parse @Program)
  expectFail = expectFailBase (tag @Program) (parse @Program)
  expectAst = expectAstBase (tag @Program)
  expectPrettyInvar = expectPrettyInvarBase (tag @Program) (parse @Program)

instance Parsable Stmt where
  tag = "stmt"
  parse' = scanToP pStmt
  placeholder = blank
  expectPass = expectPassBase (tag @Stmt) (parse @Stmt)
  expectFail = expectFailBase (tag @Stmt) (parse @Stmt)
  expectAst = expectAstBase (tag @Stmt)
  expectPrettyInvar = expectPrettyInvarBase (tag @Stmt) (parse @Stmt)

instance Parsable TopDecl where
  tag = "topDecl"
  parse' = scanToP pTDecl
  placeholder = TopDecl $ VarDecl [placeholder]
  expectPass = expectPassBase (tag @TopDecl) (parse @TopDecl)
  expectFail = expectFailBase (tag @TopDecl) (parse @TopDecl)
  expectAst = expectAstBase (tag @TopDecl)
  expectPrettyInvar = expectPrettyInvarBase (tag @TopDecl) (parse @TopDecl)

instance Parsable Signature where
  tag = "signature"
  parse' = scanToP pSig
  placeholder = Signature (Parameters placeholder) Nothing
  expectPass = expectPassBase (tag @Signature) (parse @Signature)
  expectFail = expectFailBase (tag @Signature) (parse @Signature)
  expectAst = expectAstBase (tag @Signature)
  expectPrettyInvar = expectPrettyInvarBase (tag @Signature) (parse @Signature)

instance Parsable [ParameterDecl] where
  tag = "parameterDecls"
  parse' = scanToP pPar
  placeholder = [ParameterDecl placeholder placeholder]
  expectPass = expectPassBase (tag @[ParameterDecl]) (parse @[ParameterDecl])
  expectFail = expectFailBase (tag @[ParameterDecl]) (parse @[ParameterDecl])
  expectAst = expectAstBase (tag @[ParameterDecl])
  expectPrettyInvar = expectPrettyInvarBase (tag @[ParameterDecl]) (parse @[ParameterDecl])

instance Prettify [ParameterDecl] where
  prettify' params = prettify' $ Parameters params

instance Parsable Type' where
  tag = "type"
  parse' = scanToP pT
  placeholder = (o, Type $ Identifier o "temp")
  expectPass = expectPassBase (tag @Type') (parse @Type')
  expectFail = expectFailBase (tag @Type') (parse @Type')
  expectAst = expectAstBase (tag @Type')
  expectPrettyInvar = expectPrettyInvarBase (tag @Type') (parse @Type')

instance Parsable Decl where
  tag = "decl"
  parse' = scanToP pDec
  placeholder = VarDecl [placeholder]
  expectPass = expectPassBase (tag @Decl) (parse @Decl)
  expectFail = expectFailBase (tag @Decl) (parse @Decl)
  expectAst = expectAstBase (tag @Decl)
  expectPrettyInvar = expectPrettyInvarBase (tag @Decl) (parse @Decl)

instance Parsable [Expr] where
  tag = "exprs"
  parse' = scanToP pEl
  placeholder = [placeholder]
  expectPass = expectPassBase (tag @[Expr]) (parse @[Expr])
  expectFail = expectFailBase (tag @[Expr]) (parse @[Expr])
  expectAst = expectAstBase (tag @[Expr])
  expectPrettyInvar = expectPrettyInvarBase (tag @[Expr]) (parse @[Expr])

instance Prettify [Expr] where
  prettify' exprs = [intercalate ", " $ map prettify exprs]

instance Parsable Expr where
  tag = "expr"
  parse' = scanToP pE
  placeholder = Lit $ StringLit o Raw "`temp`"
  expectPass = expectPassBase (tag @Expr) (parse @Expr)
  expectFail = expectFailBase (tag @Expr) (parse @Expr)
  expectAst = expectAstBase (tag @Expr)
  expectPrettyInvar = expectPrettyInvarBase (tag @Expr) (parse @Expr)

instance Parsable VarDecl' where
  tag = "varDecl"
  parse' = scanToP pIDecl
  placeholder = VarDecl' placeholder (Right $ placeholder :| [])
  expectPass = expectPassBase (tag @VarDecl') (parse @VarDecl')
  expectFail = expectFailBase (tag @VarDecl') (parse @VarDecl')
  expectAst = expectAstBase (tag @VarDecl')
  expectPrettyInvar = expectPrettyInvarBase (tag @VarDecl') (parse @VarDecl')

instance Parsable Identifiers where
  tag = "ids"
  parse' s = fromList . reverse <$> scanToP pId s
  placeholder = Identifier o "temp" :| []
  expectPass = expectPassBase (tag @Identifiers) (parse @Identifiers)
  expectFail = expectFailBase (tag @Identifiers) (parse @Identifiers)
  expectAst = expectAstBase (tag @Identifiers)
  expectPrettyInvar = expectPrettyInvarBase (tag @Identifiers) (parse @Identifiers)

scanToP :: (Show a, Eq a) => Alex a -> (String -> Either String a)
scanToP f s = either (\(err, o) -> Left err) Right (runAlex s f)

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
