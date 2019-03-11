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
  , PrettyFormat(..)
  , expectPrettyExact
  , expectPrettyInvar
  , qcGen
  , Parser.parsef
  , Parser.parsefNL
  ) where

import           Control.Applicative
import           Control.Monad       (unless)
import           Data
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
    expect input =
      it (take 80 $ show $ lines $ title input) $ expectation' input

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
      case (ast1 == ast2, expectStringMatch pretty1 pretty2) of
        (False, _) ->
          Left $
          "AST mismatch: First\n\n" ++
          show ast1 ++ "\n\nSecond\n\n" ++ show ast2
        (_, Just err) -> Left $ "\n\n" ++ err
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
             Left err -> expectationFailure err
             Right _  -> return ())
    toString
    (tag @a)
  where
    multiPass input = do
      pretty <- parse @a input <&> prettify
      let input' = format input
      case expectStringMatch input' pretty of
        Just err -> Left $ "Prettify failed for \n\n" ++ input' ++ "\n\n" ++ err
        Nothing -> Right pretty

-- | Checks that two strings match
-- Returns Just err if strings don't match, Nothing otherwise
expectStringMatch :: String -> String -> Maybe String
expectStringMatch s1 s2 = mismatchIndex s1 s2 <&> errorMessage
  where
    -- Return first index where strings don't match, or Nothing otherwise
    mismatchIndex :: String -> String -> Maybe Int
    mismatchIndex = mismatchIndex' 0
    mismatchIndex' :: Int -> String -> String -> Maybe Int
    mismatchIndex' i (x:xs) (x':xs') =
      if x == x'
        then mismatchIndex' (i + 1) xs xs'
        else Just i
    mismatchIndex' i l l' =
      if length l == length l'
        then Nothing
        else Just i
    -- | Generates error message around supplied index
    -- For the sake of clarity, we will showcase a portion of the expected string
    -- rather than just the mismatched character.
    -- The range is arbitrary
    errorMessage :: Int -> String
    errorMessage i =
      let message = "Expected '" ++ ([i - 10 .. i + 3] >>= get s2) ++ "'"
          error' =
            errorString $ createError (Offset i) message (createInitialState s1)
       in "Prettify failed for \n\n" ++ s1 ++ "\n\n" ++ error'
    -- | Safe index retrieval for strings
    -- Note that some chars are formatted for readability
    get :: String -> Int -> String
    get s i =
      if i >= 0 && i < length s
        then case s !! i of
               '\n' -> "\\n"
               s'   -> [s']
        else "?"

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
    lstrip (i, ' ':xs)  = lstrip (i + 1, xs)
    lstrip (i, '\t':xs) = lstrip (i + tabSize, xs)
    -- New lines don't affect indices; this is purely for formatting unlines,
    lstrip (i, '\n':xs) = lstrip (i, xs)
    lstrip (i, s)       = (i, s)
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
    gcdAll l  = max 1 $ foldl1 gcd l

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
