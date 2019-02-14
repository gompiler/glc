module Main where

import ParseCLI
import Scanner
import qualified Options.Applicative as Op

main :: IO ()
main = do
  CI cmd inp <- Op.customExecParser (Op.prefs Op.showHelpOnEmpty) cmdParser
  case cmd of
    -- Special case, match on file only
    Codegen -> putStrLn "codegen not yet implemented"
    _ -> inpToIOStr inp >>= case cmd of
                              Scan      -> scanC
                              Tokens    -> scanP
                              Parse     -> \s -> putStrLn "parse not yet implemented"
                              Pretty    -> \s -> putStrLn "pretty not yet implemented"
                              Symbol    -> \s -> putStrLn "symbol not yet implemented"
                              Typecheck -> \s -> putStrLn "typecheck not yet implemented"
