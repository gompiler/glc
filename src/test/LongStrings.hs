{-# LANGUAGE QuasiQuotes #-}

module LongStrings where

import           Data.Text         (Text, unpack)
import           NeatInterpolation

lscantest :: Int -> String
lscantest index =
  unpack $
  (!!)
    [ [text|
           /* Long block comment
           here's another line
           and another
           */
       |]
    , [text|
           // Short comments
           // More
           |]
    , [text|
           break /* Multiline to simulate
           a new line*/
           |]
    ]
    index
