module CommonTest where

-- | To format what input we give and what we expect for it in SpecWith()
expectStr :: String -> String -> String
expectStr inp out = "given \n" ++ inp ++ "\nreturns " ++ out
