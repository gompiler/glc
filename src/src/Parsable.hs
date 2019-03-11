{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Parsable where

import           Data
import           Data.List.NonEmpty (NonEmpty (..), fromList)
import qualified Parser             as P (parse, parsef, parsefNL, pDec, pE, pEl, pIDecl, pId, pPar, pSig,
                                                                               pStmt, pT, pTDecl)

class (Show a, Eq a) =>
      Parsable a
  where
  parse :: String -> Either String a

instance Parsable Program where
  parse = P.parse

instance Parsable Stmt where
  parse = P.parsefNL P.pStmt

instance Parsable TopDecl where
  parse = P.parsefNL P.pTDecl

instance Parsable Signature where
  parse = P.parsef P.pSig

instance Parsable [ParameterDecl] where
  parse = P.parsef P.pPar

instance Parsable Type' where
  parse = P.parsef P.pT

instance Parsable Decl where
  parse = P.parsef P.pDec

instance Parsable [Expr] where
  parse = P.parsef P.pEl

instance Parsable Expr where
  parse = P.parsef P.pE

instance Parsable VarDecl' where
  parse = P.parsef P.pIDecl

instance Parsable Identifiers where
  parse s = fromList . reverse <$> P.parsef P.pId s
