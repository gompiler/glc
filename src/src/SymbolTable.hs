module SymbolTable where

import qualified Data.HashTable.ST.Basic as HT
import Data.Stack
import Data (Type(..), Identifier(..))
import Control.Monad.ST
import ErrorBundle (Offset (..))
-- import Data.STRef

-- Base symbols in symbol table (int type, etc.) will not have an actual offset, so put dummy offset here so we can reuse Type from Data
-- Otherwise we'd redefine all of Type and it's inner types without offsets
o :: Offset
o = Offset 0

-- | SymbolTable, cactus stack of SymbolScope
type SymbolTable s = ST s (Stack (SymbolScope s))

-- | SymbolScope type, one scope for our SymbolTable. The Int in the tuple represents the depth of the scope
type SymbolScope s = (Int, HashTable s String Type)

-- | Type alias for HT.HashTable from Data.HashTable.ST.Basic
type HashTable s k v = HT.HashTable s k v

-- | VarInfo: symbol name, corresponding type, scope depth
type VarInfo = (Identifier, Type, Int)

-- | Insert n tabs
tabs :: Int -> String
tabs n = concat $ replicate n "\t"

-- | Initialize a symbol table with base types
init :: SymbolTable s
init = do
  ht <- HT.new
  -- Base types
  HT.insert ht "int" (Type (Identifier o "int"))
  HT.insert ht "float64" (Type (Identifier o "float64"))
  HT.insert ht "bool" (Type (Identifier o "bool"))
  HT.insert ht "rune" (Type (Identifier o "rune"))
  HT.insert ht "string" (Type (Identifier o "string"))
  -- We do not insert true and false as constants because this would require modifying Type or overcomplicating the value of the keys by creating a new type that is either a Type or a constant, when there will only be two constants that we can easily account for
  return $ stackPush stackNew (0 :: Int, ht) -- Depth 0
