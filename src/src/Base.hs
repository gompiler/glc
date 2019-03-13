module Base
  ( Glc
  , module ErrorBundle
  ) where

import           ErrorBundle

type Glc a = Either ErrorMessage a
