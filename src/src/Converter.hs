{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}

-- | Helper module to support easy conversions from one type to another
module Converter
  ( Convert(..)
  ) where

class Convert a b where
  convert :: a -> b

instance (Convert a1 a2, Convert b1 b2) => Convert (a1, b1) (a2, b2) where
  convert (a, b) = (convert a, convert b)

instance (Convert a b, Functor f) => Convert (f a) (f b) where
  convert = fmap convert
