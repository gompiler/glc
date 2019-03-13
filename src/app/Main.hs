module Main where

import           ErrorBundle
import qualified Options.Applicative as Op
import           ParseCLI
import           Prettify
import           Scanner
import           Weeding

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
        Symbol -> const $ putStrLn "symbol not yet implemented"
        Typecheck -> const $ putStrLn "typecheck not yet implemented"
        Codegen ->
          const $ putExit $ createError' "codegen called without filename" -- This should never happen because of case above
