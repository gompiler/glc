module Main where

import qualified Options.Applicative as Op
import           ParseCLI
import           Parser
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
        Scan      -> scanC
        Tokens    -> scanP
        Parse -> either putExit (const $ putSucc "OK") . (\s -> parse s >>= weed s)
        Pretty    -> putStrLn . (pCoupler parse)
        Symbol -> const $ putStrLn "symbol not yet implemented"
        Typecheck -> const $ putStrLn "typecheck not yet implemented"
