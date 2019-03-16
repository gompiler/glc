module Main where

import           ErrorBundle
import qualified Options.Applicative as Op
import           ParseCLI
import           Prettify (prettify, checkPrettifyInvariance)
import           Scanner (scanC, scanP, putExit, putSucc)
import           Weeding (weed)
import           SymbolTable (symbol)

main :: IO ()
main = do
  CI cmd inp <- Op.customExecParser (Op.prefs Op.showHelpOnEmpty) cmdParser
  case cmd
    -- Special case, match on file only
        of
    Codegen -> putStrLn "codegen not yet implemented"
    _ ->
      inpToIOStr inp >>=
      case cmd of
        Scan -> scanC
        Tokens -> scanP
        Parse -> either putExit (const $ putSucc "OK") . weed
        Pretty -> either putExit putStrLn . (fmap Prettify.prettify . weed)
        PrettyInvar ->
          either putExit (const $ putSucc "OK") . checkPrettifyInvariance
        Symbol -> symbol
        Typecheck -> const $ putStrLn "typecheck not yet implemented"
        Codegen ->
          const $ putExit $ createError' "codegen called without filename" -- This should never happen because of case above
