module IRConv where

import           Base                  (Glc)
import qualified CheckedData           as D
import           Data.Char             (ord, toLower)
import           Data.List             (intercalate)
import qualified Data.List.NonEmpty    as NE (map, toList)
import           Foreign.Marshal.Utils (fromBool)
import           IRData
import           ResourceBuilder       (convertProgram)
import qualified ResourceData          as T
import           Scanner               (putExit, putSucc)
import qualified SymbolTable           as S

displayIR :: String -> IO ()
displayIR code = either putExit (putSucc . show) (genIR code)

genIR :: String -> Glc [Class]
genIR code = toClasses . convertProgram <$> S.typecheckGen code

toClasses :: T.Program -> [Class]
toClasses (T.Program _ scts tfs is tms) =
  Class {cname = "Main", fields = cFields, methods = cMethods} :
  map structClass scts -- TODO
  where
    cFields :: [Field]
    cFields = map vdToField tfs
    cMethods :: [Method]
    cMethods =
      Method
        { mname = "glc_fn__init"
        , stackLimit = 25
        , localsLimit = 25
        , body = concatMap toIR is
        } :
      toMethods tms
    vdToField :: T.TopVarDecl -> Field
    vdToField (T.TopVarDecl (D.Ident fi) t _) =
      Field
        { access = FProtected
        , fname = "glc_fd__" ++ fi
        , descriptor = typeToJType t
      -- , value = Nothing
        }
    toMethods :: [T.FuncDecl] -> [Method]
    toMethods = map fdToMethod
      where
        fdToMethod :: T.FuncDecl -> Method
        fdToMethod (T.FuncDecl (D.Ident fni) _ fb) =
          Method
            { mname = "glc_fn__" ++ fni
            , stackLimit = maxStack
            , localsLimit = 25 -- TODO
            , body = irBody
            }
          where
            irBody :: [IRItem]
            irBody = toIR fb
            maxStack :: Int
            maxStack = maxStackSize irBody 0
            maxStackSize :: [IRItem] -> Int -> Int
            maxStackSize irs current =
              case irs of
                [] -> current
                IRLabel _:xs -> max current (maxStackSize xs current)
                IRInst inst:xs ->
                  max
                    (current + stackDelta inst)
                    (maxStackSize xs (current + stackDelta inst))
    structClass :: T.StructType -> Class
    structClass (T.Struct (D.Ident sid) fdls) =
      Class
        { cname = "GlcStruct__" ++ sid
        , fields = map sfToF fdls
        , methods = [] -- TODO: EQUALITY CHECKS?
        }
    sfToF :: T.FieldDecl -> Field
    sfToF (T.FieldDecl (D.Ident fid) t) =
      Field
        { access = FPublic
        , fname = fid
        , descriptor = typeToJType t
        -- , value = Nothing
        }

class IRRep a where
  toIR :: a -> [IRItem]

instance IRRep T.Stmt where
  toIR (T.BlockStmt stmts) = concatMap toIR stmts
  toIR (T.SimpleStmt stmt) = toIR stmt
  toIR (T.If (T.LabelIndex idx) (sstmt, expr) ifs elses) =
    toIR sstmt ++
    toIR expr ++
    iri [If IRData.EQ ("else_" ++ show idx)] ++ -- TODO: PROPER EQUALITY CHECK
    toIR ifs ++
    [IRInst (Goto ("end_if_" ++ show idx)), IRLabel ("else_" ++ show idx)] ++
    toIR elses ++ [IRLabel ("end_if_" ++ show idx)]
  toIR (T.Switch (T.LabelIndex idx) sstmt e scs dstmt) =
    toIR sstmt ++
    toIR e ++
    concatMap irCase (zip [1 ..] scs) ++
    IRLabel ("default_" ++ show idx) :
    toIR dstmt ++ IRLabel ("end_sc_" ++ show idx) : iri [NOp]
      -- duplicate expression for case statement expressions in lists
    where
      irCase :: (Int, T.SwitchCase) -> [IRItem]
      irCase (cIdx, T.Case exprs stmt) -- concat $ map (toIR . some equality check) exprs
       =
        concat (NE.map toCaseHeader exprs) ++
        [IRLabel $ "case_" ++ show cIdx ++ "_" ++ show idx] ++
        toIR stmt ++ iri [Goto ("end_sc_" ++ show idx)]
        where
          toCaseHeader :: T.Expr -> [IRItem]
          toCaseHeader ce =
            IRInst Dup :
            toIR ce ++
            iri [If IRData.EQ $ "case_" ++ show cIdx ++ "_" ++ show idx] -- TODO: NEED SPECIAL EQUALITY STUFF!!! this is = 0
  toIR (T.For (T.LabelIndex idx) (T.ForClause lstmt cond rstmt) fbody) =
    toIR lstmt ++
    [IRLabel ("loop_" ++ show idx)] ++
    toIR cond ++
    iri [If IRData.LE ("end_loop_" ++ show idx)] ++
    toIR fbody ++ toIR rstmt ++ iri [Goto ("loop_" ++ show idx)]
  toIR (T.Break (T.LabelIndex idx)) = iri [Goto ("end_loop_" ++ show idx)]
  toIR (T.Continue (T.LabelIndex idx)) = iri [Goto ("loop_" ++ show idx)] -- TODO: MAKE SURE POST-STMT IS DONE?
  toIR (T.VarDecl idx t me) =
    case me of
      Just e -> toIR e ++ iri [Store (typeToIRType t) idx]
      _      -> [] -- TODO: Get default and store?
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
    T.PBool    -> printLoad ++ toIR e ++ boolToString ++ stringPrint
    T.PString  -> printLoad ++ toIR e ++ stringPrint
    _          -> undefined -- TODO
  where
    printLoad :: [IRItem]
    printLoad = iri [GetStatic systemOut (JClass printStream)]
    intPrint :: [IRItem]
    intPrint =
      iri [InvokeVirtual $ MethodRef (CRef printStream) "print" [JInt] JVoid]
    floatPrint :: [IRItem]
    floatPrint =
      iri [InvokeVirtual $ MethodRef (CRef printStream) "print" [JFloat] JVoid]
    stringPrint :: [IRItem]
    stringPrint =
      iri
        [ InvokeVirtual $
          MethodRef (CRef printStream) "print" [JClass jString] JVoid
        ]
    boolToString :: [IRItem]
    boolToString =
      iri
        [ InvokeVirtual $
          MethodRef (CRef glcUtils) "boolStr" [JInt] (JClass jString)
        ]

instance IRRep T.SimpleStmt where
  toIR T.EmptyStmt = []
  toIR (T.VoidExprStmt (D.Ident aid) args) -- Akin to Argument without a type
   =
    iri [Load Object (T.VarIndex 0)] ++ -- this object TODO: SHOULD IT BE STATIC?
    concatMap toIR args ++
    iri
      [ InvokeVirtual $
        MethodRef (CRef (ClassRef "Main")) aid (map exprJType args) JVoid
      ]
  toIR (T.ExprStmt e) = toIR e ++ iri [Pop] -- Invariant: pop expression result
  toIR (T.Increment e) =
    case e of
      T.Var _ _ -> undefined -- TODO
      T.Selector {} -> undefined -- TODO
      T.Index _ ea ei ->
        case exprType ea of
          T.ArrayType {} ->
            case irType of
              Prim p ->
                toIR ea ++
                toIR ei ++
                iri
                  [ Dup2 -- Duplicate addressable and index at the same time
                  , ArrayLoad irType
                  , addValue p
                  , Add p
                  , ArrayStore irType
                  ]
              Object -> error "Cannot increment object"
          T.SliceType {} -> undefined -- TODO
          _ -> error "Cannot index non-array/slice"
      _ -> undefined -- Cannot increment non-addressable value
    where
      irType :: IRType
      irType = exprIRType e
      addValue :: IRPrimitive -> Instruction
      addValue p =
        case p of
          IRInt   -> IConst1
          IRFloat -> LDC (LDCFloat 1.0) -- TODO: IS THIS A REAL CASE?
  toIR T.Decrement {} = undefined -- TODO iinc for int (-1), otherwise "
  toIR (T.Assign (T.AssignOp _) _) = undefined -- TODO store IRType
  toIR (T.ShortDeclare iExps) =
    exprInsts ++ zipWith (curry expStore) idxs stTypes
    where
      idxs :: [T.VarIndex]
      idxs = reverse $ map fst (NE.toList iExps)
      exprs :: [T.Expr]
      exprs = map snd (NE.toList iExps)
      exprInsts :: [IRItem]
      exprInsts = concatMap maybeClone exprs
      stTypes :: [IRType]
      stTypes = reverse $ map exprIRType exprs
      expStore :: (T.VarIndex, IRType) -> IRItem
      expStore (idx, t) = IRInst (Load t idx)
      maybeClone :: T.Expr -> [IRItem]
      maybeClone e = toIR e ++ cloneInsts
        where
          cloneInsts :: [IRItem]
          cloneInsts =
            case exprJType e of
              JClass cr ->
                iri
                  [ InvokeVirtual $
                    MethodRef (CRef cr) "clone" [] (JClass jObject)
                  ]
              JArray jt ->
                iri
                  [ InvokeVirtual $
                    MethodRef (ARef jt) "clone" [] (JClass jObject)
                  ]
              _ -> [] -- Primitives and strings are not clonable

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
  toIR (T.Unary _ D.Not e) = toIR e ++ iri [LDC (LDCInt 1), IXOr] -- !i is equivalent to i XOR 1
  toIR (T.Unary _ D.BitComplement _) = undefined -- TODO: how to do this?
  toIR (T.Binary _ t (D.Arithm D.Add) e1 e2) =
    case t of
      T.PInt -> binary e1 e2 (Add IRInt)
      T.PFloat64 -> binary e1 e2 (Add IRFloat)
      T.PRune -> binary e1 e2 (Add IRInt)
      T.PString ->
        iri
          [ New stringBuilder
          , Dup
          , InvokeSpecial (MethodRef (CRef stringBuilder) "<init>" [] JVoid)
          ] ++
        toIR e1 ++
        iri [InvokeVirtual sbAppend] ++
        toIR e2 ++
        iri [InvokeVirtual sbAppend] ++
        iri
          [ InvokeVirtual
              (MethodRef (CRef stringBuilder) "toString" [] (JClass jString))
          ]
      _ -> iri [Debug $ show t] -- undefined
    where
      sbAppend :: MethodRef
      sbAppend =
        MethodRef
          (CRef stringBuilder)
          "append"
          [JClass jString]
          (JClass stringBuilder)
  toIR (T.Binary _ _ (D.Arithm D.BitClear) _ _) = undefined -- TODO
  toIR (T.Binary _ t (D.Arithm aop) e1 e2) =
    case typeToIRPrim t of
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
  toIR (T.Binary (T.LabelIndex idx) _ T.Or e1 e2) =
    toIR e1 ++
    iri [Dup, If IRData.NE ("true_ne_" ++ show idx), Pop] ++
    toIR e2 ++ [IRLabel ("true_ne_" ++ show idx)]
  toIR (T.Binary (T.LabelIndex idx) _ T.And e1 e2) =
    toIR e1 ++
    iri [Dup, If IRData.EQ ("false_eq_" ++ show idx), Pop] ++
    toIR e2 ++ [IRLabel ("false_eq_" ++ show idx)]
  toIR (T.Binary _ _ T.EQ _ _) = undefined -- TODO
  toIR (T.Binary idx t T.NEQ e1 e2) =
    toIR (T.Unary T.PBool D.Not (T.Binary idx t T.EQ e1 e2)) -- != is =, !
  toIR (T.Binary (T.LabelIndex idx) _ op e1 e2) -- comparisons
   =
    toIR e1 ++
    toIR e2 ++
    cmpIR ++
    iri [IConst0, Goto endLabel] ++
    [IRLabel trueLabel, IRInst IConst1, IRLabel endLabel, IRInst NOp]
    where
      labelOp :: String
      labelOp = map toLower (show op)
      trueLabel :: LabelName
      trueLabel = "true_" ++ labelOp ++ "_" ++ show idx
      endLabel :: LabelName
      endLabel = "end_" ++ labelOp ++ "_" ++ show idx
      cmpIR :: [IRItem]
      cmpIR =
        case exprIRType e1 of
          Prim IRInt   -> iri [IfICmp irCmp trueLabel]
          Prim IRFloat -> iri [FCmpG, If irCmp trueLabel]
          Object       -> undefined -- TODO: String comparisons?
      irCmp :: IRCmp
      irCmp =
        case op of
          T.LT  -> IRData.LT
          T.LEQ -> IRData.LE
          T.GT  -> IRData.GT
          T.GEQ -> IRData.GE
          _     -> undefined -- Handled above
  toIR (T.Lit l) = toIR l
  toIR (T.Var t vi) = iri [Load (typeToIRType t) vi] -- TODO (also bool?)
  toIR T.AppendExpr {} = undefined -- TODO
  toIR (T.LenExpr e) =
    case exprType e of
      T.ArrayType l _ -> iri [LDC (LDCInt l)] -- fixed at compile time
      T.SliceType _   -> undefined -- TODO
      _               -> undefined -- Can't take length of anything else
  toIR T.CapExpr {} = undefined -- TODO
  toIR (T.Selector t e (T.Ident fid)) =
    toIR e ++ iri [GetField fr (typeToJType t)]
    where
      fr :: FieldRef
      fr =
        case exprJType e of
          JClass cref -> FieldRef cref fid
          _           -> undefined -- Can't get field on non-class
  toIR (T.Index t e1 e2) =
    case exprType e1 of
      T.ArrayType _ _ -- TODO: CHECK LENGTH HERE?
       -> toIR e1 ++ toIR e2 ++ iri [ArrayLoad (typeToIRType t)]
      T.SliceType {} -> undefined -- TODO
      _ -> undefined -- Cannot index any other type
  toIR (T.Arguments t (D.Ident aid) args) =
    iri [Load Object (T.VarIndex 0)] ++ -- this object
    concatMap toIR args ++
    iri
      [ InvokeVirtual $
        MethodRef
          (CRef (ClassRef "Main"))
          aid
          (map exprJType args)
          (typeToJType t)
      ]

instance IRRep D.Literal where
  toIR (D.BoolLit i)   = iri [LDC (LDCInt $ fromBool i)]
  toIR (D.IntLit i)    = iri [LDC (LDCInt i)]
  toIR (D.FloatLit f)  = iri [LDC (LDCFloat f)]
  toIR (D.RuneLit r)   = iri [LDC (LDCInt $ ord r)]
  toIR (D.StringLit s) = iri [LDC (LDCString s)]

iri :: [Instruction] -> [IRItem]
iri = map IRInst

binary :: T.Expr -> T.Expr -> Instruction -> [IRItem]
binary e1 e2 inst = toIR e1 ++ toIR e2 ++ iri [inst]

exprType :: T.Expr -> T.Type
exprType (T.Unary t _ _)      = t
exprType (T.Binary _ t _ _ _) = t
exprType (T.Lit l)            = getLiteralType l
exprType (T.Var t _)          = t
exprType (T.AppendExpr t _ _) = t
exprType (T.LenExpr _)        = T.PInt
exprType (T.CapExpr _)        = T.PInt
exprType (T.Selector t _ _)   = t
exprType (T.Index t _ _)      = t
exprType (T.Arguments t _ _)  = t

typeToIRType :: T.Type -> IRType
typeToIRType t = maybe Object Prim (typeToIRPrim t)

typeToIRPrim :: T.Type -> Maybe IRPrimitive
typeToIRPrim T.PInt     = Just IRInt
typeToIRPrim T.PFloat64 = Just IRFloat
typeToIRPrim T.PRune    = Just IRInt
typeToIRPrim T.PBool    = Just IRInt
typeToIRPrim _          = Nothing

exprIRType :: T.Expr -> IRType
exprIRType = typeToIRType . exprType

exprJType :: T.Expr -> JType
exprJType = typeToJType . exprType

getLiteralType :: D.Literal -> T.Type
getLiteralType (D.BoolLit _)   = T.PBool
getLiteralType (D.IntLit _)    = T.PInt
getLiteralType (D.FloatLit _)  = T.PFloat64
getLiteralType (D.RuneLit _)   = T.PRune
getLiteralType (D.StringLit _) = T.PString

typeToJType :: T.Type -> JType
typeToJType (T.ArrayType _ t) = JArray (typeToJType t)
typeToJType T.SliceType {} = undefined -- TODO
typeToJType T.PInt = JInt
typeToJType T.PFloat64 = JFloat
typeToJType T.PRune = JInt
typeToJType T.PBool = JBool
typeToJType T.PString = JClass jString
typeToJType (T.StructType (D.Ident sid)) =
  JClass (ClassRef $ "GlcStruct__" ++ sid)

stackDelta :: Instruction -> Int
stackDelta Load {}                             = 1 -- ... -> ..., v
stackDelta ArrayLoad {}                        = -1 -- ..., o, i -> v
stackDelta Store {}                            = -1 -- ..., v -> ...
stackDelta ArrayStore {}                       = -3 -- ..., o, i, v -> ...
stackDelta (Return m)                          = maybe 0 (const $ -1) m
stackDelta Dup                                 = 1 -- ..., v -> ..., v, v
stackDelta Dup2                                = 2 -- ..., v, w -> ..., v, w, v, w
stackDelta Goto {}                             = 0
stackDelta Add {}                              = -1 -- ..., v, w -> ..., r
stackDelta Div {}                              = -1 -- ..., v, w -> ..., r
stackDelta Mul {}                              = -1 -- ..., v, w -> ..., r
stackDelta Neg {}                              = -1 -- ..., v, w -> ..., r
stackDelta Sub {}                              = -1 -- ..., v, w -> ..., r
stackDelta IRem                                = -1 -- ..., v, w -> ..., r
stackDelta IShL                                = -1 -- ..., v, w -> ..., r
stackDelta IShR                                = -1 -- ..., v, w -> ..., r
stackDelta IAnd                                = -1 -- ..., v, w -> ..., r
stackDelta IOr                                 = -1 -- ..., v, w -> ..., r
stackDelta IXOr                                = -1 -- ..., v, w -> ..., r
stackDelta If {}                               = -1 -- ..., v -> ...
stackDelta IfICmp {}                           = -2 -- ..., v, w -> ...
stackDelta LDC {}                              = 1 -- ... -> ..., v
stackDelta IConstM1                            = 1 -- ... -> ..., -1
stackDelta IConst0                             = 1 -- ... -> ..., 0
stackDelta IConst1                             = 1 -- ... -> ..., 1
stackDelta FCmpG                               = 1 -- ..., v1, v2 -> ..., r
stackDelta New {}                              = 1 -- ... -> ..., o
stackDelta ANewArray {}                        = 0 -- ..., c -> ..., o
stackDelta NewArray {}                         = 0 -- ..., c -> ..., o
stackDelta NOp                                 = 0
stackDelta Pop                                 = -1 -- ..., v -> ...
stackDelta Swap                                = 0 -- ..., v, w -> ..., w, v
stackDelta GetStatic {}                        = 1 -- ... -> ..., v
stackDelta GetField {}                         = 0 -- ..., o -> ..., v
stackDelta (InvokeSpecial (MethodRef _ _ a _)) = length a -- ..., o, a1, .., an -> r
stackDelta (InvokeVirtual (MethodRef _ _ a _)) = length a -- ..., o, a1, .., an -> r
stackDelta Debug {}                            = 0
