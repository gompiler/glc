{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE TypeSynonymInstances #-}

module Symbol where

import           Base
import qualified CheckedData      as T (Ident (..), Scope (..),
                                        ScopedIdent (..))
import           Control.Monad.ST
import qualified Cyclic           as C
import           Data             (Identifier (..))
import           Data.List        (intercalate)
import qualified SymbolTableCore  as S

-- We define new types for symbols and types here
-- we largely base ourselves off types in the AST, however we do not need offsets for the symbol table
type SIdent = T.ScopedIdent

type Param = (String, CType)

type Field = (String, SType)

-- | SymbolInfo: symbol name, corresponding symbol, scope depth
type SymbolInfo = (String, Symbol, S.Scope)

-- | SymbolTable, cactus stack of SymbolScope
-- specific instantiation for our uses
type SymbolTable s = S.SymbolTable s Symbol SymbolInfo Symbol

data Symbol
  = Base -- Base type, resolve to themselves, i.e. int
  -- In Golite, the only constants we have are booleans
  | ConstantBool
  | Func [Param]
         CType
  | Variable CType
  | SType CType -- Declared types
  deriving (Eq)

-- Wrapper stype with both the root instance and the current instance.
-- All cycles should redirect back to the root
type CType = C.CyclicContainer SType

instance C.Cyclic SType where
  isRoot Infer = True
  isRoot _     = False
  hasRoot Infer = True
  hasRoot (Array _ t) = C.hasRoot t
  hasRoot (Slice t) = C.hasRoot t
  hasRoot (Struct fields) = any (C.hasRoot . snd) fields
  hasRoot (TypeMap _ t) = C.hasRoot t
  hasRoot _ = False


data SType
  = Array Int
          SType
  | Slice SType
  | Struct [Field] -- List of fields
  | TypeMap SIdent
            SType
  | PInt
  | PFloat64
  | PBool
  | PRune
  | PString
  | Infer -- Infer the type at typechecking, not at symbol table generation
  | Void -- For the type of Arguments when calling a void function (which is permissible for ExprStmts)
  deriving (Eq)

--  | Cycle SType
instance Show Symbol where
  show s =
    case s of
      Func pl t ->
        " [function] = (" ++
        intercalate "," (map (\(_, t') -> show t') pl) ++ ") -> " ++ show t
      Variable t' -> " [variable] = " ++ show t'
      SType t' -> " [type] = " ++ showDef (C.get t')
      _ -> ""
      -- | Fully resolve SType as a string, alternative to show when you want to show the complete mapping
    where
      showDef :: SType -> String
      showDef t =
        case t of
          TypeMap (T.ScopedIdent _ (T.Ident name)) t' ->
            name ++ " -> " ++ showDef t'
          _ -> show t

instance Show SType where
  show t =
    case t of
      Array i t' -> "[" ++ show i ++ "]" ++ show t'
      Slice t' -> "[]" ++ show t'
      Struct fds ->
        "struct { " ++
        concatMap (\(s, t') -> s ++ " " ++ show t' ++ "; ") fds ++ "}"
      TypeMap (T.ScopedIdent _ (T.Ident name)) _ -> name -- ++ " -> " ++ show t'
      PInt -> "int"
      PFloat64 -> "float64"
      PBool -> "bool"
      PRune -> "rune"
      PString -> "string"
      Infer -> "<infer>"
      Void -> "void"

-- | Resolve type of an Identifier
resolve :: Identifier -> SymbolTable s -> ErrorMessage' -> ST s (Glc' CType)
resolve ident@(Identifier _ idv) st notDeclError = do
  res <- S.lookup st idv
  sres <- maybe (S.disableMessages st $> Left notDeclError) (return . Right) res
  return $ do
    (scope, t) <- sres
    resolve' t scope idv
    -- | Resolve symbol to type
  where
    resolve' :: Symbol -> S.Scope -> String -> Glc' CType
    resolve' Base _ ident' =
      case ident' of
        "int"     -> Right $ C.new PInt
        "float64" -> Right $ C.new PFloat64
        "bool"    -> Right $ C.new PBool
        "rune"    -> Right $ C.new PRune
        "string"  -> Right $ C.new PString
        _         -> Left $ createError ident NotBase -- This shouldn't happen, don't insert any other base types
    resolve' ConstantBool _ _ = Right $ C.new PBool
    resolve' (Variable _) _ _ =
      Left $ createError ident $ NotTypeMap "variable "
    resolve' (SType t') scope ident' =
      Right $ C.map (TypeMap (mkSIdStr scope ident')) t'
    resolve' (Func _ _) _ _ = Left $ createError ident $ NotTypeMap "function "

data ResolveError
  = NotTypeMap String
  | NotBase
  deriving (Show, Eq)

instance ErrorEntry ResolveError where
  errorMessage (NotTypeMap s) =
    "Identifier resolves to a " ++
    s ++ " which is not a type map and so we cannot resolve its type"
  errorMessage NotBase = "Undefined base type, cannot resolve to a base type"

-- | Take Symbol table scope and string to make ScopedIdent, add dummy offset
mkSIdStr :: S.Scope -> String -> SIdent
mkSIdStr (S.Scope s) str = T.ScopedIdent (T.Scope s) (T.Ident str)

mkSIdStr' :: Int -> String -> SIdent
mkSIdStr' s str = T.ScopedIdent (T.Scope s) (T.Ident str)
