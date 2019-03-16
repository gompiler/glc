module Symbol where

import           Control.Monad.ST
import           Data             (Identifier (..))
import           Data.List        (intercalate)
import           ErrorBundle
import qualified SymbolTableCore  as S
import qualified CheckedData        as T (Scope (..), ScopedIdent (..))

-- We define new types for symbols and types here
-- we largely base ourselves off types in the AST, however we do not need offsets for the symbol table
type SIdent = T.ScopedIdent

type Param = (String, SType)

type Field = (String, SType)

-- | SymbolInfo: symbol name, corresponding symbol, scope depth
type SymbolInfo = (String, Symbol, S.Scope)

-- | SymbolTable, cactus stack of SymbolScope
-- specific instantiation for our uses
type SymbolTable s = S.SymbolTable s Symbol (Maybe SymbolInfo)

data Symbol
  = Base -- Base type, resolve to themselves, i.e. int
  | Constant -- For bools only
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
          TypeMap (T.ScopedIdent _ (Identifier _ name)) t' ->
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
      TypeMap (T.ScopedIdent _ (Identifier _ name)) _ ->
        name -- ++ " -> " ++ show t'
      PInt -> "int"
      PFloat64 -> "float64"
      PBool -> "bool"
      PRune -> "rune"
      PString -> "string"
      Infer -> "<infer>"

-- | Resolve type of an Identifier
resolve ::
     Identifier
  -> SymbolTable s
  -> ErrorMessage'
  -> ErrorMessage'
  -> ST s (Either ErrorMessage' SType)
resolve (Identifier _ vname) st notDeclError voidFuncError =
  let idv = vname
   in do res <- S.lookup st idv
         case res of
           Nothing -> return $ Left notDeclError -- createError ident (NotDecl "Type " ident)
           Just (scope, t) ->
             return $
             case resolve' t scope idv of
               Nothing -> Left voidFuncError -- createError ident (VoidFunc ident)
               Just t' -> Right t'
    -- | Resolve symbol to type
  where
    resolve' :: Symbol -> S.Scope -> String -> Maybe SType
    resolve' Base _ ident' =
      Just $
      case ident' of
        "int"     -> PInt
        "float64" -> PFloat64
        "bool"    -> PBool
        "rune"    -> PRune
        "string"  -> PString
        _         -> error "Nonexistent base type in GoLite" -- This shouldn't happen, don't insert any other base types
    resolve' Constant _ _ = Just PBool -- Constants reserved for bools only
    resolve' (Variable t') _ _ = Just t'
    resolve' (SType t') scope ident' = Just $ TypeMap (mkSIdStr scope ident') t'
    resolve' (Func _ mt) _ _ = mt

-- | Take Symbol table scope and string to make ScopedIdent, add dummy offset
mkSIdStr :: S.Scope -> String -> SIdent
mkSIdStr (S.Scope s) str = T.ScopedIdent (T.Scope s) (Identifier (Offset 0) str)
