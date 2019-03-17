module Base
  ( Glc
  , Glc'
  , GlcConstraint
  , module ErrorBundle
  ) where

import           ErrorBundle

type Glc a = Either ErrorMessage a

type Glc' a = Either ErrorMessage' a

type GlcConstraint a = a -> Maybe ErrorMessage'
