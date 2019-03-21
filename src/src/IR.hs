module IR where

import CheckedData

type LabelName = String

data Method = Method
  { name :: String
  , stackLimit :: Int
  , localsLimit :: Int
  , body :: [IRItem]
  } deriving (Show)

data IRItem
  = IRInst Instruction
  | IRLabel LabelName
  deriving (Show)

data IRType
  = Integer
  | Object
  deriving (Show)

data Instruction
  = Load IRType
  | Store IRType
  | Return (Maybe IRType)
  | Dup
  | Goto LabelName
  | IAdd
  | IDiv -- TODO: Turn into Op instruction?
  | IMul
  | INeg
  | IRem
  | IShL
  | IShR
  | ISub
  | IALoad
  | IAnd
  | IAStore
  | IfEq
  | IStore Int
  | IXOr
  | LDCInt Int
  | NOp
  | Pop
  | Swap
  deriving (Show)

class IRRep a where
  toIR :: a -> [IRItem]

instance IRRep Stmt where
  toIR (BlockStmt stmts) = concat $ map toIR stmts
  toIR (If (_, expr) ifs elses) = -- TODO: SIMPLE STMT!!!
    toIR expr ++ IRInst IfEq : toIR ifs ++ IRInst (Goto "TODOElse") : toIR elses
    ++ [IRInst (Goto "TODOStop")]
  toIR (Switch {}) = undefined
  toIR (For {}) = undefined
  toIR Break = undefined -- [IRInst (Goto "TODO")]
  toIR Continue = undefined -- [IRInst (Goto "TODO")]
  toIR _ = undefined

instance IRRep Expr where
  toIR _ = undefined
