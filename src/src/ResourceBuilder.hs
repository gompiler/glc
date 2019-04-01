{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE InstanceSigs          #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE TypeSynonymInstances  #-}

module ResourceBuilder where

--import           Base
import qualified CheckedData      as T
import           Control.Monad.ST
import qualified Cyclic           as C
import qualified ResourceContext  as RC
import           ResourceData

convertProgram :: T.Program -> Program
convertProgram p =
  runST $ do
    rc <- RC.new
    convert rc p

class Converter a b where
  convert :: forall s. RC.ResourceContext s -> a -> ST s b

instance Converter T.Program Program where
  convert = undefined

instance Converter T.CType Type where
  convert :: forall s. RC.ResourceContext s -> T.CType -> ST s Type
  convert rc type' =
    case C.getActual type' of
      T.ArrayType i t -> ArrayType i <$> convert rc (C.set type' t)
      T.SliceType t -> SliceType <$> convert rc (C.set type' t)
      T.StructType fields ->
        let cfields = zip (repeat type') fields
         in StructType <$> (RC.getStructName rc =<< mapM (convert rc) cfields)
      T.TypeMap t -> convert rc t
      T.PInt -> return PInt
      T.PFloat64 -> return PFloat64
      T.PBool -> return PBool
      T.PRune -> return PRune
      T.PString -> return PString
      T.Cycle -> undefined
instance Converter (T.CType, T.FieldDecl) FieldDecl where
  convert ::
       forall s.
       RC.ResourceContext s
    -> (T.CType, T.FieldDecl)
    -> ST s FieldDecl
  convert rc (ctype, T.FieldDecl ident t) =
    FieldDecl ident <$> convert rc (C.set ctype t)
