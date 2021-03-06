{-# OPTIONS_GHC -w #-}
{-# OPTIONS -fglasgow-exts -cpp #-}
module ParserGen ( putExit
                , AlexPosn(..)
                , ParseError(..)
                , runAlex
                , pId
                , pT
                , pTDecl
                , pTDecls
                , pDec
                , pDecB
                , pFDec
                , pSig
                , pIDecl
                , pPar
                , pRes
                , pStmt
                , pStmts
                , pBStmt
                , pSStmt
                , pIf
                , pElses
                , pEl
                , pE
                , pTDef
                , pStruct
                , pFiDecls
                , pFor
                , pSwS
                , pSwB
                , hparse
                , parse
                , parsef
                , parsefNL)
where
import Scanner
import Data
import Base
import System.Exit
import System.IO

import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NonEmpty
import qualified Data.Array as Happy_Data_Array
import qualified GHC.Exts as Happy_GHC_Exts
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.5

newtype HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 = HappyAbsSyn HappyAny
#if __GLASGOW_HASKELL__ >= 607
type HappyAny = Happy_GHC_Exts.Any
#else
type HappyAny = forall a . a
#endif
happyIn29 :: t29 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn29 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn29 #-}
happyOut29 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t29
happyOut29 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut29 #-}
happyIn30 :: t30 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn30 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn30 #-}
happyOut30 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t30
happyOut30 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut30 #-}
happyIn31 :: t31 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn31 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn31 #-}
happyOut31 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t31
happyOut31 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut31 #-}
happyIn32 :: t32 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn32 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn32 #-}
happyOut32 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t32
happyOut32 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut32 #-}
happyIn33 :: t33 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn33 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn33 #-}
happyOut33 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t33
happyOut33 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut33 #-}
happyIn34 :: t34 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn34 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn34 #-}
happyOut34 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t34
happyOut34 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut34 #-}
happyIn35 :: t35 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn35 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn35 #-}
happyOut35 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t35
happyOut35 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut35 #-}
happyIn36 :: t36 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn36 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn36 #-}
happyOut36 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t36
happyOut36 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut36 #-}
happyIn37 :: t37 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn37 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn37 #-}
happyOut37 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t37
happyOut37 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut37 #-}
happyIn38 :: t38 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn38 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn38 #-}
happyOut38 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t38
happyOut38 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut38 #-}
happyIn39 :: t39 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn39 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn39 #-}
happyOut39 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t39
happyOut39 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut39 #-}
happyIn40 :: t40 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn40 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn40 #-}
happyOut40 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t40
happyOut40 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut40 #-}
happyIn41 :: t41 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn41 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn41 #-}
happyOut41 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t41
happyOut41 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut41 #-}
happyIn42 :: t42 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn42 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn42 #-}
happyOut42 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t42
happyOut42 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut42 #-}
happyIn43 :: t43 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn43 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn43 #-}
happyOut43 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t43
happyOut43 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut43 #-}
happyIn44 :: t44 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn44 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn44 #-}
happyOut44 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t44
happyOut44 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut44 #-}
happyIn45 :: t45 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn45 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn45 #-}
happyOut45 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t45
happyOut45 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut45 #-}
happyIn46 :: t46 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn46 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn46 #-}
happyOut46 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t46
happyOut46 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut46 #-}
happyIn47 :: t47 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn47 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn47 #-}
happyOut47 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t47
happyOut47 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut47 #-}
happyIn48 :: t48 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn48 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn48 #-}
happyOut48 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t48
happyOut48 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut48 #-}
happyIn49 :: t49 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn49 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn49 #-}
happyOut49 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t49
happyOut49 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut49 #-}
happyIn50 :: t50 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn50 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn50 #-}
happyOut50 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t50
happyOut50 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut50 #-}
happyIn51 :: t51 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn51 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn51 #-}
happyOut51 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t51
happyOut51 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut51 #-}
happyIn52 :: t52 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn52 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn52 #-}
happyOut52 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t52
happyOut52 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut52 #-}
happyIn53 :: t53 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn53 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn53 #-}
happyOut53 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t53
happyOut53 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut53 #-}
happyIn54 :: t54 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn54 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn54 #-}
happyOut54 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t54
happyOut54 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut54 #-}
happyIn55 :: t55 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn55 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn55 #-}
happyOut55 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t55
happyOut55 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut55 #-}
happyIn56 :: t56 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn56 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn56 #-}
happyOut56 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t56
happyOut56 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut56 #-}
happyIn57 :: t57 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn57 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn57 #-}
happyOut57 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t57
happyOut57 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut57 #-}
happyIn58 :: t58 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn58 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn58 #-}
happyOut58 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t58
happyOut58 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut58 #-}
happyIn59 :: t59 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyIn59 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn59 #-}
happyOut59 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> t59
happyOut59 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut59 #-}
happyInTok :: (Token) -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59)
happyInTok x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyInTok #-}
happyOutTok :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59) -> (Token)
happyOutTok x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOutTok #-}

happyActOffsets :: HappyAddr
happyActOffsets = HappyA# "\x65\x04\x00\x00\xd3\xff\x51\x04\xde\x00\xd0\x01\x2e\x04\x28\x04\x2a\x04\x36\x04\x00\x00\x38\x04\x54\x04\x10\x04\xde\x00\x0a\x01\x00\x00\x44\x04\xea\x03\x16\x04\x17\x04\x0c\x04\x0e\x04\x00\x00\xde\x03\x96\x03\x07\x04\xd3\x03\x25\x04\x25\x07\x22\x04\xd0\x03\x06\x04\x8a\x03\x8a\x03\x8a\x03\x8a\x03\x8a\x03\x0b\x04\x09\x04\x05\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf8\x03\xcb\x00\x00\x00\x00\x00\xf3\x00\xbf\x03\xe6\x01\xbf\x03\xda\x01\xbf\x03\xf5\xff\xbf\x03\x7e\x03\xf9\xff\xf7\x03\xaf\x03\xba\x04\xec\x03\xf3\xff\xa8\x03\x00\x00\x82\x00\x00\x00\xa8\x03\xe9\x03\x00\x00\xbd\x03\xb1\x03\xa1\x03\x9d\x03\x95\x03\xce\x01\x0d\x00\x07\x00\x92\x03\x8b\x03\x00\x00\x00\x00\x44\x03\xde\x00\xa5\x00\x84\x03\x00\x00\x08\x04\x3e\x03\x3d\x03\x9b\x03\x3c\x03\x36\x03\x2c\x03\x13\x03\x51\x03\xf2\x02\xe5\x02\xde\x00\x2e\x03\xea\x02\x72\x03\x00\x04\xea\x02\x53\x01\xea\x02\xea\x02\x23\x00\x1f\x03\xe1\x02\x00\x00\x00\x00\xfd\x01\xe1\x02\x00\x00\xdf\x02\xd9\x02\x11\x03\x0f\x03\x25\x07\x00\x00\x72\x03\x08\x03\xde\x00\x2f\x03\xc3\x02\xfe\x02\xe3\x02\x00\x00\x7f\x02\x00\x00\x00\x00\xde\x00\xd5\x02\xc5\x02\xc1\x02\xb9\x02\xc1\x01\x79\x01\x00\x00\x00\x00\x2b\x00\xde\x00\xfc\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xee\x00\x2a\x03\x1e\x03\x12\x03\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x6d\x01\x06\x03\x06\x03\x79\x02\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x00\x00\x00\x00\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x06\x03\x00\x00\xbe\x02\xb2\x02\xa6\x02\x8d\x04\x00\x00\x00\x00\x00\x00\x61\x01\x8d\x04\x52\x01\x60\x04\x00\x00\x9a\x02\xb5\x02\x52\x02\x52\x02\x52\x02\xef\x00\xd3\x06\xef\x00\xef\x00\xef\x00\x52\x02\x46\x02\xb1\x02\x00\x00\x55\x02\xf7\x00\x25\x07\x00\x00\xaa\x06\x81\x06\x58\x06\x00\x00\x2f\x06\xac\x02\xa6\x00\x00\x00\x06\x06\x00\x00\x00\x00\xdd\x05\x3a\x02\x7d\x02\xb4\x05\x00\x00\x6f\x00\xfd\x03\x25\x07\x25\x07\x25\x07\xae\x07\xae\x07\xae\x07\xae\x07\x4e\x07\x77\x07\x25\x07\x25\x07\x25\x07\x25\x07\x25\x07\x25\x07\x25\x07\x25\x07\xef\x00\xef\x00\xef\x00\xae\x07\xae\x07\x00\x00\x25\x07\x8b\x05\x62\x05\xa1\x02\x00\x00\xc5\x07\xc5\x07\xef\x00\xef\x00\xef\x00\xef\x00\xc5\x07\xc5\x07\x00\x00\x25\x07\x0a\x00\xed\x03\x00\x00\x00\x00\x9c\x02\x22\x00\x97\x02\x09\x00\x39\x05\x91\x02\x85\x02\x10\x05\x77\x02\x6d\x02\x00\x00\xde\x00\xde\x00\xde\x00\x00\x00\xf1\xff\xeb\x01\xcf\x00\xde\x00\x5b\x02\x58\x02\x56\x02\x48\x02\x00\x00\x25\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x37\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2b\x02\x0d\x02\x00\x00\xf4\x01\xf1\x01\x00\x00\xe8\x01\x00\x00\xe5\x01\x00\x00\x00\x00\x00\x00\x00\x00\xaf\x01\x00\x00\xd7\x01\x3a\x02\x6d\x00\x00\x00\x5d\x00\x00\x00\x00\x00\x00\x00\x66\x00\x00\x00\x00\x00\x2e\x02\xd3\xff\xe7\x04\x1d\x00\x01\x00\x00\x00\xf8\xff\x00\x00\xd7\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyGotoOffsets :: HappyAddr
happyGotoOffsets = HappyA# "\xd3\x01\xd9\x01\x7d\x00\xd2\x01\x61\x02\xb1\x01\x15\x01\xef\x01\xa1\x01\x84\x01\x93\x01\x80\x01\x59\x01\x84\x00\x6c\x01\x90\x07\x4d\x01\x49\x01\x7d\x07\x42\x01\x2b\x01\x26\x01\x22\x01\x1f\x01\x0f\x05\x03\x05\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfe\x04\xf0\x04\xec\x04\xe8\x04\xe6\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x87\x03\x00\x00\xaf\x02\x00\x00\xe5\x00\x00\x00\x1b\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x25\x01\x39\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xdc\x04\x00\x00\x85\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x5f\x02\x00\x00\x00\x00\x00\x00\x51\x02\x00\x00\x00\x00\x45\x02\x00\x00\x77\x00\x00\x00\x00\x00\x1c\x01\x00\x00\x00\x00\x39\x02\x00\x00\x00\x00\x3e\x04\xc0\x01\x00\x00\x7e\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x1f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe7\x03\x00\x00\x30\x02\xf0\x01\xca\x01\x10\x01\x00\x00\x00\x00\x17\x01\x00\x00\x06\x01\xc7\x01\x00\x00\x00\x00\x00\x00\x00\x00\x73\x03\x07\x03\x00\x00\x0c\x01\x01\x01\x83\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x39\x04\xda\x04\xd5\x04\x3b\x02\xad\x04\xa8\x04\x7b\x04\x4e\x04\x42\x04\x29\x04\x27\x04\x1f\x04\x2f\x02\xdf\x03\xd4\x03\x00\x00\xd2\x03\xcc\x03\xc9\x03\xc6\x03\x93\x03\x8e\x03\x68\x03\x66\x03\x60\x03\x5d\x03\x27\x03\x22\x03\xfc\x02\xfa\x02\xf4\x02\x00\x00\x00\x00\xf1\x02\xbb\x02\xb6\x02\x9d\x02\x9b\x02\x90\x02\x8e\x02\x00\x00\x88\x02\xc2\x01\x84\x02\xe4\x00\x00\x00\x00\x00\x00\x00\x24\x02\xd9\x00\xab\x01\x00\x00\xd0\x00\xf2\x00\x00\x00\x81\x01\x6e\x01\x64\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x62\x01\x3b\x01\x00\x00\xdc\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xd3\x00\x00\x00\x00\x00\x00\x00\xc1\x00\x00\x00\xbf\x00\x00\x00\x00\x00\xcf\x01\xbd\x00\x9e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x71\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x63\x01\x51\x01\xfb\x00\x00\x00\x97\x00\xb0\x00\x65\x00\x16\x00\x5f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x59\x00\x00\x00\x58\x00\x56\x01\x00\x00\x08\x00\x00\x00\x00\x00\xfd\xff\xf4\xff\x39\x04\x00\x00\x00\x00\x74\x00\x1f\x00\x00\x00\x39\x04\x39\x04\x00\x00\x00\x00\x00\x00\xf7\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyDefActions :: HappyAddr
happyDefActions = HappyA# "\x00\x00\xe3\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc4\xff\x00\x00\x00\x00\xc0\xff\xba\xff\x94\xff\xa8\xff\x00\x00\x94\xff\x00\x00\x8e\xff\x00\x00\x00\x00\x82\xff\x00\x00\x00\x00\x00\x00\x00\x00\x57\xff\x00\x00\x81\xff\x00\x00\x58\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x65\xff\x64\xff\x63\xff\x62\xff\x61\xff\x60\xff\x5f\xff\x80\xff\x00\x00\x81\xff\x80\xff\x00\x00\x00\x00\x94\xff\x00\x00\x94\xff\x00\x00\x00\x00\x00\x00\x94\xff\x57\xff\x00\x00\x00\x00\x95\xff\x00\x00\x80\xff\x00\x00\xa8\xff\x94\xff\xb2\xff\x00\x00\x00\x00\xb8\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xbb\xff\xd8\xff\x00\x00\x00\x00\x00\x00\x00\x00\xde\xff\x00\x00\x00\x00\xc1\xff\x00\x00\x00\x00\xc0\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xce\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe2\xff\xe1\xff\x00\x00\x00\x00\xe4\xff\x00\x00\x00\x00\x00\x00\x00\x00\xca\xff\xcb\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xbc\xff\x00\x00\xbd\xff\xc4\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xd7\xff\xcf\xff\x00\x00\x00\x00\x00\x00\xaa\xff\xb3\xff\xb4\xff\xb5\xff\xb6\xff\xb7\xff\xb9\xff\xa9\xff\x94\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa6\xff\xa5\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x93\xff\x00\x00\x00\x00\x00\x00\x95\xff\x8f\xff\x90\xff\x8d\xff\x00\x00\x95\xff\x00\x00\x95\xff\x82\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x7d\xff\x00\x00\x7c\xff\x7e\xff\x7f\xff\x00\x00\x00\x00\x00\x00\xe3\xff\x81\xff\x80\xff\x56\xff\x68\xff\x00\x00\x00\x00\x00\x00\xa8\xff\x00\x00\x00\x00\x00\x00\x82\xff\x00\x00\x82\xff\x8c\xff\x00\x00\x94\xff\x8e\xff\x00\x00\x97\xff\x81\xff\x80\xff\x99\xff\x9b\xff\x9c\xff\x74\xff\x76\xff\x78\xff\x79\xff\x7b\xff\x7a\xff\xa0\xff\xa1\xff\x9a\xff\x9d\xff\x9e\xff\x9f\xff\xa2\xff\xa3\xff\x6b\xff\x69\xff\x6a\xff\x77\xff\x75\xff\x67\xff\x98\xff\x00\x00\x00\x00\x00\x00\x5b\xff\x6d\xff\x6e\xff\x6c\xff\x6f\xff\x70\xff\x71\xff\x72\xff\x73\xff\xa4\xff\x96\xff\x81\xff\x80\xff\xa7\xff\xab\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xdd\xff\x00\x00\x00\x00\x00\x00\xd9\xff\x00\x00\x00\x00\x00\x00\xba\xff\x00\x00\x00\x00\x00\x00\x00\x00\xc8\xff\xcc\xff\xcd\xff\xd2\xff\xd1\xff\xe0\xff\xdf\xff\xc9\xff\xc6\xff\xc5\xff\x00\x00\xc2\xff\xbe\xff\xbf\xff\xc7\xff\xdc\xff\xdb\xff\xda\xff\xac\xff\x00\x00\x00\x00\xaf\xff\x00\x00\x00\x00\xd0\xff\x00\x00\xd3\xff\x00\x00\xd5\xff\x59\xff\x5a\xff\x66\xff\x8e\xff\x91\xff\x00\x00\x94\xff\x00\x00\x82\xff\x00\x00\x86\xff\xa8\xff\xa8\xff\x94\xff\x5c\xff\x5d\xff\x00\x00\xe5\xff\x00\x00\x94\xff\x94\xff\x87\xff\x00\x00\x88\xff\x00\x00\x8a\xff\x92\xff\xd4\xff\xd6\xff\xb0\xff\xb1\xff\xad\xff\xae\xff\xc3\xff\x8b\xff\x89\xff\x5e\xff"#

happyCheck :: HappyAddr
happyCheck = HappyA# "\xff\xff\x10\x00\x01\x00\x02\x00\x0f\x00\x12\x00\x12\x00\x34\x00\x10\x00\x08\x00\x13\x00\x12\x00\x0b\x00\x3a\x00\x3b\x00\x12\x00\x0f\x00\x10\x00\x0b\x00\x09\x00\x0a\x00\x0c\x00\x0c\x00\x16\x00\x0b\x00\x0f\x00\x04\x00\x11\x00\x12\x00\x2a\x00\x01\x00\x02\x00\x0a\x00\x02\x00\x1a\x00\x2a\x00\x05\x00\x08\x00\x10\x00\x2f\x00\x0b\x00\x31\x00\x35\x00\x0c\x00\x0f\x00\x10\x00\x0c\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x16\x00\x33\x00\x12\x00\x35\x00\x0c\x00\x37\x00\x48\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x48\x00\x33\x00\x48\x00\x35\x00\x49\x00\x37\x00\x48\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x01\x00\x02\x00\x04\x00\x48\x00\x13\x00\x49\x00\x10\x00\x08\x00\x0a\x00\x17\x00\x0b\x00\x13\x00\x48\x00\x03\x00\x0f\x00\x10\x00\x06\x00\x09\x00\x0a\x00\x03\x00\x0c\x00\x16\x00\x10\x00\x0f\x00\x02\x00\x11\x00\x12\x00\x05\x00\x01\x00\x02\x00\x0e\x00\x0f\x00\x03\x00\x03\x00\x0c\x00\x08\x00\x06\x00\x2f\x00\x0b\x00\x31\x00\x1b\x00\x1c\x00\x0f\x00\x0e\x00\x0f\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x16\x00\x33\x00\x03\x00\x35\x00\x2f\x00\x37\x00\x31\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x2e\x00\x13\x00\x30\x00\x0e\x00\x04\x00\x33\x00\x10\x00\x35\x00\x49\x00\x37\x00\x0a\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x17\x00\x2f\x00\x0b\x00\x31\x00\x0d\x00\x1a\x00\x0b\x00\x1a\x00\x0d\x00\x01\x00\x13\x00\x14\x00\x15\x00\x12\x00\x17\x00\x18\x00\x19\x00\x12\x00\x41\x00\x42\x00\x43\x00\x0b\x00\x1a\x00\x0d\x00\x13\x00\x22\x00\x23\x00\x01\x00\x02\x00\x26\x00\x27\x00\x28\x00\x29\x00\x03\x00\x08\x00\x13\x00\x13\x00\x0b\x00\x0b\x00\x16\x00\x0d\x00\x0f\x00\x10\x00\x04\x00\x09\x00\x0a\x00\x13\x00\x0c\x00\x16\x00\x0a\x00\x0f\x00\x38\x00\x11\x00\x12\x00\x09\x00\x01\x00\x02\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x0b\x00\x08\x00\x07\x00\x49\x00\x0b\x00\x38\x00\x48\x00\x03\x00\x0f\x00\x03\x00\x06\x00\x2e\x00\x0d\x00\x30\x00\x03\x00\x16\x00\x33\x00\x2f\x00\x35\x00\x31\x00\x37\x00\x48\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x12\x00\x2e\x00\x1a\x00\x30\x00\x19\x00\x49\x00\x33\x00\x18\x00\x35\x00\x49\x00\x37\x00\x17\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x01\x00\x02\x00\x04\x00\x1b\x00\x1c\x00\x16\x00\x03\x00\x08\x00\x0a\x00\x13\x00\x0b\x00\x0b\x00\x12\x00\x0d\x00\x0f\x00\x01\x00\x02\x00\x11\x00\x12\x00\x0d\x00\x04\x00\x16\x00\x08\x00\x14\x00\x0a\x00\x0b\x00\x0a\x00\x01\x00\x02\x00\x04\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x0c\x00\x01\x00\x02\x00\x10\x00\x1b\x00\x1c\x00\x1b\x00\x1c\x00\x08\x00\x04\x00\x16\x00\x0b\x00\x0c\x00\x08\x00\x04\x00\x0a\x00\x1b\x00\x1c\x00\x38\x00\x0c\x00\x0a\x00\x0a\x00\x16\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x48\x00\x1b\x00\x1c\x00\x0b\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x09\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x05\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x01\x00\x02\x00\x04\x00\x03\x00\x1b\x00\x1c\x00\x08\x00\x08\x00\x0a\x00\x04\x00\x0b\x00\x0c\x00\x04\x00\x01\x00\x02\x00\x0a\x00\x03\x00\x00\x00\x0a\x00\x03\x00\x08\x00\x16\x00\x0a\x00\x0b\x00\x01\x00\x01\x00\x02\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x32\x00\x08\x00\x14\x00\x16\x00\x0b\x00\x0f\x00\x01\x00\x02\x00\x0f\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x0a\x00\x04\x00\x04\x00\x0f\x00\x0b\x00\x08\x00\x0d\x00\x0a\x00\x0a\x00\x0a\x00\x16\x00\x12\x00\x0a\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x3a\x00\x3b\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x0a\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x38\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x01\x00\x02\x00\x34\x00\x03\x00\x48\x00\x04\x00\x0a\x00\x08\x00\x3a\x00\x3b\x00\x0b\x00\x0a\x00\x01\x00\x02\x00\x04\x00\x03\x00\x1b\x00\x1c\x00\x0a\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x49\x00\x01\x00\x02\x00\x04\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x0a\x00\x01\x00\x02\x00\x04\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x09\x00\x0a\x00\x0a\x00\x0c\x00\x0a\x00\x04\x00\x0f\x00\x04\x00\x11\x00\x12\x00\x16\x00\x0a\x00\x0f\x00\x0a\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x0a\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x0c\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x0a\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x01\x00\x02\x00\x0c\x00\x49\x00\x1b\x00\x1c\x00\x0a\x00\x08\x00\x1b\x00\x1c\x00\x0b\x00\x0a\x00\x01\x00\x02\x00\x1b\x00\x1c\x00\x1b\x00\x1c\x00\x0c\x00\x08\x00\x32\x00\x16\x00\x0b\x00\x03\x00\x01\x00\x02\x00\x09\x00\x1b\x00\x1c\x00\x1b\x00\x1c\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x09\x00\x01\x00\x02\x00\x48\x00\x13\x00\x14\x00\x15\x00\x0c\x00\x08\x00\x48\x00\x16\x00\x0b\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x0b\x00\x0e\x00\x0d\x00\x1b\x00\x1c\x00\x0e\x00\x16\x00\x12\x00\x1b\x00\x1c\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x0e\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x0c\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x38\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x01\x00\x02\x00\x0b\x00\x03\x00\x48\x00\x1b\x00\x1c\x00\x08\x00\x1b\x00\x1c\x00\x0b\x00\x0a\x00\x01\x00\x02\x00\x1b\x00\x1c\x00\x1b\x00\x1c\x00\x0a\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x03\x00\x01\x00\x02\x00\x48\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x08\x00\x48\x00\x16\x00\x0b\x00\x49\x00\x01\x00\x02\x00\x48\x00\x49\x00\x14\x00\x15\x00\x12\x00\x08\x00\x49\x00\x16\x00\x0b\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x0b\x00\x49\x00\x0d\x00\x1b\x00\x1c\x00\x11\x00\x16\x00\x12\x00\x1b\x00\x1c\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x12\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x48\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x38\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x01\x00\x02\x00\x49\x00\x03\x00\x48\x00\x1b\x00\x1c\x00\x08\x00\x1b\x00\x1c\x00\x0b\x00\x48\x00\x01\x00\x02\x00\x1b\x00\x1c\x00\x1b\x00\x1c\x00\x49\x00\x08\x00\x49\x00\x16\x00\x0b\x00\x03\x00\x01\x00\x02\x00\x49\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x08\x00\x0f\x00\x16\x00\x0b\x00\x0b\x00\x01\x00\x02\x00\x48\x00\x49\x00\x14\x00\x15\x00\x0b\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x0b\x00\x0a\x00\x0d\x00\x1b\x00\x1c\x00\x0a\x00\x16\x00\x12\x00\x1b\x00\x1c\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x0a\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x0a\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x38\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x01\x00\x02\x00\x1b\x00\x1c\x00\x48\x00\x1b\x00\x1c\x00\x08\x00\x1b\x00\x1c\x00\x0b\x00\x03\x00\x01\x00\x02\x00\x1b\x00\x1c\x00\x1b\x00\x1c\x00\x49\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x09\x00\x0a\x00\x49\x00\x0c\x00\x1b\x00\x1c\x00\x0f\x00\x11\x00\x11\x00\x12\x00\x16\x00\x0a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x09\x00\x0a\x00\x49\x00\x0c\x00\x12\x00\x0b\x00\x0f\x00\x0d\x00\x11\x00\x12\x00\x0b\x00\x11\x00\x12\x00\x0b\x00\x0b\x00\x0d\x00\x0b\x00\x2a\x00\x12\x00\x49\x00\x12\x00\x48\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x2a\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x0b\x00\x12\x00\x0d\x00\x49\x00\x12\x00\x38\x00\x11\x00\x1b\x00\x1c\x00\x03\x00\x36\x00\x05\x00\x33\x00\x38\x00\x03\x00\x1b\x00\x1c\x00\x1b\x00\x1c\x00\x49\x00\x39\x00\x48\x00\x32\x00\x11\x00\x35\x00\x13\x00\x14\x00\x15\x00\x16\x00\x48\x00\x18\x00\x19\x00\x0f\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x48\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1b\x00\x1c\x00\x0b\x00\x38\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x1b\x00\x1c\x00\x0b\x00\x34\x00\x0d\x00\x38\x00\x0f\x00\x48\x00\x11\x00\x48\x00\x13\x00\x14\x00\x15\x00\x48\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x28\x00\x29\x00\xff\xff\x2b\x00\x2c\x00\x2d\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x1b\x00\x1c\x00\x0b\x00\x48\x00\x0d\x00\x36\x00\x0f\x00\xff\xff\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x28\x00\x29\x00\xff\xff\x2b\x00\x2c\x00\x2d\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x1b\x00\x1c\x00\x0b\x00\xff\xff\x0d\x00\x1b\x00\x1c\x00\xff\xff\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x28\x00\x29\x00\xff\xff\x2b\x00\x2c\x00\x2d\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x1b\x00\x1c\x00\x0b\x00\x0c\x00\x0d\x00\x1b\x00\x1c\x00\x1b\x00\x1c\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x1b\x00\x1c\x00\x1b\x00\x1c\x00\xff\xff\x03\x00\x1b\x00\x1c\x00\x22\x00\x23\x00\x1b\x00\x1c\x00\x26\x00\x27\x00\x28\x00\x29\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x1b\x00\x1c\x00\x0b\x00\x0c\x00\x0d\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x1b\x00\x1c\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\x26\x00\x27\x00\x28\x00\x29\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\x0c\x00\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\x26\x00\x27\x00\x28\x00\x29\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\x0c\x00\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\x26\x00\x27\x00\x28\x00\x29\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\x0e\x00\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\x26\x00\x27\x00\x28\x00\x29\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\x0f\x00\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\x26\x00\x27\x00\x28\x00\x29\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\x0a\x00\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\x26\x00\x27\x00\x28\x00\x29\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\x0f\x00\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\x26\x00\x27\x00\x28\x00\x29\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x09\x00\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\x26\x00\x27\x00\x28\x00\x29\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\x0c\x00\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\x26\x00\x27\x00\x28\x00\x29\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\x0c\x00\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\x26\x00\x27\x00\x28\x00\x29\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\x12\x00\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\x26\x00\x27\x00\x28\x00\x29\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\x0c\x00\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\x26\x00\x27\x00\x28\x00\x29\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\x0a\x00\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\x26\x00\x27\x00\x28\x00\x29\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\x26\x00\x27\x00\x28\x00\x29\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\xff\xff\xff\xff\xff\xff\x26\x00\x27\x00\x28\x00\x29\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x03\x00\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x14\x00\x15\x00\x03\x00\xff\xff\x05\x00\xff\xff\xff\xff\x1b\x00\x1c\x00\x1d\x00\x1e\x00\xff\xff\x26\x00\x27\x00\x28\x00\x29\x00\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\x16\x00\xff\xff\x18\x00\x19\x00\xff\xff\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\xff\xff\xff\xff\xff\xff\x17\x00\x18\x00\x19\x00\x03\x00\x04\x00\x05\x00\x06\x00\xff\xff\xff\xff\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\xff\xff\xff\xff\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff"#

happyTable :: HappyAddr
happyTable = HappyA# "\x00\x00\x45\x01\x22\x00\x23\x00\x45\x00\x9e\x00\x66\x01\x63\x00\x77\x01\x24\x00\x75\x01\xc6\x00\x25\x00\x51\x00\x52\x00\x67\x01\x45\x00\x85\xff\x91\x00\x52\xff\x52\xff\x50\x01\x52\xff\x26\x00\x92\x00\x52\xff\x54\x00\x52\xff\x52\xff\x9f\x00\x22\x00\x23\x00\x55\x00\x76\x00\x69\x01\xc7\x00\x72\x00\x24\x00\x41\x01\xd2\x00\x25\x00\xd3\x00\x3d\x00\x73\x00\x45\x00\x84\xff\x52\x01\x4e\x00\x85\xff\x4f\x00\x85\xff\x26\x00\x39\x00\x79\x00\x3d\x00\x22\x01\x50\x00\x82\x00\x37\x00\x51\x00\x52\x00\x53\x00\x54\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x43\x00\x85\xff\x4e\x00\x84\xff\x4f\x00\x84\xff\x6d\x00\x39\x00\x6d\x00\x3d\x00\x52\xff\x50\x00\x93\x00\x37\x00\x51\x00\x52\x00\x53\x00\x54\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x43\x00\x84\xff\x22\x00\x23\x00\x42\x01\x80\x00\x6c\x01\xff\xff\x69\x01\x24\x00\x55\x00\x6d\x01\x25\x00\x40\x01\x67\x00\x6a\x00\x45\x00\x83\xff\x4e\x01\x55\xff\x55\xff\x5b\x00\x55\xff\x26\x00\x6b\x01\x55\xff\x71\x00\x55\xff\x55\xff\x72\x00\x22\x00\x23\x00\x83\x00\x5d\x00\x5b\x00\x6a\x00\x73\x00\x24\x00\x8f\x00\xd2\x00\x25\x00\xd3\x00\x65\x01\x32\x00\x45\x00\x5c\x00\x5d\x00\x4e\x00\x83\xff\x4f\x00\x83\xff\x26\x00\x39\x00\x80\x00\x3d\x00\xd2\x00\x50\x00\xd3\x00\x37\x00\x51\x00\x52\x00\x53\x00\x54\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x43\x00\x83\xff\x4e\x00\x56\x01\x4f\x00\x89\x00\x43\x01\x39\x00\x5e\x01\x3d\x00\x55\xff\x50\x00\x55\x00\x37\x00\x51\x00\x52\x00\x53\x00\x54\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x43\x00\xff\xff\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x57\x01\xd2\x00\xa9\x00\xd3\x00\xaa\x00\x5a\x01\x58\x00\x5c\x01\x59\x00\x64\x01\xac\x00\xad\x00\xae\x00\x78\x00\xaf\x00\xb0\x00\xb1\x00\x60\x01\x8a\x00\x8b\x00\x8c\x00\x58\x00\xe9\x00\x59\x00\xed\x00\xba\x00\xbb\x00\x22\x00\x23\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x1c\x00\x24\x00\xf0\x00\xc9\x00\x25\x00\xa9\x00\xca\x00\xaa\x00\x45\x00\x1e\x01\x45\x01\x53\xff\x53\xff\xac\x00\x53\xff\x26\x00\x55\x00\x53\xff\x5a\x00\x53\xff\x53\xff\x20\x01\x22\x00\x23\x00\xe7\x00\x1e\x00\xe8\x00\x20\x00\x2e\x01\x24\x00\x22\x01\xff\xff\x25\x00\x5a\x00\x5b\x00\x6a\x00\x45\x00\x2f\x01\x6b\x00\x4e\x00\x32\x01\x4f\x00\x80\x00\x26\x00\x39\x00\xd2\x00\x3d\x00\xd3\x00\x50\x00\x5b\x00\x37\x00\x51\x00\x52\x00\x53\x00\x54\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x43\x00\x9c\x00\x4e\x00\x34\x00\x4f\x00\x35\x00\xff\xff\x39\x00\x37\x00\x3d\x00\x53\xff\x50\x00\x39\x00\x37\x00\x51\x00\x52\x00\x53\x00\x54\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x43\x00\x22\x00\x23\x00\x46\x01\x1d\x00\xdf\x00\x3b\x00\x3d\x00\x24\x00\x55\x00\x43\x00\x25\x00\x58\x00\x45\x00\x59\x00\xed\x00\x22\x00\x23\x00\x6a\x00\x78\x00\x5f\x00\x47\x01\x26\x00\x24\x00\x6b\x01\xf0\x00\x25\x00\x55\x00\x22\x00\x23\x00\x54\x00\x40\x00\x1e\x00\x41\x00\x20\x00\x24\x00\x55\x00\x26\x00\x25\x00\x11\x01\x22\x00\x23\x00\x56\x00\xe1\x00\x32\x00\xe3\x00\x32\x00\x24\x00\x67\x00\x26\x00\x25\x00\x26\x01\x79\x00\x1f\x01\x55\x00\xe4\x00\x32\x00\x5a\x00\x61\x00\x55\x00\x64\x00\x26\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x5b\x00\xe5\x00\x32\x00\x63\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x65\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x6d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x22\x00\x23\x00\x67\x00\x1c\x00\xeb\x00\x32\x00\x7a\x00\x24\x00\x55\x00\x2d\x01\x25\x00\x29\x01\x33\x01\x22\x00\x23\x00\x55\x00\x3d\x00\x75\x00\x55\x00\x6f\x00\x24\x00\x26\x00\x95\x00\x25\x00\x74\x00\x22\x00\x23\x00\x1d\x00\x1e\x00\xf2\x00\x20\x00\x3b\x00\x24\x00\x58\x01\x26\x00\x25\x00\x45\x00\x22\x00\x23\x00\x45\x00\x40\x00\x1e\x00\x41\x00\x20\x00\x24\x00\x6f\x01\x26\x00\x25\x00\x70\x01\x67\x00\x34\x01\xd1\x00\x58\x00\x68\x00\x59\x00\x55\x00\x55\x00\x71\x01\x26\x00\x79\x00\x72\x01\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x51\x00\x52\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x73\x01\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x43\x00\x5a\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x43\x00\x22\x00\x23\x00\x63\x00\x1c\x00\x5b\x00\x35\x01\x74\x01\x24\x00\x51\x00\x52\x00\x25\x00\x55\x00\x22\x00\x23\x00\x7e\x00\x1c\x00\xee\x00\x32\x00\x75\x01\x24\x00\x55\x00\x26\x00\x25\x00\xff\xff\x22\x00\x23\x00\x84\x00\x0e\x01\x1e\x00\x0f\x01\x20\x00\x24\x00\x55\x00\x26\x00\x25\x00\x3e\x01\x22\x00\x23\x00\x86\x00\x1d\x00\x1e\x00\x19\x01\x20\x00\x24\x00\x55\x00\x26\x00\x25\x00\x54\xff\x54\xff\x3f\x01\x54\xff\x40\x01\x8c\x00\x54\xff\x6e\x00\x54\xff\x54\xff\x26\x00\x55\x00\x45\x00\x55\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x49\x01\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x43\x00\x4a\x01\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\xe1\x00\x4c\x01\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x22\x00\x23\x00\x4d\x01\x54\xff\xf1\x00\x32\x00\x51\x01\x24\x00\x1d\x00\xf3\x00\x25\x00\x53\x01\x22\x00\x23\x00\xf5\x00\x32\x00\xf6\x00\x32\x00\x54\x01\x24\x00\x3b\x00\x26\x00\x25\x00\x3d\x00\x22\x00\x23\x00\x5f\x01\xf7\x00\x32\x00\xf8\x00\x32\x00\x24\x00\xdf\x00\x26\x00\x25\x00\xe7\x00\x22\x00\x23\x00\x0c\x01\xcb\x00\x3e\x00\xcc\x00\x2a\x01\x24\x00\x31\x01\x26\x00\x25\x00\xcd\x00\x1e\x00\x41\x00\x20\x00\x58\x00\x2b\x01\x59\x00\xf9\x00\x32\x00\x2c\x01\x26\x00\x78\x00\xfa\x00\x32\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x2d\x01\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x32\x01\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x5a\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\xf5\x00\x22\x00\x23\x00\x61\x00\x1c\x00\x5b\x00\xfb\x00\x32\x00\x24\x00\xfc\x00\x32\x00\x25\x00\x37\x01\x22\x00\x23\x00\xfd\x00\x32\x00\xfe\x00\x32\x00\x3a\x01\x24\x00\x3b\x01\x26\x00\x25\x00\x3d\x00\x22\x00\x23\x00\x3c\x01\x23\x01\x1e\x00\x24\x01\x20\x00\x24\x00\x3d\x01\x26\x00\x25\x00\xff\xff\x22\x00\x23\x00\x80\x00\xff\xff\x3e\x00\xc7\x00\x78\x00\x24\x00\xff\xff\x26\x00\x25\x00\xc8\x00\x1e\x00\x41\x00\x20\x00\x58\x00\xff\xff\x59\x00\xff\x00\x32\x00\x7e\x00\x26\x00\x79\x00\x00\x01\x32\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x86\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x83\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x5a\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x1d\x01\x22\x00\x23\x00\xff\xff\x1c\x00\x5b\x00\x01\x01\x32\x00\x24\x00\x02\x01\x32\x00\x25\x00\x5f\x00\x22\x00\x23\x00\x03\x01\x32\x00\x04\x01\x32\x00\xff\xff\x24\x00\xff\xff\x26\x00\x25\x00\x3d\x00\x22\x00\x23\x00\xff\xff\x26\x01\x1e\x00\x27\x01\x20\x00\x24\x00\x88\x00\x26\x00\x25\x00\x8e\x00\x22\x00\x23\x00\x82\x00\xff\xff\x3e\x00\xce\x00\x8f\x00\x24\x00\x96\x00\x26\x00\x25\x00\xcf\x00\x1e\x00\x41\x00\x20\x00\x58\x00\x97\x00\x59\x00\x05\x01\x32\x00\x98\x00\x26\x00\x78\x00\x06\x01\x32\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x99\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x43\x00\x9a\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x5a\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x22\x00\x23\x00\x07\x01\x32\x00\x5b\x00\x08\x01\x32\x00\x24\x00\x09\x01\x32\x00\x25\x00\x1c\x00\x22\x00\x23\x00\x0a\x01\x32\x00\x0c\x01\x32\x00\xff\xff\x24\x00\x9b\x00\x26\x00\x25\x00\xdf\xff\xdf\xff\xff\xff\xdf\xff\x0d\x01\x32\x00\xdf\xff\xa0\x00\xdf\xff\xdf\xff\x26\x00\xc5\x00\x37\x01\x1e\x00\x38\x01\x20\x00\xe0\xff\xe0\xff\xff\xff\xe0\xff\x9e\x00\x58\x00\xe0\xff\x59\x00\xe0\xff\xe0\xff\xd4\x00\x6a\x00\x79\x00\x58\x00\xd5\x00\x59\x00\xd6\x00\xdf\xff\xdc\x00\xff\xff\x79\x00\xde\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\xe0\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x43\x00\x58\x00\xdd\x00\x59\x00\xdf\xff\xc6\x00\x5a\x00\x6a\x00\x11\x01\x32\x00\x3d\x00\x1c\x00\x46\x00\x39\x00\x5a\x00\x1c\x00\x12\x01\x32\x00\x13\x01\x32\x00\xe0\xff\x37\x00\x5b\x00\x3b\x00\x9b\x00\x3d\x00\x48\x00\x3e\x00\x49\x00\x4a\x00\x5b\x00\x4b\x00\x4c\x00\x45\x00\x40\x00\x1e\x00\x41\x00\x20\x00\x5f\x00\x7b\x00\x1e\x00\x7c\x00\x20\x00\x14\x01\x32\x00\x61\x00\x5a\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x15\x01\x32\x00\xa9\x00\x63\x00\xaa\x00\x5a\x00\xeb\x00\x5b\x00\xab\x00\x67\x00\xac\x00\xad\x00\xae\x00\x6d\x00\xaf\x00\xb0\x00\xb1\x00\xb2\x00\xb3\x00\xb4\x00\xb5\x00\xb6\x00\xb7\x00\xb8\x00\xb9\x00\xba\x00\xbb\x00\xbc\x00\xbd\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x00\x00\xc2\x00\xc3\x00\xc4\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x16\x01\x32\x00\xa9\x00\x71\x00\xaa\x00\x1c\x00\x45\x00\x00\x00\xab\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xb2\x00\xb3\x00\xb4\x00\xb5\x00\xb6\x00\xb7\x00\xb8\x00\xb9\x00\xba\x00\xbb\x00\xbc\x00\xbd\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x00\x00\xc2\x00\xc3\x00\xc4\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x17\x01\x32\x00\xa9\x00\x00\x00\xaa\x00\x18\x01\x32\x00\x00\x00\xab\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xb2\x00\xb3\x00\xb4\x00\xb5\x00\xb6\x00\xb7\x00\xb8\x00\xb9\x00\xba\x00\xbb\x00\xbc\x00\xbd\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x00\x00\xc2\x00\xc3\x00\xc4\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x1a\x01\x32\x00\xa9\x00\x78\x01\xaa\x00\x1d\x00\x1b\x01\x93\x00\x32\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xd6\x00\x32\x00\xd7\x00\x32\x00\x00\x00\x1c\x00\xd8\x00\x32\x00\xba\x00\xbb\x00\xd9\x00\x32\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\xda\x00\x32\x00\xa9\x00\x4b\x01\xaa\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x31\x00\x32\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x00\x00\x00\x00\xa9\x00\x4e\x01\xaa\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x00\x00\x00\x00\xa9\x00\x55\x01\xaa\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x00\x00\x00\x00\xa9\x00\x00\x00\xaa\x00\x56\x01\x00\x00\x00\x00\x00\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x00\x00\x00\x00\xa9\x00\x00\x00\xaa\x00\x00\x00\x45\x00\x00\x00\x00\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x00\x00\x5a\x01\xa9\x00\x00\x00\xaa\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x00\x00\x00\x00\xa9\x00\x00\x00\xaa\x00\x00\x00\x5c\x01\x00\x00\x00\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x60\x01\x00\x00\xa9\x00\x00\x00\xaa\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x00\x00\x00\x00\xa9\x00\x62\x01\xaa\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x00\x00\x00\x00\xa9\x00\x63\x01\xaa\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x00\x00\x00\x00\xa9\x00\x00\x00\xaa\x00\x00\x00\x00\x00\x00\x00\x00\x00\x64\x01\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x00\x00\x00\x00\xa9\x00\xe3\x00\xaa\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x00\x00\x1f\x01\xa9\x00\x00\x00\xaa\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x00\x00\x00\x00\xa9\x00\x00\x00\xaa\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x00\x00\x00\x00\xa9\x00\x00\x00\xaa\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\x00\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x3d\x00\x00\x00\xa9\x00\x00\x00\xaa\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x3e\x00\x3f\x00\x3d\x00\x00\x00\x46\x00\x00\x00\x00\x00\x40\x00\x1e\x00\x41\x00\x20\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x47\x00\x00\x00\x48\x00\x3e\x00\x49\x00\x4a\x00\x00\x00\x4b\x00\x4c\x00\x00\x00\x40\x00\x1e\x00\x41\x00\x20\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xa8\x00\x00\x00\x00\x00\xa9\x00\x00\x00\xaa\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xac\x00\x00\x00\x00\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa9\x00\x00\x00\xaa\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xac\x00\x00\x00\x00\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyReduceArr = Happy_Data_Array.array (26, 173) [
	(26 , happyReduce_26),
	(27 , happyReduce_27),
	(28 , happyReduce_28),
	(29 , happyReduce_29),
	(30 , happyReduce_30),
	(31 , happyReduce_31),
	(32 , happyReduce_32),
	(33 , happyReduce_33),
	(34 , happyReduce_34),
	(35 , happyReduce_35),
	(36 , happyReduce_36),
	(37 , happyReduce_37),
	(38 , happyReduce_38),
	(39 , happyReduce_39),
	(40 , happyReduce_40),
	(41 , happyReduce_41),
	(42 , happyReduce_42),
	(43 , happyReduce_43),
	(44 , happyReduce_44),
	(45 , happyReduce_45),
	(46 , happyReduce_46),
	(47 , happyReduce_47),
	(48 , happyReduce_48),
	(49 , happyReduce_49),
	(50 , happyReduce_50),
	(51 , happyReduce_51),
	(52 , happyReduce_52),
	(53 , happyReduce_53),
	(54 , happyReduce_54),
	(55 , happyReduce_55),
	(56 , happyReduce_56),
	(57 , happyReduce_57),
	(58 , happyReduce_58),
	(59 , happyReduce_59),
	(60 , happyReduce_60),
	(61 , happyReduce_61),
	(62 , happyReduce_62),
	(63 , happyReduce_63),
	(64 , happyReduce_64),
	(65 , happyReduce_65),
	(66 , happyReduce_66),
	(67 , happyReduce_67),
	(68 , happyReduce_68),
	(69 , happyReduce_69),
	(70 , happyReduce_70),
	(71 , happyReduce_71),
	(72 , happyReduce_72),
	(73 , happyReduce_73),
	(74 , happyReduce_74),
	(75 , happyReduce_75),
	(76 , happyReduce_76),
	(77 , happyReduce_77),
	(78 , happyReduce_78),
	(79 , happyReduce_79),
	(80 , happyReduce_80),
	(81 , happyReduce_81),
	(82 , happyReduce_82),
	(83 , happyReduce_83),
	(84 , happyReduce_84),
	(85 , happyReduce_85),
	(86 , happyReduce_86),
	(87 , happyReduce_87),
	(88 , happyReduce_88),
	(89 , happyReduce_89),
	(90 , happyReduce_90),
	(91 , happyReduce_91),
	(92 , happyReduce_92),
	(93 , happyReduce_93),
	(94 , happyReduce_94),
	(95 , happyReduce_95),
	(96 , happyReduce_96),
	(97 , happyReduce_97),
	(98 , happyReduce_98),
	(99 , happyReduce_99),
	(100 , happyReduce_100),
	(101 , happyReduce_101),
	(102 , happyReduce_102),
	(103 , happyReduce_103),
	(104 , happyReduce_104),
	(105 , happyReduce_105),
	(106 , happyReduce_106),
	(107 , happyReduce_107),
	(108 , happyReduce_108),
	(109 , happyReduce_109),
	(110 , happyReduce_110),
	(111 , happyReduce_111),
	(112 , happyReduce_112),
	(113 , happyReduce_113),
	(114 , happyReduce_114),
	(115 , happyReduce_115),
	(116 , happyReduce_116),
	(117 , happyReduce_117),
	(118 , happyReduce_118),
	(119 , happyReduce_119),
	(120 , happyReduce_120),
	(121 , happyReduce_121),
	(122 , happyReduce_122),
	(123 , happyReduce_123),
	(124 , happyReduce_124),
	(125 , happyReduce_125),
	(126 , happyReduce_126),
	(127 , happyReduce_127),
	(128 , happyReduce_128),
	(129 , happyReduce_129),
	(130 , happyReduce_130),
	(131 , happyReduce_131),
	(132 , happyReduce_132),
	(133 , happyReduce_133),
	(134 , happyReduce_134),
	(135 , happyReduce_135),
	(136 , happyReduce_136),
	(137 , happyReduce_137),
	(138 , happyReduce_138),
	(139 , happyReduce_139),
	(140 , happyReduce_140),
	(141 , happyReduce_141),
	(142 , happyReduce_142),
	(143 , happyReduce_143),
	(144 , happyReduce_144),
	(145 , happyReduce_145),
	(146 , happyReduce_146),
	(147 , happyReduce_147),
	(148 , happyReduce_148),
	(149 , happyReduce_149),
	(150 , happyReduce_150),
	(151 , happyReduce_151),
	(152 , happyReduce_152),
	(153 , happyReduce_153),
	(154 , happyReduce_154),
	(155 , happyReduce_155),
	(156 , happyReduce_156),
	(157 , happyReduce_157),
	(158 , happyReduce_158),
	(159 , happyReduce_159),
	(160 , happyReduce_160),
	(161 , happyReduce_161),
	(162 , happyReduce_162),
	(163 , happyReduce_163),
	(164 , happyReduce_164),
	(165 , happyReduce_165),
	(166 , happyReduce_166),
	(167 , happyReduce_167),
	(168 , happyReduce_168),
	(169 , happyReduce_169),
	(170 , happyReduce_170),
	(171 , happyReduce_171),
	(172 , happyReduce_172),
	(173 , happyReduce_173)
	]

happy_n_terms = 74 :: Int
happy_n_nonterms = 31 :: Int

happyReduce_26 = happyReduce 4# 0# happyReduction_26
happyReduction_26 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut30 happy_x_4 of { happy_var_4 -> 
	happyIn29
		 (Program {package=(getIdent happy_var_2), topLevels=(reverse happy_var_4)}
	) `HappyStk` happyRest}}

happyReduce_27 = happySpecReduce_2  1# happyReduction_27
happyReduction_27 happy_x_2
	happy_x_1
	 =  case happyOut30 happy_x_1 of { happy_var_1 -> 
	case happyOut31 happy_x_2 of { happy_var_2 -> 
	happyIn30
		 (happy_var_2 : happy_var_1
	)}}

happyReduce_28 = happySpecReduce_0  1# happyReduction_28
happyReduction_28  =  happyIn30
		 ([]
	)

happyReduce_29 = happySpecReduce_1  2# happyReduction_29
happyReduction_29 happy_x_1
	 =  case happyOut34 happy_x_1 of { happy_var_1 -> 
	happyIn31
		 (TopDecl happy_var_1
	)}

happyReduce_30 = happySpecReduce_1  2# happyReduction_30
happyReduction_30 happy_x_1
	 =  case happyOut41 happy_x_1 of { happy_var_1 -> 
	happyIn31
		 (TopFuncDecl happy_var_1
	)}

happyReduce_31 = happySpecReduce_3  3# happyReduction_31
happyReduction_31 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	happyIn32
		 ((getIdent happy_var_3) : happy_var_1
	)}}

happyReduce_32 = happySpecReduce_3  3# happyReduction_32
happyReduction_32 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	happyIn32
		 ([getIdent happy_var_3, getIdent happy_var_1]
	)}}

happyReduce_33 = happySpecReduce_1  4# happyReduction_33
happyReduction_33 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn33
		 (((getOffset happy_var_1), Type $ getIdent happy_var_1)
	)}

happyReduce_34 = happySpecReduce_3  4# happyReduction_34
happyReduction_34 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut33 happy_x_2 of { happy_var_2 -> 
	happyIn33
		 (happy_var_2
	)}

happyReduce_35 = happyReduce 4# 4# happyReduction_35
happyReduction_35 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut33 happy_x_4 of { happy_var_4 -> 
	happyIn33
		 (((getOffset happy_var_1), ArrayType (Lit (IntLit (getOffset happy_var_2) Decimal $ getInnerString happy_var_2)) (snd happy_var_4))
	) `HappyStk` happyRest}}}

happyReduce_36 = happyReduce 4# 4# happyReduction_36
happyReduction_36 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut33 happy_x_4 of { happy_var_4 -> 
	happyIn33
		 (((getOffset happy_var_1), ArrayType (Lit (IntLit (getOffset happy_var_2) Octal $ getInnerString happy_var_2)) (snd happy_var_4))
	) `HappyStk` happyRest}}}

happyReduce_37 = happyReduce 4# 4# happyReduction_37
happyReduction_37 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut33 happy_x_4 of { happy_var_4 -> 
	happyIn33
		 (((getOffset happy_var_1), ArrayType (Lit (IntLit (getOffset happy_var_2) Hexadecimal $ getInnerString happy_var_2)) (snd happy_var_4))
	) `HappyStk` happyRest}}}

happyReduce_38 = happySpecReduce_3  4# happyReduction_38
happyReduction_38 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut33 happy_x_3 of { happy_var_3 -> 
	happyIn33
		 (((getOffset happy_var_1), SliceType (snd happy_var_3))
	)}}

happyReduce_39 = happySpecReduce_1  4# happyReduction_39
happyReduction_39 happy_x_1
	 =  case happyOut39 happy_x_1 of { happy_var_1 -> 
	happyIn33
		 (((fst happy_var_1), StructType (snd happy_var_1))
	)}

happyReduce_40 = happySpecReduce_2  5# happyReduction_40
happyReduction_40 happy_x_2
	happy_x_1
	 =  case happyOut35 happy_x_2 of { happy_var_2 -> 
	happyIn34
		 (VarDecl [happy_var_2]
	)}

happyReduce_41 = happyReduce 5# 5# happyReduction_41
happyReduction_41 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut36 happy_x_3 of { happy_var_3 -> 
	happyIn34
		 (VarDecl (reverse happy_var_3)
	) `HappyStk` happyRest}

happyReduce_42 = happyReduce 4# 5# happyReduction_42
happyReduction_42 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut33 happy_x_3 of { happy_var_3 -> 
	happyIn34
		 (TypeDef [TypeDef' (getIdent happy_var_2) happy_var_3]
	) `HappyStk` happyRest}}

happyReduce_43 = happyReduce 5# 5# happyReduction_43
happyReduction_43 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut38 happy_x_3 of { happy_var_3 -> 
	happyIn34
		 (TypeDef (reverse happy_var_3)
	) `HappyStk` happyRest}

happyReduce_44 = happyReduce 4# 5# happyReduction_44
happyReduction_44 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = happyIn34
		 (TypeDef ([])
	) `HappyStk` happyRest

happyReduce_45 = happySpecReduce_3  6# happyReduction_45
happyReduction_45 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	case happyOut37 happy_x_2 of { happy_var_2 -> 
	happyIn35
		 (VarDecl' ((nonEmpty . reverse) happy_var_1) happy_var_2
	)}}

happyReduce_46 = happySpecReduce_3  6# happyReduction_46
happyReduction_46 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut37 happy_x_2 of { happy_var_2 -> 
	happyIn35
		 (VarDecl' (nonEmpty [getIdent happy_var_1]) happy_var_2
	)}}

happyReduce_47 = happySpecReduce_2  7# happyReduction_47
happyReduction_47 happy_x_2
	happy_x_1
	 =  case happyOut36 happy_x_1 of { happy_var_1 -> 
	case happyOut35 happy_x_2 of { happy_var_2 -> 
	happyIn36
		 (happy_var_2 : happy_var_1
	)}}

happyReduce_48 = happySpecReduce_0  7# happyReduction_48
happyReduction_48  =  happyIn36
		 ([]
	)

happyReduce_49 = happySpecReduce_1  8# happyReduction_49
happyReduction_49 happy_x_1
	 =  case happyOut33 happy_x_1 of { happy_var_1 -> 
	happyIn37
		 (Left (happy_var_1, [])
	)}

happyReduce_50 = happySpecReduce_3  8# happyReduction_50
happyReduction_50 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut33 happy_x_1 of { happy_var_1 -> 
	case happyOut58 happy_x_3 of { happy_var_3 -> 
	happyIn37
		 (Left (happy_var_1, happy_var_3)
	)}}

happyReduce_51 = happySpecReduce_3  8# happyReduction_51
happyReduction_51 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut33 happy_x_1 of { happy_var_1 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn37
		 (Left (happy_var_1, [happy_var_3])
	)}}

happyReduce_52 = happySpecReduce_2  8# happyReduction_52
happyReduction_52 happy_x_2
	happy_x_1
	 =  case happyOut58 happy_x_2 of { happy_var_2 -> 
	happyIn37
		 (Right (nonEmpty happy_var_2)
	)}

happyReduce_53 = happySpecReduce_2  8# happyReduction_53
happyReduction_53 happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_2 of { happy_var_2 -> 
	happyIn37
		 (Right (nonEmpty [happy_var_2])
	)}

happyReduce_54 = happyReduce 4# 9# happyReduction_54
happyReduction_54 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut38 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut33 happy_x_3 of { happy_var_3 -> 
	happyIn38
		 ((TypeDef' (getIdent happy_var_2) happy_var_3) : happy_var_1
	) `HappyStk` happyRest}}}

happyReduce_55 = happySpecReduce_3  9# happyReduction_55
happyReduction_55 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut33 happy_x_2 of { happy_var_2 -> 
	happyIn38
		 ([TypeDef' (getIdent happy_var_1) happy_var_2]
	)}}

happyReduce_56 = happyReduce 4# 10# happyReduction_56
happyReduction_56 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut40 happy_x_3 of { happy_var_3 -> 
	happyIn39
		 (((getOffset happy_var_1), (reverse happy_var_3))
	) `HappyStk` happyRest}}

happyReduce_57 = happyReduce 4# 11# happyReduction_57
happyReduction_57 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut40 happy_x_1 of { happy_var_1 -> 
	case happyOut32 happy_x_2 of { happy_var_2 -> 
	case happyOut33 happy_x_3 of { happy_var_3 -> 
	happyIn40
		 ((FieldDecl ((nonEmpty . reverse) happy_var_2) happy_var_3) : happy_var_1
	) `HappyStk` happyRest}}}

happyReduce_58 = happyReduce 4# 11# happyReduction_58
happyReduction_58 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut40 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut33 happy_x_3 of { happy_var_3 -> 
	happyIn40
		 ((FieldDecl (nonEmpty [getIdent happy_var_2]) happy_var_3) : happy_var_1
	) `HappyStk` happyRest}}}

happyReduce_59 = happySpecReduce_0  11# happyReduction_59
happyReduction_59  =  happyIn40
		 ([]
	)

happyReduce_60 = happyReduce 5# 12# happyReduction_60
happyReduction_60 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut42 happy_x_3 of { happy_var_3 -> 
	case happyOut48 happy_x_4 of { happy_var_4 -> 
	happyIn41
		 (FuncDecl (getIdent happy_var_2) happy_var_3 happy_var_4
	) `HappyStk` happyRest}}}

happyReduce_61 = happyReduce 4# 13# happyReduction_61
happyReduction_61 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut43 happy_x_2 of { happy_var_2 -> 
	case happyOut45 happy_x_4 of { happy_var_4 -> 
	happyIn42
		 (Signature (Parameters happy_var_2) happy_var_4
	) `HappyStk` happyRest}}

happyReduce_62 = happySpecReduce_1  14# happyReduction_62
happyReduction_62 happy_x_1
	 =  case happyOut44 happy_x_1 of { happy_var_1 -> 
	happyIn43
		 (reverse happy_var_1
	)}

happyReduce_63 = happySpecReduce_0  14# happyReduction_63
happyReduction_63  =  happyIn43
		 ([]
	)

happyReduce_64 = happyReduce 4# 15# happyReduction_64
happyReduction_64 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut44 happy_x_1 of { happy_var_1 -> 
	case happyOut32 happy_x_3 of { happy_var_3 -> 
	case happyOut33 happy_x_4 of { happy_var_4 -> 
	happyIn44
		 ((ParameterDecl ((nonEmpty . reverse) happy_var_3) happy_var_4) : happy_var_1
	) `HappyStk` happyRest}}}

happyReduce_65 = happyReduce 4# 15# happyReduction_65
happyReduction_65 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut44 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	case happyOut33 happy_x_4 of { happy_var_4 -> 
	happyIn44
		 ((ParameterDecl (nonEmpty [getIdent happy_var_3]) happy_var_4) : happy_var_1
	) `HappyStk` happyRest}}}

happyReduce_66 = happySpecReduce_2  15# happyReduction_66
happyReduction_66 happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	case happyOut33 happy_x_2 of { happy_var_2 -> 
	happyIn44
		 ([(ParameterDecl ((nonEmpty . reverse) happy_var_1) happy_var_2)]
	)}}

happyReduce_67 = happySpecReduce_2  15# happyReduction_67
happyReduction_67 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut33 happy_x_2 of { happy_var_2 -> 
	happyIn44
		 ([(ParameterDecl (nonEmpty [getIdent happy_var_1]) happy_var_2)]
	)}}

happyReduce_68 = happySpecReduce_1  16# happyReduction_68
happyReduction_68 happy_x_1
	 =  case happyOut33 happy_x_1 of { happy_var_1 -> 
	happyIn45
		 (Just happy_var_1
	)}

happyReduce_69 = happySpecReduce_0  16# happyReduction_69
happyReduction_69  =  happyIn45
		 (Nothing
	)

happyReduce_70 = happySpecReduce_2  17# happyReduction_70
happyReduction_70 happy_x_2
	happy_x_1
	 =  case happyOut48 happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (happy_var_1
	)}

happyReduce_71 = happySpecReduce_1  17# happyReduction_71
happyReduction_71 happy_x_1
	 =  case happyOut50 happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (SimpleStmt happy_var_1
	)}

happyReduce_72 = happySpecReduce_2  17# happyReduction_72
happyReduction_72 happy_x_2
	happy_x_1
	 =  case happyOut51 happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (happy_var_1
	)}

happyReduce_73 = happySpecReduce_2  17# happyReduction_73
happyReduction_73 happy_x_2
	happy_x_1
	 =  case happyOut53 happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (happy_var_1
	)}

happyReduce_74 = happySpecReduce_2  17# happyReduction_74
happyReduction_74 happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (happy_var_1
	)}

happyReduce_75 = happySpecReduce_2  17# happyReduction_75
happyReduction_75 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (Break $ getOffset happy_var_1
	)}

happyReduce_76 = happySpecReduce_2  17# happyReduction_76
happyReduction_76 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (Continue $ getOffset happy_var_1
	)}

happyReduce_77 = happySpecReduce_1  17# happyReduction_77
happyReduction_77 happy_x_1
	 =  case happyOut34 happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (Declare happy_var_1
	)}

happyReduce_78 = happyReduce 5# 17# happyReduction_78
happyReduction_78 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut58 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Print happy_var_3
	) `HappyStk` happyRest}

happyReduce_79 = happyReduce 5# 17# happyReduction_79
happyReduction_79 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Print [happy_var_3]
	) `HappyStk` happyRest}

happyReduce_80 = happyReduce 4# 17# happyReduction_80
happyReduction_80 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = happyIn46
		 (Print []
	) `HappyStk` happyRest

happyReduce_81 = happyReduce 5# 17# happyReduction_81
happyReduction_81 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut58 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Println happy_var_3
	) `HappyStk` happyRest}

happyReduce_82 = happyReduce 5# 17# happyReduction_82
happyReduction_82 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Println [happy_var_3]
	) `HappyStk` happyRest}

happyReduce_83 = happyReduce 4# 17# happyReduction_83
happyReduction_83 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = happyIn46
		 (Println []
	) `HappyStk` happyRest

happyReduce_84 = happySpecReduce_3  17# happyReduction_84
happyReduction_84 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut56 happy_x_2 of { happy_var_2 -> 
	happyIn46
		 (Return (getOffset happy_var_1) $ Just happy_var_2
	)}}

happyReduce_85 = happySpecReduce_2  17# happyReduction_85
happyReduction_85 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (Return (getOffset happy_var_1) Nothing
	)}

happyReduce_86 = happySpecReduce_2  18# happyReduction_86
happyReduction_86 happy_x_2
	happy_x_1
	 =  case happyOut47 happy_x_1 of { happy_var_1 -> 
	case happyOut46 happy_x_2 of { happy_var_2 -> 
	happyIn47
		 (happy_var_2 : happy_var_1
	)}}

happyReduce_87 = happySpecReduce_0  18# happyReduction_87
happyReduction_87  =  happyIn47
		 ([]
	)

happyReduce_88 = happySpecReduce_3  19# happyReduction_88
happyReduction_88 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut47 happy_x_2 of { happy_var_2 -> 
	happyIn48
		 (BlockStmt (reverse happy_var_2)
	)}

happyReduce_89 = happySpecReduce_2  20# happyReduction_89
happyReduction_89 happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn49
		 (Increment (getOffset happy_var_2) happy_var_1
	)}}

happyReduce_90 = happySpecReduce_2  20# happyReduction_90
happyReduction_90 happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn49
		 (Decrement (getOffset happy_var_2) happy_var_1
	)}}

happyReduce_91 = happySpecReduce_3  20# happyReduction_91
happyReduction_91 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut58 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut58 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp Nothing) (nonEmpty happy_var_1) (nonEmpty happy_var_3)
	)}}}

happyReduce_92 = happySpecReduce_3  20# happyReduction_92
happyReduction_92 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just Add) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_93 = happySpecReduce_3  20# happyReduction_93
happyReduction_93 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just Subtract) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_94 = happySpecReduce_3  20# happyReduction_94
happyReduction_94 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just BitOr) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_95 = happySpecReduce_3  20# happyReduction_95
happyReduction_95 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just BitXor) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_96 = happySpecReduce_3  20# happyReduction_96
happyReduction_96 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just Multiply) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_97 = happySpecReduce_3  20# happyReduction_97
happyReduction_97 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just Divide) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_98 = happySpecReduce_3  20# happyReduction_98
happyReduction_98 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just Remainder) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_99 = happySpecReduce_3  20# happyReduction_99
happyReduction_99 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just ShiftL) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_100 = happySpecReduce_3  20# happyReduction_100
happyReduction_100 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just ShiftR) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_101 = happySpecReduce_3  20# happyReduction_101
happyReduction_101 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just BitAnd) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_102 = happySpecReduce_3  20# happyReduction_102
happyReduction_102 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just BitClear) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_103 = happySpecReduce_3  20# happyReduction_103
happyReduction_103 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp Nothing) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_104 = happySpecReduce_3  20# happyReduction_104
happyReduction_104 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	case happyOut58 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (ShortDeclare ((nonEmpty . reverse) happy_var_1) (nonEmpty happy_var_3)
	)}}

happyReduce_105 = happySpecReduce_3  20# happyReduction_105
happyReduction_105 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (ShortDeclare (nonEmpty [getIdent happy_var_1]) (nonEmpty [happy_var_3])
	)}}

happyReduce_106 = happySpecReduce_1  20# happyReduction_106
happyReduction_106 happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	happyIn49
		 (ExprStmt happy_var_1
	)}

happyReduce_107 = happySpecReduce_0  20# happyReduction_107
happyReduction_107  =  happyIn49
		 (EmptyStmt
	)

happyReduce_108 = happySpecReduce_2  21# happyReduction_108
happyReduction_108 happy_x_2
	happy_x_1
	 =  case happyOut49 happy_x_1 of { happy_var_1 -> 
	happyIn50
		 (happy_var_1
	)}

happyReduce_109 = happyReduce 5# 22# happyReduction_109
happyReduction_109 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut50 happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	case happyOut48 happy_x_4 of { happy_var_4 -> 
	case happyOut52 happy_x_5 of { happy_var_5 -> 
	happyIn51
		 (If (happy_var_2, happy_var_3) happy_var_4 happy_var_5
	) `HappyStk` happyRest}}}}

happyReduce_110 = happyReduce 4# 22# happyReduction_110
happyReduction_110 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut56 happy_x_2 of { happy_var_2 -> 
	case happyOut48 happy_x_3 of { happy_var_3 -> 
	case happyOut52 happy_x_4 of { happy_var_4 -> 
	happyIn51
		 (If (EmptyStmt, happy_var_2) happy_var_3 happy_var_4
	) `HappyStk` happyRest}}}

happyReduce_111 = happySpecReduce_2  23# happyReduction_111
happyReduction_111 happy_x_2
	happy_x_1
	 =  case happyOut51 happy_x_2 of { happy_var_2 -> 
	happyIn52
		 (happy_var_2
	)}

happyReduce_112 = happySpecReduce_2  23# happyReduction_112
happyReduction_112 happy_x_2
	happy_x_1
	 =  case happyOut48 happy_x_2 of { happy_var_2 -> 
	happyIn52
		 (happy_var_2
	)}

happyReduce_113 = happySpecReduce_0  23# happyReduction_113
happyReduction_113  =  happyIn52
		 (blank
	)

happyReduce_114 = happySpecReduce_2  24# happyReduction_114
happyReduction_114 happy_x_2
	happy_x_1
	 =  case happyOut48 happy_x_2 of { happy_var_2 -> 
	happyIn53
		 (For (ForClause EmptyStmt Nothing EmptyStmt) happy_var_2
	)}

happyReduce_115 = happySpecReduce_3  24# happyReduction_115
happyReduction_115 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_2 of { happy_var_2 -> 
	case happyOut48 happy_x_3 of { happy_var_3 -> 
	happyIn53
		 (For (ForClause EmptyStmt (Just happy_var_2) EmptyStmt) happy_var_3
	)}}

happyReduce_116 = happyReduce 6# 24# happyReduction_116
happyReduction_116 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut50 happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	case happyOut49 happy_x_5 of { happy_var_5 -> 
	case happyOut48 happy_x_6 of { happy_var_6 -> 
	happyIn53
		 (For (ForClause happy_var_2 (Just happy_var_3) happy_var_5) happy_var_6
	) `HappyStk` happyRest}}}}

happyReduce_117 = happyReduce 5# 24# happyReduction_117
happyReduction_117 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut50 happy_x_2 of { happy_var_2 -> 
	case happyOut49 happy_x_4 of { happy_var_4 -> 
	case happyOut48 happy_x_5 of { happy_var_5 -> 
	happyIn53
		 (For (ForClause happy_var_2 Nothing (happy_var_4)) happy_var_5
	) `HappyStk` happyRest}}}

happyReduce_118 = happyReduce 6# 25# happyReduction_118
happyReduction_118 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut50 happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	case happyOut55 happy_x_5 of { happy_var_5 -> 
	happyIn54
		 (Switch happy_var_2 (Just happy_var_3) (reverse happy_var_5)
	) `HappyStk` happyRest}}}

happyReduce_119 = happyReduce 5# 25# happyReduction_119
happyReduction_119 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut50 happy_x_2 of { happy_var_2 -> 
	case happyOut55 happy_x_4 of { happy_var_4 -> 
	happyIn54
		 (Switch happy_var_2 Nothing (reverse happy_var_4)
	) `HappyStk` happyRest}}

happyReduce_120 = happyReduce 5# 25# happyReduction_120
happyReduction_120 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut56 happy_x_2 of { happy_var_2 -> 
	case happyOut55 happy_x_4 of { happy_var_4 -> 
	happyIn54
		 (Switch EmptyStmt (Just happy_var_2) (reverse happy_var_4)
	) `HappyStk` happyRest}}

happyReduce_121 = happyReduce 4# 25# happyReduction_121
happyReduction_121 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut55 happy_x_3 of { happy_var_3 -> 
	happyIn54
		 (Switch EmptyStmt Nothing (reverse happy_var_3)
	) `HappyStk` happyRest}

happyReduce_122 = happyReduce 5# 26# happyReduction_122
happyReduction_122 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut55 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut58 happy_x_3 of { happy_var_3 -> 
	case happyOut47 happy_x_5 of { happy_var_5 -> 
	happyIn55
		 ((Case (getOffset happy_var_2) (nonEmpty happy_var_3) (BlockStmt $ reverse happy_var_5)) : happy_var_1
	) `HappyStk` happyRest}}}}

happyReduce_123 = happyReduce 5# 26# happyReduction_123
happyReduction_123 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut55 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	case happyOut47 happy_x_5 of { happy_var_5 -> 
	happyIn55
		 ((Case (getOffset happy_var_2) (nonEmpty [happy_var_3]) (BlockStmt $ reverse happy_var_5)) : happy_var_1
	) `HappyStk` happyRest}}}}

happyReduce_124 = happyReduce 4# 26# happyReduction_124
happyReduction_124 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut55 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut47 happy_x_4 of { happy_var_4 -> 
	happyIn55
		 ((Default (getOffset happy_var_2) $ BlockStmt (reverse happy_var_4)) : happy_var_1
	) `HappyStk` happyRest}}}

happyReduce_125 = happySpecReduce_0  26# happyReduction_125
happyReduction_125  =  happyIn55
		 ([]
	)

happyReduce_126 = happySpecReduce_1  27# happyReduction_126
happyReduction_126 happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	happyIn56
		 (happy_var_1
	)}

happyReduce_127 = happySpecReduce_1  27# happyReduction_127
happyReduction_127 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn56
		 (Var (getIdent happy_var_1)
	)}

happyReduce_128 = happySpecReduce_2  28# happyReduction_128
happyReduction_128 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut56 happy_x_2 of { happy_var_2 -> 
	happyIn57
		 (Unary (getOffset happy_var_1) Pos happy_var_2
	)}}

happyReduce_129 = happySpecReduce_2  28# happyReduction_129
happyReduction_129 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut56 happy_x_2 of { happy_var_2 -> 
	happyIn57
		 (Unary (getOffset happy_var_1) Neg happy_var_2
	)}}

happyReduce_130 = happySpecReduce_2  28# happyReduction_130
happyReduction_130 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut56 happy_x_2 of { happy_var_2 -> 
	happyIn57
		 (Unary (getOffset happy_var_1) Not happy_var_2
	)}}

happyReduce_131 = happySpecReduce_2  28# happyReduction_131
happyReduction_131 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut56 happy_x_2 of { happy_var_2 -> 
	happyIn57
		 (Unary (getOffset happy_var_1) BitComplement happy_var_2
	)}}

happyReduce_132 = happySpecReduce_3  28# happyReduction_132
happyReduction_132 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) Or happy_var_1 happy_var_3
	)}}}

happyReduce_133 = happySpecReduce_3  28# happyReduction_133
happyReduction_133 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) And happy_var_1 happy_var_3
	)}}}

happyReduce_134 = happySpecReduce_3  28# happyReduction_134
happyReduction_134 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) Data.EQ happy_var_1 happy_var_3
	)}}}

happyReduce_135 = happySpecReduce_3  28# happyReduction_135
happyReduction_135 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) NEQ happy_var_1 happy_var_3
	)}}}

happyReduce_136 = happySpecReduce_3  28# happyReduction_136
happyReduction_136 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) Data.LT happy_var_1 happy_var_3
	)}}}

happyReduce_137 = happySpecReduce_3  28# happyReduction_137
happyReduction_137 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) LEQ happy_var_1 happy_var_3
	)}}}

happyReduce_138 = happySpecReduce_3  28# happyReduction_138
happyReduction_138 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) Data.GT happy_var_1 happy_var_3
	)}}}

happyReduce_139 = happySpecReduce_3  28# happyReduction_139
happyReduction_139 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) GEQ happy_var_1 happy_var_3
	)}}}

happyReduce_140 = happySpecReduce_3  28# happyReduction_140
happyReduction_140 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) (Arithm Add) happy_var_1 happy_var_3
	)}}}

happyReduce_141 = happySpecReduce_3  28# happyReduction_141
happyReduction_141 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) (Arithm Subtract) happy_var_1 happy_var_3
	)}}}

happyReduce_142 = happySpecReduce_3  28# happyReduction_142
happyReduction_142 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) (Arithm Multiply) happy_var_1 happy_var_3
	)}}}

happyReduce_143 = happySpecReduce_3  28# happyReduction_143
happyReduction_143 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) (Arithm Divide) happy_var_1 happy_var_3
	)}}}

happyReduce_144 = happySpecReduce_3  28# happyReduction_144
happyReduction_144 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) (Arithm Remainder) happy_var_1 happy_var_3
	)}}}

happyReduce_145 = happySpecReduce_3  28# happyReduction_145
happyReduction_145 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) (Arithm BitOr) happy_var_1 happy_var_3
	)}}}

happyReduce_146 = happySpecReduce_3  28# happyReduction_146
happyReduction_146 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) (Arithm BitXor) happy_var_1 happy_var_3
	)}}}

happyReduce_147 = happySpecReduce_3  28# happyReduction_147
happyReduction_147 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) (Arithm BitAnd) happy_var_1 happy_var_3
	)}}}

happyReduce_148 = happySpecReduce_3  28# happyReduction_148
happyReduction_148 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) (Arithm BitClear) happy_var_1 happy_var_3
	)}}}

happyReduce_149 = happySpecReduce_3  28# happyReduction_149
happyReduction_149 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) (Arithm ShiftL) happy_var_1 happy_var_3
	)}}}

happyReduce_150 = happySpecReduce_3  28# happyReduction_150
happyReduction_150 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Binary (getOffset happy_var_2) (Arithm ShiftR) happy_var_1 happy_var_3
	)}}}

happyReduce_151 = happySpecReduce_3  28# happyReduction_151
happyReduction_151 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_2 of { happy_var_2 -> 
	happyIn57
		 (happy_var_2
	)}

happyReduce_152 = happySpecReduce_3  28# happyReduction_152
happyReduction_152 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Selector (getOffset happy_var_2) happy_var_1 $ getIdent happy_var_3
	)}}}

happyReduce_153 = happyReduce 4# 28# happyReduction_153
happyReduction_153 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Index (getOffset happy_var_2) happy_var_1 happy_var_3
	) `HappyStk` happyRest}}}

happyReduce_154 = happySpecReduce_1  28# happyReduction_154
happyReduction_154 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn57
		 (Lit (IntLit (getOffset happy_var_1) Decimal $ getInnerString happy_var_1)
	)}

happyReduce_155 = happySpecReduce_1  28# happyReduction_155
happyReduction_155 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn57
		 (Lit (IntLit (getOffset happy_var_1) Octal $ getInnerString happy_var_1)
	)}

happyReduce_156 = happySpecReduce_1  28# happyReduction_156
happyReduction_156 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn57
		 (Lit (IntLit (getOffset happy_var_1) Hexadecimal $ getInnerString happy_var_1)
	)}

happyReduce_157 = happySpecReduce_1  28# happyReduction_157
happyReduction_157 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn57
		 (Lit (FloatLit (getOffset happy_var_1) $ getInnerString happy_var_1)
	)}

happyReduce_158 = happySpecReduce_1  28# happyReduction_158
happyReduction_158 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn57
		 (Lit (RuneLit (getOffset happy_var_1) $ getInnerString happy_var_1)
	)}

happyReduce_159 = happySpecReduce_1  28# happyReduction_159
happyReduction_159 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn57
		 (Lit (StringLit (getOffset happy_var_1) Interpreted $ getInnerString happy_var_1)
	)}

happyReduce_160 = happySpecReduce_1  28# happyReduction_160
happyReduction_160 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn57
		 (Lit (StringLit (getOffset happy_var_1) Raw $ getInnerString happy_var_1)
	)}

happyReduce_161 = happyReduce 6# 28# happyReduction_161
happyReduction_161 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	case happyOut56 happy_x_5 of { happy_var_5 -> 
	happyIn57
		 (AppendExpr (getOffset happy_var_1) happy_var_3 happy_var_5
	) `HappyStk` happyRest}}}

happyReduce_162 = happyReduce 4# 28# happyReduction_162
happyReduction_162 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (LenExpr (getOffset happy_var_1) happy_var_3
	) `HappyStk` happyRest}}

happyReduce_163 = happyReduce 4# 28# happyReduction_163
happyReduction_163 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (CapExpr (getOffset happy_var_1) happy_var_3
	) `HappyStk` happyRest}}

happyReduce_164 = happySpecReduce_3  28# happyReduction_164
happyReduction_164 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn57
		 (Arguments (getOffset happy_var_2) happy_var_1 []
	)}}

happyReduce_165 = happyReduce 4# 28# happyReduction_165
happyReduction_165 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Arguments (getOffset happy_var_2) happy_var_1 [happy_var_3]
	) `HappyStk` happyRest}}}

happyReduce_166 = happyReduce 4# 28# happyReduction_166
happyReduction_166 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut58 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (Arguments (getOffset happy_var_2) happy_var_1 happy_var_3
	) `HappyStk` happyRest}}}

happyReduce_167 = happySpecReduce_1  29# happyReduction_167
happyReduction_167 happy_x_1
	 =  case happyOut59 happy_x_1 of { happy_var_1 -> 
	happyIn58
		 (reverse happy_var_1
	)}

happyReduce_168 = happySpecReduce_1  29# happyReduction_168
happyReduction_168 happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	happyIn58
		 (map Var (reverse happy_var_1)
	)}

happyReduce_169 = happySpecReduce_3  30# happyReduction_169
happyReduction_169 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut59 happy_x_1 of { happy_var_1 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn59
		 (happy_var_3 : happy_var_1
	)}}

happyReduce_170 = happySpecReduce_3  30# happyReduction_170
happyReduction_170 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn59
		 (happy_var_3 : (map Var happy_var_1)
	)}}

happyReduce_171 = happySpecReduce_3  30# happyReduction_171
happyReduction_171 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn59
		 ([happy_var_3, happy_var_1]
	)}}

happyReduce_172 = happySpecReduce_3  30# happyReduction_172
happyReduction_172 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	happyIn59
		 ([(Var . getIdent) happy_var_3, happy_var_1]
	)}}

happyReduce_173 = happySpecReduce_3  30# happyReduction_173
happyReduction_173 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn59
		 ([happy_var_3, (Var . getIdent) happy_var_1]
	)}}

happyNewToken action sts stk
	= lexer(\tk -> 
	let cont i = happyDoAction i tk action sts stk in
	case tk of {
	Token _ TEOF -> happyDoAction 73# tk action sts stk;
	Token _ TPlus -> cont 1#;
	Token _ TMinus -> cont 2#;
	Token _ TTimes -> cont 3#;
	Token _ TDiv -> cont 4#;
	Token _ TMod -> cont 5#;
	Token _ TLAnd -> cont 6#;
	Token _ TLOr -> cont 7#;
	Token _ TLXor -> cont 8#;
	Token _ TColon -> cont 9#;
	Token _ TSemicolon -> cont 10#;
	Token _ TLParen -> cont 11#;
	Token _ TRParen -> cont 12#;
	Token _ TLSquareB -> cont 13#;
	Token _ TRSquareB -> cont 14#;
	Token _ TLBrace -> cont 15#;
	Token _ TRBrace -> cont 16#;
	Token _ TAssn -> cont 17#;
	Token _ TComma -> cont 18#;
	Token _ TDot -> cont 19#;
	Token _ TGt -> cont 20#;
	Token _ TLt -> cont 21#;
	Token _ TNot -> cont 22#;
	Token _ TLeftS -> cont 23#;
	Token _ TRightS -> cont 24#;
	Token _ TLAndNot -> cont 25#;
	Token _ TIncA -> cont 26#;
	Token _ TDIncA -> cont 27#;
	Token _ TMultA -> cont 28#;
	Token _ TDivA -> cont 29#;
	Token _ TModA -> cont 30#;
	Token _ TLAndA -> cont 31#;
	Token _ TLOrA -> cont 32#;
	Token _ TLXorA -> cont 33#;
	Token _ TAnd -> cont 34#;
	Token _ TOr -> cont 35#;
	Token _ TInc -> cont 36#;
	Token _ TDInc -> cont 37#;
	Token _ TEq -> cont 38#;
	Token _ TNEq -> cont 39#;
	Token _ TLEq -> cont 40#;
	Token _ TGEq -> cont 41#;
	Token _ TDeclA -> cont 42#;
	Token _ TLeftSA -> cont 43#;
	Token _ TRightSA -> cont 44#;
	Token _ TLAndNotA -> cont 45#;
	Token _ TBreak -> cont 46#;
	Token _ TCase -> cont 47#;
	Token _ TContinue -> cont 48#;
	Token _ TDefault -> cont 49#;
	Token _ TElse -> cont 50#;
	Token _ TFor -> cont 51#;
	Token _ TFunc -> cont 52#;
	Token _ TIf -> cont 53#;
	Token _ TPackage -> cont 54#;
	Token _ TReturn -> cont 55#;
	Token _ TStruct -> cont 56#;
	Token _ TSwitch -> cont 57#;
	Token _ TType -> cont 58#;
	Token _ TVar -> cont 59#;
	Token _ TPrint -> cont 60#;
	Token _ TPrintln -> cont 61#;
	Token _ TAppend -> cont 62#;
	Token _ TLen -> cont 63#;
	Token _ TCap -> cont 64#;
	Token _ (TDecVal _) -> cont 65#;
	Token _ (TOctVal _) -> cont 66#;
	Token _ (THexVal _) -> cont 67#;
	Token _ (TFloatVal _) -> cont 68#;
	Token _ (TRuneVal _) -> cont 69#;
	Token _ (TStringVal _) -> cont 70#;
	Token _ (TRStringVal _) -> cont 71#;
	Token _ (TIdent _) -> cont 72#;
	_ -> happyError' tk
	})

happyError_ 73# tk = happyError' tk
happyError_ _ tk = happyError' tk

happyThen :: () => Alex a -> (a -> Alex b) -> Alex b
happyThen = (>>=)
happyReturn :: () => a -> Alex a
happyReturn = (return)
happyThen1 = happyThen
happyReturn1 :: () => a -> Alex a
happyReturn1 = happyReturn
happyError' :: () => (Token) -> Alex a
happyError' tk = parseError tk

hparse = happySomeParser where
  happySomeParser = happyThen (happyParse 0#) (\x -> happyReturn (happyOut29 x))

pTDecls = happySomeParser where
  happySomeParser = happyThen (happyParse 1#) (\x -> happyReturn (happyOut30 x))

pTDecl = happySomeParser where
  happySomeParser = happyThen (happyParse 2#) (\x -> happyReturn (happyOut31 x))

pId = happySomeParser where
  happySomeParser = happyThen (happyParse 3#) (\x -> happyReturn (happyOut32 x))

pT = happySomeParser where
  happySomeParser = happyThen (happyParse 4#) (\x -> happyReturn (happyOut33 x))

pDec = happySomeParser where
  happySomeParser = happyThen (happyParse 5#) (\x -> happyReturn (happyOut34 x))

pIDecl = happySomeParser where
  happySomeParser = happyThen (happyParse 6#) (\x -> happyReturn (happyOut35 x))

pDecB = happySomeParser where
  happySomeParser = happyThen (happyParse 7#) (\x -> happyReturn (happyOut37 x))

pTDef = happySomeParser where
  happySomeParser = happyThen (happyParse 8#) (\x -> happyReturn (happyOut38 x))

pStruct = happySomeParser where
  happySomeParser = happyThen (happyParse 9#) (\x -> happyReturn (happyOut39 x))

pFiDecls = happySomeParser where
  happySomeParser = happyThen (happyParse 10#) (\x -> happyReturn (happyOut40 x))

pFDec = happySomeParser where
  happySomeParser = happyThen (happyParse 11#) (\x -> happyReturn (happyOut41 x))

pSig = happySomeParser where
  happySomeParser = happyThen (happyParse 12#) (\x -> happyReturn (happyOut42 x))

pPar = happySomeParser where
  happySomeParser = happyThen (happyParse 13#) (\x -> happyReturn (happyOut43 x))

pRes = happySomeParser where
  happySomeParser = happyThen (happyParse 14#) (\x -> happyReturn (happyOut45 x))

pStmt = happySomeParser where
  happySomeParser = happyThen (happyParse 15#) (\x -> happyReturn (happyOut46 x))

pStmts = happySomeParser where
  happySomeParser = happyThen (happyParse 16#) (\x -> happyReturn (happyOut47 x))

pBStmt = happySomeParser where
  happySomeParser = happyThen (happyParse 17#) (\x -> happyReturn (happyOut48 x))

pSStmt = happySomeParser where
  happySomeParser = happyThen (happyParse 18#) (\x -> happyReturn (happyOut50 x))

pIf = happySomeParser where
  happySomeParser = happyThen (happyParse 19#) (\x -> happyReturn (happyOut51 x))

pElses = happySomeParser where
  happySomeParser = happyThen (happyParse 20#) (\x -> happyReturn (happyOut52 x))

pFor = happySomeParser where
  happySomeParser = happyThen (happyParse 21#) (\x -> happyReturn (happyOut53 x))

pSwS = happySomeParser where
  happySomeParser = happyThen (happyParse 22#) (\x -> happyReturn (happyOut54 x))

pSwB = happySomeParser where
  happySomeParser = happyThen (happyParse 23#) (\x -> happyReturn (happyOut55 x))

pE = happySomeParser where
  happySomeParser = happyThen (happyParse 24#) (\x -> happyReturn (happyOut56 x))

pEl = happySomeParser where
  happySomeParser = happyThen (happyParse 25#) (\x -> happyReturn (happyOut58 x))

happySeq = happyDontSeq

-- Helper functions
getOffset :: Token -> Offset
getOffset (Token (AlexPn o _ _) _) = Offset o

nonEmpty :: [a] -> NonEmpty a
nonEmpty l = NonEmpty.fromList l

getIdent :: Token -> Identifier
getIdent t@(Token _ (TIdent id)) = Identifier (getOffset t) id

getInnerString :: Token -> String
getInnerString t = case t of
  Token _ (TDecVal val) -> val
  Token _ (TOctVal val) -> val
  Token _ (THexVal val) -> val
  Token _ (TFloatVal val) -> val
  Token _ (TRuneVal val) -> val
  Token _ (TStringVal val) -> val
  Token _ (TRStringVal val) -> val
  Token _ (TIdent val) -> val

-- Main parse function
parse :: String -> Glc Program
parse s = either (Left . errODef s) Right (runAlex s hparse)

-- Parse function that takes in any parser
parsef :: Alex a -> String -> Glc a
parsef f s = either (Left . errODef s) Right (runAlex' s f)
-- runAlex' does not insert newline at end if needed

-- parsef but insert newline if needed at end just like main parse function
parsefNL :: Alex a -> String -> Glc a
parsefNL f s = either (Left . errODef s) Right (runAlex s f)

-- Extract posn only
ptokl t = case t of
          Token pos _ -> pos

newtype ParseError = ParseError InnerToken
  deriving (Show, Eq)

instance ErrorEntry ParseError where
  errorMessage (ParseError t) = "Parsing error: unexpected " ++ humanize t ++ "."

parseError :: Token -> Alex a
parseError (Token (AlexPn o l c) t) =
           alexError $ createError (Offset o) (ParseError t)
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 18 "<built-in>" #-}
{-# LINE 1 "/usr/local/Cellar/ghc/8.6.3/lib/ghc-8.6.3/include/ghcversion.h" #-}

{-# LINE 19 "<built-in>" #-}
{-# LINE 1 "/var/folders/hd/dnzz34rj7891bl2b3r_rmgsc0000gn/T/ghc99700_0/ghc_2.h" #-}

{-# LINE 20 "<built-in>" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 

{-# LINE 13 "templates/GenericTemplate.hs" #-}

-- Do not remove this comment. Required to fix CPP parsing when using GCC and a clang-compiled alex.
#if __GLASGOW_HASKELL__ > 706
#define LT(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.<# m)) :: Bool)
#define GTE(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.>=# m)) :: Bool)
#define EQ(n,m) ((Happy_GHC_Exts.tagToEnum# (n Happy_GHC_Exts.==# m)) :: Bool)
#else
#define LT(n,m) (n Happy_GHC_Exts.<# m)
#define GTE(n,m) (n Happy_GHC_Exts.>=# m)
#define EQ(n,m) (n Happy_GHC_Exts.==# m)
#endif

{-# LINE 46 "templates/GenericTemplate.hs" #-}

data Happy_IntList = HappyCons Happy_GHC_Exts.Int# Happy_IntList

{-# LINE 67 "templates/GenericTemplate.hs" #-}

{-# LINE 77 "templates/GenericTemplate.hs" #-}

infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is 0#, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept 0# tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
        (happyTcHack j (happyTcHack st)) (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action

happyDoAction i tk st
        = {- nothing -}
          

          case action of
                0#           -> {- nothing -}
                                     happyFail i tk st
                -1#          -> {- nothing -}
                                     happyAccept i tk st
                n | LT(n,(0# :: Happy_GHC_Exts.Int#)) -> {- nothing -}
                                                   
                                                   (happyReduceArr Happy_Data_Array.! rule) i tk st
                                                   where rule = (Happy_GHC_Exts.I# ((Happy_GHC_Exts.negateInt# ((n Happy_GHC_Exts.+# (1# :: Happy_GHC_Exts.Int#))))))
                n                 -> {- nothing -}
                                     

                                     happyShift new_state i tk st
                                     where new_state = (n Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#))
   where off    = indexShortOffAddr happyActOffsets st
         off_i  = (off Happy_GHC_Exts.+# i)
         check  = if GTE(off_i,(0# :: Happy_GHC_Exts.Int#))
                  then EQ(indexShortOffAddr happyCheck off_i, i)
                  else False
         action
          | check     = indexShortOffAddr happyTable off_i
          | otherwise = indexShortOffAddr happyDefActions st

indexShortOffAddr (HappyA# arr) off =
        Happy_GHC_Exts.narrow16Int# i
  where
        i = Happy_GHC_Exts.word2Int# (Happy_GHC_Exts.or# (Happy_GHC_Exts.uncheckedShiftL# high 8#) low)
        high = Happy_GHC_Exts.int2Word# (Happy_GHC_Exts.ord# (Happy_GHC_Exts.indexCharOffAddr# arr (off' Happy_GHC_Exts.+# 1#)))
        low  = Happy_GHC_Exts.int2Word# (Happy_GHC_Exts.ord# (Happy_GHC_Exts.indexCharOffAddr# arr off'))
        off' = off Happy_GHC_Exts.*# 2#

data HappyAddr = HappyA# Happy_GHC_Exts.Addr#

-----------------------------------------------------------------------------
-- HappyState data type (not arrays)

{-# LINE 170 "templates/GenericTemplate.hs" #-}

-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state 0# tk st sts stk@(x `HappyStk` _) =
     let i = (case Happy_GHC_Exts.unsafeCoerce# x of { (Happy_GHC_Exts.I# (i)) -> i }) in
--     trace "shifting the error token" $
     happyDoAction i tk new_state (HappyCons (st) (sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state (HappyCons (st) (sts)) ((happyInTok (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn 0# tk st sts stk
     = happyFail 0# tk st sts stk
happySpecReduce_0 nt fn j tk st@((action)) sts stk
     = happyGoto nt j tk st (HappyCons (st) (sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn 0# tk st sts stk
     = happyFail 0# tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@((HappyCons (st@(action)) (_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn 0# tk st sts stk
     = happyFail 0# tk st sts stk
happySpecReduce_2 nt fn j tk _ (HappyCons (_) (sts@((HappyCons (st@(action)) (_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn 0# tk st sts stk
     = happyFail 0# tk st sts stk
happySpecReduce_3 nt fn j tk _ (HappyCons (_) ((HappyCons (_) (sts@((HappyCons (st@(action)) (_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn 0# tk st sts stk
     = happyFail 0# tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) sts of
         sts1@((HappyCons (st1@(action)) (_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (happyGoto nt j tk st1 sts1 r)

happyMonadReduce k nt fn 0# tk st sts stk
     = happyFail 0# tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k (HappyCons (st) (sts)) of
        sts1@((HappyCons (st1@(action)) (_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> happyGoto nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn 0# tk st sts stk
     = happyFail 0# tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k (HappyCons (st) (sts)) of
        sts1@((HappyCons (st1@(action)) (_))) ->
         let drop_stk = happyDropStk k stk

             off = indexShortOffAddr happyGotoOffsets st1
             off_i = (off Happy_GHC_Exts.+# nt)
             new_state = indexShortOffAddr happyTable off_i

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop 0# l = l
happyDrop n (HappyCons (_) (t)) = happyDrop (n Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) t

happyDropStk 0# l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Happy_GHC_Exts.-# (1#::Happy_GHC_Exts.Int#)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction

happyGoto nt j tk st = 
   {- nothing -}
   happyDoAction j tk new_state
   where off = indexShortOffAddr happyGotoOffsets st
         off_i = (off Happy_GHC_Exts.+# nt)
         new_state = indexShortOffAddr happyTable off_i

-----------------------------------------------------------------------------
-- Error recovery (0# is the error token)

-- parse error if we are in recovery and we fail again
happyFail 0# tk old_st _ stk@(x `HappyStk` _) =
     let i = (case Happy_GHC_Exts.unsafeCoerce# x of { (Happy_GHC_Exts.I# (i)) -> i }) in
--      trace "failing" $ 
        happyError_ i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  0# tk old_st (HappyCons ((action)) (sts)) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        happyDoAction 0# tk action sts ((saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail  i tk (action) sts stk =
--      trace "entering error recovery" $
        happyDoAction 0# tk action sts ( (Happy_GHC_Exts.unsafeCoerce# (Happy_GHC_Exts.I# (i))) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions

happyTcHack :: Happy_GHC_Exts.Int# -> a -> a
happyTcHack x y = y
{-# INLINE happyTcHack #-}

-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.

{-# NOINLINE happyDoAction #-}
{-# NOINLINE happyTable #-}
{-# NOINLINE happyCheck #-}
{-# NOINLINE happyActOffsets #-}
{-# NOINLINE happyGotoOffsets #-}
{-# NOINLINE happyDefActions #-}

{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.

