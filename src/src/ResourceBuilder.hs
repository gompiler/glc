{-# LANGUAGE MultiParamTypeClasses #-}

module ResourceBuilder where

--import           Base
import qualified CheckedData      as C
import           Control.Monad.ST
import qualified ResourceContext  as RC
import           ResourceData

convertProgram :: C.Program -> Program
convertProgram p =
  runST $ do
    rc <- RC.new
    convert rc p

class Converter a b where
  convert :: RC.ResourceContext s -> a -> ST s b

instance Converter C.Program Program where
  convert = undefined

instance Converter C.Type Type where
  convert rc type' =
    case type' of
      C.ArrayType i t -> ArrayType i <$> convert rc t
      C.SliceType t -> SliceType <$> convert rc t
      C.StructType fields ->
        StructType <$> (RC.getStructName rc =<< mapM (convert rc) fields)
      C.PInt -> return PInt
      C.PFloat64 -> return PFloat64
      C.PBool -> return PBool
      C.PRune -> return PRune
      C.PString -> return PString
      C.Cycle -> return Cycle
      C.TypeMap _ -> return TypeMap

instance Converter C.FieldDecl FieldDecl where
  convert rc (C.FieldDecl ident t) = FieldDecl ident <$> convert rc t
