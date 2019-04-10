{-# LANGUAGE NamedFieldPuns #-}

module UtilsBuilder where

--import           IRConv
import qualified IRData    as IR
import           UtilsData

generateUtils :: [Category] -> [IR.Class]
generateUtils categories = generateUtils' =<< categories

generateUtils' :: Category -> [IR.Class]
--generateUtils' Category {baseType = Custom baseClass, arrayDepth, sliceDepth} =
--  undefined
generateUtils' _ = undefined
