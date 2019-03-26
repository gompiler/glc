module IR where

import qualified CheckedData as C
import           Data.Char        (ord)
import qualified SymbolTable as S
import           Scanner          (putExit, putSucc)
-- import Data.List.NonEmpty (toList)

type LabelName = String

data FieldAccess
  = FPublic
  | FPrivate
  | FProtected
  | FStatic
  | FFinal
  | FVolatile
  | FTransient
  deriving (Show)

data Field = Field
  { access :: FieldAccess
  , fname :: String
  , descriptor :: String
  -- , value :: LDCType TODO?
  } deriving (Show)

data Class = Class
  { cname :: String
  , fields :: [Field]
  , methods :: [Method]
  } deriving (Show)

data Method = Method
  { mname :: String
  , stackLimit :: Int
  , localsLimit :: Int
  , body :: [IRItem]
  } deriving (Show)

data IRItem
  = IRInst Instruction
  | IRLabel LabelName
  deriving (Show)

data IRPrimitive
  = IRInt -- Integers, booleans, runes
  | IRFloat -- Float64s
  deriving (Show)

data IRType
  = Prim IRPrimitive -- Integer, boolean, rune, float64
  | Object -- String, array, struct, slice
  deriving (Show)

data LDCType
  = LDCInt Int -- Integers, booleans, runes
  | LDCFloat Float -- Float64s
  | LDCString String -- Strings
  deriving (Show)

data Instruction
  = Load IRType Int
  | Store IRType Int
  | Return (Maybe IRType)
  | Dup
  | Goto LabelName
  | Add IRPrimitive
  | Div IRPrimitive -- TODO: Turn into Op instruction?
  | Mul IRPrimitive
  | Neg IRPrimitive
  | Sub IRPrimitive
  | IRem
  | IShL
  | IShR
  | IALoad
  | IAnd
  | IAStore
  | IfEq
  | IStore Int
  | IXOr
  | LDC LDCType -- pushes an int/float/string value onto the stack
  | NOp
  | Pop
  | Swap
  | Debug String -- TODO: remove
  deriving (Show)

displayIR :: String -> IO ()
displayIR code = either putExit (putSucc . show . toClass) (S.typecheckGen code)

toClass :: C.Program -> Class
toClass (C.Program _ tls) =
  Class {cname="Main", fields=cFields, methods=cMethods} -- TODO
  where
    cFields :: [Field]
    cFields = toFields tls
    cMethods :: [Method]
    cMethods = toMethods tls
    toFields :: [C.TopDecl] -> [Field]
    toFields = concat . map
      (\td ->
        case td of
          C.TopDecl (C.VarDecl ds) -> map vdToField ds
          _ -> [])
    vdToField :: C.VarDecl' -> Field
    vdToField (C.VarDecl' si _ _) = Field
      { access = FProtected
      , fname = siToName si
      , descriptor = "TODO"
      -- , value = Nothing
      }
    toMethods :: [C.TopDecl] -> [Method]
    toMethods = concat . map
      (\td ->
        case td of
          C.TopDecl _ -> []
          C.TopFuncDecl (C.FuncDecl si _ fb) -> [Method
            { mname = siToName si
            , stackLimit = 25
            , localsLimit = 25
            , body = toIR fb
            }])

class IRRep a where
  toIR :: a -> [IRItem]

instance IRRep C.Stmt where
  toIR (C.BlockStmt stmts) = concat $ map toIR stmts
  toIR (C.SimpleStmt stmt) = toIR stmt
  toIR (C.If (sstmt, expr) ifs elses) = -- TODO: SIMPLE STMT!!!
    toIR sstmt ++ toIR expr ++ IRInst IfEq : toIR ifs ++
    IRInst (Goto "TODOElse") : toIR elses ++ iri [Goto "TODOStop"]
  toIR (C.Switch {}) = undefined -- duplicate expression as many times as non-default case statement expressions in lists

  toIR (C.For {}) = undefined
  toIR C.Break = undefined -- [IRInst (Goto "TODO")]
  toIR C.Continue = undefined -- [IRInst (Goto "TODO")]
  toIR (C.Declare d) = toIR d
  toIR _ = undefined

instance IRRep C.ForClause where
  toIR (C.ForClause {}) = undefined -- s1 me s2 = toIR s1 ++ (maybe [] toIR me) ++ toIR s2

instance IRRep C.SwitchCase where
  toIR (C.Case {}) = undefined -- concat $ map (toIR . some equality check) exprs
  toIR (C.Default stmt) = toIR stmt -- Default doesn't need to check expr value

instance IRRep C.SimpleStmt where
  toIR C.EmptyStmt         = []
  toIR (C.ExprStmt e)      = toIR e ++ iri [Pop] -- Invariant: pop expression result
  toIR (C.Increment {})    = undefined -- iinc for int, otherwise load/save + 1
  toIR (C.Decrement {})    = undefined -- iinc for int (-1), otherwise "
  toIR (C.Assign {})       = undefined -- store IRType
  toIR (C.ShortDeclare _)  = undefined -- concat (map toIR $ toList el) ++ [istores...]

instance IRRep C.Decl where
  toIR (C.VarDecl vds) = concat $ map toIR vds
  toIR _ = undefined -- TODO

instance IRRep C.VarDecl' where
  toIR (C.VarDecl' _ t me) =
    case me of
      Just e -> toIR e ++ iri [Store irType (-1)]
      _ -> [] -- HOPEFULLY WE CAN REMOVE THE NOTHING!
    where
      irType :: IRType
      irType =
        case t of
          C.PInt     -> Prim IRInt
          C.PFloat64 -> Prim IRFloat
          C.PBool    -> Prim IRInt
          C.PRune    -> Prim IRInt
          _          -> Object

instance IRRep C.Expr where
  toIR (C.Unary _ C.Pos e) = toIR e -- unary pos is identity function after typecheck
  toIR (C.Unary t C.Neg e) =
    case t of
      C.PInt     -> intPattern
      C.PFloat64 -> toIR e ++ iri [LDC (LDCFloat (-1.0)), Mul IRFloat]
      C.PRune    -> intPattern
      _        -> undefined -- Cannot take negative of other types
    where
      intPattern :: [IRItem]
      intPattern = toIR e ++ iri [LDC (LDCInt (-1)), Mul IRInt]
       -- int: toIR e ++ [IRInst $ LDC (LDCInt -1), Mul typeToPrimitive TODO]
  toIR (C.Unary _ C.Not e) = toIR e ++ iri [LDC (LDCInt 1), IXOr] -- !i is equivalent to i XOR 1
  toIR (C.Unary _ C.BitComplement _) = undefined -- TODO: how to do this?
  toIR (C.Binary t (C.Arithm C.Add) e1 e2) =
    case t of
      C.PInt -> binary e1 e2 (Add IRInt)
      C.PFloat64 -> binary e1 e2 (Add IRFloat )
      C.PRune -> binary e1 e2 (Add IRInt)
      C.PString -> undefined -- TODO
      _ -> iri [Debug $ show t] -- undefined
  toIR (C.Binary t (C.Arithm C.Subtract) e1 e2) =
    case t of
      C.PInt -> binary e1 e2 (Sub IRInt)
      C.PFloat64 -> binary e1 e2 (Sub IRFloat)
      C.PRune -> binary e1 e2 (Sub IRInt)
      _ -> iri [Debug $ show t] -- undefined
  toIR (C.Lit l) = toIR l
  toIR _ = undefined

instance IRRep C.Literal where
  toIR (C.IntLit i) = iri [LDC (LDCInt i)]
  toIR (C.FloatLit f) = iri [LDC (LDCFloat f)]
  toIR (C.RuneLit r) = iri [LDC (LDCInt $ ord r)]
  toIR (C.StringLit s) = iri [LDC (LDCString s)]

iri :: [Instruction] -> [IRItem]
iri = map IRInst

binary :: C.Expr -> C.Expr -> Instruction -> [IRItem]
binary e1 e2 inst = toIR e1 ++ toIR e2 ++ iri [inst]

exprType :: C.Expr -> C.Type
exprType (C.Unary t _ _) = t
exprType (C.Binary t _ _ _) = t
exprType (C.Lit l) = getLiteralType l
exprType (C.Var _) = undefined
exprType (C.AppendExpr t _ _) = t
exprType (C.LenExpr _) = C.PInt
exprType (C.CapExpr _) = C.PInt
exprType (C.Selector t _ _) = t
exprType (C.Index t _ _) = t
exprType (C.Arguments t _ _) = t

getLiteralType :: C.Literal -> C.Type
getLiteralType (C.IntLit _) = C.PInt
getLiteralType (C.FloatLit _) = C.PFloat64
getLiteralType (C.RuneLit _) = C.PRune
getLiteralType (C.StringLit _) = C.PString

siToName :: C.ScopedIdent -> String
siToName (C.ScopedIdent (C.Scope sc) (C.Ident nm)) = nm ++ "__" ++ (show sc)
