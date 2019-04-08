module IRConv where

import           Base                  (Glc)
import qualified CheckedData           as D
import           Data.Char             (ord, toLower)
import           Data.List             (intercalate)
import           Data.List.NonEmpty    (NonEmpty (..))
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
toClasses (T.Program _ scts tfs (T.InitDecl ifb ill) (T.MainDecl mfb mll) tms) =
  Class {cname = "Main", fields = cFields, methods = cMethods} :
  map structClass scts -- TODO
  where
    cFields :: [Field]
    cFields = map vdToField tfs
    cMethods :: [Method]
    cMethods =
      Method
        { mname = "__glc$init__"
        , stackLimit = maxStackInit
        , localsLimit = getLim ill
        , spec = emptySpec
        , body = irBody
        } :
      Method
        { mname = "__glc$main__"
        , stackLimit = maxStackMain
        , localsLimit = getLim mll
        , spec = emptySpec
        , body = mfBody
        } :
      Method
        { mname = "main"
        , stackLimit = 0
        , localsLimit = 1
        , spec = MethodSpec ([JArray (JClass jString)], JVoid)
        , body =
            iri
              [ InvokeStatic (MethodRef (CRef cMain) "__glc$init__" emptySpec)
              , InvokeStatic (MethodRef (CRef cMain) "__glc$main__" emptySpec)
              , Return Nothing
              ] -- TODO: Field Initialization
        } :
      Method
        { mname = "<clinit>"
        , stackLimit = maxStackSize clBody 0
        , localsLimit = 0
        , spec = MethodSpec ([], JVoid)
        , body = clBody
        } :
      toMethods tms
      where
        irBody :: [IRItem]
        irBody = toIR ifb
        maxStackInit :: Int
        maxStackInit = maxStackSize irBody 0
        mfBody :: [IRItem]
        mfBody = toIR mfb
        maxStackMain :: Int
        maxStackMain = maxStackSize mfBody 0
    vdToField :: T.TopVarDecl -> Field
    vdToField (T.TopVarDecl fi t _) =
      Field
        { access = FProtected
        , static = True
        , fname = tVarStr fi
        , descriptor = typeToJType t
      -- , value = Nothing
        }
    clBody :: [IRItem]
    clBody = vdToIns tfs ++ iri [Return Nothing]
    vdToIns :: [T.TopVarDecl] -> [IRItem]
    vdToIns tvdl = concatMap vdToIns' tvdl
    vdToIns' :: T.TopVarDecl -> [IRItem]
    vdToIns' (T.TopVarDecl fi t me) =
      case me of
        Nothing -> [] -- Default
      -- Convert declaration to assignments, reuse logic
        Just e ->
          toIR (T.Assign (T.AssignOp Nothing) ((T.TopVar t fi, e) :| []))
    toMethods :: [T.FuncDecl] -> [Method]
    toMethods = map fdToMethod
      where
        fdToMethod :: T.FuncDecl -> Method
        fdToMethod (T.FuncDecl fni sig fb fll) =
          Method
            { mname = tFnStr fni
            , stackLimit = maxStack
            , localsLimit = getLim fll
            , spec = sigToSpec sig
            , body = irBody
            }
          where
            irBody :: [IRItem]
            irBody = toIR fb
            maxStack :: Int
            maxStack = maxStackSize irBody 0
            sigToSpec :: T.Signature -> MethodSpec
            sigToSpec (T.Signature (T.Parameters pdl) mr) =
              MethodSpec (map (typeToJType . pdToType) pdl, mrToJType mr)
            pdToType :: T.ParameterDecl -> T.Type
            pdToType (T.ParameterDecl _ t) = t
            mrToJType :: Maybe T.Type -> JType
            mrToJType mr = maybe JVoid typeToJType mr
    structClass :: T.StructType -> Class
    structClass (T.Struct (D.Ident sid) fdls) =
      Class
        { cname = "__Glc$Struct__" ++ sid
        , fields = map sfToF fdls
        , methods = [] -- TODO: EQUALITY CHECKS?
        }
    sfToF :: T.FieldDecl -> Field
    sfToF (T.FieldDecl (D.Ident fid) t) =
      Field
        { access = FPublic
        , static = False
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
    iri [If IRData.EQ ("else_" ++ show idx)] ++
    toIR ifs ++
    [IRInst (Goto ("end_if_" ++ show idx)), IRLabel ("else_" ++ show idx)] ++
    toIR elses ++ [IRLabel ("end_if_" ++ show idx), IRInst NOp]
  toIR (T.Switch (T.LabelIndex idx) sstmt e scs dstmt) =
    toIR sstmt ++
    toIR e ++
    concatMap irCase (zip [1 ..] scs) ++
    IRLabel ("default_" ++ show idx) :
    toIR dstmt ++ [IRLabel ("end_sc_" ++ show idx), IRInst NOp]
      -- duplicate expression for case statement expressions in lists
    where
      irCase :: (Int, T.SwitchCase) -> [IRItem]
      irCase (cIdx, T.Case exprs stmt) =
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
    IRLabel ("loop_" ++ show idx) :
    toIR cond ++
    iri [If IRData.LE ("end_loop_" ++ show idx)] ++
    toIR fbody ++
    IRLabel ("post_loop_" ++ show idx) :
    toIR rstmt ++
    [ IRInst (Goto $ "loop_" ++ show idx)
    , IRLabel ("end_loop_" ++ show idx)
    , IRInst NOp
    ]
  toIR (T.Break (T.LabelIndex idx)) = iri [Goto ("end_loop_" ++ show idx)]
  toIR (T.Continue (T.LabelIndex idx)) = iri [Goto ("post_loop_" ++ show idx)]
  toIR (T.VarDecl idx t me) =
    case me of
      Just e -> toIR e ++ iri [Store (typeToIRType t) idx]
      _      -> [] -- TODO: Get default and store?
  toIR (T.Print el) = concatMap printIR el
  toIR (T.Println el) =
    intercalate (printIR (T.Lit $ D.StringLit " ")) (map printIR el) ++
    printIR (T.Lit $ D.StringLit "\n")
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
      iri
        [ InvokeVirtual $
          MethodRef (CRef printStream) "print" (MethodSpec ([JInt], JVoid))
        ]
    floatPrint :: [IRItem]
    floatPrint =
      iri
        [ InvokeVirtual $
          MethodRef (CRef printStream) "print" (MethodSpec ([JDouble], JVoid))
        ]
    stringPrint :: [IRItem]
    stringPrint =
      iri
        [ InvokeVirtual $
          MethodRef
            (CRef printStream)
            "print"
            (MethodSpec ([JClass jString], JVoid))
        ]
    boolToString :: [IRItem]
    boolToString =
      iri
        [ InvokeVirtual $
          MethodRef
            (CRef glcUtils)
            "boolStr"
            (MethodSpec ([JInt], JClass jString))
        ]

instance IRRep T.SimpleStmt where
  toIR T.EmptyStmt = []
  toIR (T.VoidExprStmt aid args) -- Akin to Argument without a type
   =
    concatMap toIR args ++
    iri
      [ InvokeStatic $
        MethodRef
          (CRef cMain)
          (tFnStr aid)
          (MethodSpec (map exprJType args, JVoid))
      ]
  toIR (T.ExprStmt e) = toIR e ++ iri [Pop] -- Invariant: pop expression result
  toIR (T.Assign (T.AssignOp mAop) pairs) =
    concatMap getValue (NE.toList pairs) ++
    concatMap getStore (reverse $ NE.toList pairs)
    where
      getValue :: (T.Expr, T.Expr) -> [IRItem]
      getValue (se, ve) =
        case mAop of
          Nothing -> toIR ve ++ cloneIfNeeded ve
          Just op ->
            case se of
              T.Var t idx ->
                setUpOps ++
                iri [Load (typeToIRType t) idx] ++
                afterLoadOps ++ toIR ve ++ finalOps
              T.TopVar t tvi ->
                setUpOps ++
                iri [GetStatic (FieldRef cMain (tVarStr tvi)) (typeToJType t)] ++
                afterLoadOps ++ toIR ve ++ finalOps
              T.Selector t eo (T.Ident fid) ->
                case exprJType eo of
                  JClass cr ->
                    setUpOps ++
                    toIR eo ++
                    iri [GetField (FieldRef cr fid) (typeToJType t)] ++
                    afterLoadOps ++ toIR ve ++ finalOps
                  _ -> error "Cannot get field of non-object"
              T.Index t ea ei ->
                case exprType ea of
                  T.ArrayType {} ->
                    setUpOps ++
                    toIR ea ++
                    toIR ei ++
                    iri [Dup2, ArrayLoad irType] ++ -- Duplicate addr. and index at the same time
                    afterLoadOps ++ toIR ve ++ finalOps
                  T.SliceType {} ->
                    setUpOps ++
                    toIR ea ++
                    toIR ei ++
                    iri [Dup2, InvokeVirtual sliceGet] ++
                    objectDecode t ++
                    afterLoadOps ++ toIR ve ++ finalOps
                  _ -> error "Cannot index non-array/slice"
              _ -> error "Cannot assign to non-addressable value"
            where irType :: IRType
                  irType = exprIRType ve
                  setUpOps :: [IRItem]
                  setUpOps =
                    case (op, irType) of
                      (T.Add, Object) ->
                        iri [New stringBuilder, Dup, InvokeSpecial sbInit]
                      _ -> []
                  afterLoadOps :: [IRItem]
                  afterLoadOps =
                    case (op, irType) of
                      (T.Add, Object) -> iri [InvokeVirtual sbAppend]
                      _               -> []
                  finalOps :: [IRItem]
                  finalOps =
                    case (op, irType) of
                      (T.Add, Object) ->
                        iri [InvokeVirtual sbAppend, InvokeVirtual sbToString]
                      (T.Add, Prim p) -> iri [Add p]
                      (T.Subtract, Prim p) -> iri [Sub p]
                      (T.Multiply, Prim p) -> iri [Mul p]
                      (T.Divide, Prim p) -> iri [Div p]
                      (T.Remainder, Prim _) -> iri [IRem]
                      (T.ShiftL, Prim _) -> iri [IShL]
                      (T.ShiftR, Prim _) -> iri [IShR]
                      (T.BitAnd, Prim _) -> iri [IAnd]
                      (T.BitOr, Prim _) -> iri [IAnd]
                      (T.BitXor, Prim _) -> iri [IXOr]
                      (T.BitClear, Prim _) -> iri [IConstM1, IXOr, IAnd]
                      _ -> error "Invalid operation on non-primitive"
      getStore :: (T.Expr, T.Expr) -> [IRItem]
      getStore (e, _) =
        case e of
          T.Var t idx -> iri [Store (typeToIRType t) idx]
          T.TopVar t tvi ->
            iri [PutStatic (FieldRef cMain (tVarStr tvi)) (typeToJType t)]
          T.Selector t eo (T.Ident fid) ->
            case exprJType eo of
              JClass cr ->
                toIR eo ++ iri [PutField (FieldRef cr fid) (typeToJType t)]
              _ -> error "Cannot get field of non-object"
          T.Index t ea _ ->
            case exprType ea of
              T.ArrayType {} -> iri [ArrayStore irType] -- matched with above
              T.SliceType {} ->
                objectRepr (typeToJType t) ++ iri [InvokeVirtual sliceSet]
              _ -> error "Cannot index non-array/slice"
          _ -> error "Cannot assign to non-addressable value"
        where
          irType :: IRType
          irType = exprIRType e
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
      maybeClone e = toIR e ++ cloneIfNeeded e

instance IRRep T.Expr where
  toIR (T.Unary _ D.Pos e) = toIR e -- unary pos is identity function after typecheck
  toIR (T.Unary t D.Neg e) =
    case t of
      T.PInt     -> intPattern
      T.PFloat64 -> toIR e ++ iri [LDC (LDCDouble (-1.0)), Mul IRDouble]
      T.PRune    -> intPattern
      _          -> error "Cannot negate non-numeric types"
    where
      intPattern :: [IRItem]
      intPattern = toIR e ++ iri [IConstM1, Mul IRInt]
  toIR (T.Unary _ D.Not e) = toIR e ++ iri [IConst1, IXOr] -- !i is equivalent to i XOR 1
  toIR (T.Unary _ D.BitComplement e) = toIR e ++ iri [IConstM1, IXOr] -- all ones, XOR
  toIR (T.Binary _ t (D.Arithm D.Add) e1 e2) =
    case t of
      T.PInt -> binary e1 e2 [Add IRInt]
      T.PFloat64 -> binary e1 e2 [Add IRDouble]
      T.PRune -> binary e1 e2 [Add IRInt]
      T.PString ->
        iri [New stringBuilder, Dup, InvokeSpecial sbInit] ++
        toIR e1 ++
        iri [InvokeVirtual sbAppend] ++
        toIR e2 ++ iri [InvokeVirtual sbAppend, InvokeVirtual sbToString]
      _ -> error "Addition is not defined for non-numeric/string type"
  toIR (T.Binary _ t (D.Arithm aop) e1 e2) =
    case typeToIRPrim t of
      Just t' -> binary e1 e2 (opToInsts t')
      Nothing -> error "Cannot do op on non-primitive (non-numeric) types"
    where
      opToInsts :: IRPrimitive -> [Instruction]
      opToInsts ip =
        case aop of
          D.Subtract  -> [Sub ip]
          D.Multiply  -> [Mul ip]
          D.Divide    -> [Div ip]
          D.BitOr     -> [IOr]
          D.BitXor    -> [IXOr]
          D.Remainder -> [IRem]
          D.ShiftL    -> [IShL]
          D.ShiftR    -> [IShR]
          D.BitAnd    -> [IAnd]
          D.BitClear  -> [IConstM1, IXOr, IAnd] -- in GoLite (vs. Go), x &^ y === x & ^y
          D.Add       -> undefined -- handled above
  toIR (T.Binary (T.LabelIndex idx) _ T.Or e1 e2) =
    toIR e1 ++
    iri [Dup, If IRData.NE ("true_or_" ++ show idx), Pop] ++
    toIR e2 ++ [IRLabel ("true_or_" ++ show idx)]
  toIR (T.Binary (T.LabelIndex idx) _ T.And e1 e2) =
    toIR e1 ++
    iri [Dup, If IRData.EQ ("false_and_" ++ show idx), Pop] ++
    toIR e2 ++ [IRLabel ("false_and_" ++ show idx)]
  toIR (T.Binary (T.LabelIndex idx) t T.EQ e1 e2) =
    case t of
      T.ArrayType {} -> undefined -- TODO
      T.PString ->
        toIR e1 ++
        toIR e2 ++
        iri
          [ InvokeVirtual stringEquals
          , If IRData.GT ("true_eq_" ++ show idx) -- 1 > 0, i.e. true
          , Goto ("stop_eq_" ++ show idx)
          ] ++
        eqPostfix
      (T.StructType (D.Ident _)) -> undefined -- TODO
      T.PFloat64 ->
        toIR e1 ++
        toIR e2 ++
        iri
          [ DCmpG
          , If IRData.EQ ("true_eq_" ++ show idx) -- dcmpg is 0, they're equal
          , Goto ("stop_eq_" ++ show idx)
          ] ++
        eqPostfix
      T.SliceType {} -> error "Cannot compare slice equality"
      _
        -- Integer types
       ->
        toIR e1 ++
        toIR e2 ++
        iri
          [ IfICmp IRData.EQ ("true_eq_" ++ show idx)
          , IConst0
          , Goto ("stop_eq_" ++ show idx)
          ] ++
        eqPostfix
    where
      eqPostfix :: [IRItem]
      eqPostfix =
        [ IRLabel ("true_eq_" ++ show idx)
        , IRInst IConst1
        , IRLabel ("stop_eq_" ++ show idx) -- Don't need NOP, can't end block with x == y
        ]
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
        case exprJType e1 of
          JInt -> iri [IfICmp irCmp trueLabel]
          JBool -> iri [IfICmp irCmp trueLabel]
          JDouble -> iri [DCmpG, If irCmp trueLabel]
          JClass (ClassRef "java/lang/String") ->
            iri [InvokeVirtual stringCompare, If irCmp trueLabel]
          _ -> error "Cannot compare non-comparable types"
      irCmp :: IRCmp
      irCmp =
        case op of
          T.LT  -> IRData.LT
          T.LEQ -> IRData.LE
          T.GT  -> IRData.GT
          T.GEQ -> IRData.GE
          _     -> undefined -- Handled above
  toIR (T.Lit l) = toIR l
  toIR (T.Var t vi) = iri [Load (typeToIRType t) vi]
  toIR (T.TopVar t tvi) =
    iri [GetStatic (FieldRef cMain (tVarStr tvi)) (typeToJType t)]
  toIR (T.AppendExpr _ e1 e2) =
    toIR e1 ++
    toIR e2 ++
    objectRepr (exprJType e2) ++
    iri [InvokeVirtual sliceAppend] -- returns Slice for us
  toIR (T.LenExpr e) =
    case exprType e of
      T.ArrayType l _ -> iri [LDC (LDCInt l)] -- fixed at compile time
      T.SliceType _   -> toIR e ++ iri [GetField sliceLength JInt]
      _               -> error "Cannot get length of non-array/slice"
  toIR (T.CapExpr e) =
    case exprType e of
      T.ArrayType l _ -> iri [LDC (LDCInt l)]
      T.SliceType _   -> toIR e ++ iri [InvokeVirtual sliceCapacity]
      _               -> error "Cannot get capacity of non-array/slice"
  toIR (T.Selector t e (T.Ident fid)) =
    toIR e ++ iri [GetField fr (typeToJType t)]
    where
      fr :: FieldRef
      fr =
        case exprJType e of
          JClass cref -> FieldRef cref fid
          _           -> error "Cannot get field of non-object"
  toIR (T.Index t e1 e2) =
    case exprType e1 of
      T.ArrayType _ _ -- TODO: CHECK LENGTH HERE?
       -> toIR e1 ++ toIR e2 ++ iri [ArrayLoad (typeToIRType t)]
      T.SliceType {} ->
        toIR e1 ++ toIR e2 ++ iri [InvokeVirtual sliceGet] ++ objectDecode t
      _ -> error "Cannot index non-array/slice"
  toIR (T.Arguments t (D.Ident aid) args) =
    concatMap (\e -> toIR e ++ cloneIfNeeded e) args ++
    iri
      [ InvokeStatic $
        MethodRef
          (CRef cMain)
          aid
          (MethodSpec (map exprJType args, typeToJType t))
      ]

instance IRRep D.Literal where
  toIR (D.BoolLit i)   = iri [LDC (LDCInt $ fromBool i)]
  toIR (D.IntLit i)    = iri [LDC (LDCInt i)]
  toIR (D.FloatLit f)  = iri [LDC (LDCDouble f)]
  toIR (D.RuneLit r)   = iri [LDC (LDCInt $ ord r)]
  toIR (D.StringLit s) = iri [LDC (LDCString s)]

iri :: [Instruction] -> [IRItem]
iri = map IRInst

binary :: T.Expr -> T.Expr -> [Instruction] -> [IRItem]
binary e1 e2 insts = toIR e1 ++ toIR e2 ++ iri insts

tVarStr :: T.Ident -> String
tVarStr (T.Ident tvs) = "__glc$fd__" ++ tvs

prependfd :: T.Ident -> T.Ident
prependfd (T.Ident fn) = T.Ident $ "__glc$fd__" ++ fn

tFnStr :: T.Ident -> String
tFnStr (T.Ident tfs) = "__glc$fn__" ++ tfs

cloneIfNeeded :: T.Expr -> [IRItem]
cloneIfNeeded e =
  case exprJType e of
    JClass cr ->
      iri
        [ InvokeVirtual $
          MethodRef (CRef cr) "clone" (MethodSpec ([], JClass jObject))
        ]
    JArray jt ->
      iri
        [ InvokeVirtual $
          MethodRef (ARef jt) "clone" (MethodSpec ([], JClass jObject))
        ]
    _ -> [] -- Primitives and strings are not clonable

objectRepr :: JType -> [IRItem]
objectRepr t =
  case t of
    JClass cr ->
      iri
        [ InvokeVirtual $
          MethodRef (CRef cr) "clone" (MethodSpec ([], JClass jObject))
        ]
    JArray jt ->
      iri
        [ InvokeVirtual $
          MethodRef (ARef jt) "clone" (MethodSpec ([], JClass jObject))
        ]
    JInt ->
      iri [New jInteger, DupX1, Swap, InvokeSpecial jIntInit] -- e, o -> o, e, o -> o, o, e -> o
    JDouble -> -- e1, e2, o -> e1, e2, o, o -> o, o, e1, e2, o, o -> o, o, e1, e2 -> o
      iri [New jDouble, Dup, Dup2X2, Pop2, InvokeSpecial jDoubleInit]
    JBool ->
      iri [New jInteger, DupX1, Swap, InvokeSpecial jIntInit]
    JVoid -> error "Cannot have slice of void"

objectDecode :: T.Type -> [IRItem]
objectDecode t = -- TODO: Maybe this should just be IRType
  case t of -- TODO: Might need CheckCast
    T.ArrayType {} -> [] -- nothing to do
    T.SliceType {} -> [] -- nothing to do
    T.PInt -> iri [InvokeVirtual jIntValue]
    T.PFloat64 -> iri [InvokeVirtual jDoubleValue]
    T.PBool -> iri [InvokeVirtual jIntValue]
    T.PRune -> iri [InvokeVirtual jIntValue]
    T.PString -> [] -- nothing to do
    T.StructType _ -> [] -- nothing to do

exprType :: T.Expr -> T.Type
exprType (T.Unary t _ _)      = t
exprType (T.Binary _ t _ _ _) = t
exprType (T.Lit l)            = getLiteralType l
exprType (T.Var t _)          = t
exprType (T.TopVar t _)       = t
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
typeToIRPrim T.PFloat64 = Just IRDouble
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
typeToJType T.SliceType {} = undefined -- TODO: JClass (...)
typeToJType T.PInt = JInt
typeToJType T.PFloat64 = JDouble
typeToJType T.PRune = JInt
typeToJType T.PBool = JBool
typeToJType T.PString = JClass jString
typeToJType (T.StructType (D.Ident sid)) =
  JClass (ClassRef $ "GlcStruct__" ++ sid)

stackDelta :: Instruction -> Int
stackDelta (Load (Prim IRDouble) _) = 2 -- ... -> ..., v (double-wide)
stackDelta Load {} = 1 -- ... -> ..., v
stackDelta (ArrayLoad (Prim IRDouble)) = 0 -- ..., o, i -> v (double-wide)
stackDelta ArrayLoad {} = -1 -- ..., o, i -> v
stackDelta (Store (Prim IRDouble) _) = -2 -- ..., v -> ... (double-wide)
stackDelta Store {} = -1 -- ..., v -> ...
stackDelta (ArrayStore (Prim IRDouble)) = -4 -- ..., o, i, v2 -> ...
stackDelta ArrayStore {} = -3 -- ..., o, i, v -> ...
stackDelta (Return m) =
  case m of
    Nothing              -> 0
    Just (Prim IRDouble) -> -2
    Just _               -> -1
stackDelta Dup = 1 -- ..., v -> ..., v, v
stackDelta Dup2 = 2 -- ..., v, w -> ..., v, w, v, w
stackDelta DupX1 = 1 -- ..., v, w -> ..., w, v, w
stackDelta Dup2X2 = 2 -- ..., v, w, x, y -> ..., x, y, v, w, x, y
stackDelta Goto {} = 0
stackDelta (Add IRDouble) = -2 -- ..., v, w -> ..., r (double-wide)
stackDelta (Add IRInt) = -1 -- ..., v, w -> ..., r
stackDelta (Div IRDouble) = -2 -- ..., v, w -> ..., r (double-wide)
stackDelta (Div IRInt) = -1 -- ..., v, w -> ..., r
stackDelta (Mul IRDouble) = -2 -- ..., v, w -> ..., r (double-wide)
stackDelta (Mul IRInt) = -1 -- ..., v, w -> ..., r
stackDelta (Sub IRDouble) = -2 -- ..., v, w -> ..., r (double-wide)
stackDelta (Sub IRInt) = -1 -- ..., v, w -> ..., r
stackDelta Neg {} = 0 -- ..., v -> ..., r (double-wide or not)
stackDelta IRem = -1 -- ..., v, w -> ..., r
stackDelta IShL = -1 -- ..., v, w -> ..., r
stackDelta IShR = -1 -- ..., v, w -> ..., r
stackDelta IAnd = -1 -- ..., v, w -> ..., r
stackDelta IOr = -1 -- ..., v, w -> ..., r
stackDelta IXOr = -1 -- ..., v, w -> ..., r
stackDelta If {} = -1 -- ..., v -> ...
stackDelta IfICmp {} = -2 -- ..., v, w -> ...
stackDelta (LDC (LDCDouble _)) = 2 -- ... -> ..., v (double-wide)
stackDelta LDC {} = 1 -- ... -> ..., v
stackDelta IConstM1 = 1 -- ... -> ..., -1
stackDelta IConst0 = 1 -- ... -> ..., 0
stackDelta IConst1 = 1 -- ... -> ..., 1
stackDelta DCmpG = -3 -- ..., v1, v2 -> ..., r
stackDelta New {} = 1 -- ... -> ..., o
stackDelta ANewArray {} = 0 -- ..., c -> ..., o
stackDelta NewArray {} = 0 -- ..., c -> ..., o
stackDelta NOp = 0
stackDelta Pop = -1 -- ..., v -> ...
stackDelta Pop2 = -2 -- ..., v, w -> ...
stackDelta Swap = 0 -- ..., v, w -> ..., w, v
stackDelta (GetStatic _ JDouble) = 2 -- ... -> ..., v (double-wide)
stackDelta GetStatic {} = 1 -- ... -> ..., v
stackDelta (GetField _ JDouble) = 1 -- ..., o -> ..., v (double-wide)
stackDelta GetField {} = 0 -- ..., o -> ..., v
stackDelta (PutStatic _ JDouble) = -2 -- ..., v -> ... (double-wide)
stackDelta PutStatic {} = -1 -- ..., v -> ...
stackDelta (PutField _ JDouble) = -3 -- ..., o, v -> ... (double-wide)
stackDelta PutField {} = -2 -- ..., o, v -> ...
stackDelta (InvokeSpecial (MethodRef _ _ (MethodSpec (a, rt))))
  -- ..., o, a1, .., an -> r (or void)
 =
  case rt of
    JVoid -> -(length a) - 1
    _     -> -(length a)
stackDelta (InvokeVirtual (MethodRef _ _ (MethodSpec (a, rt))))
  -- ..., o, a1, .., an -> r (or void)
 =
  case rt of
    JVoid -> -(length a) - 1
    _     -> -(length a)
stackDelta (InvokeStatic (MethodRef _ _ (MethodSpec (a, rt))))
  -- ..., a1, .., an -> r
 =
  case rt of
    JVoid -> -(length a)
    _     -> -(length a) + 1
stackDelta Debug {} = 0

maxStackSize :: [IRItem] -> Int -> Int
maxStackSize irs current =
  case irs of
    [] -> current
    IRLabel _:xs -> max current (maxStackSize xs current)
    IRInst inst:xs ->
      max
        (current + stackDelta inst)
        (maxStackSize xs (current + stackDelta inst))

getLim :: T.LocalLimit -> Int
getLim (T.LocalLimit i) = i
