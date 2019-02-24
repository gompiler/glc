module ParseExtra where

import Parser
import Data.List.NonEmpty (NonEmpty)

-- Collection of golang models that aren't supported in golite

-- | Identifier here can either be:
-- * blank - same name as package
-- * '.' - imports all packages in folder without qualifier
-- * '_' - ignored; imported solely for side-effects (initialization)
-- * some string - qualified name
data ImportSpec =
  ImportSpec (Maybe Identifier)
             String

-- | See https://golang.org/ref/spec#ConstDecl
data ConstDecl' =
  ConstDecl' (NonEmpty Identifier)
             (Maybe Type)
             Expr