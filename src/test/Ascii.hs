module Ascii (ascii) where

-- | Returns a list of all ascii characters from 0 to 255
ascii :: [Char]
ascii = asciiRec [] 255

asciiRec :: [Char] -> Int -> [Char]
asciiRec cl i = if i > 255 || i < 0 then cl
                else asciiRec ((toEnum i :: Char) : cl) (i - 1)
