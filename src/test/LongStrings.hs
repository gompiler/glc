{-# LANGUAGE QuasiQuotes #-}

module LongStrings where

import           Data.Text         (Text)
import           NeatInterpolation

lscantest :: Int -> String
lscantest index =
  show $
  (!!)
    [ [text|
       //* Long block comment
       here's another line
       and another
       *//
       |]
    , [text|
              // Short comments
              // More
              |]
    , [text|
                break //* Multiline to simulate
                a new line*//
                |]
    ]
    index
