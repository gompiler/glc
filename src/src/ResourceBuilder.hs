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
