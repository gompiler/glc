module Main where

import           Base
import           IRConv                  (displayIR)
import qualified Options.Applicative as Op
import           ParseCLI
import           Prettify            (checkPrettifyInvariance, prettify)
import           CheckedPrettify     (prettify)
import           Scanner             (putExit, putSucc, scanC, scanP)
import           SymbolTable         (symbol, typecheckP, typecheckGen)
import           Weeding             (weed)
import           Codegen             (codegen)

main :: IO ()
main = do
  cmdi@(CI cmd inp) <- Op.customExecParser (Op.prefs Op.showHelpOnEmpty) cmdParser
  case cmdi
    -- Special case, match on file only
    of
    CI Codegen (FileInp f) -> codegen f
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
        IR -> displayIR
        PrettyTypecheck -> either putExit (putStrLn . CheckedPrettify.prettify) . typecheckGen
        Codegen ->
          const $ putExit $ createError' "codegen called without filename" -- This should never happen because of case above
