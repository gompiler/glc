module Symbol where

import           Base
import qualified CheckedData      as T (Ident (..), Scope (..),
                                        ScopedIdent (..))
import           Control.Monad.ST
import           Data             (Identifier (..))
import           Data.Functor       (($>))
import           Data.List        (intercalate)
import qualified Data.Maybe       as Maybe
import qualified SymbolTableCore  as S

-- We define new types for symbols and types here
-- we largely base ourselves off types in the AST, however we do not need offsets for the symbol table
type SIdent = T.ScopedIdent

type Param = (String, SType)

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
         (Maybe SType)
  | Variable SType
  | SType SType -- Declared types
  deriving (Eq)

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

instance Show Symbol where
  show s =
    case s of
      Func pl mt ->
        " [function] = (" ++
        intercalate "," (map (\(_, t') -> show t') pl) ++
        ") -> " ++ maybe "void" show mt
      Variable t' -> " [variable] = " ++ show t'
      SType t' -> " [type] = " ++ showDef t'
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
resolve ::
     Identifier
  -> SymbolTable s
  -> ErrorMessage'
  -> ST s (Either ErrorMessage' SType)
resolve (Identifier _ idv) st notDeclError = do
  res <- S.lookup st idv
  sres <- maybe (S.disableMessages st $> Left notDeclError) (return . Right) res
  return $ do
    (scope, t) <- sres
    return $ Maybe.fromMaybe Void $ resolve' t scope idv
    -- | Resolve symbol to type
  where
    resolve' :: Symbol -> S.Scope -> String -> Maybe SType
    resolve' Base _ ident' =
      case ident' of
        "int"     -> Just PInt
        "float64" -> Just PFloat64
        "bool"    -> Just PBool
        "rune"    -> Just PRune
        "string"  -> Just PString
        _         -> Nothing -- This shouldn't happen, don't insert any other base types
    resolve' ConstantBool _ _ = Just PBool
    resolve' (Variable t') _ _ = Just t'
    resolve' (SType t') scope ident' = Just $ TypeMap (mkSIdStr scope ident') t'
    resolve' (Func _ mt) _ _ = mt

-- | Take Symbol table scope and string to make ScopedIdent, add dummy offset
mkSIdStr :: S.Scope -> String -> SIdent
mkSIdStr (S.Scope s) str = T.ScopedIdent (T.Scope s) (T.Ident str)

mkSIdStr' :: Int -> String -> SIdent
mkSIdStr' s str = T.ScopedIdent (T.Scope s) (T.Ident str)
