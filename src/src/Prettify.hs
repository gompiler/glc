module Prettify where

import           Data

class Prettify a where
  prettify :: a -> String
  prettify = unlines . prettify'
  prettify' :: a -> [String]

instance Prettify Identifier where
  prettify' (Identifier _ id) = [id]

--instance Prettify Program where
--  prettify' Program {package:: String, topLevels} = [""]
