module IRConv where

import           Base                  (Glc)
import qualified CheckedData           as D
import           Data.Char             (ord, toLower)
import           Data.List             (intercalate)
import           Data.List.NonEmpty    (NonEmpty (..))
import qualified Data.List.NonEmpty    as NE (toList)
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
toClasses T.Program { T.structs = scts
                    , T.topVars = tfs
                    , T.init = (T.InitDecl ifb ill)
                    , T.main = (T.MainDecl mfb mll)
                    , T.functions = tms
                    } =
  Class {cname = "Main", bstruct = False, fields = cFields, methods = cMethods} :
  map structClass scts -- TODO
  where
    cFields :: [Field]
    cFields = concatMap vdToFields tfs
    cMethods :: [Method]
    cMethods =
      Method
        { mname = "__glc$init__"
        , mstatic = True
        , stackLimit = maxStackInit
        , localsLimit = getLim ill
        , spec = emptySpec
        , body = irBody
        } :
      Method
        { mname = "__glc$main__"
        , mstatic = True
        , stackLimit = maxStackMain
        , localsLimit = getLim mll
        , spec = emptySpec
        , body = mfBody
        } :
      Method -- int -> string casts
        { mname = "__glc$fn__string"
        , mstatic = True
        , stackLimit = 1
        , localsLimit = 1
        , spec = MethodSpec ([JInt], JClass jString)
        , body = intToString
        } :
      Method -- string -> string identity casts
        { mname = "__glc$fn__string"
        , mstatic = True
        , stackLimit = 1
        , localsLimit = 1
        , spec = MethodSpec ([JClass jString], JClass jString)
        , body = idString
        } :
      Method -- int -> int identity casts
        { mname = "__glc$fn__int"
        , mstatic = True
        , stackLimit = 1
        , localsLimit = 1
        , spec = MethodSpec ([JInt], JInt)
        , body = idInt
        } :
      Method -- int -> float64 casts
        { mname = "__glc$fn__int"
        , mstatic = True
        , stackLimit = 2
        , localsLimit = 2
        , spec = MethodSpec ([JDouble], JInt)
        , body = doubleToInt
        } :
      Method -- rune -> rune identity casts
        { mname = "__glc$fn__rune"
        , mstatic = True
        , stackLimit = 1
        , localsLimit = 1
        , spec = MethodSpec ([JInt], JInt)
        , body = idInt
        } :
      Method -- rune -> float64 casts
        { mname = "__glc$fn__rune"
        , mstatic = True
        , stackLimit = 2
        , localsLimit = 2
        , spec = MethodSpec ([JDouble], JInt)
        , body = doubleToInt
        } :
      Method -- bool -> bool identity casts
        { mname = "__glc$fn__bool"
        , mstatic = True
        , stackLimit = 1
        , localsLimit = 1
        , spec = MethodSpec ([JInt], JInt)
        , body = idInt
        } :
      Method -- float64 -> float64 identity casts
        { mname = "__glc$fn__float64"
        , mstatic = True
        , stackLimit = 2
        , localsLimit = 2
        , spec = MethodSpec ([JDouble], JDouble)
        , body = idDouble
        } :
      Method -- float64 -> int casts
        { mname = "__glc$fn__float64"
        , mstatic = True
        , stackLimit = 2
        , localsLimit = 2
        , spec = MethodSpec ([JInt], JDouble)
        , body = intToDouble
        } :
      Method
        { mname = "main"
        , mstatic = True
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
        , mstatic = True
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
        intToString :: [IRItem]
        intToString =
          iri
            [ Load (Prim IRInt) (T.VarIndex 0)
            , InvokeStatic jValueOfChar
            , Return (Just Object)
            ]
        intToDouble :: [IRItem]
        intToDouble =
          iri
            [ Load (Prim IRInt) (T.VarIndex 0)
            , IntToDouble
            , Return (Just $ Prim IRDouble)
            ]
        doubleToInt :: [IRItem]
        doubleToInt =
          iri
            [ Load (Prim IRDouble) (T.VarIndex 0)
            , DoubleToInt
            , Return (Just $ Prim IRInt)
            ]
        idString :: [IRItem]
        idString = iri [Load Object (T.VarIndex 0), Return (Just Object)]
        idInt :: [IRItem]
        idInt =
          iri [Load (Prim IRInt) (T.VarIndex 0), Return (Just $ Prim IRInt)]
        idDouble :: [IRItem]
        idDouble =
          iri
            [Load (Prim IRDouble) (T.VarIndex 0), Return (Just $ Prim IRDouble)]
    vdToFields :: T.TopVarDecl -> [Field]
    vdToFields (T.TopVarDecl vdl) = map vdpToFields vdl
    vdpToFields :: T.TopVarDecl' -> Field
    vdpToFields (T.TopVarDecl' fi t _) =
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
    vdToIns = concatMap vdToIns'
    vdToIns' :: T.TopVarDecl -> [IRItem]
    vdToIns' (T.TopVarDecl vdl) = concatMap vdToIns'' vdl
    vdToIns'' :: T.TopVarDecl' -> [IRItem]
    vdToIns'' (T.TopVarDecl' fi t me) =
      case me of
        Nothing ->
          case t of
            (T.ArrayType l _) -> glcArrayIR l t (Left fi)
            (T.SliceType _) -> glcArrayIR (-1) t (Left fi)
            T.PInt -> iri [LDC (LDCInt 0), primPut]
            T.PFloat64 -> iri [LDC (LDCDouble 0.0), primPut]
            T.PBool -> iri [LDC (LDCInt 0), primPut]
            T.PRune -> iri [LDC (LDCInt 0), primPut]
            T.PString -> iri [LDC (LDCString ""), primPut]
            T.StructType sid -> structInitIR sid (Left fi)
      -- Convert declaration to assignments, reuse logic
        Just e ->
          toIR (T.Assign (T.AssignOp Nothing) ((T.TopVar t fi, e) :| []))
      where
        primPut :: Instruction
        primPut = PutStatic (FieldRef cMain (tVarStr fi)) (typeToJType t)
    toMethods :: [T.FuncDecl] -> [Method]
    toMethods = map fdToMethod
      where
        fdToMethod :: T.FuncDecl -> Method
        fdToMethod (T.FuncDecl fni sig fb fll) =
          Method
            { mname = tFnStr fni
            , mstatic = True
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
    structClass strc@(T.Struct sid fdls) =
      Class
        { cname = structName sid
        , bstruct = True
        , fields = map sfToF fdls
        , methods =
            sinit :
            [checkEq strc, copyStc strc] ++
            map (setter sn) fdls ++ map (getter sn) fdls
        }
      where
        sn :: String
        sn = structName sid
    sfToF :: T.FieldDecl -> Field
    sfToF (T.FieldDecl fid t) =
      Field
        { access = FPrivate
        , static = False
        , fname = (structField fid)
        , descriptor = typeToJType t
        -- , value = Nothing
        }
    checkEq :: T.StructType -> Method
    checkEq (T.Struct sid fdls) =
      Method
        { mname = "equals"
        , mstatic = False
        , stackLimit = maxStackSize equalsBody 0
        , localsLimit = 3 -- One for this and one for argument, one for temp
        , spec = MethodSpec ([JClass jObject], JBool)
        , body = equalsBody
        }
      where
        labelFdls :: [(Int, T.FieldDecl)]
        labelFdls = labelFdls' fdls 0 []
        labelFdls' ::
             [T.FieldDecl]
          -> Int
          -> [(Int, T.FieldDecl)]
          -> [(Int, T.FieldDecl)]
        labelFdls' [] _ acc     = reverse acc
        labelFdls' [fd] i acc   = labelFdls' [] (i + 1) ((i, fd) : acc)
        labelFdls' (fd:t) i acc = labelFdls' t (i + 1) ((i, fd) : acc)
        sn :: String
        sn = structName sid
        cr :: ClassOrArrayRef
        cr = CRef (ClassRef sn)
        equalsBody :: [IRItem]
        equalsBody =
          iri
            [ Load Object (T.VarIndex 0)
            , Load Object (T.VarIndex 1)
            , IfACmpNE "FALSE_STEQ"
            , IConst1
            , Return (Just $ Prim IRInt)
            ] ++
          [IRLabel "FALSE_STEQ"] ++
          iri
            [ Load Object (T.VarIndex 1)
            , InstanceOf cr
            , If IRData.NE "ISSTRUCT_STEQ"
            , IConst0
            , Return (Just $ Prim IRInt)
            ] ++
          [IRLabel "ISSTRUCT_STEQ"] ++
          iri
            [ Load Object (T.VarIndex 1)
            , CheckCast cr
            , Store Object (T.VarIndex 2)
            ] ++
          concatMap (createNE "LSEQ_false") labelFdls ++
          iri [IConst1, Goto "LSEQ_return"] ++
          [ IRLabel "LSEQ_false"
          , IRInst IConst0
          , IRLabel "LSEQ_return"
          , IRInst $ Return (Just $ Prim IRInt)
          ]
        createNE :: String -> (Int, T.FieldDecl) -> [IRItem]
        createNE label (i, T.FieldDecl fid t) =
          case t of
            T.ArrayType {}    -> arrayEq
            T.SliceType {}    -> arrayEq
            T.StructType sid' -> structEq (ClassRef $ structName sid')
            T.PString         -> stringEq
            _                 -> primEq
          where
            jt :: JType
            jt = typeToJType t
            fr :: FieldRef
            fr = FieldRef (ClassRef sn) (structField fid)
            arrayEq :: [IRItem]
            arrayEq =
              iri
                [ Load Object (T.VarIndex 0)
                , GetField fr jt
                , Load Object (T.VarIndex 2)
                , GetField fr jt
                , IfACmpEQ ("refeq" ++ show i)
                , Load Object (T.VarIndex 0)
                , InvokeVirtual $
                    MethodRef
                      cr
                      (structGetter fid)
                      (MethodSpec ([], jt))
                , Load Object (T.VarIndex 2)
                , InvokeVirtual $
                    MethodRef
                      cr
                      (structGetter fid)
                      (MethodSpec ([], jt))
                , InvokeVirtual glcArrayEquals
                , If IRData.EQ label
                ] ++
              [IRLabel ("refeq" ++ show i)] ++ iri [IConst1, Goto "LSEQ_return"]
            structEq :: ClassRef -> [IRItem]
            structEq cr' =
              iri
                [ Load Object (T.VarIndex 0)
                , GetField fr jt
                , Load Object (T.VarIndex 2)
                , GetField fr jt
                , IfACmpEQ ("refeq" ++ show i)
                , Load Object (T.VarIndex 0)
                , InvokeVirtual $
                    MethodRef
                      cr
                      (structGetter fid)
                      (MethodSpec ([], jt))
                , Load Object (T.VarIndex 2)
                , InvokeVirtual $
                    MethodRef
                      cr
                      (structGetter fid)
                      (MethodSpec ([], jt))
                , CheckCast (CRef jObject)
                , InvokeVirtual
                    ((MethodRef $ CRef cr')
                       "equals"
                       (MethodSpec ([JClass jObject], JBool)))
                , If IRData.EQ label
                ] ++
              [IRLabel ("refeq" ++ show i)] ++ iri [IConst1, Goto "LSEQ_return"]
            stringEq :: [IRItem]
            stringEq =
              iri
                [ Load Object (T.VarIndex 0)
                , GetField fr jt
                , Load Object (T.VarIndex 2)
                , GetField fr jt
                , InvokeStatic
                    (MethodRef
                       (CRef jObjects)
                       "equals"
                       (MethodSpec ([JClass jObject, JClass jObject], JBool)))
                , If IRData.EQ label
                ]
            primEq :: [IRItem]
            primEq =
              iri
                [ Load Object (T.VarIndex 0)
                , GetField fr jt
                , Load Object (T.VarIndex 2)
                , GetField fr jt
                ] ++
              iri
                (if t == T.PFloat64
                   then [DCmpG, If IRData.NE label]
                   else [IfICmp IRData.NE label])
    copyStc :: T.StructType -> Method
    copyStc (T.Struct sid fdls) =
      Method
        { mname = "copy"
        , mstatic = False
        , stackLimit = maxStackSize copyBody 0
        , localsLimit = 2
        , spec = MethodSpec ([], JClass jObject)
        , body = copyBody
        }
      where
        sn :: String
        sn = structName sid
        cr :: ClassOrArrayRef
        cr = CRef (ClassRef sn)
        copyBody :: [IRItem]
        copyBody =
          iri
            [ New (ClassRef sn)
            , Dup
            , InvokeSpecial (MethodRef cr "<init>" (MethodSpec ([], JVoid)))
            , Store Object (T.VarIndex 1)
            ] ++
          concatMap cpField fdls ++
          iri [Load Object (T.VarIndex 1), Return (Just Object)]
        cpField :: T.FieldDecl -> [IRItem]
        cpField (T.FieldDecl fid t) =
          case t of
            T.ArrayType {} -> cpObj cGlcArray
            T.SliceType {} -> cpObj cGlcArray
            T.StructType sid' -> cpObj (ClassRef $ structName sid')
            _ ->
              iri
                [ Load Object (T.VarIndex 1)
                , Load Object (T.VarIndex 0)
                , GetField (FieldRef (ClassRef sn) (structField fid)) jt
                , PutField (FieldRef (ClassRef sn) (structField fid)) jt
                ]
          where
            jt :: JType
            jt = typeToJType t
            cpObj :: ClassRef -> [IRItem]
            cpObj cr' =
              iri
                [ Load Object (T.VarIndex 1)
                , Load Object (T.VarIndex 0)
                , GetField (FieldRef (ClassRef sn) (structField fid)) jt
                , InvokeStatic
                    (MethodRef
                       (CRef glcUtils)
                       "copy"
                       (MethodSpec ([JClass jObject], JClass jObject)))
                , CheckCast (CRef cr')
                ] ++
              iri [PutField (FieldRef (ClassRef sn) (structField fid)) jt]
    setter :: String -> T.FieldDecl -> Method
    setter sn (T.FieldDecl fid t) =
      Method
        { mname = structSetter fid
        , mstatic = False
        , stackLimit = maxStackSize setBody 0
        , localsLimit = ll -- One for this and one/two for argument
        , spec = MethodSpec ([typeToJType t], JVoid)
        , body = setBody
        }
      where
        ll :: Int
        ll =
          1 +
          (case t of
             T.PFloat64 -> 2
             _          -> 1)
        setBody :: [IRItem]
        setBody =
          let jt = typeToJType t
           in iri
                [ Load Object (T.VarIndex 0)
                , Load (typeToIRType t) (T.VarIndex 1)
                ] ++
              iri
                [ PutField (FieldRef (ClassRef sn) (structField fid)) jt
                , Return Nothing]
    getter :: String -> T.FieldDecl -> Method
    getter sn (T.FieldDecl fid t) =
      Method
        { mname = structGetter fid
        , mstatic = False
        , stackLimit = maxStackSize getBody 0
        , localsLimit = ll -- One for this and one/two for copy
        , spec = MethodSpec ([], typeToJType t)
        , body = getBody
        }
      where
        ll :: Int
        ll =
          1 +
          (case t of
             T.PFloat64 -> 2
             _          -> 1)
        getBody :: [IRItem]
        getBody =
          let jt = typeToJType t
           in iri [Load Object (T.VarIndex 0)] ++
              (case t of
                 T.ArrayType {} -> getObj t
                 T.SliceType {} -> getObj t
                 T.StructType {} -> getObj t
                 _ ->
                   iri
                     [ GetField (FieldRef (ClassRef sn) (structField fid)) jt
                     , Return (Just $ typeToIRType t)
                     ])
        getObj :: T.Type -> [IRItem]
        getObj t' =
          let jt = typeToJType t
           in iri
                [ GetField (FieldRef (ClassRef sn) (structField fid)) jt
                , IfNonNull "LSGET_NULL"
                , Load Object (T.VarIndex 0)
                ] ++
              toIR (T.VarDecl' (T.VarIndex 1) t' Nothing) ++
              iri
                [ Load Object (T.VarIndex 1)
                , PutField (FieldRef (ClassRef sn) (structField fid)) jt
                , Load Object (T.VarIndex 0)
                , GetField (FieldRef (ClassRef sn) (structField fid)) jt
                , Goto "LSGET_RET"
                ] ++
              [IRLabel "LSGET_NULL"] ++
              iri
                [ Load Object (T.VarIndex 0)
                , GetField (FieldRef (ClassRef sn) (structField fid)) jt
                ] ++
              [IRLabel "LSGET_RET"] ++ iri [Return (Just Object)]
    sinit :: Method
    sinit =
      Method
        { mname = "<init>"
        , mstatic = False
        , stackLimit = 1
        , localsLimit = 1 -- One for this and one for copy
        , spec = MethodSpec ([], JVoid)
        , body =
            iri
              [ Load Object (T.VarIndex 0)
              , InvokeSpecial
                  (MethodRef (CRef jObject) "<init>" (MethodSpec ([], JVoid)))
              , Return Nothing
              ]
        }

invokeCp :: T.Type -> [IRItem]
invokeCp t =
  iri $
  case t of
    T.ArrayType {} ->
      [ InvokeVirtual
          (MethodRef (CRef cGlcArray) "copy" (MethodSpec ([], JClass cGlcArray)))
      ]
    T.SliceType {} ->
      [ InvokeVirtual
          (MethodRef (CRef cGlcArray) "copy" (MethodSpec ([], JClass cGlcArray)))
      ]
    T.StructType sid' ->
      [ InvokeVirtual
          (MethodRef
             (CRef (ClassRef $ structName sid'))
             "copy"
             (MethodSpec ([], JClass $ ClassRef $ structName sid')))
      ]
    _ -> []

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
    concatMap irCaseHeaders (zip [1 ..] scs) ++
    IRLabel ("default_" ++ show idx) :
    toIR dstmt ++ -- pop off remaining comparison value
    iri [Goto ("end_breakable_" ++ show idx)] ++
    concatMap irCaseBodies (zip [1 ..] scs) ++
    [IRLabel ("end_breakable_" ++ show idx), IRInst Pop] -- duplicate expression for case statement expressions in lists
    where
      irCaseHeaders :: (Int, T.SwitchCase) -> [IRItem]
      irCaseHeaders (cIdx, T.Case _ exprs _) =
        concatMap toCaseHeader (zip [1 ..] (NE.toList exprs))
        where
          toCaseHeader :: (Int, T.Expr) -> [IRItem]
          toCaseHeader (eIdx, ce) =
            IRInst Dup :
            toIR ce ++
            equality
              True
              ("case_" ++ show cIdx ++ "_" ++ show eIdx)
              idx
              (exprType ce) ++
            iri [If IRData.NE $ "case_" ++ show cIdx ++ "_" ++ show idx] -- If it's true, make the jump
      irCaseBodies :: (Int, T.SwitchCase) -> [IRItem]
      irCaseBodies (cIdx, T.Case _ _ stmt) =
        [IRLabel $ "case_" ++ show cIdx ++ "_" ++ show idx] ++
        toIR stmt ++ iri [Goto ("end_breakable_" ++ show idx)]
  toIR (T.For (T.LabelIndex idx) (T.ForClause lstmt cond rstmt) fbody) =
    toIR lstmt ++
    IRLabel ("loop_" ++ show idx) :
    toIR cond ++
    iri [If IRData.LE ("end_breakable_" ++ show idx)] ++
    toIR fbody ++
    IRLabel ("post_loop_" ++ show idx) :
    toIR rstmt ++
    [ IRInst (Goto $ "loop_" ++ show idx)
    , IRLabel ("end_breakable_" ++ show idx)
    , IRInst NOp
    ]
  toIR (T.Break (T.LabelIndex idx)) = iri [Goto ("end_breakable_" ++ show idx)]
  toIR (T.Continue (T.LabelIndex idx)) = iri [Goto ("post_loop_" ++ show idx)]
  toIR (T.VarDecl vdl) = concatMap toIR vdl
  toIR (T.Print el) = concatMap printIR el
  toIR (T.Println el) =
    intercalate (printIR (T.Lit $ D.StringLit " ")) (map printIR el) ++
    printIR (T.Lit $ D.StringLit "\n")
  toIR (T.Return me) =
    maybe
      (iri [Return Nothing])
      (\e -> toIR e ++ iri [Return $ Just (exprIRType e)])
      me

instance IRRep T.VarDecl' where
  toIR (T.VarDecl' idx t me) =
    case me of
      Just e -> toIR e ++ cloneIfNeeded e ++ iri [Store (typeToIRType t) idx]
      _ -- Get default and store
       ->
        case t of
          (T.ArrayType l _) -> glcArrayIR l t (Right idx)
          (T.SliceType _) -> glcArrayIR (-1) t (Right idx)
          T.PInt -> iri [IConst0, Store (Prim IRInt) idx]
          T.PFloat64 -> iri [LDC (LDCDouble 0.0), Store (Prim IRDouble) idx]
          T.PRune -> iri [IConst0, Store (Prim IRInt) idx]
          T.PBool -> iri [IConst0, Store (Prim IRInt) idx]
          T.PString -> iri [LDC (LDCString ""), Store Object idx]
          (T.StructType sid) -> structInitIR sid (Right idx)

structInitIR :: T.Ident -> Either T.Ident T.VarIndex -> [IRItem]
structInitIR sid eid =
  iri
    [ New structCR
    , Dup
    , InvokeSpecial (MethodRef (CRef structCR) "<init>" emptySpec)
    , storeStruct
    ]
  where
    storeStruct :: Instruction
    storeStruct =
      either
        (\v -> PutStatic (FieldRef cMain (tVarStr v)) (JClass structCR))
        (\x -> Store Object x)
        eid
    structCR :: ClassRef
    structCR = ClassRef (structName sid)

glcArrayIR ::  Int -> T.Type -> Either T.Ident T.VarIndex -> [IRItem]
glcArrayIR l t eid =
  case t' of
    T.ArrayType {} -> nestedGlcArrayIR t eid
    T.SliceType {} -> nestedGlcArrayIR t eid
    T.PInt -> arrayOrSliceIR jInteger l eid
    T.PFloat64 -> arrayOrSliceIR jDouble l eid
    T.PRune -> arrayOrSliceIR jInteger l eid
    T.PBool -> arrayOrSliceIR jInteger l eid
    T.PString -> arrayOrSliceIR jString l eid
    T.StructType sid ->
      arrayOrSliceIR (ClassRef $ structName sid) l eid
  where
    t' :: T.Type
    t' =
      case t of
        T.ArrayType _ at -> at
        T.SliceType st -> st
        _ ->
          error "Error: glcArrayIR called on non-array/slice type"

nestedGlcArrayIR :: T.Type -> (Either T.Ident T.VarIndex) -> [IRItem]
nestedGlcArrayIR t eid =
  iri
    [ New cGlcArray
    , Dup
    , LDC (LDCClass $ classOfBase t)
    , LDC (LDCInt $ length sizes) -- Number of dimensions of array
    , NewArray IRInt -- array of dimensions
    ] ++
  sizeArrayIR ++ (IRInst $ InvokeSpecial glcArrayInit) : storeArray
  where
    sizeArrayIR :: [IRItem]
    sizeArrayIR =
      map (const $ IRInst Dup) sizes ++
      concatMap
        (\(i, s) ->
           iri [LDC $ LDCInt i, LDC $ LDCInt s, ArrayStore (Prim IRInt)])
        (zip [0 ..] sizes)
    sizes :: [Int]
    sizes = getSizes [] t
    getSizes :: [Int] -> T.Type -> [Int]
    getSizes rSizes rt =
      case rt of
        T.ArrayType rl rrt -> getSizes (rl : rSizes) rrt
        T.SliceType rrt    -> getSizes (-1 : rSizes) rrt
        _                  -> reverse rSizes -- no more arrays
    classOfBase :: T.Type -> ClassRef
    classOfBase ct =
      case ct of
        (T.ArrayType _ rt) -> classOfBase rt
        (T.SliceType rt)   -> classOfBase rt
        T.PInt             -> jInteger
        T.PFloat64         -> jDouble
        T.PRune            -> jInteger
        T.PBool            -> jInteger
        T.PString          -> jString
        T.StructType sid   -> ClassRef (structName sid)
    storeArray :: [IRItem]
    storeArray =
      either
        (\v -> iri [PutStatic (FieldRef cMain (tVarStr v)) (JClass cGlcArray)])
        (\x -> iri [Store Object x])
        eid

arrayOrSliceIR :: ClassRef -> Int -> Either T.Ident T.VarIndex -> [IRItem]
arrayOrSliceIR cr l eid =
  iri
    [ New cGlcArray
    , Dup
    , LDC (LDCClass cr)
    , IConst1
    , NewArray IRInt
    , Dup
    , IConst0
    , LDC (LDCInt l)
    , ArrayStore (Prim IRInt)
    , InvokeSpecial glcArrayInit
    ] ++ storeIR
  where
    storeIR :: [IRItem]
    storeIR =
      either
        (\v -> iri [PutStatic (FieldRef cMain (tVarStr v)) (JClass cGlcArray)])
        (\x -> iri [Store Object x])
        eid


newSliceIR :: ClassRef -> T.VarIndex -> [IRItem]
newSliceIR cr idx =
  iri
    [ New cGlcArray
    , Dup
    , LDC (LDCClass cr)
    , IConst1
    , NewArray IRInt -- dimension array
    , Dup
    , IConst0 -- position 0
    , IConstM1 -- slices have dimension -1 to start
    , ArrayStore (Prim IRInt)
    , InvokeSpecial glcArrayInit
    , Store Object idx
    ]

printIR :: T.Expr -> [IRItem]
printIR e =
  case exprType e of
    T.PInt     -> printLoad ++ toIR e ++ intPrint
    T.PFloat64 -> printLoad ++ floatPrint
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
      iri [LDC (LDCString "%+e")] ++
      iri [IConst1, ANewArray jObject, Dup, IConst0] ++
      toIR e ++
      doubleObjectRepr ++
      iri
        [ ArrayStore Object
        , InvokeVirtual $
          MethodRef
            (CRef printStream)
            "printf"
            (MethodSpec
               ([JClass jString, JArray (JClass jObject)], JClass printStream))
        , Pop
        ]
      where
        doubleObjectRepr :: [IRItem]
        doubleObjectRepr =
          iri [New jDouble, Dup, Dup2X2, Pop2, InvokeSpecial jDoubleInit]
    stringPrint :: [IRItem]
    stringPrint =
      iri
        [ LDC (LDCString "")
        , InvokeStatic objectToString
        , InvokeVirtual $
          MethodRef
            (CRef printStream)
            "print"
            (MethodSpec ([JClass jString], JVoid))
        ]
    boolToString :: [IRItem]
    boolToString =
      iri
        [ InvokeStatic $
          MethodRef
            (CRef glcUtils)
            "boolStr"
            (MethodSpec ([JInt], JClass jString))
        ]

instance IRRep T.SimpleStmt where
  toIR T.EmptyStmt = []
  toIR (T.VoidExprStmt aid args) -- Akin to Argument without a type
   =
    concatMap (\e -> toIR e ++ cloneIfNeeded e) args ++
    iri
      [ InvokeStatic $
        MethodRef
          (CRef cMain)
          (tFnStr aid)
          (MethodSpec (map exprJType args, JVoid))
      ]
  toIR (T.ExprStmt e) = toIR e ++ iri [Pop] -- Invariant: pop expression result
  toIR (T.Assign (T.AssignOp mAop) pairs) =
    concatMap getValue (reverse $ NE.toList pairs) ++
    concatMap setStore (NE.toList pairs)
    where
      getValue :: (T.Expr, T.Expr) -> [IRItem]
      getValue (se, ve) =
        case (mAop, se) of
          (Nothing, T.Index _ ea ei) ->
            toIR ea ++ toIR ei ++ toIR ve ++ cloneIfNeeded ve
          (Nothing, T.Selector _ eo _) -> toIR eo ++ toIR ve ++ cloneIfNeeded ve
          (Nothing, _) -> toIR ve ++ cloneIfNeeded ve
          (Just op, T.Var t idx) ->
            setUpOps op ++
            iri [Load (typeToIRType t) idx] ++
            afterLoadOps op ++ toIR ve ++ finalOps op
          (Just op, T.TopVar t tvi) ->
            setUpOps op ++
            iri [GetStatic (FieldRef cMain (tVarStr tvi)) (typeToJType t)] ++
            afterLoadOps op ++ toIR ve ++ finalOps op
          (Just op, T.Selector t eo fid) ->
            case exprJType eo of
              JClass cr ->
                setUpOps op ++
                toIR eo ++
                iri
                  [ Dup
                  , InvokeVirtual $
                    MethodRef
                      (CRef cr)
                      (structGetter fid)
                      (MethodSpec ([], typeToJType t))
                  ] ++
                afterLoadOps op ++ toIR ve ++ finalOps op
              _ -> error "Cannot get field of non-object"
          (Just op, T.Index t ea ei) ->
            setUpOps op ++
            toIR ea ++
            toIR ei ++
            IRInst Dup2 :
            glcArrayGetIR t ++ -- Duplicate addr. and index at the same time...
            afterLoadOps op ++ toIR ve ++ finalOps op
          _ -> error "Cannot assign to non-addressable value"
        where
          irType :: IRType
          irType = exprIRType ve
          setUpOps :: T.ArithmOp -> [IRItem]
          setUpOps op =
            case (op, irType) of
              (T.Add, Object) ->
                iri [New stringBuilder, Dup, InvokeSpecial sbInit]
              _ -> []
          afterLoadOps :: T.ArithmOp -> [IRItem]
          afterLoadOps op =
            case (op, irType) of
              (T.Add, Object) -> iri [InvokeVirtual sbAppend]
              _               -> []
          finalOps :: T.ArithmOp -> [IRItem]
          finalOps op -- TODO: Cloning here????
           =
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
      setStore :: (T.Expr, T.Expr) -> [IRItem]
      setStore (se, ve) =
        case se of
          T.Var _ idx -> iri [Store (exprIRType ve) idx] -- Cannot use var t in the case of holes...
          T.TopVar t tvi ->
            iri [PutStatic (FieldRef cMain (tVarStr tvi)) (typeToJType t)]
          T.Selector t eo fid ->
            case exprJType eo of
              JClass cr ->
                if cr == cGlcArray
                  then error "Cannot set field of non-struct"
                  else iri
                         [ InvokeVirtual $
                           MethodRef
                             (CRef cr)
                             (structSetter fid)
                             (MethodSpec ([typeToJType t], JVoid))
                         ]
              _ -> error "Cannot set field of non-struct"
          T.Index t _ _ -> storeIR
            where storeIR :: [IRItem]
                  storeIR =
                    case t of
                      T.ArrayType {} -> iri [InvokeVirtual glcArraySetObj] -- TODO: LOOK AT CLONING
                      T.SliceType {} -> iri [InvokeVirtual glcArraySetObj] -- TODO: LOOK AT CLONING
                      T.PInt -> iri [InvokeVirtual (glcArraySet JInt)]
                      T.PFloat64 -> iri [InvokeVirtual (glcArraySet JDouble)]
                      T.PBool -> iri [InvokeVirtual (glcArraySet JInt)]
                      T.PRune -> iri [InvokeVirtual (glcArraySet JInt)]
                      T.PString -> iri [InvokeVirtual glcArraySetObj] -- TODO: LOOK AT CLONING
                      T.StructType {} -> iri [InvokeVirtual glcArraySetObj] -- TODO: LOOK AT CLONING
          _ -> error "Cannot assign to non-addressable value"
  toIR (T.ShortDeclare iExps) =
    exprInsts ++ zipWith (curry expStore) ids stTypes
    where
      ids :: [Either T.Ident T.VarIndex]
      ids = map fst (NE.toList iExps)
      exprs :: [T.Expr]
      exprs = reverse $ map snd (NE.toList iExps)
      exprInsts :: [IRItem]
      exprInsts = concatMap maybeClone exprs
      stTypes :: [T.Type]
      stTypes = reverse $ map exprType exprs
      expStore :: (Either T.Ident T.VarIndex, T.Type) -> IRItem
      expStore (vid, t) =
        either
          (\i -> expFieldStore (i, t))
          (\vi -> expIdxStore (vi, t))
          vid
      expIdxStore :: (T.VarIndex, T.Type) -> IRItem
      expIdxStore (idx, t) = IRInst (Store (typeToIRType t) idx)
      expFieldStore :: (T.Ident, T.Type) -> IRItem
      expFieldStore (tvi, t) =
        IRInst (PutStatic (FieldRef cMain (tVarStr tvi)) (typeToJType t))
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
  toIR (T.Binary (T.LabelIndex idx) _ T.EQ e1 e2) =
    toIR e1 ++ toIR e2 ++ equality True "bin" idx (exprType e1)
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
    toIR e1 ++ toIR e2 ++ cloneIfNeeded e2 ++ appendIR -- clone e2 as if it were an argument
    where
      appendIR :: [IRItem]
      appendIR =
        case exprType e2 of
          T.ArrayType {}  -> iri [InvokeVirtual glcArrayAppendObj] -- TODO: CLONE?
          T.SliceType {}  -> iri [InvokeVirtual glcArrayAppendObj] -- TODO: CLONE?
          T.PInt          -> iri [InvokeVirtual (glcArrayAppend JInt)]
          T.PFloat64      -> iri [InvokeVirtual (glcArrayAppend JDouble)]
          T.PRune         -> iri [InvokeVirtual (glcArrayAppend JInt)]
          T.PBool         -> iri [InvokeVirtual (glcArrayAppend JInt)]
          T.PString       -> iri [InvokeVirtual glcArrayAppendObj] -- TODO: CLONE?
          T.StructType {} -> iri [InvokeVirtual glcArrayAppendObj] -- TODO: CLONE?
  toIR (T.LenExpr e) =
    case exprType e of
      T.ArrayType l _ -> iri [LDC (LDCInt l)] -- fixed at compile time
      T.SliceType _   -> toIR e ++ iri [InvokeVirtual glcArrayLength]
      T.PString       -> toIR e ++ iri [InvokeVirtual stringLength]
      _               -> error "Cannot get length of non-array/slice"
  toIR (T.CapExpr e) =
    case exprType e of
      T.ArrayType l _ -> iri [LDC (LDCInt l)]
      T.SliceType _   -> toIR e ++ iri [InvokeVirtual glcArrayCap]
      _               -> error "Cannot get capacity of non-array/slice"
  toIR (T.Selector t e fid) =
    toIR e ++
    iri
      [ InvokeVirtual $
        MethodRef
          (CRef cr)
          (structGetter fid)
          (MethodSpec ([], typeToJType t))
      ]
    where
      cr :: ClassRef
      cr =
        case exprJType e of
          JClass cref ->
            if cref == cGlcArray
              then error "Cannot get field of non-struct"
              else cref
          _ -> error "Cannot get field of non-struct"
  toIR (T.Index t e1 e2) = toIR e1 ++ toIR e2 ++ glcArrayGetIR t
  toIR (T.Arguments t aid args) =
    concatMap (\e -> toIR e ++ cloneIfNeeded e) args ++
    iri
      [ InvokeStatic $
        MethodRef
          (CRef cMain)
          (tFnStr aid)
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

tFnStr :: T.Ident -> String
tFnStr (T.Ident tfs) = "__glc$fn__" ++ tfs

structName :: T.Ident -> String
structName (T.Ident sid) = "__Glc$Struct__" ++ sid

structField :: T.Ident -> String
structField (T.Ident fid) = "__glc$sf__" ++ fid

structGetter :: T.Ident -> String
structGetter fid = "get_" ++ structField fid

structSetter :: T.Ident -> String
structSetter fid = "set_" ++ structField fid

cloneIfNeeded :: T.Expr -> [IRItem]
cloneIfNeeded e =
  case exprJType e of
    JClass (ClassRef "java/lang/String") -> [] -- Cannot clone strings
    JClass (ClassRef "java/lang/Object") -> [] -- Cannot clone base objects
    JClass cr ->
      iri
        [ InvokeVirtual $
          MethodRef (CRef cr) "copy" (MethodSpec ([], JClass jObject))
        , CheckCast (CRef cr)
        ]
    JArray jt ->
      iri
        [ InvokeVirtual $
          MethodRef (ARef jt) "copy" (MethodSpec ([], JClass jObject))
        , CheckCast (ARef jt)
        ]
    _ -> [] -- Primitives and strings are not clonable

equalityNL :: Bool -> String -> Int -> T.Type -> [IRItem]
equalityNL eq lbl idx t =
  case t of
    T.ArrayType {} ->
      iri
        [ InvokeVirtual glcArrayEquals
        , If checkBool (lbl ++ "_true_eq_" ++ show idx) -- 1 > 0, i.e. true
        ]
    T.PString ->
      iri
        [ InvokeVirtual stringEquals
        , If checkBool (lbl ++ "_true_eq_" ++ show idx) -- 1 > 0, i.e. true
        ]
    (T.StructType sid) ->
      iri
        [ CheckCast (CRef jObject)
        , InvokeVirtual $
          MethodRef
            (CRef $ ClassRef $ structName sid)
            "equals"
            (MethodSpec ([JClass jObject], JBool))
        , If checkBool (lbl ++ "_true_eq_" ++ show idx) -- 1 > 0, i.e. true
        ]
    T.PFloat64 ->
      iri
        [ DCmpG
        , If checkInt (lbl ++ "_true_eq_" ++ show idx) -- dcmpg is 0, they're equal
        ]
    T.SliceType {} ->
      iri
        [ InvokeVirtual glcArrayEquals
        , If checkBool (lbl ++ "_true_eq_" ++ show idx) -- 1 > 0, i.e. true
        ]
    _
      -- Integer types
     -> iri [IfICmp checkInt (lbl ++ "_true_eq_" ++ show idx)]
  where
    checkBool :: IRCmp
    checkBool =
      if eq
        then IRData.GT
        else IRData.EQ
    checkInt :: IRCmp
    checkInt =
      if eq
        then IRData.EQ
        else IRData.NE

equality :: Bool -> String -> Int -> T.Type -> [IRItem]
equality eq lbl idx t = equalityNL eq lbl idx t ++ eqPostfix
  where
    eqPostfix :: [IRItem]
    eqPostfix =
      [ IRInst IConst0
      , IRInst (Goto (lbl ++ "_stop_eq_" ++ show idx))
      , IRLabel (lbl ++ "_true_eq_" ++ show idx)
      , IRInst IConst1
      , IRLabel (lbl ++ "_stop_eq_" ++ show idx) -- Don't need NOP, can't end block with x == y
      ]

glcArrayGetIR :: T.Type -> [IRItem]
glcArrayGetIR t =
  case t of
    T.ArrayType {} ->
      iri [InvokeVirtual (glcArrayGet jObject), CheckCast (CRef cGlcArray)]
    T.SliceType {} ->
      iri [InvokeVirtual (glcArrayGet jObject), CheckCast (CRef cGlcArray)]
    T.PInt -> iri [InvokeVirtual glcArrayGetInt]
    T.PFloat64 -> iri [InvokeVirtual glcArrayGetDouble]
    T.PRune -> iri [InvokeVirtual glcArrayGetInt]
    T.PBool -> iri [InvokeVirtual glcArrayGetInt]
    T.PString ->
      iri [InvokeVirtual (glcArrayGet jObject), CheckCast (CRef jString)]
    (T.StructType sid) ->
      iri
        [ InvokeVirtual (glcArrayGet jObject)
        , CheckCast (CRef $ ClassRef $ structName sid)
        ]

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
typeToJType T.ArrayType {}     = JClass cGlcArray
typeToJType T.SliceType {}     = JClass cGlcArray
typeToJType T.PInt             = JInt
typeToJType T.PFloat64         = JDouble
typeToJType T.PRune            = JInt
typeToJType T.PBool            = JBool
typeToJType T.PString          = JClass jString
typeToJType (T.StructType sid) = JClass (ClassRef $ structName sid)

class StackHeight a where
  stackDelta :: a -> Int

instance StackHeight Instruction where
  stackDelta (Load ir _) = stackDelta ir -- ... -> ..., v
  stackDelta (ArrayLoad ir) = -1 + stackDelta ir -- ..., o, i -> v (double-wide)
  stackDelta (Store ir _) = -(stackDelta ir) -- ..., v -> ...
  stackDelta (ArrayStore ir) = -2 - stackDelta ir -- ..., o, i, v -> ...
  stackDelta (Return m) = maybe 0 stackDelta m
  stackDelta Dup = 1 -- ..., v -> ..., v, v
  stackDelta Dup2 = 2 -- ..., v, w -> ..., v, w, v, w
  stackDelta DupX1 = 1 -- ..., v, w -> ..., w, v, w
  stackDelta Dup2X2 = 2 -- ..., v, w, x, y -> ..., x, y, v, w, x, y
  stackDelta Goto {} = 0
  stackDelta (Add ir) = -(stackDelta ir) -- ..., v, w -> ..., r
  stackDelta (Div ir) = -(stackDelta ir) -- ..., v, w -> ..., r
  stackDelta (Mul ir) = -(stackDelta ir) -- ..., v, w -> ..., r
  stackDelta (Sub ir) = -(stackDelta ir) -- ..., v, w -> ..., r
  stackDelta Neg {} = 0 -- ..., v -> ..., r (double-wide or not)
  stackDelta IRem = -1 -- ..., v, w -> ..., r
  stackDelta IShL = -1 -- ..., v, w -> ..., r
  stackDelta IShR = -1 -- ..., v, w -> ..., r
  stackDelta IAnd = -1 -- ..., v, w -> ..., r
  stackDelta IOr = -1 -- ..., v, w -> ..., r
  stackDelta IXOr = -1 -- ..., v, w -> ..., r
  stackDelta InstanceOf {} = 0 -- ..., v -> .., r
  stackDelta IntToDouble = 1 --- ..., i -> ..., d (double-wide)
  stackDelta DoubleToInt = -1 --- ..., d (double-wide) -> ..., i
  stackDelta IfACmpNE {} = -2 --- ..., v1, v2 -> ...
  stackDelta IfACmpEQ {} = -2 --- ..., v1, v2 -> ...
  stackDelta If {} = -1 -- ..., v -> ...
  stackDelta IfICmp {} = -2 -- ..., v, w -> ...
  stackDelta IfNonNull {} = -1 -- ..., v -> ...
  stackDelta (LDC (LDCDouble _)) = 2 -- ... -> ..., v (double-wide)
  stackDelta LDC {} = 1 -- ... -> ..., v
  stackDelta IConstM1 = 1 -- ... -> ..., -1
  stackDelta IConst0 = 1 -- ... -> ..., 0
  stackDelta IConst1 = 1 -- ... -> ..., 1
  stackDelta AConstNull = 1 -- ... -> ..., null
  stackDelta DCmpG = -3 -- ..., v1, v2 -> ..., r
  stackDelta New {} = 1 -- ... -> ..., o
  stackDelta CheckCast {} = 0 -- ..., o -> ..., o (checked)
  stackDelta ANewArray {} = 0 -- ..., c -> ..., o
  stackDelta (MultiANewArray _ c) = (-c) + 1 -- ..., c1, c2, .. -> ..., o
  stackDelta NewArray {} = 0 -- ..., c -> ..., o
  stackDelta NOp = 0
  stackDelta Pop = -1 -- ..., v -> ...
  stackDelta Pop2 = -2 -- ..., v, w -> ...
  stackDelta Swap = 0 -- ..., v, w -> ..., w, v
  stackDelta (GetStatic _ jt) = stackDelta jt -- ... -> ..., v
  stackDelta (GetField _ jt) = -1 + stackDelta jt -- ..., o -> ..., v
  stackDelta (PutStatic _ jt) = -(stackDelta jt) -- ..., v -> ...
  stackDelta (PutField _ jt) = -1 - stackDelta jt -- ..., o, v -> ...
  stackDelta (InvokeSpecial (MethodRef _ _ (MethodSpec (a, rt))))
    -- ..., o, a1, .., an -> r (or void)
   = sum (map stackDelta a) - 1 + stackDelta rt
  stackDelta (InvokeVirtual (MethodRef _ _ (MethodSpec (a, rt))))
    -- ..., o, a1, .., an -> r (or void)
   = sum (map stackDelta a) - 1 + stackDelta rt
  stackDelta (InvokeStatic (MethodRef _ _ (MethodSpec (a, rt))))
    -- ..., a1, .., an -> r
   = sum (map stackDelta a) + stackDelta rt
  stackDelta Debug {} = 0

instance StackHeight JType where
  stackDelta JDouble = 2
  stackDelta JVoid   = 0
  stackDelta _       = 1 -- references, chars, ints, bools

instance StackHeight IRType where
  stackDelta Object    = 1 -- references are 32-bit
  stackDelta (Prim ir) = stackDelta ir

instance StackHeight IRPrimitive where
  stackDelta IRDouble = 2
  stackDelta IRInt    = 1

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
