{-# LANGUAGE AllowAmbiguousTypes   #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables   #-}
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
  , expectPass
  , expectFail
  , expectAst
  , expectPrettyExact
  , expectPrettyInvar
  , qcGen
  , Parser.parsef
  , Parser.parsefNL
  ) where

import           Control.Applicative
import           Control.Monad       (unless)
import           Data
import           Data.Char           (isSpace)
import           Data.Functor        ((<&>))
import           Data.List.NonEmpty  (NonEmpty (..), fromList)
import           Data.Text           (Text, unpack)
import           ErrorBundle
import           Examples
import           NeatInterpolation
import           Parser              (pDec, pE, pEl, pIDecl, pId, pPar, pSig,
                                      pStmt, pT, pTDecl)
import qualified Parser              (parse, parsef, parsefNL)
import           Prettify
import           Scanner             (InnerToken, scanT)
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
expectBase suffix expectation' title name inputs =
  describe (name ++ " " ++ suffix) $ mapM_ expect inputs
  where
    expect input = it (show $ lines $ title input) $ expectation' input

-- | Expects that input parses with some ast
expectPass ::
     forall a s. (Parsable a, Stringable s)
  => [s]
  -> SpecWith ()
expectPass =
  expectBase
    "success"
    (\s ->
       case parse @a s of
         Left err ->
           expectationFailure $
           "Expected parse success on:\n\n" ++
           toString s ++ "\n\nbut failed with\n\n" ++ err
         _ -> return ())
    toString
    (tag @a)

-- | Expects that input parses with some error
expectFail ::
     forall a s. (Parsable a, Stringable s)
  => [s]
  -> SpecWith ()
expectFail =
  expectBase
    "fail"
    (\s ->
       case parse @a s of
         Right ast ->
           expectationFailure $
           "Expected parse failure on:\n\n" ++
           toString s ++ "\n\nbut succeeded with\n\n" ++ show ast
         _ -> return ())
    toString
    (tag @a)

-- | Expects that input parses with an exact ast match
expectAst ::
     forall a s. (Parsable a, Stringable s)
  => [(s, a)]
  -> SpecWith ()
expectAst =
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
    (tag @a)

-- | Expects that pretty(parse(input)) = pretty(parse(pretty(parse(input))))
expectPrettyInvar ::
     forall a s. (Parsable a, Prettify a, Stringable s)
  => [s]
  -> SpecWith ()
expectPrettyInvar =
  expectBase
    "pretty invar"
    (\s ->
       let s' = toString s
        in case multiPass s' of
             Left err ->
               expectationFailure $
               "Invalid prettify for:\n\n" ++ s' ++ "\n\nfailed with\n\n" ++ err
             Right _ -> return ())
    toString
    (tag @a)
  where
    multiPass input = do
      ast1 <- parse @a input
      let pretty1 = prettify ast1
      ast2 <- parse @a pretty1
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
expectPrettyExact ::
     forall a s. (Parsable a, Prettify a, Stringable s)
  => [s]
  -> SpecWith ()
expectPrettyExact =
  expectBase
    "pretty exact"
    (\s ->
       let s' = toString s
        in case multiPass s' of
             Left err ->
               expectationFailure $
               "Invalid prettify for:\n\n" ++ s' ++ "\n\nfailed with\n\n" ++ err
             Right _ -> return ())
    toString
    (tag @a)
  where
    multiPass input = do
      pretty <- parse @a input <&> prettify
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

instance Parsable Program where
  tag = "program"
  parse' = Parser.parse
  placeholder = Program {package = "temp", topLevels = []}

instance Parsable Stmt where
  tag = "stmt"
  parse' = Parser.parsefNL pStmt
  placeholder = blank

instance Parsable TopDecl where
  tag = "topDecl"
  parse' = Parser.parsefNL pTDecl
  placeholder = TopDecl $ VarDecl [placeholder]

instance Parsable Signature where
  tag = "signature"
  parse' = Parser.parsef pSig
  placeholder = Signature (Parameters placeholder) Nothing

instance Parsable [ParameterDecl] where
  tag = "parameterDecls"
  parse' = Parser.parsef pPar
  placeholder = [ParameterDecl placeholder placeholder]

instance Parsable Type' where
  tag = "type"
  parse' = Parser.parsef pT
  placeholder = (o, Type $ Identifier o "temp")

instance Parsable Decl where
  tag = "decl"
  parse' = Parser.parsef pDec
  placeholder = VarDecl [placeholder]

instance Parsable [Expr] where
  tag = "exprs"
  parse' = Parser.parsef pEl
  placeholder = [placeholder]

instance Parsable Expr where
  tag = "expr"
  parse' = Parser.parsef pE
  placeholder = Lit $ StringLit o Raw "`temp`"

instance Parsable VarDecl' where
  tag = "varDecl"
  parse' = Parser.parsef pIDecl
  placeholder = VarDecl' placeholder (Right $ placeholder :| [])

instance Parsable Identifiers where
  tag = "ids"
  parse' s = fromList . reverse <$> Parser.parsef pId s
  placeholder = Identifier o "temp" :| []

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

instance SpecBuilder (String, [InnerToken]) where
  expectation (input, expected) =
    it (show $ lines input) $ scanT input `shouldBe` Right expected

instance SpecBuilder (String, String) where
  expectation (input, failure) =
    it (show $ lines input) $ scanT input `shouldBe` Left failure

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
