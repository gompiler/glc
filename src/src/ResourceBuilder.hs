{-# LANGUAGE MultiParamTypeClasses #-}

module ResourceBuilder where

--import           Base
--import qualified CheckedData  as C
--import           ResourceData

--data ResourceContext = RC
--  { limit   :: Int
--  , allStructs :: [StructType]
----  , assignVarIndex :: C.ScopedIdent ->
--  }
--
--initContext = RC {limit = 0, allStructs = []}
--
--convertProgram :: C.Program -> Program
--convertProgram = convert initContext
--
--class Converter a b c where
--  convert :: c -> a -> b
--
--instance Converter C.Program Program ResourceContext