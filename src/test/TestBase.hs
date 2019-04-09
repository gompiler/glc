{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

module TestBase
  ( SpecBuilder(..)
  , Data.Text.Text
  , Data.Text.unpack
  , NeatInterpolation.text
  , o
  , module Base
  , Stringable(..)
  , ParseTest(..)
  , expectBase
  , printError
  , expectError
  , module Test.Hspec
  , module Examples
  , module Test.QuickCheck
  , toRetL
  , containsError
  , expectPass
  , expectFail
  , expectAst
  , PrettyFormat(..)
  , expectPrettyExact
  , expectPrettyMatch
  , expectPrettyInvar
  , todoSpec
  , qcGen
  , unless
  ) where

import Base
import Control.Monad (unless)
import Data
import Data.List.NonEmpty (NonEmpty(..))
import Data.Text (Text, unpack)
import Examples
import NeatInterpolation
import Parser
import Prettify
import Scanner (InnerToken, scanT)
import Test.Hspec
import Test.Hspec.QuickCheck (prop)
import Test.QuickCheck

todoSpec :: Spec
todoSpec = describe "TODO" $ return ()

o :: Offset
o = Offset 0

class Stringable a where
  toString :: a -> String

instance Stringable String where
  toString = id

instance Stringable Text where
  toString = unpack

printError :: Either String String -> Spec
printError (Right s) =
  describe "print" $ it "right error" $ expectationFailure s
printError (Left s) = describe "print" $ it "left error" $ expectationFailure s

-- | Relatively complex base expectation
-- Suffix is a tag for the description
-- Expectation maps the input to an expectation
-- Title maps the input to a string (prefix of description)
-- Name refers to tag from ParseTest
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
  -> Spec
expectBase suffix expectation' title name inputs =
  describe (name ++ " " ++ suffix) $ mapM_ expect inputs
    -- | We trim the spec title so that it doesn't take too much space
    -- The limit is arbitrary
  where
    expect input =
      it (take 80 $ show $ lines $ title input) $ expectation' input

-- | Expects that input parses with some ast
expectPass ::
     forall a s. (ParseTest a, Stringable s)
  => [s]
  -> Spec
expectPass =
  expectBase
    "success"
    (\s ->
       case parse' @a s of
         Left err ->
           expectationFailure $
           "Expected parse success on:\n\n" ++
           toString s ++ "\n\nbut failed with\n\n" ++ show err
         _ -> return ())
    toString
    (tag @a)

-- | Expects that input parses with some error
expectFail ::
     forall a s. (ParseTest a, Stringable s)
  => [s]
  -> Spec
expectFail =
  expectBase
    "fail"
    (\s ->
       case parse' @a s of
         Right ast ->
           expectationFailure $
           "Expected parse failure on:\n\n" ++
           toString s ++ "\n\nbut succeeded with\n\n" ++ show ast
         _ -> return ())
    toString
    (tag @a)

expectError ::
     forall a s e. (ParseTest a, Stringable s, ErrorEntry e)
  => [(s, e)]
  -> Spec
expectError =
  expectBase
    "error"
    (\(s, e) ->
       case parse' @a s of
         Right ast ->
           expectationFailure $
           "Expected parse failure on:\n\n" ++
           toString s ++ "\n\nbut succeeded with\n\n" ++ show ast
         Left err -> err `containsError` e)
    (toString . fst)
    (tag @a)

containsError :: ErrorEntry e => ErrorMessage -> e -> Expectation
err `containsError` e =
  unless (err `hasError` e) . expectationFailure $
  "Expected error:\t" ++
  show e ++ "\nbut got:\t" ++ showErrorEntry err ++ "\n\n" ++ show err

-- | Expects that input parses with an exact ast match
expectAst ::
     forall a s. (ParseTest a, Stringable s)
  => [(s, a)]
  -> Spec
expectAst =
  expectBase
    "ast"
    (\(s, e) ->
       case parse' s of
         Left err ->
           expectationFailure $
           "Invalid ast for:\n\n" ++
           toString s ++
           "\n\nexpected\n\n" ++ show e ++ "\n\nbut failed with\n\n" ++ show err
         Right a ->
           unless (e == a) . expectationFailure $
           "Invalid ast for:\n\n" ++
           toString s ++
           "\n\nexpected\n\n" ++ show e ++ "\n\nbut got\n\n" ++ show a)
    (toString . fst)
    (tag @a)

-- | Expects that pretty(parse(input)) = pretty(parse(pretty(parse(input))))
expectPrettyInvar ::
     forall a s. (ParseTest a, Prettify a, Stringable s)
  => [s]
  -> Spec
expectPrettyInvar =
  expectBase
    "pretty invar"
    (\s ->
       let s' = toString s
        in case multiPass s' of
             Left err ->
               expectationFailure $
               "Invalid prettify for:\n\n" ++
               s' ++ "\n\nfailed with\n\n" ++ show err
             Right _ -> return ())
    toString
    (tag @a)
  where
    multiPass input = do
      ast1 <- parse' @a input
      let pretty1 = prettify ast1
      ast2 <- parse' @a pretty1
      let pretty2 = prettify ast2
      case (ast1 == ast2, expectStringMatch pretty1 pretty2) of
        (False, _) ->
          Left $
          createError' $
          "AST mismatch: First\n\n" ++
          show ast1 ++ "\n\nSecond\n\n" ++ show ast2
        (_, Just err) -> Left err
        _ -> Right pretty2

-- | Expects that input = pretty(parse(input))
expectPrettyExact ::
     forall a s. (ParseTest a, Prettify a, Stringable s)
  => [s]
  -> Spec
expectPrettyExact =
  expectBase
    "pretty exact"
    (\s ->
       let s' = toString s
        in case multiPass s' of
             Left err -> expectationFailure $ show err
             Right _ -> return ())
    toString
    (tag @a)
  where
    multiPass :: String -> Glc String
    multiPass input = do
      pretty <- parse @a input <&> prettify
      let input' = format input
      maybe (Right pretty) Left $ expectStringMatch input' pretty

expectPrettyMatch ::
     forall s1 s2 p. (Stringable s1, Stringable s2, Prettify p)
  => String
  -> (String -> Glc p)
  -> [(s1, s2)]
  -> Spec
expectPrettyMatch tag' formatter =
  expectBase
    "pretty match"
    (\(s1, s2) ->
       let input = toString s1
           actual = format . prettify <$> formatter input
           expected = format $ toString s2
        in either
             (expectationFailure . show)
             (const $ return ())
             (check' expected =<< actual))
    (toString . fst)
    tag'
  where
    check' :: String -> String -> Glc String
    check' expected actual =
      maybe (Right expected) Left $ expectStringMatch expected actual

-- | Checks that two strings match
-- Returns Just err if strings don't match, Nothing otherwise
expectStringMatch :: String -> String -> Maybe ErrorMessage
expectStringMatch expected actual = mismatchIndex expected actual <&> indexError
    -- | Return first index where strings don't match, or Nothing otherwise
  where
    mismatchIndex :: String -> String -> Maybe Int
    mismatchIndex = mismatchIndex' 0
    mismatchIndex' :: Int -> String -> String -> Maybe Int
    mismatchIndex' i (x:xs) (x':xs') =
      if x == x'
        then mismatchIndex' (i + 1) xs xs'
        else Just i
    mismatchIndex' i l l' =
      if null l && null l'
        then Nothing
        else Just i
    -- | Generates error message around supplied index
    -- For the sake of clarity, we will showcase a portion of the expected string
    -- rather than just the mismatched character.
    -- The range is arbitrary
    indexError :: Int -> ErrorMessage
    indexError i =
      let message =
            "Expected '" ++ ([i - 10 .. i + 7] >>= getSafe expected) ++ "'"
          error' = createError (Offset i) message actual
       in error' `withPrefix` ("Prettify failed for \n\n" ++ actual ++ "\n\n")
    -- | Safe index retrieval for strings
    -- Note that some chars are formatted for readability
    getSafe :: String -> Int -> String
    getSafe s i =
      if i >= 0 && i < length s
        then case s !! i of
               '\n' -> "\\n"
               s' -> [s']
        else "?"

class (Parsable a) =>
      ParseTest a
  where
  tag :: String
  parse' :: Stringable s => s -> Glc a
  parse' = parse . toString
  placeholder :: a

instance ParseTest Program where
  tag = "program"
  placeholder = Program {package = Identifier o "temp", topLevels = []}

instance ParseTest Stmt where
  tag = "stmt"
  placeholder = blank

instance ParseTest TopDecl where
  tag = "topDecl"
  placeholder = TopDecl $ VarDecl [placeholder]

instance ParseTest Signature where
  tag = "signature"
  placeholder = Signature (Parameters placeholder) Nothing

instance ParseTest [ParameterDecl] where
  tag = "parameterDecls"
  placeholder = [ParameterDecl placeholder placeholder]

instance ParseTest Type' where
  tag = "type"
  placeholder = (o, Type $ Identifier o "temp")

instance ParseTest Decl where
  tag = "decl"
  placeholder = VarDecl [placeholder]

instance ParseTest [Expr] where
  tag = "exprs"
  placeholder = [placeholder]

instance ParseTest Expr where
  tag = "expr"
  placeholder = Lit $ StringLit o Raw "`temp`"

instance ParseTest VarDecl' where
  tag = "varDecl"
  placeholder = VarDecl' placeholder (Right $ placeholder :| [])

instance ParseTest Identifiers where
  tag = "ids"
  placeholder = Identifier o "temp" :| []

class SpecBuilder a where
  expectation :: a -> Spec
  specAll :: String -> [a] -> Spec
  specAll name items = describe name $ mapM_ expectation items

instance SpecBuilder (String, [InnerToken]) where
  expectation (input, expected) =
    it (show $ lines input) $ scanT input `shouldBe` Right expected

instance SpecBuilder (String, String) where
  expectation (input, failure) =
    it (show $ lines input) $ scanT input `shouldBe` Left (createError' failure)

newtype PrettyFormat =
  PrettyFormat (String, String)

instance SpecBuilder PrettyFormat where
  expectation (PrettyFormat (input, expected)) =
    it (show $ lines input) $ format input `shouldBe` expected

-- | Formats a program string so that it conforms with prettify
-- * Leading and trailing lines with just whitespaces are removed
-- * Trailing whitespaces for every line is removed
-- * Tabs are reformatted so that the tab size matches that of prettify
format :: String -> String
format program =
  let (offsets, rows) = unzip $ (lstrip' . rstrip') $ map clean $ lines program
      gcd' = gcdAll offsets
      offsets' = map (`div` gcd') offsets
      newLines = zipWith (\i r -> concat (replicate i tabS) ++ r) offsets' rows
   in (rstrip . unlines) newLines
  where
    clean :: String -> (Int, String)
    clean s = lstrip (0, rstrip s)
    -- Removes leading whitespace and track number of occurrences
    lstrip :: (Int, String) -> (Int, String)
    lstrip (i, ' ':xs) = lstrip (i + 1, xs)
    lstrip (i, '\t':xs) = lstrip (i + tabSize, xs)
    -- New lines don't affect indices; this is purely for formatting unlines,
    lstrip (i, '\n':xs) = lstrip (i, xs)
    lstrip (i, s) = (i, s)
    rstrip :: String -> String
    rstrip = reverse . (\s -> snd $ lstrip (0, s)) . reverse
    -- Removes leading empty lines; indices are left untouched
    lstrip' :: [(Int, String)] -> [(Int, String)]
    lstrip' [] = []
    lstrip' l@((_, x):xs) =
      if null x
        then lstrip' xs
        else l
    rstrip' :: [(Int, String)] -> [(Int, String)]
    rstrip' = reverse . lstrip' . reverse
    gcdAll :: [Int] -> Int
    gcdAll [] = 1
    gcdAll l = max 1 $ foldl1 gcd l

-- | Generate Either given a string and feed this to constructor
--strData :: String -> (String -> a) -> (String, a)
--strData s constr = (s, constr s)
--strData' :: (String -> a) -> String -> (String, a)
--strData' constr s = (s, constr s)
-- | Cartesian product of two lists
--cartP :: [a] -> [b] -> [(a, b)]
--cartP = liftA2 (,)
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
  prop desc $
  if verb
    then verbose (forAll g p)
    else forAll g p
