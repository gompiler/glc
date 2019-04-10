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

-- | Generate the name of the array class
-- Note that the depth should start at 1 to represent 1D array
-- For convenience, depth 0 returns the base class, as that will be the generic type
arrayClass :: String -> Int -> String
arrayClass baseClass 0 = baseClass
arrayClass baseClass i = "GlcArray$" ++ baseClass ++ "$" ++ show i

-- | Generate the name of the slice class
-- Note that the depth should start at 1 to represent 1D slice
-- For convenience, depth 0 returns the base class, as that will be the generic type
sliceClass :: String -> Int -> String
sliceClass baseClass 0 = baseClass
sliceClass baseClass i = "GlcSlice" ++ baseClass ++ "$" ++ show i
