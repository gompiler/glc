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
  , expectBase
  , Parsable(..)
  , strData'
  , cartP
  , printError
  , module Test.Hspec
  , module Examples
  , module Test.QuickCheck
  , toRetL
  , qcGen
  , Parser.parsef
  , Parser.parsefNL
  ) where

import           Control.Applicative
import           Control.Monad       (unless)
import           Data
import qualified Data.Either         as Either
import           Data.Functor        ((<&>))
import           Data.List           (intercalate)
import           Data.List.NonEmpty  (NonEmpty (..), fromList)
import           Data.Text           (Text, unpack)
import           ErrorBundle
import           Examples
import           GHC.Unicode         (isSpace)
import           NeatInterpolation
import           Parser              (pDec, pE, pEl, pIDecl, pId, pPar, pSig,
                                      pStmt, pT, pTDecl)
import qualified Parser              (hparse, parse, parsef, parsefNL)
import           Prettify
import           Scanner             (Alex (..), errODef, runAlex')
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

printError :: Either String String -> SpecWith ()
printError (Right s) =
  describe "print" $ it "right error" $ expectationFailure s
printError (Left s) = describe "print" $ it "left error" $ expectationFailure s

-- | Relatively complex base expectation
-- Suffix is a tag for the description
-- Expectation maps the input to an expectation
-- Title maps the input to a string (prefix of description)
-- Name refers to tag from Parsable
-- Inputs refers to list of inputs
-- Note that the last two entries are type ambiguous, which is why we need to specify them
-- We order the parameters this way to avoid rewriting them
expectBase ::
     (HasCallStack)
  => String
  -> (s -> Expectation)
  -> (s -> String)
  -> String
  -> [s]
  -> SpecWith ()
expectBase suffix expectation title name inputs =
  describe (name ++ " " ++ suffix) $ mapM_ expect inputs
  where
    expect input = it (show $ lines $ title input) $ expectation input

-- | Expects that input parses with some ast
expectPassBase ::
     (Parsable a, Stringable s)
  => String
  -> (s -> Either String a)
  -> [s]
  -> SpecWith ()
expectPassBase tag parse =
  expectBase
    "success"
    (\s ->
       case parse s of
         Left error ->
           expectationFailure $
           "Expected parse success on:\n\n" ++
           toString s ++ "\n\nbut failed with\n\n" ++ error
         _ -> return ())
    toString
    tag

-- | Expects that input parses with some error
expectFailBase ::
     (Parsable a, Stringable s)
  => String
  -> (s -> Either String a)
  -> [s]
  -> SpecWith ()
expectFailBase tag parse =
  expectBase
    "fail"
    (\s ->
       case parse s of
         Right ast ->
           expectationFailure $
           "Expected parse failure on:\n\n" ++
           toString s ++ "\n\nbut succeeded with\n\n" ++ show ast
         _ -> return ())
    toString
    tag

-- | Expects that input parses with an exact ast match
expectAstBase :: (Parsable a, Stringable s) => String -> [(s, a)] -> SpecWith ()
expectAstBase =
  expectBase
    "ast"
    (\(s, e) ->
       case parse s of
         Left err ->
           expectationFailure $
           "Invalid ast for:\n\n" ++
           toString s ++
           "\n\nexpected\n\n" ++ show e ++ "\n\nbut failed with\n\n" ++ err
         Right a ->
           unless (e == a) . expectationFailure $
           "Invalid ast for:\n\n" ++
           toString s ++
           "\n\nexpected\n\n" ++ show e ++ "\n\nbut got\n\n" ++ show a)
    (toString . fst)

-- | Expects that pretty(parse(input)) = pretty(parse(pretty(parse(input))))
expectPrettyInvarBase ::
     (Parsable a, Prettify a, Stringable s)
  => String
  -> (String -> Either String a)
  -> [s]
  -> SpecWith ()
expectPrettyInvarBase tag parse =
  expectBase
    "pretty invar"
    (\s ->
       let s' = toString s
        in case multiPass s' of
             Left err ->
               expectationFailure $
               "Invalid prettify for:\n\n" ++ s' ++ "\n\nfailed with\n\n" ++ err
             Right p -> return ())
    toString
    tag
  where
    multiPass input = do
      ast1 <- parse input
      let pretty1 = prettify ast1
      ast2 <- parse pretty1
      let pretty2 = prettify ast2
      case (ast1 == ast2, pretty1 == pretty2) of
        (False, _) ->
          Left $
          "AST mismatch: First\n\n" ++
          show ast1 ++ "\n\nSecond\n\n" ++ show ast2
        (_, False) ->
          Left $
          "Prettify mismatch: First\n\n" ++
          pretty1 ++ "\n\nSecond\n\n" ++ pretty2
        _ -> Right pretty2

-- | Expects that input = pretty(parse(input))
expectPrettyExactBase ::
     (Parsable a, Prettify a, Stringable s)
  => String
  -> (String -> Either String a)
  -> [s]
  -> SpecWith ()
expectPrettyExactBase tag parse =
  expectBase
    "pretty exact"
    (\s ->
       let s' = toString s
        in case multiPass s' of
             Left err ->
               expectationFailure $
               "Invalid prettify for:\n\n" ++ s' ++ "\n\nfailed with\n\n" ++ err
             Right p -> return ())
    toString
    tag
  where
    multiPass input = do
      pretty <- parse input <&> prettify
      if clean input == clean pretty
        then Right pretty
        else Left $
             "Prettify mismatch: Expected\n\n" ++
             input ++ "\n\nActually (whitespace ignored)\n\n" ++ pretty
    clean = filter (not . isSpace)

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
  expectPrettyExact :: Stringable s => [s] -> SpecWith ()

instance Parsable Program where
  tag = "program"
  parse' = Parser.parse
  placeholder = Program {package = "temp", topLevels = []}
  expectPass = expectPassBase (tag @Program) (parse @Program)
  expectFail = expectFailBase (tag @Program) (parse @Program)
  expectAst = expectAstBase (tag @Program)
  expectPrettyInvar = expectPrettyInvarBase (tag @Program) (parse @Program)
  expectPrettyExact = expectPrettyExactBase (tag @Program) (parse @Program)

instance Parsable Stmt where
  tag = "stmt"
  parse' = Parser.parsefNL pStmt
  placeholder = blank
  expectPass = expectPassBase (tag @Stmt) (parse @Stmt)
  expectFail = expectFailBase (tag @Stmt) (parse @Stmt)
  expectAst = expectAstBase (tag @Stmt)
  expectPrettyInvar = expectPrettyInvarBase (tag @Stmt) (parse @Stmt)
  expectPrettyExact = expectPrettyExactBase (tag @Stmt) (parse @Stmt)

instance Parsable TopDecl where
  tag = "topDecl"
  parse' = Parser.parsefNL pTDecl
  placeholder = TopDecl $ VarDecl [placeholder]
  expectPass = expectPassBase (tag @TopDecl) (parse @TopDecl)
  expectFail = expectFailBase (tag @TopDecl) (parse @TopDecl)
  expectAst = expectAstBase (tag @TopDecl)
  expectPrettyInvar = expectPrettyInvarBase (tag @TopDecl) (parse @TopDecl)
  expectPrettyExact = expectPrettyExactBase (tag @TopDecl) (parse @TopDecl)

instance Parsable Signature where
  tag = "signature"
  parse' = Parser.parsef pSig
  placeholder = Signature (Parameters placeholder) Nothing
  expectPass = expectPassBase (tag @Signature) (parse @Signature)
  expectFail = expectFailBase (tag @Signature) (parse @Signature)
  expectAst = expectAstBase (tag @Signature)
  expectPrettyInvar = expectPrettyInvarBase (tag @Signature) (parse @Signature)
  expectPrettyExact = expectPrettyExactBase (tag @Signature) (parse @Signature)

instance Parsable [ParameterDecl] where
  tag = "parameterDecls"
  parse' = Parser.parsef pPar
  placeholder = [ParameterDecl placeholder placeholder]
  expectPass = expectPassBase (tag @[ParameterDecl]) (parse @[ParameterDecl])
  expectFail = expectFailBase (tag @[ParameterDecl]) (parse @[ParameterDecl])
  expectAst = expectAstBase (tag @[ParameterDecl])
  expectPrettyInvar =
    expectPrettyInvarBase (tag @[ParameterDecl]) (parse @[ParameterDecl])
  expectPrettyExact =
    expectPrettyExactBase (tag @[ParameterDecl]) (parse @[ParameterDecl])

instance Prettify [ParameterDecl] where
  prettify' params = prettify' $ Parameters params

instance Parsable Type' where
  tag = "type"
  parse' = Parser.parsef pT
  placeholder = (o, Type $ Identifier o "temp")
  expectPass = expectPassBase (tag @Type') (parse @Type')
  expectFail = expectFailBase (tag @Type') (parse @Type')
  expectAst = expectAstBase (tag @Type')
  expectPrettyInvar = expectPrettyInvarBase (tag @Type') (parse @Type')
  expectPrettyExact = expectPrettyExactBase (tag @Type') (parse @Type')

instance Parsable Decl where
  tag = "decl"
  parse' = Parser.parsef pDec
  placeholder = VarDecl [placeholder]
  expectPass = expectPassBase (tag @Decl) (parse @Decl)
  expectFail = expectFailBase (tag @Decl) (parse @Decl)
  expectAst = expectAstBase (tag @Decl)
  expectPrettyInvar = expectPrettyInvarBase (tag @Decl) (parse @Decl)
  expectPrettyExact = expectPrettyExactBase (tag @Decl) (parse @Decl)

instance Parsable [Expr] where
  tag = "exprs"
  parse' = Parser.parsef pEl
  placeholder = [placeholder]
  expectPass = expectPassBase (tag @[Expr]) (parse @[Expr])
  expectFail = expectFailBase (tag @[Expr]) (parse @[Expr])
  expectAst = expectAstBase (tag @[Expr])
  expectPrettyInvar = expectPrettyInvarBase (tag @[Expr]) (parse @[Expr])
  expectPrettyExact = expectPrettyExactBase (tag @[Expr]) (parse @[Expr])

instance Prettify [Expr] where
  prettify' exprs = [intercalate ", " $ map prettify exprs]

instance Parsable Expr where
  tag = "expr"
  parse' = Parser.parsef pE
  placeholder = Lit $ StringLit o Raw "`temp`"
  expectPass = expectPassBase (tag @Expr) (parse @Expr)
  expectFail = expectFailBase (tag @Expr) (parse @Expr)
  expectAst = expectAstBase (tag @Expr)
  expectPrettyInvar = expectPrettyInvarBase (tag @Expr) (parse @Expr)
  expectPrettyExact = expectPrettyExactBase (tag @Expr) (parse @Expr)

instance Parsable VarDecl' where
  tag = "varDecl"
  parse' = Parser.parsef pIDecl
  placeholder = VarDecl' placeholder (Right $ placeholder :| [])
  expectPass = expectPassBase (tag @VarDecl') (parse @VarDecl')
  expectFail = expectFailBase (tag @VarDecl') (parse @VarDecl')
  expectAst = expectAstBase (tag @VarDecl')
  expectPrettyInvar = expectPrettyInvarBase (tag @VarDecl') (parse @VarDecl')
  expectPrettyExact = expectPrettyExactBase (tag @VarDecl') (parse @VarDecl')

instance Parsable Identifiers where
  tag = "ids"
  parse' s = fromList . reverse <$> Parser.parsef pId s
  placeholder = Identifier o "temp" :| []
  expectPass = expectPassBase (tag @Identifiers) (parse @Identifiers)
  expectFail = expectFailBase (tag @Identifiers) (parse @Identifiers)
  expectAst = expectAstBase (tag @Identifiers)
  expectPrettyInvar =
    expectPrettyInvarBase (tag @Identifiers) (parse @Identifiers)
  expectPrettyExact =
    expectPrettyExactBase (tag @Identifiers) (parse @Identifiers)

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

qcGen ::
     (Show a, Testable prop)
  => String
  -> Bool
  -> Gen a
  -> (a -> prop)
  -> SpecWith (Arg Property)
qcGen desc verb g p =
  it desc $
  property $
  if verb
    then verbose (forAll g p)
    else forAll g p
