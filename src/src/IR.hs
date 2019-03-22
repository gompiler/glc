module IR where

import CheckedData
-- import Data.List.NonEmpty (toList)

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

data IRPrimitive
  = Integer -- Integers, booleans, runes
  | Float -- Float64
  deriving (Show)

data IRType
  = Prim IRPrimitive -- Integer, boolean, rune, float64
  | Object -- String, array, struct, slice
  deriving (Show)

data Instruction
  = Load IRType
  | Store IRType
  | Return (Maybe IRType)
  | Dup
  | Goto LabelName
  | Add IRPrimitive
  | Div IRPrimitive -- TODO: Turn into Op instruction?
  | Mul IRPrimitive
  | Neg IRPrimitive
  | Sub IRPrimitive
  | IRem
  | IShL
  | IShR
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
  toIR (SimpleStmt stmt) = toIR stmt
  toIR (If (sstmt, expr) ifs elses) = -- TODO: SIMPLE STMT!!!
    toIR sstmt ++ toIR expr ++ IRInst IfEq : toIR ifs ++
    IRInst (Goto "TODOElse") : toIR elses ++ [IRInst (Goto "TODOStop")]
  toIR (Switch {}) = undefined -- duplicate expression as many times as non-default case statement expressions in lists

  toIR (For {}) = undefined
  toIR Break = undefined -- [IRInst (Goto "TODO")]
  toIR Continue = undefined -- [IRInst (Goto "TODO")]
  toIR _ = undefined

instance IRRep ForClause where
  toIR (ForClause {}) = undefined -- s1 me s2 = toIR s1 ++ (maybe [] toIR me) ++ toIR s2

instance IRRep SwitchCase where
  toIR (Case {}) = undefined -- concat $ map (toIR . some equality check) exprs
  toIR (Default stmt) = toIR stmt -- Default doesn't need to check expr value

instance IRRep SimpleStmt where
  toIR EmptyStmt         = []
  toIR (ExprStmt e)      = toIR e ++ [IRInst Pop] -- Invariant: pop expression result
  toIR (Increment {})    = undefined -- iinc for int, otherwise load/save + 1
  toIR (Decrement {})    = undefined -- iinc for int (-1), otherwise "
  toIR (Assign {})       = undefined -- store IRType
  toIR (ShortDeclare _) = undefined -- concat (map toIR $ toList el) ++ [istores...]

instance IRRep Expr where
  toIR (Binary (Arithm CheckedData.Add) _ _ ) = undefined -- toIR e1 ++ toIR e2 ++ [IRInst $ Add typeToPrimitive TODO]
  toIR _ = undefined

instance IRRep Literal where
  toIR _ = undefined
