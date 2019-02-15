module Ascii
  ( ascii
  ) where

-- | Returns a list of all ascii characters from 0 to 255
ascii :: String
ascii = asciiRec [] 255

asciiRec :: String -> Int -> String
asciiRec cl i =
  if i > 255 || i < 0
    then cl
    else asciiRec ((toEnum i :: Char) : cl) (i - 1)
