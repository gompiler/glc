module Main where

import           Base
import           IR                  (displayIR)
import qualified Options.Applicative as Op
import           ParseCLI
import           Prettify            (checkPrettifyInvariance, prettify)
import           Scanner             (putExit, putSucc, scanC, scanP)
import           SymbolTable         (symbol, typecheckP)
import           Weeding             (weed)

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
        Typecheck -> typecheckP
        ParseCLI.IR -> displayIR
        Codegen ->
          const $ putExit $ createError' "codegen called without filename" -- This should never happen because of case above
