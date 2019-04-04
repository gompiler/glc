module IRConv where

import           Base               (Glc)
import qualified CheckedData        as D
import           Data.Char          (ord)
import           Data.List          (intercalate)
import qualified Data.List.NonEmpty as NE (map)
import           IRData
import           ResourceBuilder    (convertProgram)
import qualified ResourceData       as T
import           Scanner            (putExit, putSucc)
import qualified SymbolTable        as S

displayIR :: String -> IO ()
displayIR code = either putExit (putSucc . show) (genIR code)

genIR :: String -> Glc Class
genIR code = toClass . convertProgram <$> S.typecheckGen code

toClass :: T.Program -> Class
toClass (T.Program _ _ tfs _ tms) -- TODO: INITS EZ
 = Class {cname = "Main", fields = cFields, methods = cMethods} -- TODO
  where
    cFields :: [Field]
    cFields = map vdToField tfs
    cMethods :: [Method]
    cMethods = toMethods tms
    -- toFields :: [T.VarDecl] -> [Field]
    -- toFields = concatMap (\(T.VarDecl ds) -> map vdToField ds)
    vdToField :: T.VarDecl -> Field
    vdToField (T.VarDecl (T.VarIndex fi) _ _) =
      Field
        { access = FProtected
        , fname = "field__" ++ show fi
        , descriptor = "TODO"
      -- , value = Nothing
        }
    toMethods :: [T.FuncDecl] -> [Method]
    toMethods =
      concatMap
        (\(T.FuncDecl (D.Ident fni) _ fb) ->
           [ Method
               { mname = fni
               , stackLimit = 25 -- TODO
               , localsLimit = 25 -- TODO
               , body = toIR fb
               }
           ])

class IRRep a where
  toIR :: a -> [IRItem]

instance IRRep T.Stmt where
  toIR (T.BlockStmt stmts) = concatMap toIR stmts
  toIR (T.SimpleStmt stmt) = toIR stmt
  toIR (T.If (sstmt, expr) ifs elses) -- TODO: SIMPLE STMT!!!
   =
    toIR sstmt ++
    toIR expr ++
    iri [IfEq "else_todo"] ++ -- TODO: PROPER EQUALITY CHECK
    toIR ifs ++
    [IRInst (Goto "end_todo"), IRLabel "else_todo"] ++
    toIR elses ++ [IRLabel "end_todo"]
  toIR (T.Switch sstmt e scs dstmt) =
    toIR sstmt ++
    toIR e ++
    concatMap toIR scs ++
    IRLabel "default_todo" :
    toIR dstmt ++ iri [Goto "end_todo"] ++ IRLabel "end_todo" : iri [NOp]
      -- duplicate expression for case statement expressions in lists
  toIR T.For {} = undefined
  toIR T.Break = iri [Goto "end_todo"]
  toIR T.Continue = iri [Goto "loop_todo"] -- TODO: MAKE SURE POST-STMT IS DONE?
  toIR (T.Declare d) = toIR d
  toIR (T.Print el) = concatMap printIR el
  toIR (T.Println el) =
    intercalate (printIR (T.Lit $ D.StringLit " ")) (map printIR el) ++
    printIR (T.Lit $ D.StringLit "\n") -- TODO
  toIR (T.Return me) =
    maybe
      (iri [Return Nothing])
      (\e -> toIR e ++ iri [Return $ Just (exprIRType e)])
      me

printIR :: T.Expr -> [IRItem]
printIR e =
  case exprType e of
    T.PInt     -> printLoad ++ toIR e ++ intPrint
    T.PFloat64 -> printLoad ++ toIR e ++ floatPrint
    T.PRune    -> printLoad ++ toIR e ++ intPrint
    T.PBool    -> undefined -- TODO: PRINT true/false
    T.PString  -> printLoad ++ toIR e ++ stringPrint
    _          -> undefined -- TODO
  where
    printLoad :: [IRItem]
    printLoad = iri [GetStatic systemOut printStream]
    intPrint :: [IRItem]
    intPrint = iri [InvokeVirtual $ MethodRef printStream "print" [JInt] JVoid]
    floatPrint :: [IRItem]
    floatPrint =
      iri [InvokeVirtual $ MethodRef printStream "print" [JFloat] JVoid]
    stringPrint :: [IRItem]
    stringPrint =
      iri [InvokeVirtual $ MethodRef printStream "print" [JClass jString] JVoid]

instance IRRep T.ForClause where
  toIR T.ForClause {} = undefined -- s1 me s2 = toIR s1 ++ (maybe [] toIR me) ++ toIR s2

instance IRRep T.SwitchCase where
  toIR (T.Case exprs stmt) -- concat $ map (toIR . some equality check) exprs
   =
    concat (NE.map toCaseHeader exprs) ++
    [IRLabel "case_todo"] ++ toIR stmt ++ iri [Goto "end_todo"]
    where
      toCaseHeader :: T.Expr -> [IRItem]
      toCaseHeader e = IRInst Dup : toIR e ++ iri [IfEq "case_todo"] -- TODO: NEED SPECIAL EQUALITY STUFF!!! this is = 0

instance IRRep T.SimpleStmt where
  toIR T.EmptyStmt          = []
  toIR (T.VoidExprStmt _ _) = undefined
  toIR (T.ExprStmt e)       = toIR e ++ iri [Pop] -- Invariant: pop expression result TODO: VOID FUNCTIONS
  toIR T.Increment {}       = undefined -- iinc for int, otherwise load/save + 1
  toIR T.Decrement {}       = undefined -- iinc for int (-1), otherwise "
  toIR T.Assign {}          = undefined -- store IRType
  toIR (T.ShortDeclare _)   = undefined -- concat (map toIR $ toList el) ++ [istores...]

instance IRRep T.VarDecl where
  toIR (T.VarDecl idx t me) =
    case me of
      Just e -> toIR e ++ iri [Store (astToIRType t) idx]
      _      -> [] -- HOPEFULLY WE CAN REMOVE THE NOTHING!

instance IRRep T.Expr where
  toIR (T.Unary _ D.Pos e) = toIR e -- unary pos is identity function after typecheck
  toIR (T.Unary t D.Neg e) =
    case t of
      T.PInt     -> intPattern
      T.PFloat64 -> toIR e ++ iri [LDC (LDCFloat (-1.0)), Mul IRFloat]
      T.PRune    -> intPattern
      _          -> undefined -- Cannot take negative of other types
    where
      intPattern :: [IRItem]
      intPattern = toIR e ++ iri [LDC (LDCInt (-1)), Mul IRInt]
       -- int: toIR e ++ [IRInst $ LDC (LDCInt -1), Mul typeToPrimitive TODO]
  toIR (T.Unary _ D.Not e) = toIR e ++ iri [LDC (LDCInt 1), IXOr] -- !i is equivalent to i XOR 1
  toIR (T.Unary _ D.BitComplement _) = undefined -- TODO: how to do this?
  toIR (T.Binary t (D.Arithm D.Add) e1 e2) =
    case t of
      T.PInt -> binary e1 e2 (Add IRInt)
      T.PFloat64 -> binary e1 e2 (Add IRFloat)
      T.PRune -> binary e1 e2 (Add IRInt)
      T.PString ->
        iri
          [ New stringBuilder
          , Dup
          , InvokeSpecial (MethodRef stringBuilder "<init>" [] JVoid)
          ] ++
        toIR e1 ++
        iri [InvokeVirtual sbAppend] ++
        toIR e2 ++
        iri [InvokeVirtual sbAppend] ++
        iri
          [ InvokeVirtual
              (MethodRef stringBuilder "toString" [] (JClass jString))
          ]
      _ -> iri [Debug $ show t] -- undefined
    where
      sbAppend :: MethodRef
      sbAppend =
        MethodRef stringBuilder "append" [JClass jString] (JClass stringBuilder)
  toIR (T.Binary t (D.Arithm aop) e1 e2) =
    case astToIRPrim t of
      Just t' -> binary e1 e2 (opToInst t')
      Nothing -> error "Cannot do op on non-primitive (non-numeric) types"
    where
      opToInst :: IRPrimitive -> Instruction
      opToInst ip =
        case aop of
          D.Subtract  -> Sub ip
          D.Multiply  -> Mul ip
          D.Divide    -> Div ip
          D.BitOr     -> IOr
          D.BitXor    -> IXOr
          D.Remainder -> IRem
          D.ShiftL    -> IShL
          D.ShiftR    -> IShR
          D.BitAnd    -> IAnd
          D.Add       -> undefined -- handled above
          D.BitClear  -> undefined -- handled above TODO
  toIR T.Binary {} = undefined -- TODO
  toIR (T.Lit l) = toIR l
  toIR (T.Var t vi) = iri [Load (astToIRType t) vi] -- TODO (also bool?)
  toIR T.AppendExpr {} = undefined -- TODO
  toIR T.LenExpr {} = undefined -- TODO
  toIR T.CapExpr {} = undefined -- TODO
  toIR T.Selector {} = undefined -- TODO
  toIR T.Index {} = undefined -- TODO
  toIR T.Arguments {} = undefined -- TODO

instance IRRep D.Literal where
  toIR (D.BoolLit i) =
    iri
      [ LDC
          (LDCInt
             (if i
                then 1
                else 0))
      ]
  toIR (D.IntLit i) = iri [LDC (LDCInt i)]
  toIR (D.FloatLit f) = iri [LDC (LDCFloat f)]
  toIR (D.RuneLit r) = iri [LDC (LDCInt $ ord r)]
  toIR (D.StringLit s) = iri [LDC (LDCString s)]

iri :: [Instruction] -> [IRItem]
iri = map IRInst

binary :: T.Expr -> T.Expr -> Instruction -> [IRItem]
binary e1 e2 inst = toIR e1 ++ toIR e2 ++ iri [inst]

exprType :: T.Expr -> T.Type
exprType (T.Unary t _ _)      = t
exprType (T.Binary t _ _ _)   = t
exprType (T.Lit l)            = getLiteralType l
exprType (T.Var t _)          = t
exprType (T.AppendExpr t _ _) = t
exprType (T.LenExpr _)        = T.PInt
exprType (T.CapExpr _)        = T.PInt
exprType (T.Selector t _ _)   = t
exprType (T.Index t _ _)      = t
exprType (T.Arguments t _ _)  = t

astToIRType :: T.Type -> IRType
astToIRType t = maybe Object Prim (astToIRPrim t)

astToIRPrim :: T.Type -> Maybe IRPrimitive
astToIRPrim T.PInt     = Just IRInt
astToIRPrim T.PFloat64 = Just IRFloat
astToIRPrim T.PRune    = Just IRInt
astToIRPrim T.PBool    = Just IRInt
astToIRPrim _          = Nothing

exprIRType :: T.Expr -> IRType
exprIRType = astToIRType . exprType

getLiteralType :: D.Literal -> T.Type
getLiteralType (D.BoolLit _)   = T.PBool
getLiteralType (D.IntLit _)    = T.PInt
getLiteralType (D.FloatLit _)  = T.PFloat64
getLiteralType (D.RuneLit _)   = T.PRune
getLiteralType (D.StringLit _) = T.PString
-- siToName :: T.ScopedIdent -> String
-- siToName (T.ScopedIdent (T.Scope sc) (T.Ident nm)) = nm ++ "__" ++ show sc
