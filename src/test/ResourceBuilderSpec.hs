{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE QuasiQuotes    #-}

module ResourceBuilderSpec
  ( spec
  ) where

import           Data.List          (intercalate)
import           Data.List.NonEmpty (toList)
import           Prelude            hiding (init)
import           ResourceBuilder
import           ResourceData
import           SymbolTable
import           TestBase

spec :: Spec
spec = offsetSpec

offsetSpec :: Spec
offsetSpec =
  expectOffsetValues
  -- Info
    [ ( [text|
        package empty
        |]
      , [])
    , ( [text|
        package main

        func basic(a int) {
        }
        |]
      , [(LocalLimit 1, [0])])
    , ( [text|
        package main

        func basic() {
          a := 2
        }
        |]
      , [(LocalLimit 1, [0])])
    , ( [text|
        package main

        var top int

        func test1(c int) {
          if c < 2 {
            e := 2
          } else {
            e := 5
          }
        }

        func test2(a int) {
          a, b := 2, 3
          {
            c := 5
          }
          d := 5
        }
        |]
      , [(LocalLimit 2, [0, 1, 1]), (LocalLimit 3, [0, 0, 1, 2, 2])])
    ]

type OffsetInfo = [(LocalLimit, [Int])]

-- | Expects that input = pretty(parse(input))
expectOffsetValues :: (Stringable s) => [(s, OffsetInfo)] -> Spec
expectOffsetValues =
  expectBase
    "check offset values"
    (\(s, info) ->
       let s' = toString s
        in case resourceGen s' of
             Left err -> expectationFailure $ show err
             Right program ->
               let actual = programOffsets program
                in unless (actual == info) . expectationFailure $
                   showError s' program info actual)
    (toString . fst)
    ""
  where
    showError :: String -> Program -> OffsetInfo -> OffsetInfo -> String
    showError input program expected actual =
      "Failed offset values for\n\n" ++
      input ++
      "\n\nexpected:" ++
      show expected ++
      "\n but got:" ++
      show actual ++
      "\n\nAST:\n\n" ++
      showProgram program ++ "\n\n" ++ show (typecheckGen input)
    showProgram :: Program -> String
    showProgram Program {functions} = intercalate "\n" $ map show functions
    programOffsets :: Program -> [(LocalLimit, [Int])]
    programOffsets Program {functions} =
      map
        (\f@(FuncDecl _ _ _ limit) ->
           (limit, map (\(VarIndex i) -> i) $ indices f))
        functions

class VarIndices a where
  indices :: a -> [VarIndex]

instance VarIndices FuncDecl where
  indices (FuncDecl _ sig body _) = indices sig ++ indices body

instance VarIndices Signature where
  indices (Signature (Parameters params) _) = indices =<< params

instance VarIndices ParameterDecl where
  indices (ParameterDecl i _) = [i]

instance VarIndices Stmt where
  indices stmt =
    case stmt of
      BlockStmt stmts       -> indices =<< stmts
      SimpleStmt s          -> indices s
      If _ (ss, _) s1 s2    -> indices ss ++ indices s1 ++ indices s2
      Switch _ ss _ cases s -> indices ss ++ (indices =<< cases) ++ indices s
      For _ clause s        -> indices clause ++ indices s
      VarDecl i _ _         -> [i]
      _                     -> []

instance VarIndices SwitchCase where
  indices (Case _ s) = indices s

instance VarIndices ForClause where
  indices (ForClause ss1 _ ss2) = indices ss1 ++ indices ss2

instance VarIndices SimpleStmt where
  indices stmt =
    case stmt of
      ShortDeclare decls -> map fst $ toList decls
      _                  -> []
