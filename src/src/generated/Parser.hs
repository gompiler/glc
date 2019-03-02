{-# OPTIONS_GHC -w #-}
{-# OPTIONS -fglasgow-exts -cpp #-}
module Parser ( putExit
                , AlexPosn(..)
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
                , hparse
                , parse)
where
import Scanner
import Data
import ErrorBundle
import System.Exit
import System.IO

import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NonEmpty
import qualified Data.Array as Happy_Data_Array
import qualified GHC.Exts as Happy_GHC_Exts
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.5

newtype HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 = HappyAbsSyn HappyAny
#if __GLASGOW_HASKELL__ >= 607
type HappyAny = Happy_GHC_Exts.Any
#else
type HappyAny = forall a . a
#endif
happyIn26 :: t26 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn26 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn26 #-}
happyOut26 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t26
happyOut26 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut26 #-}
happyIn27 :: t27 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn27 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn27 #-}
happyOut27 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t27
happyOut27 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut27 #-}
happyIn28 :: t28 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn28 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn28 #-}
happyOut28 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t28
happyOut28 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut28 #-}
happyIn29 :: t29 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn29 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn29 #-}
happyOut29 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t29
happyOut29 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut29 #-}
happyIn30 :: t30 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn30 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn30 #-}
happyOut30 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t30
happyOut30 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut30 #-}
happyIn31 :: t31 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn31 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn31 #-}
happyOut31 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t31
happyOut31 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut31 #-}
happyIn32 :: t32 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn32 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn32 #-}
happyOut32 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t32
happyOut32 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut32 #-}
happyIn33 :: t33 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn33 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn33 #-}
happyOut33 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t33
happyOut33 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut33 #-}
happyIn34 :: t34 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn34 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn34 #-}
happyOut34 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t34
happyOut34 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut34 #-}
happyIn35 :: t35 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn35 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn35 #-}
happyOut35 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t35
happyOut35 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut35 #-}
happyIn36 :: t36 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn36 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn36 #-}
happyOut36 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t36
happyOut36 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut36 #-}
happyIn37 :: t37 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn37 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn37 #-}
happyOut37 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t37
happyOut37 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut37 #-}
happyIn38 :: t38 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn38 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn38 #-}
happyOut38 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t38
happyOut38 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut38 #-}
happyIn39 :: t39 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn39 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn39 #-}
happyOut39 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t39
happyOut39 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut39 #-}
happyIn40 :: t40 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn40 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn40 #-}
happyOut40 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t40
happyOut40 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut40 #-}
happyIn41 :: t41 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn41 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn41 #-}
happyOut41 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t41
happyOut41 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut41 #-}
happyIn42 :: t42 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn42 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn42 #-}
happyOut42 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t42
happyOut42 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut42 #-}
happyIn43 :: t43 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn43 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn43 #-}
happyOut43 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t43
happyOut43 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut43 #-}
happyIn44 :: t44 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn44 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn44 #-}
happyOut44 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t44
happyOut44 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut44 #-}
happyIn45 :: t45 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn45 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn45 #-}
happyOut45 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t45
happyOut45 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut45 #-}
happyIn46 :: t46 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn46 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn46 #-}
happyOut46 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t46
happyOut46 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut46 #-}
happyIn47 :: t47 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn47 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn47 #-}
happyOut47 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t47
happyOut47 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut47 #-}
happyIn48 :: t48 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn48 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn48 #-}
happyOut48 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t48
happyOut48 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut48 #-}
happyIn49 :: t49 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn49 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn49 #-}
happyOut49 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t49
happyOut49 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut49 #-}
happyIn50 :: t50 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn50 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn50 #-}
happyOut50 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t50
happyOut50 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut50 #-}
happyIn51 :: t51 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn51 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn51 #-}
happyOut51 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t51
happyOut51 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut51 #-}
happyIn52 :: t52 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn52 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn52 #-}
happyOut52 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t52
happyOut52 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut52 #-}
happyIn53 :: t53 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn53 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn53 #-}
happyOut53 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t53
happyOut53 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut53 #-}
happyIn54 :: t54 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn54 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn54 #-}
happyOut54 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t54
happyOut54 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut54 #-}
happyIn55 :: t55 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn55 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn55 #-}
happyOut55 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t55
happyOut55 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut55 #-}
happyIn56 :: t56 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn56 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn56 #-}
happyOut56 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t56
happyOut56 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut56 #-}
happyIn57 :: t57 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyIn57 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn57 #-}
happyOut57 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> t57
happyOut57 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut57 #-}
happyInTok :: (Token) -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57)
happyInTok x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyInTok #-}
happyOutTok :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57) -> (Token)
happyOutTok x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOutTok #-}


happyActOffsets :: HappyAddr
happyActOffsets = HappyA# "\xd1\x02\xc7\x02\xa9\x04\xdb\x00\x7e\x04\xd4\xff\x00\x00\xd6\x00\x5b\x01\xe0\x02\x06\x03\xc3\x02\xc2\x02\xdb\x00\x82\x00\x00\x00\x01\x03\x54\x04\xd6\x02\xd3\x02\xaf\x02\x00\x00\xce\x02\xc8\x02\x9f\x02\xf2\x02\xac\x01\x07\x00\xf2\x02\x54\x04\xf2\x02\xf5\xff\xf2\x02\x54\x04\xff\xff\xe6\x02\x00\x00\xef\x02\xb6\x05\xdf\x02\xd8\x02\xcd\x02\x29\x04\x29\x04\x29\x04\x29\x04\x29\x04\xe3\x02\xe2\x02\xe1\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf4\xff\xc9\x02\x00\x00\x01\x00\x00\x00\xc9\x02\xde\x02\x00\x00\xdd\x02\xdc\x02\xdb\x02\xd4\x02\xd2\x02\xbd\x02\x81\x01\x08\x00\x02\x00\xbf\x02\xba\x02\x00\x00\x00\x00\xc6\x02\xdb\x00\x57\x01\x8c\x02\x00\x00\xaf\x01\xc4\x02\xb1\x02\x84\x01\xda\x00\xc0\x02\x15\x00\xc0\x02\x6d\x02\xbe\x02\x67\x02\xac\x02\xbb\x02\xff\x03\xbb\x02\x29\x00\xbb\x02\x00\x00\x00\x00\xa3\x02\x9b\x08\xb4\x02\xa0\x02\x9d\x02\xe5\x05\x00\x00\x00\x00\x12\x00\x8e\x02\x49\x02\x47\x02\x45\x02\xd4\x03\xd4\x03\xd4\x03\xd4\x03\xd4\x03\xd4\x03\xd4\x03\xd4\x03\x2c\x01\xd4\x03\x44\x02\xd4\x03\xd4\x03\xd4\x03\xd4\x03\xd4\x03\xd4\x03\xd4\x03\xd4\x03\xd4\x03\xd4\x03\xd4\x03\xaa\x03\x7f\x03\x00\x00\x9b\x08\x00\x00\x55\x03\x8d\x02\x8b\x02\x8a\x02\x89\x02\x00\x00\x3d\x02\x00\x00\x00\x00\xd3\x07\xdb\x00\x85\x02\x02\x01\xd7\x00\x00\x00\x00\x00\x35\x02\xdb\x00\xa9\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x57\x00\x00\x00\x00\x00\x2a\x03\x2a\x03\x2a\x03\x2a\x03\x7b\x00\x7f\x07\x7b\x00\x7b\x00\x7b\x00\x2a\x03\x00\x03\xd5\x02\x00\x00\xab\x02\xab\x02\xab\x02\xab\x02\xab\x02\xab\x02\xab\x02\xab\x02\xab\x02\xab\x02\xab\x02\xab\x02\x00\x00\x80\x02\x56\x02\x5a\x05\x00\x00\x00\x00\x86\x02\x2c\x05\x2b\x02\x00\x00\x00\x00\x01\x02\xfe\x04\x7f\x02\x00\x00\x00\x00\x66\x07\x2c\x00\x3c\x07\x04\x02\x00\x00\xad\x00\x3b\x02\x12\x07\x00\x00\x9b\x08\x9b\x08\x9b\x08\x9b\x08\x9b\x08\x9b\x08\x9b\x08\x9b\x08\x9b\x08\x9b\x08\x9b\x08\x9b\x08\x82\x08\x69\x08\x00\x00\x50\x08\x00\x00\xe8\x06\xcf\x06\xb6\x06\x50\x08\x00\x00\x00\x00\x7d\x02\x0c\x00\xdb\x00\x09\x00\x9d\x06\x7a\x02\x7b\x02\x84\x06\x77\x02\x6b\x02\x00\x00\x00\x00\xdb\x00\x2d\x00\x5c\x01\x2f\x01\x00\x00\x00\x00\xdb\x00\x62\x02\x50\x08\x00\x00\x37\x08\x1e\x08\x05\x08\xec\x07\x06\x09\x06\x09\x06\x09\x06\x09\xb4\x08\xcd\x08\x7b\x00\x7b\x00\x7b\x00\x06\x09\x06\x09\x00\x00\x6b\x06\x41\x06\x68\x02\x00\x00\x56\x03\x56\x03\x7b\x00\x7b\x00\x7b\x00\x7b\x00\x56\x03\x56\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x66\x02\x00\x00\x00\x00\x00\x00\x05\x01\x00\x00\x16\x00\x00\x00\x00\x00\x65\x02\x64\x02\x00\x00\x63\x02\x61\x02\x00\x00\x60\x02\x53\x02\x4f\x02\xdb\x00\x00\x00\x00\x00\x00\x00\x01\x02\xfb\x01\x00\x00\x28\x06\x00\x00\x7c\x00\x00\x00\x00\x00\xd6\x01\xd4\xff\x39\x02\x88\x05\x2c\x00\x2c\x00\x00\x00\x0e\x00\x00\x00\x00\x00\xfe\x05\x24\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x02\xec\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfa\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyGotoOffsets :: HappyAddr
happyGotoOffsets = HappyA# "\x05\x02\xf0\x01\x4c\x02\x41\x01\x1a\x03\x90\x00\xea\x01\xdd\x01\xaf\x00\xbf\x01\x83\x01\x09\x01\x06\x01\x01\x01\xe7\x08\x9d\x01\x60\x01\x46\x02\x73\x01\x46\x01\x43\x01\x2e\x01\x33\x01\x00\x00\x00\x00\x00\x00\xc7\x01\x00\x00\x00\x00\x1b\x02\x00\x00\x19\x00\x00\x00\xf2\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4a\x02\x43\x02\x2e\x02\x2a\x02\x28\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x24\x01\xc3\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x26\x02\x00\x00\xf0\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x3c\x01\x23\x02\x00\x00\x00\x00\x3a\x01\x00\x00\x00\x00\x39\x01\x8f\x00\x00\x00\x64\x00\x00\x00\xe6\x00\x00\x00\x00\x00\x00\x00\x00\x00\x11\x03\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x21\x02\x1f\x02\x18\x02\x03\x02\x00\x02\xfe\x01\xfc\x01\xf8\x01\xf0\x02\xf6\x01\x00\x00\xee\x01\xd5\x01\xd3\x01\xd1\x01\xcd\x01\xcb\x01\xc3\x01\xab\x01\xa9\x01\xa7\x01\xa3\x01\xa1\x01\x9c\x01\x00\x00\x00\x00\x00\x00\xe7\x02\x0d\x01\x00\x00\x00\x00\x00\x00\x00\x00\x30\x01\x00\x00\xfd\x00\x00\x00\x35\x01\x00\x00\xc5\x02\xbc\x02\x00\x00\xe7\x00\xd5\x00\x31\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc3\x04\x00\x00\x00\x00\x99\x01\x96\x01\x82\x01\x80\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x7e\x01\x9b\x02\x7c\x01\x00\x00\x78\x01\x76\x01\x71\x01\x6b\x01\x69\x01\x59\x01\x55\x01\x53\x01\x4e\x01\x47\x01\x44\x01\x3f\x01\x00\x00\x92\x02\x2b\x01\xb4\x00\x00\x00\x00\x00\x00\x00\x00\x00\xbe\x00\xb0\x00\x00\x00\x15\x01\xaa\x00\x00\x00\xb3\x00\x00\x00\x00\x00\xc3\x04\x00\x00\x00\x00\x80\x00\xea\x00\x98\x00\x83\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x17\x01\xec\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x12\x01\x86\x00\x0f\x01\xed\x00\x00\x00\x00\x00\xe0\x00\x32\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xbc\x00\x00\x00\xba\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x3c\x00\x00\x00\x00\x00\x00\x00\xc4\x00\x6d\x00\x00\x00\x00\x00\x26\x00\x00\x00\x13\x00\x04\x00\x70\x02\x03\x00\x20\x00\x0a\x00\xc3\x04\xc3\x04\x00\x00\x00\x00\xf9\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyDefActions :: HappyAddr
happyDefActions = HappyA# "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe6\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc6\xff\xc0\xff\xab\xff\xad\xff\x00\x00\xab\xff\x00\x00\x92\xff\x00\x00\x87\xff\x00\x00\x00\x00\x00\x00\x00\x00\xab\xff\x00\x00\x00\x00\xab\xff\x00\x00\x00\x00\x00\x00\xab\xff\x5c\xff\x00\x00\x97\xff\x00\x00\x00\x00\x86\xff\x00\x00\x5d\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6a\xff\x69\xff\x68\xff\x67\xff\x66\xff\x65\xff\x64\xff\x85\xff\x00\x00\xad\xff\x00\x00\xb7\xff\x00\x00\x00\x00\xbe\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc1\xff\xdd\xff\x00\x00\x00\x00\x00\x00\x00\x00\xe1\xff\x00\x00\x00\x00\xc7\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc6\xff\x00\x00\x00\x00\xd4\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe5\xff\xe4\xff\x5c\xff\x00\x00\x00\x00\x85\xff\x00\x00\x00\x00\x86\xff\x85\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe7\xff\xd0\xff\xd1\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc2\xff\x00\x00\xc3\xff\xca\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xdc\xff\xd5\xff\x00\x00\x00\x00\x00\x00\xaf\xff\xb8\xff\xb9\xff\xba\xff\xbb\xff\xbc\xff\xbd\xff\xbf\xff\xae\xff\xab\xff\xaa\xff\xa9\xff\x00\x00\x00\x00\x00\x00\x00\x00\x82\xff\x00\x00\x81\xff\x83\xff\x84\xff\x00\x00\x00\x00\x00\x00\x99\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x98\xff\x00\x00\x00\x00\x00\x00\x93\xff\x94\xff\x00\x00\x00\x00\x00\x00\xad\xff\x91\xff\x00\x00\x00\x00\x00\x00\xe6\xff\x90\xff\x00\x00\x88\xff\x00\x00\x00\x00\x87\xff\x00\x00\x92\xff\x00\x00\x9b\xff\x9d\xff\x9f\xff\xa0\xff\xa4\xff\xa5\xff\x9e\xff\xa1\xff\xa2\xff\xa3\xff\xa6\xff\xa7\xff\x9c\xff\x59\xff\x58\xff\xa8\xff\x5b\xff\x6d\xff\x00\x00\x00\x00\x00\x00\x9a\xff\xac\xff\xb0\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\xff\xde\xff\x00\x00\x00\x00\x00\x00\x00\x00\xd8\xff\xd7\xff\xc0\xff\x00\x00\xd2\xff\xd3\xff\x5a\xff\xe3\xff\x57\xff\xe2\xff\x79\xff\x7b\xff\x7d\xff\x7e\xff\x80\xff\x7f\xff\x70\xff\x6e\xff\x6f\xff\x7c\xff\x7a\xff\x6c\xff\x00\x00\x00\x00\x00\x00\x60\xff\x72\xff\x73\xff\x71\xff\x74\xff\x75\xff\x76\xff\x77\xff\x78\xff\xe3\xff\xe2\xff\x5e\xff\x5f\xff\x6b\xff\x00\x00\xc8\xff\xc4\xff\xc5\xff\x00\x00\xcd\xff\x00\x00\xdf\xff\xb1\xff\x00\x00\x00\x00\xb4\xff\x00\x00\x00\x00\xd6\xff\x00\x00\x00\x00\x00\x00\x00\x00\xda\xff\x61\xff\x62\xff\x00\x00\x92\xff\x95\xff\x00\x00\x87\xff\x00\x00\xad\xff\xad\xff\xab\xff\xe8\xff\x00\x00\x00\x00\x89\xff\x8a\xff\x8b\xff\x00\x00\x87\xff\x96\xff\x00\x00\x00\x00\xd9\xff\xce\xff\xdb\xff\xb5\xff\xb6\xff\xb2\xff\xb3\xff\x00\x00\x00\x00\xc9\xff\xcc\xff\xcb\xff\xcf\xff\x63\xff\x00\x00\x8c\xff\x8e\xff\x8f\xff\x8d\xff"#

happyCheck :: HappyAddr
happyCheck = HappyA# "\xff\xff\x00\x00\x01\x00\x02\x00\x0f\x00\x02\x00\x12\x00\x00\x00\x05\x00\x08\x00\x10\x00\x0a\x00\x0b\x00\x0b\x00\x3a\x00\x0c\x00\x0f\x00\x12\x00\x00\x00\x0b\x00\x1b\x00\x0c\x00\x12\x00\x16\x00\x0c\x00\x25\x00\x26\x00\x47\x00\x48\x00\x13\x00\x10\x00\x2b\x00\x0b\x00\x0b\x00\x0d\x00\x0d\x00\x12\x00\x12\x00\x11\x00\x12\x00\x12\x00\x00\x00\x2b\x00\x31\x00\x13\x00\x01\x00\x02\x00\x35\x00\x17\x00\x30\x00\x3d\x00\x13\x00\x08\x00\x34\x00\x0a\x00\x0b\x00\x31\x00\x38\x00\x39\x00\x0f\x00\x35\x00\x10\x00\x3d\x00\x31\x00\x04\x00\x1b\x00\x16\x00\x35\x00\x43\x00\x13\x00\x0a\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x55\x00\x01\x00\x02\x00\x45\x00\x45\x00\x30\x00\x55\x00\x55\x00\x08\x00\x34\x00\x55\x00\x0b\x00\x3a\x00\x38\x00\x39\x00\x0f\x00\x10\x00\x04\x00\x3d\x00\x55\x00\x55\x00\x08\x00\x16\x00\x0a\x00\x43\x00\x47\x00\x48\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x55\x00\x01\x00\x02\x00\x18\x00\x0b\x00\x30\x00\x0d\x00\x03\x00\x08\x00\x34\x00\x10\x00\x0b\x00\x13\x00\x38\x00\x39\x00\x0f\x00\x02\x00\x04\x00\x3d\x00\x05\x00\x13\x00\x08\x00\x16\x00\x0a\x00\x43\x00\x1b\x00\x0c\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x31\x00\x01\x00\x02\x00\x18\x00\x35\x00\x30\x00\x04\x00\x01\x00\x08\x00\x34\x00\x08\x00\x0b\x00\x0a\x00\x38\x00\x39\x00\x0f\x00\x13\x00\x04\x00\x3d\x00\x04\x00\x03\x00\x12\x00\x16\x00\x0a\x00\x43\x00\x0a\x00\x13\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x09\x00\x08\x00\x1c\x00\x1d\x00\x0b\x00\x0c\x00\x04\x00\x0b\x00\x0b\x00\x0d\x00\x0d\x00\x03\x00\x0a\x00\x11\x00\x12\x00\x16\x00\x07\x00\x03\x00\x10\x00\x04\x00\x06\x00\x03\x00\x0e\x00\x0f\x00\x06\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x04\x00\x1c\x00\x1d\x00\x0b\x00\x03\x00\x08\x00\x0a\x00\x03\x00\x0b\x00\x0c\x00\x06\x00\x0b\x00\x10\x00\x0d\x00\x04\x00\x0e\x00\x0f\x00\x04\x00\x12\x00\x16\x00\x0a\x00\x0d\x00\x04\x00\x0a\x00\x47\x00\x48\x00\x45\x00\x45\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x55\x00\x55\x00\x1c\x00\x1d\x00\x03\x00\x08\x00\x04\x00\x12\x00\x0b\x00\x0c\x00\x04\x00\x0b\x00\x0a\x00\x0d\x00\x04\x00\x04\x00\x0a\x00\x04\x00\x12\x00\x16\x00\x0a\x00\x0a\x00\x04\x00\x0a\x00\x1c\x00\x1d\x00\x1b\x00\x45\x00\x0a\x00\x19\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x55\x00\x1c\x00\x1d\x00\x1a\x00\x18\x00\x08\x00\x1c\x00\x1d\x00\x0b\x00\x1c\x00\x1d\x00\x0e\x00\x0b\x00\x0b\x00\x0d\x00\x0d\x00\x1c\x00\x1d\x00\x11\x00\x16\x00\x12\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x13\x00\x45\x00\x1c\x00\x1d\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x55\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x08\x00\x17\x00\x0a\x00\x0b\x00\x1c\x00\x1d\x00\x0b\x00\x0d\x00\x0d\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x12\x00\x16\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x45\x00\x45\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x12\x00\x55\x00\x55\x00\x1c\x00\x1d\x00\x08\x00\x1c\x00\x1d\x00\x0b\x00\x1c\x00\x1d\x00\x0b\x00\x0f\x00\x0d\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x12\x00\x16\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x45\x00\x03\x00\x0c\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x55\x00\x13\x00\x14\x00\x15\x00\x16\x00\x08\x00\x1c\x00\x1d\x00\x0b\x00\x05\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x01\x00\x16\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x03\x00\x45\x00\x03\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x55\x00\x00\x00\x14\x00\x15\x00\x16\x00\x08\x00\x1c\x00\x1d\x00\x0b\x00\x09\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x0a\x00\x16\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x03\x00\x1c\x00\x1d\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x0a\x00\x14\x00\x15\x00\x16\x00\x37\x00\x08\x00\x1c\x00\x1d\x00\x0b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x16\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x0f\x00\x03\x00\x1c\x00\x1d\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x0a\x00\x14\x00\x15\x00\x16\x00\x0a\x00\x08\x00\x1c\x00\x1d\x00\x0b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x0a\x00\x0a\x00\x16\x00\x0a\x00\x0a\x00\x0a\x00\x0a\x00\x0f\x00\x37\x00\x03\x00\x0c\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x0c\x00\x14\x00\x0a\x00\x0c\x00\x0a\x00\x08\x00\x0a\x00\x55\x00\x0b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x0a\x00\x0c\x00\x55\x00\x0a\x00\x0a\x00\x03\x00\x16\x00\x0c\x00\x0b\x00\x55\x00\x55\x00\x0f\x00\x55\x00\x00\x00\x03\x00\x56\x00\x12\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x12\x00\x08\x00\x00\x00\x12\x00\x0b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x00\x00\x55\x00\x11\x00\x00\x00\x03\x00\x00\x00\x16\x00\x55\x00\x12\x00\x00\x00\x0b\x00\x00\x00\x0a\x00\x03\x00\x00\x00\x0b\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x0a\x00\x08\x00\x0a\x00\x12\x00\x0b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x0a\x00\x0a\x00\x0a\x00\x0a\x00\x11\x00\x03\x00\x16\x00\x0b\x00\x0b\x00\x0b\x00\x00\x00\x0a\x00\x12\x00\x00\x00\x03\x00\x55\x00\x46\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x39\x00\x08\x00\x41\x00\x37\x00\x0b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x0f\x00\x0b\x00\x41\x00\x3d\x00\x03\x00\xff\xff\x16\x00\x55\x00\x55\x00\xff\xff\x3a\x00\xff\xff\x55\x00\x03\x00\xff\xff\xff\xff\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\xff\xff\x08\x00\xff\xff\xff\xff\x0b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x16\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\xff\xff\x03\x00\x04\x00\x05\x00\x06\x00\x08\x00\xff\xff\xff\xff\x0b\x00\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\xff\xff\x16\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x16\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x16\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x16\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x16\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x16\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x16\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x16\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x16\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x03\x00\xff\xff\x05\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\xff\xff\x19\x00\x1a\x00\xff\xff\x1c\x00\x1d\x00\x1e\x00\x1f\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\x0a\x00\x0b\x00\xff\xff\x0d\x00\xff\xff\x0f\x00\xff\xff\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x2c\x00\x2d\x00\x2e\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\x0a\x00\x0b\x00\xff\xff\x0d\x00\xff\xff\x0f\x00\xff\xff\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x2c\x00\x2d\x00\x2e\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\x0a\x00\x0b\x00\xff\xff\x0d\x00\xff\xff\x0f\x00\xff\xff\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x2c\x00\x2d\x00\x2e\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\x0f\x00\xff\xff\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x2c\x00\x2d\x00\x2e\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\x0a\x00\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x2c\x00\x2d\x00\x2e\x00\x00\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\x0f\x00\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\x0e\x00\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x12\x00\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\x0f\x00\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x09\x00\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\x0a\x00\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\x0a\x00\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\x0e\x00\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\xff\xff\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\x03\x00\xff\xff\x05\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\xff\xff\x19\x00\x1a\x00\xff\xff\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\xff\xff\xff\xff\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff"#

happyTable :: HappyAddr
happyTable = HappyA# "\x00\x00\xff\xff\x2b\x00\x2c\x00\x3c\x00\x8b\x00\x8a\x00\xff\xff\x64\x00\x2d\x00\x6a\x01\xab\xff\x2e\x00\x9e\x00\x5e\x00\x65\x00\x3c\x00\x8b\x00\xff\xff\x9f\x00\x65\x01\x3d\x01\x4f\x01\x2f\x00\x3f\x01\xac\x00\xad\x00\x49\x00\x4a\x00\x67\x01\x67\x01\xae\x00\x50\x00\x50\x00\x51\x00\x51\x00\x73\x00\x50\x01\x61\x00\x72\x00\x72\x00\xff\xff\xc8\x00\xcf\x00\xca\x00\x2b\x00\x2c\x00\xd0\x00\xcb\x00\x45\x00\x22\x00\x68\x01\x2d\x00\x46\x00\xab\xff\x2e\x00\xcf\x00\x47\x00\x1b\x00\x3c\x00\xd0\x00\x33\x01\x22\x00\xcf\x00\x56\x01\x52\x01\x2f\x00\xd0\x00\x48\x00\x2d\x01\x4d\x00\x1e\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x5a\x00\x2b\x00\x2c\x00\x52\x00\x52\x00\x45\x00\xa0\x00\x5a\x00\x2d\x00\x46\x00\x40\x01\x2e\x00\x5e\x00\x47\x00\x1b\x00\x3c\x00\xf5\x00\x5e\x00\x22\x00\x53\x00\x53\x00\x91\x00\x2f\x00\x4d\x00\x48\x00\x49\x00\x4a\x00\x1e\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x34\x01\x2b\x00\x2c\x00\x54\x01\x7c\x00\x45\x00\x7d\x00\x31\x01\x2d\x00\x46\x00\x52\x01\x2e\x00\x7e\x00\x47\x00\x1b\x00\x3c\x00\x63\x00\x5e\x00\x22\x00\x64\x00\x44\x01\x92\x00\x2f\x00\x4d\x00\x48\x00\x48\x01\x65\x00\x1e\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\xcf\x00\x2b\x00\x2c\x00\x45\x01\xd0\x00\x45\x00\x5e\x00\x4c\x01\x2d\x00\x46\x00\x5f\x00\x2e\x00\x4d\x00\x47\x00\x1b\x00\x48\x01\xd5\x00\x5e\x01\x22\x00\x5f\x01\x66\x00\xd7\x00\x2f\x00\x4d\x00\x48\x00\x4d\x00\xdc\x00\x1e\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x2b\x00\x2c\x00\xd8\x00\x27\x00\xd9\x00\x29\x00\xf7\x00\x2d\x00\x55\x01\x6c\x00\x2e\x00\xfd\x00\x4c\x00\x50\x00\x50\x00\x51\x00\x51\x00\x53\x00\x4d\x00\x61\x00\x73\x00\x2f\x00\xf9\x00\x57\x00\x2e\x01\x2f\x01\x3b\x01\x57\x00\x90\x00\x55\x00\x9c\x00\x4d\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6e\x00\x2b\x00\x2c\x00\x4c\x00\x46\x01\x6c\x00\x03\x01\x53\x00\x2d\x00\x4d\x00\x57\x00\x2e\x00\x00\x01\x58\x00\x50\x00\x4e\x00\x51\x00\x30\x01\x54\x00\x55\x00\x34\x01\x73\x00\x2f\x00\x4d\x00\x09\x01\x3d\x01\x4d\x00\x49\x00\x4a\x00\x52\x00\x52\x00\x4d\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6a\x00\x2b\x00\x2c\x00\x53\x00\x53\x00\xd6\x00\x6c\x00\x04\x01\x2d\x00\xf6\x00\xaa\x00\x2e\x00\x20\x01\x01\x01\x50\x00\x4d\x00\x51\x00\x93\x00\x95\x00\x4d\x00\x99\x00\x72\x00\x2f\x00\x4d\x00\x4d\x00\x6a\x00\x4d\x00\xdd\x00\x6c\x00\x1b\x00\x52\x00\x4d\x00\x19\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6a\x00\x2b\x00\x2c\x00\x53\x00\xdf\x00\x6c\x00\x1c\x00\x1e\x00\x2d\x00\xe0\x00\x6c\x00\x2e\x00\xe1\x00\x6c\x00\x99\x00\x50\x00\x50\x00\x51\x00\x51\x00\xe2\x00\x6c\x00\x61\x00\x2f\x00\x73\x00\xe3\x00\x6c\x00\xe4\x00\x6c\x00\x3a\x00\x52\x00\xe5\x00\x6c\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6a\x00\x2b\x00\x2c\x00\x53\x00\xe6\x00\x6c\x00\xe7\x00\x6c\x00\x2d\x00\x20\x00\xa2\x00\x2e\x00\xe8\x00\x6c\x00\x50\x00\x5a\x00\x51\x00\xe9\x00\x6c\x00\xea\x00\x6c\x00\x72\x00\x2f\x00\x67\x00\xeb\x00\xee\x00\x6c\x00\xf0\x00\x6c\x00\xf1\x00\x6c\x00\x52\x00\x52\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6e\x00\x2b\x00\x2c\x00\x3c\x00\x53\x00\x53\x00\xf2\x00\x6c\x00\x2d\x00\xf3\x00\x6c\x00\x2e\x00\x67\x00\x0c\x01\x50\x00\x3c\x00\x51\x00\x67\x00\x0e\x01\x10\x01\x6c\x00\x73\x00\x2f\x00\x11\x01\x6c\x00\x12\x01\x6c\x00\x13\x01\x6c\x00\x52\x00\x22\x00\x5c\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6e\x00\x2b\x00\x2c\x00\x53\x00\xd0\x00\x23\x00\x24\x00\xd1\x00\x2d\x00\x14\x01\x6c\x00\x2e\x00\x61\x00\xd2\x00\x27\x00\x28\x00\x29\x00\x15\x01\x6c\x00\x16\x01\x6c\x00\x62\x00\x2f\x00\x17\x01\x6c\x00\x18\x01\x6c\x00\x19\x01\x6c\x00\x6e\x00\x52\x00\x22\x00\x62\x01\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x2b\x00\x2c\x00\x53\x00\x70\x00\x23\x00\x24\x00\xc8\x00\x2d\x00\x1a\x01\x6c\x00\x2e\x00\x4a\x01\xc9\x00\x27\x00\x28\x00\x29\x00\x1c\x01\x6c\x00\x20\x01\x6c\x00\x63\x01\x2f\x00\x21\x01\x6c\x00\x22\x01\x6c\x00\x23\x01\x6c\x00\x22\x00\x24\x01\x6c\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x2b\x00\x2c\x00\x64\x01\x23\x00\x24\x00\xcc\x00\x20\x00\x2d\x00\x25\x01\x6c\x00\x2e\x00\xcd\x00\x27\x00\x28\x00\x29\x00\x26\x01\x6c\x00\x27\x01\x6c\x00\x97\x00\x6c\x00\x2f\x00\xa0\x00\x6c\x00\xb1\x00\x6c\x00\xb2\x00\x6c\x00\x3c\x00\x22\x00\xb3\x00\x6c\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6e\x00\x2b\x00\x2c\x00\x58\x01\x23\x00\x24\x00\x25\x00\x59\x01\x2d\x00\xb4\x00\x6c\x00\x2e\x00\x26\x00\x27\x00\x28\x00\x29\x00\xb5\x00\x6c\x00\x6b\x00\x6c\x00\x5a\x01\x5b\x01\x2f\x00\x5c\x01\x5d\x01\x5e\x01\x61\x01\x3c\x00\x20\x00\x22\x00\x2b\x01\x36\x01\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6a\x00\x2b\x00\x2c\x00\x37\x01\x4d\x01\x39\x01\x3a\x01\x41\x01\x2d\x00\xd5\x00\xf9\x00\x2e\x00\x4e\x01\x27\x00\x28\x00\x29\x00\xdc\x00\x01\x01\x06\x01\x07\x01\x08\x01\x66\x00\x2f\x00\x09\x01\x5c\x00\x1c\x01\x29\x01\x97\x00\x2a\x01\xff\xff\x66\x00\xff\xff\x72\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6e\x00\x2b\x00\x2c\x00\x67\x00\x27\x00\xde\x00\x29\x00\x8a\x00\x2d\x00\xff\xff\x8b\x00\x2e\x00\x67\x00\x27\x00\xed\x00\x29\x00\xff\xff\x90\x00\x8f\x00\xff\xff\x66\x00\xff\xff\x2f\x00\x57\x00\x95\x00\xff\xff\x9b\x00\xff\xff\xa3\x00\x66\x00\xff\xff\x9c\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6a\x00\x2b\x00\x2c\x00\xfa\x00\x27\x00\xfb\x00\x29\x00\xa4\x00\x2d\x00\xa5\x00\xb7\x00\x2e\x00\xfd\x00\x27\x00\xfe\x00\x29\x00\xa6\x00\xa7\x00\xa8\x00\xa9\x00\xb8\x00\x66\x00\x2f\x00\xaf\x00\xb0\x00\xb1\x00\xff\xff\xc7\x00\xb9\x00\xff\xff\x66\x00\xd4\x00\x1e\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6e\x00\x2b\x00\x2c\x00\x0a\x01\x27\x00\x0b\x01\x29\x00\x1b\x00\x2d\x00\x19\x00\x20\x00\x2e\x00\x1d\x01\x27\x00\x1e\x01\x29\x00\x3c\x00\x5c\x00\x19\x00\x22\x00\x66\x00\x00\x00\x2f\x00\x57\x00\x5a\x00\x00\x00\x5e\x00\x00\x00\x70\x00\x66\x00\x00\x00\x00\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\xed\x00\x2b\x00\x2c\x00\x8c\x00\x27\x00\x8d\x00\x29\x00\x00\x00\x2d\x00\x00\x00\x00\x00\x2e\x00\x67\x00\x27\x00\x68\x00\x29\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6a\x00\x2b\x00\x2c\x00\x00\x00\x76\x00\x77\x00\x78\x00\x79\x00\x2d\x00\x00\x00\x00\x00\x2e\x00\x7c\x00\x00\x00\x7d\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x7e\x00\x00\x00\x2f\x00\x00\x00\x81\x00\x82\x00\x83\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6e\x00\x2b\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2d\x00\x00\x00\x00\x00\x2e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6a\x00\x2b\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2d\x00\x00\x00\x00\x00\x2e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x0e\x01\x2b\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2d\x00\x00\x00\x00\x00\x2e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x10\x01\x2b\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2d\x00\x00\x00\x00\x00\x2e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6e\x00\x2b\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2d\x00\x00\x00\x00\x00\x2e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6a\x00\x2b\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2d\x00\x00\x00\x00\x00\x2e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6e\x00\x2b\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2d\x00\x00\x00\x00\x00\x2e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x2b\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2d\x00\x00\x00\x00\x00\x2e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x22\x00\x00\x00\x3d\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6a\x00\xa9\x00\x00\x00\x3f\x00\x23\x00\x24\x00\x40\x00\x41\x00\x00\x00\x42\x00\x43\x00\x00\x00\x26\x00\x27\x00\x28\x00\x29\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x6e\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x00\x00\xba\x00\x7c\x00\x00\x00\x7d\x00\x00\x00\x3c\x00\x00\x00\xbb\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\xbc\x00\xbd\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xc2\x00\xc3\x00\x84\x00\x85\x00\x00\x00\x00\x00\x00\x00\x86\x00\x87\x00\x88\x00\x89\x00\x00\x00\xc4\x00\xc5\x00\xc6\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x00\x00\xba\x00\x7c\x00\x00\x00\x7d\x00\x00\x00\xdb\x00\x00\x00\xbb\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\xbc\x00\xbd\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xc2\x00\xc3\x00\x84\x00\x85\x00\x00\x00\x00\x00\x00\x00\x86\x00\x87\x00\x88\x00\x89\x00\x00\x00\xc4\x00\xc5\x00\xc6\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x00\x00\xba\x00\x7c\x00\x00\x00\x7d\x00\x00\x00\x3c\x00\x00\x00\xbb\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\xbc\x00\xbd\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xc2\x00\xc3\x00\x84\x00\x85\x00\x00\x00\x00\x00\x00\x00\x86\x00\x87\x00\x88\x00\x89\x00\x00\x00\xc4\x00\xc5\x00\xc6\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x00\x00\x00\x00\x7c\x00\x00\x00\x7d\x00\x00\x00\x3c\x00\x00\x00\xbb\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\xbc\x00\xbd\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xc2\x00\xc3\x00\x84\x00\x85\x00\x00\x00\x00\x00\x00\x00\x86\x00\x87\x00\x88\x00\x89\x00\x00\x00\xc4\x00\xc5\x00\xc6\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x00\x00\xba\x00\x7c\x00\x00\x00\x7d\x00\x00\x00\x00\x00\x00\x00\xbb\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\xbc\x00\xbd\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xc2\x00\xc3\x00\x84\x00\x85\x00\x00\x00\x00\x00\x00\x00\x86\x00\x87\x00\x88\x00\x89\x00\x00\x00\xc4\x00\xc5\x00\xc6\x00\xff\xff\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x00\x00\x00\x00\x7c\x00\x00\x00\x7d\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x84\x00\x85\x00\x7c\x00\x65\x01\x7d\x00\x86\x00\x87\x00\x88\x00\x89\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x84\x00\x85\x00\x00\x00\x00\x00\x00\x00\x86\x00\x87\x00\x88\x00\x89\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x00\x00\x00\x00\x7c\x00\x00\x00\x7d\x00\x00\x00\x54\x01\x00\x00\x00\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x84\x00\x85\x00\x7c\x00\x2c\x01\x7d\x00\x86\x00\x87\x00\x88\x00\x89\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x84\x00\x85\x00\x00\x00\x00\x00\x00\x00\x86\x00\x87\x00\x88\x00\x89\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x00\x00\x00\x00\x7c\x00\x00\x00\x7d\x00\x2d\x01\x00\x00\x00\x00\x00\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x84\x00\x85\x00\x7c\x00\x38\x01\x7d\x00\x86\x00\x87\x00\x88\x00\x89\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x84\x00\x85\x00\x7c\x00\x3b\x01\x7d\x00\x86\x00\x87\x00\x88\x00\x89\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x84\x00\x85\x00\x7c\x00\x42\x01\x7d\x00\x86\x00\x87\x00\x88\x00\x89\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x84\x00\x85\x00\x7c\x00\x43\x01\x7d\x00\x86\x00\x87\x00\x88\x00\x89\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x84\x00\x85\x00\x7c\x00\x00\x00\x7d\x00\x86\x00\x87\x00\x88\x00\x89\x00\x44\x01\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x84\x00\x85\x00\x00\x00\x00\x00\x00\x00\x86\x00\x87\x00\x88\x00\x89\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x00\x00\x00\x00\x7c\x00\x00\x00\x7d\x00\x00\x00\x3c\x00\x00\x00\x00\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x84\x00\x85\x00\x00\x00\x00\x00\x00\x00\x86\x00\x87\x00\x88\x00\x89\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x4b\x01\x00\x00\x7c\x00\x00\x00\x7d\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x84\x00\x85\x00\x00\x00\x00\x00\x00\x00\x86\x00\x87\x00\x88\x00\x89\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x00\x00\x4c\x01\x7c\x00\x00\x00\x7d\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x84\x00\x85\x00\x7c\x00\xf0\x00\x7d\x00\x86\x00\x87\x00\x88\x00\x89\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x84\x00\x85\x00\x00\x00\x00\x00\x00\x00\x86\x00\x87\x00\x88\x00\x89\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x00\x00\xf6\x00\x7c\x00\x00\x00\x7d\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x84\x00\x85\x00\x00\x00\x00\x00\x00\x00\x86\x00\x87\x00\x88\x00\x89\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x00\x00\x00\x00\x7c\x00\x00\x00\x7d\x00\x03\x01\x00\x00\x00\x00\x00\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x85\xff\x85\xff\x85\xff\x85\xff\x85\xff\x85\xff\x85\xff\x85\xff\x84\x00\x85\x00\x85\xff\x00\x00\x85\xff\x86\x00\x87\x00\x88\x00\x89\x00\x00\x00\x85\xff\x85\xff\x85\xff\x00\x00\x85\xff\x85\xff\x85\xff\x86\xff\x86\xff\x86\xff\x86\xff\x86\xff\x86\xff\x86\xff\x86\xff\x85\xff\x85\xff\x86\xff\x00\x00\x86\xff\x85\xff\x85\xff\x85\xff\x85\xff\x00\x00\x86\xff\x86\xff\x86\xff\x00\x00\x86\xff\x86\xff\x86\xff\x85\xff\x85\xff\x85\xff\x85\xff\x85\xff\x85\xff\x85\xff\x85\xff\x86\xff\x86\xff\x85\xff\x00\x00\x85\xff\x86\xff\x86\xff\x86\xff\x86\xff\x00\x00\x85\xff\x85\xff\x85\xff\x00\x00\x85\xff\x85\xff\x85\xff\x86\xff\x86\xff\x86\xff\x86\xff\x86\xff\x86\xff\x86\xff\x86\xff\x85\xff\x85\xff\x86\xff\x00\x00\x86\xff\x85\xff\x85\xff\x85\xff\x85\xff\x00\x00\x86\xff\x86\xff\x86\xff\x00\x00\x86\xff\x86\xff\x86\xff\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x86\xff\x86\xff\x7c\x00\x00\x00\x7d\x00\x86\xff\x86\xff\x86\xff\x86\xff\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x85\xff\x85\xff\x85\xff\x85\xff\x85\xff\x85\xff\x85\xff\x85\xff\x84\x00\x85\x00\x85\xff\x00\x00\x85\xff\x86\x00\x87\x00\x88\x00\x89\x00\x00\x00\x85\xff\x85\xff\x85\xff\x00\x00\x85\xff\x85\xff\x85\xff\x86\xff\x86\xff\x86\xff\x86\xff\x86\xff\x86\xff\x86\xff\x86\xff\x85\xff\x85\xff\x86\xff\x00\x00\x86\xff\x85\xff\x85\xff\x85\xff\x85\xff\x00\x00\x86\xff\x86\xff\x86\xff\x00\x00\x86\xff\x86\xff\x86\xff\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x86\xff\x86\xff\x7c\x00\x00\x00\x7d\x00\x86\xff\x86\xff\x86\xff\x86\xff\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x84\x00\x85\x00\x7c\x00\x00\x00\x7d\x00\x86\x00\x87\x00\x88\x00\x89\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x84\x00\x00\x00\x7c\x00\x00\x00\x7d\x00\x86\x00\x87\x00\x88\x00\x89\x00\x00\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x81\x00\x82\x00\x83\x00\x00\x00\x00\x00\x00\x00\x22\x00\x00\x00\x3d\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x86\x00\x87\x00\x88\x00\x89\x00\x3e\x00\x00\x00\x3f\x00\x23\x00\x24\x00\x40\x00\x41\x00\x00\x00\x42\x00\x43\x00\x00\x00\x26\x00\x27\x00\x28\x00\x29\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x00\x00\x00\x00\x7c\x00\x00\x00\x7d\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x7e\x00\x00\x00\x00\x00\x00\x00\x81\x00\x82\x00\x83\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyReduceArr = Happy_Data_Array.array (23, 168) [
	(23 , happyReduce_23),
	(24 , happyReduce_24),
	(25 , happyReduce_25),
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
	(168 , happyReduce_168)
	]

happy_n_terms = 87 :: Int
happy_n_nonterms = 32 :: Int

happyReduce_23 = happyReduce 4# 0# happyReduction_23
happyReduction_23 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut27 happy_x_4 of { happy_var_4 -> 
	happyIn26
		 (Program {package=getInnerString(happy_var_2), topLevels=(reverse happy_var_4)}
	) `HappyStk` happyRest}}

happyReduce_24 = happySpecReduce_2  1# happyReduction_24
happyReduction_24 happy_x_2
	happy_x_1
	 =  case happyOut27 happy_x_1 of { happy_var_1 -> 
	case happyOut28 happy_x_2 of { happy_var_2 -> 
	happyIn27
		 (happy_var_2 : happy_var_1
	)}}

happyReduce_25 = happySpecReduce_0  1# happyReduction_25
happyReduction_25  =  happyIn27
		 ([]
	)

happyReduce_26 = happySpecReduce_1  2# happyReduction_26
happyReduction_26 happy_x_1
	 =  case happyOut31 happy_x_1 of { happy_var_1 -> 
	happyIn28
		 (TopDecl happy_var_1
	)}

happyReduce_27 = happySpecReduce_1  2# happyReduction_27
happyReduction_27 happy_x_1
	 =  case happyOut38 happy_x_1 of { happy_var_1 -> 
	happyIn28
		 (TopFuncDecl happy_var_1
	)}

happyReduce_28 = happySpecReduce_3  3# happyReduction_28
happyReduction_28 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut29 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	happyIn29
		 ((getIdent happy_var_3) : happy_var_1
	)}}

happyReduce_29 = happySpecReduce_3  3# happyReduction_29
happyReduction_29 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	happyIn29
		 ([getIdent happy_var_3, getIdent happy_var_1]
	)}}

happyReduce_30 = happySpecReduce_1  4# happyReduction_30
happyReduction_30 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn30
		 (((getOffset happy_var_1), Type $ getIdent happy_var_1)
	)}

happyReduce_31 = happySpecReduce_3  4# happyReduction_31
happyReduction_31 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut30 happy_x_2 of { happy_var_2 -> 
	happyIn30
		 (happy_var_2
	)}

happyReduce_32 = happyReduce 4# 4# happyReduction_32
happyReduction_32 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut54 happy_x_2 of { happy_var_2 -> 
	case happyOut30 happy_x_4 of { happy_var_4 -> 
	happyIn30
		 (((getOffset happy_var_1), ArrayType happy_var_2 (snd happy_var_4))
	) `HappyStk` happyRest}}}

happyReduce_33 = happySpecReduce_3  4# happyReduction_33
happyReduction_33 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut30 happy_x_3 of { happy_var_3 -> 
	happyIn30
		 (((getOffset happy_var_1), SliceType (snd happy_var_3))
	)}}

happyReduce_34 = happySpecReduce_1  4# happyReduction_34
happyReduction_34 happy_x_1
	 =  case happyOut36 happy_x_1 of { happy_var_1 -> 
	happyIn30
		 (((fst happy_var_1), StructType (snd happy_var_1))
	)}

happyReduce_35 = happySpecReduce_2  5# happyReduction_35
happyReduction_35 happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_2 of { happy_var_2 -> 
	happyIn31
		 (VarDecl [happy_var_2]
	)}

happyReduce_36 = happyReduce 5# 5# happyReduction_36
happyReduction_36 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut33 happy_x_3 of { happy_var_3 -> 
	happyIn31
		 (VarDecl (reverse happy_var_3)
	) `HappyStk` happyRest}

happyReduce_37 = happyReduce 4# 5# happyReduction_37
happyReduction_37 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut30 happy_x_3 of { happy_var_3 -> 
	happyIn31
		 (TypeDef [TypeDef' (getIdent happy_var_2) happy_var_3]
	) `HappyStk` happyRest}}

happyReduce_38 = happyReduce 5# 5# happyReduction_38
happyReduction_38 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut35 happy_x_3 of { happy_var_3 -> 
	happyIn31
		 (TypeDef (reverse happy_var_3)
	) `HappyStk` happyRest}

happyReduce_39 = happySpecReduce_3  6# happyReduction_39
happyReduction_39 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut29 happy_x_1 of { happy_var_1 -> 
	case happyOut34 happy_x_2 of { happy_var_2 -> 
	happyIn32
		 (VarDecl' ((nonEmpty . reverse) happy_var_1) happy_var_2
	)}}

happyReduce_40 = happySpecReduce_3  6# happyReduction_40
happyReduction_40 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut34 happy_x_2 of { happy_var_2 -> 
	happyIn32
		 (VarDecl' (nonEmpty [getIdent happy_var_1]) happy_var_2
	)}}

happyReduce_41 = happySpecReduce_2  7# happyReduction_41
happyReduction_41 happy_x_2
	happy_x_1
	 =  case happyOut33 happy_x_1 of { happy_var_1 -> 
	case happyOut32 happy_x_2 of { happy_var_2 -> 
	happyIn33
		 (happy_var_2 : happy_var_1
	)}}

happyReduce_42 = happySpecReduce_0  7# happyReduction_42
happyReduction_42  =  happyIn33
		 ([]
	)

happyReduce_43 = happySpecReduce_1  8# happyReduction_43
happyReduction_43 happy_x_1
	 =  case happyOut30 happy_x_1 of { happy_var_1 -> 
	happyIn34
		 (Left (happy_var_1, [])
	)}

happyReduce_44 = happySpecReduce_3  8# happyReduction_44
happyReduction_44 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut30 happy_x_1 of { happy_var_1 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn34
		 (Left (happy_var_1, happy_var_3)
	)}}

happyReduce_45 = happySpecReduce_3  8# happyReduction_45
happyReduction_45 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut30 happy_x_1 of { happy_var_1 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn34
		 (Left (happy_var_1, [happy_var_3])
	)}}

happyReduce_46 = happySpecReduce_2  8# happyReduction_46
happyReduction_46 happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_2 of { happy_var_2 -> 
	happyIn34
		 (Right (nonEmpty happy_var_2)
	)}

happyReduce_47 = happySpecReduce_2  8# happyReduction_47
happyReduction_47 happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_2 of { happy_var_2 -> 
	happyIn34
		 (Right (nonEmpty [happy_var_2])
	)}

happyReduce_48 = happyReduce 4# 9# happyReduction_48
happyReduction_48 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut35 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut30 happy_x_3 of { happy_var_3 -> 
	happyIn35
		 ((TypeDef' (getIdent happy_var_2) happy_var_3) : happy_var_1
	) `HappyStk` happyRest}}}

happyReduce_49 = happySpecReduce_3  9# happyReduction_49
happyReduction_49 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut30 happy_x_2 of { happy_var_2 -> 
	happyIn35
		 ([TypeDef' (getIdent happy_var_1) happy_var_2]
	)}}

happyReduce_50 = happyReduce 4# 10# happyReduction_50
happyReduction_50 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut37 happy_x_3 of { happy_var_3 -> 
	happyIn36
		 (((getOffset happy_var_1), (reverse happy_var_3))
	) `HappyStk` happyRest}}

happyReduce_51 = happyReduce 4# 11# happyReduction_51
happyReduction_51 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut37 happy_x_1 of { happy_var_1 -> 
	case happyOut29 happy_x_2 of { happy_var_2 -> 
	case happyOut30 happy_x_3 of { happy_var_3 -> 
	happyIn37
		 ((FieldDecl ((nonEmpty . reverse) happy_var_2) happy_var_3) : happy_var_1
	) `HappyStk` happyRest}}}

happyReduce_52 = happyReduce 4# 11# happyReduction_52
happyReduction_52 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut37 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut30 happy_x_3 of { happy_var_3 -> 
	happyIn37
		 ((FieldDecl (nonEmpty [getIdent happy_var_2]) happy_var_3) : happy_var_1
	) `HappyStk` happyRest}}}

happyReduce_53 = happySpecReduce_0  11# happyReduction_53
happyReduction_53  =  happyIn37
		 ([]
	)

happyReduce_54 = happyReduce 5# 12# happyReduction_54
happyReduction_54 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut39 happy_x_3 of { happy_var_3 -> 
	case happyOut45 happy_x_4 of { happy_var_4 -> 
	happyIn38
		 (FuncDecl (getIdent happy_var_2) happy_var_3 happy_var_4
	) `HappyStk` happyRest}}}

happyReduce_55 = happyReduce 4# 13# happyReduction_55
happyReduction_55 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut40 happy_x_2 of { happy_var_2 -> 
	case happyOut42 happy_x_4 of { happy_var_4 -> 
	happyIn39
		 (Signature (Parameters happy_var_2) happy_var_4
	) `HappyStk` happyRest}}

happyReduce_56 = happySpecReduce_1  14# happyReduction_56
happyReduction_56 happy_x_1
	 =  case happyOut41 happy_x_1 of { happy_var_1 -> 
	happyIn40
		 (reverse happy_var_1
	)}

happyReduce_57 = happySpecReduce_0  14# happyReduction_57
happyReduction_57  =  happyIn40
		 ([]
	)

happyReduce_58 = happyReduce 4# 15# happyReduction_58
happyReduction_58 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut41 happy_x_1 of { happy_var_1 -> 
	case happyOut29 happy_x_3 of { happy_var_3 -> 
	case happyOut30 happy_x_4 of { happy_var_4 -> 
	happyIn41
		 ((ParameterDecl ((nonEmpty . reverse) happy_var_3) happy_var_4) : happy_var_1
	) `HappyStk` happyRest}}}

happyReduce_59 = happyReduce 4# 15# happyReduction_59
happyReduction_59 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut41 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	case happyOut30 happy_x_4 of { happy_var_4 -> 
	happyIn41
		 ((ParameterDecl (nonEmpty [getIdent happy_var_3]) happy_var_4) : happy_var_1
	) `HappyStk` happyRest}}}

happyReduce_60 = happySpecReduce_2  15# happyReduction_60
happyReduction_60 happy_x_2
	happy_x_1
	 =  case happyOut29 happy_x_1 of { happy_var_1 -> 
	case happyOut30 happy_x_2 of { happy_var_2 -> 
	happyIn41
		 ([(ParameterDecl ((nonEmpty . reverse) happy_var_1) happy_var_2)]
	)}}

happyReduce_61 = happySpecReduce_2  15# happyReduction_61
happyReduction_61 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut30 happy_x_2 of { happy_var_2 -> 
	happyIn41
		 ([(ParameterDecl (nonEmpty [getIdent happy_var_1]) happy_var_2)]
	)}}

happyReduce_62 = happySpecReduce_1  16# happyReduction_62
happyReduction_62 happy_x_1
	 =  case happyOut30 happy_x_1 of { happy_var_1 -> 
	happyIn42
		 (Just happy_var_1
	)}

happyReduce_63 = happySpecReduce_0  16# happyReduction_63
happyReduction_63  =  happyIn42
		 (Nothing
	)

happyReduce_64 = happySpecReduce_2  17# happyReduction_64
happyReduction_64 happy_x_2
	happy_x_1
	 =  case happyOut45 happy_x_1 of { happy_var_1 -> 
	happyIn43
		 (happy_var_1
	)}

happyReduce_65 = happySpecReduce_1  17# happyReduction_65
happyReduction_65 happy_x_1
	 =  case happyOut48 happy_x_1 of { happy_var_1 -> 
	happyIn43
		 (SimpleStmt happy_var_1
	)}

happyReduce_66 = happySpecReduce_2  17# happyReduction_66
happyReduction_66 happy_x_2
	happy_x_1
	 =  case happyOut49 happy_x_1 of { happy_var_1 -> 
	happyIn43
		 (happy_var_1
	)}

happyReduce_67 = happySpecReduce_2  17# happyReduction_67
happyReduction_67 happy_x_2
	happy_x_1
	 =  case happyOut51 happy_x_1 of { happy_var_1 -> 
	happyIn43
		 (happy_var_1
	)}

happyReduce_68 = happySpecReduce_2  17# happyReduction_68
happyReduction_68 happy_x_2
	happy_x_1
	 =  case happyOut52 happy_x_1 of { happy_var_1 -> 
	happyIn43
		 (happy_var_1
	)}

happyReduce_69 = happySpecReduce_2  17# happyReduction_69
happyReduction_69 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn43
		 (Break $ getOffset happy_var_1
	)}

happyReduce_70 = happySpecReduce_2  17# happyReduction_70
happyReduction_70 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn43
		 (Continue $ getOffset happy_var_1
	)}

happyReduce_71 = happySpecReduce_2  17# happyReduction_71
happyReduction_71 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn43
		 (Fallthrough $ getOffset happy_var_1
	)}

happyReduce_72 = happySpecReduce_1  17# happyReduction_72
happyReduction_72 happy_x_1
	 =  case happyOut31 happy_x_1 of { happy_var_1 -> 
	happyIn43
		 (Declare happy_var_1
	)}

happyReduce_73 = happyReduce 5# 17# happyReduction_73
happyReduction_73 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn43
		 (Print happy_var_3
	) `HappyStk` happyRest}

happyReduce_74 = happyReduce 5# 17# happyReduction_74
happyReduction_74 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn43
		 (Print [happy_var_3]
	) `HappyStk` happyRest}

happyReduce_75 = happyReduce 4# 17# happyReduction_75
happyReduction_75 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = happyIn43
		 (Print []
	) `HappyStk` happyRest

happyReduce_76 = happyReduce 5# 17# happyReduction_76
happyReduction_76 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn43
		 (Println happy_var_3
	) `HappyStk` happyRest}

happyReduce_77 = happyReduce 5# 17# happyReduction_77
happyReduction_77 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn43
		 (Println [happy_var_3]
	) `HappyStk` happyRest}

happyReduce_78 = happyReduce 4# 17# happyReduction_78
happyReduction_78 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = happyIn43
		 (Println []
	) `HappyStk` happyRest

happyReduce_79 = happySpecReduce_3  17# happyReduction_79
happyReduction_79 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_2 of { happy_var_2 -> 
	happyIn43
		 (Return $ Just happy_var_2
	)}

happyReduce_80 = happySpecReduce_2  17# happyReduction_80
happyReduction_80 happy_x_2
	happy_x_1
	 =  happyIn43
		 (Return Nothing
	)

happyReduce_81 = happySpecReduce_2  18# happyReduction_81
happyReduction_81 happy_x_2
	happy_x_1
	 =  case happyOut44 happy_x_1 of { happy_var_1 -> 
	case happyOut43 happy_x_2 of { happy_var_2 -> 
	happyIn44
		 (happy_var_2 : happy_var_1
	)}}

happyReduce_82 = happySpecReduce_0  18# happyReduction_82
happyReduction_82  =  happyIn44
		 ([]
	)

happyReduce_83 = happySpecReduce_3  19# happyReduction_83
happyReduction_83 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut44 happy_x_2 of { happy_var_2 -> 
	happyIn45
		 (BlockStmt (reverse happy_var_2)
	)}

happyReduce_84 = happySpecReduce_0  20# happyReduction_84
happyReduction_84  =  happyIn46
		 (EmptyStmt
	)

happyReduce_85 = happySpecReduce_2  20# happyReduction_85
happyReduction_85 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn46
		 (Increment (getOffset happy_var_2) $ Var (getIdent happy_var_1)
	)}}

happyReduce_86 = happySpecReduce_2  20# happyReduction_86
happyReduction_86 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn46
		 (Decrement (getOffset happy_var_2) $ Var (getIdent happy_var_1)
	)}}

happyReduce_87 = happySpecReduce_3  20# happyReduction_87
happyReduction_87 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Assign (getOffset happy_var_2) (AssignOp Nothing) (nonEmpty happy_var_1) (nonEmpty happy_var_3)
	)}}}

happyReduce_88 = happySpecReduce_3  20# happyReduction_88
happyReduction_88 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Assign (getOffset happy_var_2) (AssignOp $ Just Add) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_89 = happySpecReduce_3  20# happyReduction_89
happyReduction_89 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Assign (getOffset happy_var_2) (AssignOp $ Just Subtract) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_90 = happySpecReduce_3  20# happyReduction_90
happyReduction_90 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Assign (getOffset happy_var_2) (AssignOp $ Just BitOr) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_91 = happySpecReduce_3  20# happyReduction_91
happyReduction_91 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Assign (getOffset happy_var_2) (AssignOp $ Just BitXor) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_92 = happySpecReduce_3  20# happyReduction_92
happyReduction_92 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Assign (getOffset happy_var_2) (AssignOp $ Just Multiply) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_93 = happySpecReduce_3  20# happyReduction_93
happyReduction_93 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Assign (getOffset happy_var_2) (AssignOp $ Just Divide) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_94 = happySpecReduce_3  20# happyReduction_94
happyReduction_94 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Assign (getOffset happy_var_2) (AssignOp $ Just Remainder) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_95 = happySpecReduce_3  20# happyReduction_95
happyReduction_95 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Assign (getOffset happy_var_2) (AssignOp $ Just ShiftL) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_96 = happySpecReduce_3  20# happyReduction_96
happyReduction_96 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Assign (getOffset happy_var_2) (AssignOp $ Just ShiftR) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_97 = happySpecReduce_3  20# happyReduction_97
happyReduction_97 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Assign (getOffset happy_var_2) (AssignOp $ Just BitAnd) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_98 = happySpecReduce_3  20# happyReduction_98
happyReduction_98 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Assign (getOffset happy_var_2) (AssignOp $ Just BitClear) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_99 = happySpecReduce_3  20# happyReduction_99
happyReduction_99 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Assign (getOffset happy_var_2) (AssignOp Nothing) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_100 = happySpecReduce_3  20# happyReduction_100
happyReduction_100 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut29 happy_x_1 of { happy_var_1 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (ShortDeclare ((nonEmpty . reverse) happy_var_1) (nonEmpty happy_var_3)
	)}}

happyReduce_101 = happySpecReduce_3  20# happyReduction_101
happyReduction_101 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (ShortDeclare (nonEmpty [getIdent happy_var_1]) (nonEmpty [happy_var_3])
	)}}

happyReduce_102 = happySpecReduce_2  21# happyReduction_102
happyReduction_102 happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	happyIn47
		 (ExprStmt happy_var_1
	)}

happyReduce_103 = happySpecReduce_2  22# happyReduction_103
happyReduction_103 happy_x_2
	happy_x_1
	 =  case happyOut46 happy_x_1 of { happy_var_1 -> 
	happyIn48
		 (happy_var_1
	)}

happyReduce_104 = happySpecReduce_1  22# happyReduction_104
happyReduction_104 happy_x_1
	 =  case happyOut47 happy_x_1 of { happy_var_1 -> 
	happyIn48
		 (happy_var_1
	)}

happyReduce_105 = happyReduce 5# 23# happyReduction_105
happyReduction_105 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut48 happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	case happyOut45 happy_x_4 of { happy_var_4 -> 
	case happyOut50 happy_x_5 of { happy_var_5 -> 
	happyIn49
		 (If (happy_var_2, happy_var_3) happy_var_4 happy_var_5
	) `HappyStk` happyRest}}}}

happyReduce_106 = happyReduce 4# 23# happyReduction_106
happyReduction_106 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut54 happy_x_2 of { happy_var_2 -> 
	case happyOut45 happy_x_3 of { happy_var_3 -> 
	case happyOut50 happy_x_4 of { happy_var_4 -> 
	happyIn49
		 (If (EmptyStmt, happy_var_2) happy_var_3 happy_var_4
	) `HappyStk` happyRest}}}

happyReduce_107 = happySpecReduce_2  24# happyReduction_107
happyReduction_107 happy_x_2
	happy_x_1
	 =  case happyOut49 happy_x_2 of { happy_var_2 -> 
	happyIn50
		 (happy_var_2
	)}

happyReduce_108 = happySpecReduce_2  24# happyReduction_108
happyReduction_108 happy_x_2
	happy_x_1
	 =  case happyOut45 happy_x_2 of { happy_var_2 -> 
	happyIn50
		 (happy_var_2
	)}

happyReduce_109 = happySpecReduce_0  24# happyReduction_109
happyReduction_109  =  happyIn50
		 (blank
	)

happyReduce_110 = happySpecReduce_2  25# happyReduction_110
happyReduction_110 happy_x_2
	happy_x_1
	 =  case happyOut45 happy_x_2 of { happy_var_2 -> 
	happyIn51
		 (For ForInfinite happy_var_2
	)}

happyReduce_111 = happySpecReduce_3  25# happyReduction_111
happyReduction_111 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_2 of { happy_var_2 -> 
	case happyOut45 happy_x_3 of { happy_var_3 -> 
	happyIn51
		 (For (ForCond happy_var_2) happy_var_3
	)}}

happyReduce_112 = happyReduce 6# 25# happyReduction_112
happyReduction_112 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut48 happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	case happyOut46 happy_x_5 of { happy_var_5 -> 
	case happyOut45 happy_x_6 of { happy_var_6 -> 
	happyIn51
		 (For (ForClause happy_var_2 happy_var_3 happy_var_5) happy_var_6
	) `HappyStk` happyRest}}}}

happyReduce_113 = happyReduce 6# 25# happyReduction_113
happyReduction_113 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut48 happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	case happyOut54 happy_x_5 of { happy_var_5 -> 
	case happyOut45 happy_x_6 of { happy_var_6 -> 
	happyIn51
		 (For (ForClause happy_var_2 happy_var_3 (ExprStmt happy_var_5)) happy_var_6
	) `HappyStk` happyRest}}}}

happyReduce_114 = happyReduce 7# 26# happyReduction_114
happyReduction_114 (happy_x_7 `HappyStk`
	happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut48 happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_4 of { happy_var_4 -> 
	case happyOut53 happy_x_6 of { happy_var_6 -> 
	happyIn52
		 (Switch happy_var_2 (Just happy_var_4) (reverse happy_var_6)
	) `HappyStk` happyRest}}}

happyReduce_115 = happyReduce 6# 26# happyReduction_115
happyReduction_115 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut48 happy_x_2 of { happy_var_2 -> 
	case happyOut53 happy_x_5 of { happy_var_5 -> 
	happyIn52
		 (Switch happy_var_2 Nothing (reverse happy_var_5)
	) `HappyStk` happyRest}}

happyReduce_116 = happyReduce 5# 26# happyReduction_116
happyReduction_116 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut54 happy_x_2 of { happy_var_2 -> 
	case happyOut53 happy_x_4 of { happy_var_4 -> 
	happyIn52
		 (Switch EmptyStmt (Just happy_var_2) (reverse happy_var_4)
	) `HappyStk` happyRest}}

happyReduce_117 = happyReduce 5# 27# happyReduction_117
happyReduction_117 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut53 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	case happyOut44 happy_x_5 of { happy_var_5 -> 
	happyIn53
		 ((Case (getOffset happy_var_2) (nonEmpty happy_var_3) (BlockStmt $ reverse happy_var_5)) : happy_var_1
	) `HappyStk` happyRest}}}}

happyReduce_118 = happyReduce 5# 27# happyReduction_118
happyReduction_118 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut53 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	case happyOut44 happy_x_5 of { happy_var_5 -> 
	happyIn53
		 ((Case (getOffset happy_var_2) (nonEmpty [happy_var_3]) (BlockStmt $ reverse happy_var_5)) : happy_var_1
	) `HappyStk` happyRest}}}}

happyReduce_119 = happySpecReduce_3  27# happyReduction_119
happyReduction_119 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut53 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut44 happy_x_3 of { happy_var_3 -> 
	happyIn53
		 ((Default (getOffset happy_var_2) $ BlockStmt (reverse happy_var_3)) : happy_var_1
	)}}}

happyReduce_120 = happySpecReduce_0  27# happyReduction_120
happyReduction_120  =  happyIn53
		 ([]
	)

happyReduce_121 = happySpecReduce_1  28# happyReduction_121
happyReduction_121 happy_x_1
	 =  case happyOut55 happy_x_1 of { happy_var_1 -> 
	happyIn54
		 (happy_var_1
	)}

happyReduce_122 = happySpecReduce_1  28# happyReduction_122
happyReduction_122 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn54
		 (Var (getIdent happy_var_1)
	)}

happyReduce_123 = happySpecReduce_2  29# happyReduction_123
happyReduction_123 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut54 happy_x_2 of { happy_var_2 -> 
	happyIn55
		 (Unary (getOffset happy_var_1) Pos happy_var_2
	)}}

happyReduce_124 = happySpecReduce_2  29# happyReduction_124
happyReduction_124 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut54 happy_x_2 of { happy_var_2 -> 
	happyIn55
		 (Unary (getOffset happy_var_1) Neg happy_var_2
	)}}

happyReduce_125 = happySpecReduce_2  29# happyReduction_125
happyReduction_125 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut54 happy_x_2 of { happy_var_2 -> 
	happyIn55
		 (Unary (getOffset happy_var_1) Not happy_var_2
	)}}

happyReduce_126 = happySpecReduce_2  29# happyReduction_126
happyReduction_126 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut54 happy_x_2 of { happy_var_2 -> 
	happyIn55
		 (Unary (getOffset happy_var_1) BitComplement happy_var_2
	)}}

happyReduce_127 = happySpecReduce_3  29# happyReduction_127
happyReduction_127 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) Or happy_var_1 happy_var_3
	)}}}

happyReduce_128 = happySpecReduce_3  29# happyReduction_128
happyReduction_128 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) And happy_var_1 happy_var_3
	)}}}

happyReduce_129 = happySpecReduce_3  29# happyReduction_129
happyReduction_129 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) Data.EQ happy_var_1 happy_var_3
	)}}}

happyReduce_130 = happySpecReduce_3  29# happyReduction_130
happyReduction_130 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) NEQ happy_var_1 happy_var_3
	)}}}

happyReduce_131 = happySpecReduce_3  29# happyReduction_131
happyReduction_131 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) Data.LT happy_var_1 happy_var_3
	)}}}

happyReduce_132 = happySpecReduce_3  29# happyReduction_132
happyReduction_132 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) LEQ happy_var_1 happy_var_3
	)}}}

happyReduce_133 = happySpecReduce_3  29# happyReduction_133
happyReduction_133 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) Data.GT happy_var_1 happy_var_3
	)}}}

happyReduce_134 = happySpecReduce_3  29# happyReduction_134
happyReduction_134 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) GEQ happy_var_1 happy_var_3
	)}}}

happyReduce_135 = happySpecReduce_3  29# happyReduction_135
happyReduction_135 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) (Arithm Add) happy_var_1 happy_var_3
	)}}}

happyReduce_136 = happySpecReduce_3  29# happyReduction_136
happyReduction_136 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) (Arithm Subtract) happy_var_1 happy_var_3
	)}}}

happyReduce_137 = happySpecReduce_3  29# happyReduction_137
happyReduction_137 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) (Arithm Multiply) happy_var_1 happy_var_3
	)}}}

happyReduce_138 = happySpecReduce_3  29# happyReduction_138
happyReduction_138 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) (Arithm Divide) happy_var_1 happy_var_3
	)}}}

happyReduce_139 = happySpecReduce_3  29# happyReduction_139
happyReduction_139 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) (Arithm Remainder) happy_var_1 happy_var_3
	)}}}

happyReduce_140 = happySpecReduce_3  29# happyReduction_140
happyReduction_140 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) (Arithm BitOr) happy_var_1 happy_var_3
	)}}}

happyReduce_141 = happySpecReduce_3  29# happyReduction_141
happyReduction_141 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) (Arithm BitXor) happy_var_1 happy_var_3
	)}}}

happyReduce_142 = happySpecReduce_3  29# happyReduction_142
happyReduction_142 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) (Arithm BitAnd) happy_var_1 happy_var_3
	)}}}

happyReduce_143 = happySpecReduce_3  29# happyReduction_143
happyReduction_143 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) (Arithm BitClear) happy_var_1 happy_var_3
	)}}}

happyReduce_144 = happySpecReduce_3  29# happyReduction_144
happyReduction_144 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) (Arithm ShiftL) happy_var_1 happy_var_3
	)}}}

happyReduce_145 = happySpecReduce_3  29# happyReduction_145
happyReduction_145 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Binary (getOffset happy_var_2) (Arithm ShiftR) happy_var_1 happy_var_3
	)}}}

happyReduce_146 = happySpecReduce_3  29# happyReduction_146
happyReduction_146 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_2 of { happy_var_2 -> 
	happyIn55
		 (happy_var_2
	)}

happyReduce_147 = happySpecReduce_3  29# happyReduction_147
happyReduction_147 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Selector (getOffset happy_var_2) happy_var_1 $ getIdent happy_var_3
	)}}}

happyReduce_148 = happyReduce 4# 29# happyReduction_148
happyReduction_148 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Index (getOffset happy_var_2) happy_var_1 happy_var_3
	) `HappyStk` happyRest}}}

happyReduce_149 = happySpecReduce_1  29# happyReduction_149
happyReduction_149 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn55
		 (Lit (IntLit (getOffset happy_var_1) Decimal $ getInnerString happy_var_1)
	)}

happyReduce_150 = happySpecReduce_1  29# happyReduction_150
happyReduction_150 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn55
		 (Lit (IntLit (getOffset happy_var_1) Octal $ getInnerString happy_var_1)
	)}

happyReduce_151 = happySpecReduce_1  29# happyReduction_151
happyReduction_151 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn55
		 (Lit (IntLit (getOffset happy_var_1) Hexadecimal $ getInnerString happy_var_1)
	)}

happyReduce_152 = happySpecReduce_1  29# happyReduction_152
happyReduction_152 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn55
		 (Lit (FloatLit (getOffset happy_var_1) $ getInnerFloat happy_var_1)
	)}

happyReduce_153 = happySpecReduce_1  29# happyReduction_153
happyReduction_153 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn55
		 (Lit (RuneLit (getOffset happy_var_1) $ getInnerChar happy_var_1)
	)}

happyReduce_154 = happySpecReduce_1  29# happyReduction_154
happyReduction_154 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn55
		 (Lit (StringLit (getOffset happy_var_1) Interpreted $ getInnerString happy_var_1)
	)}

happyReduce_155 = happySpecReduce_1  29# happyReduction_155
happyReduction_155 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn55
		 (Lit (StringLit (getOffset happy_var_1) Raw $ getInnerString happy_var_1)
	)}

happyReduce_156 = happyReduce 6# 29# happyReduction_156
happyReduction_156 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	case happyOut54 happy_x_5 of { happy_var_5 -> 
	happyIn55
		 (AppendExpr (getOffset happy_var_1) happy_var_3 happy_var_5
	) `HappyStk` happyRest}}}

happyReduce_157 = happyReduce 4# 29# happyReduction_157
happyReduction_157 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (LenExpr (getOffset happy_var_1) happy_var_3
	) `HappyStk` happyRest}}

happyReduce_158 = happyReduce 4# 29# happyReduction_158
happyReduction_158 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (CapExpr (getOffset happy_var_1) happy_var_3
	) `HappyStk` happyRest}}

happyReduce_159 = happySpecReduce_3  29# happyReduction_159
happyReduction_159 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn55
		 (Arguments (getOffset happy_var_2) happy_var_1 []
	)}}

happyReduce_160 = happyReduce 4# 29# happyReduction_160
happyReduction_160 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Arguments (getOffset happy_var_2) happy_var_1 [happy_var_3]
	) `HappyStk` happyRest}}}

happyReduce_161 = happyReduce 4# 29# happyReduction_161
happyReduction_161 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut54 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Arguments (getOffset happy_var_2) happy_var_1 happy_var_3
	) `HappyStk` happyRest}}}

happyReduce_162 = happySpecReduce_1  30# happyReduction_162
happyReduction_162 happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	happyIn56
		 (reverse happy_var_1
	)}

happyReduce_163 = happySpecReduce_1  30# happyReduction_163
happyReduction_163 happy_x_1
	 =  case happyOut29 happy_x_1 of { happy_var_1 -> 
	happyIn56
		 (map Var (reverse happy_var_1)
	)}

happyReduce_164 = happySpecReduce_3  31# happyReduction_164
happyReduction_164 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOut54 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (happy_var_3 : happy_var_1
	)}}

happyReduce_165 = happySpecReduce_3  31# happyReduction_165
happyReduction_165 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut29 happy_x_1 of { happy_var_1 -> 
	case happyOut55 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (happy_var_3 : (map Var happy_var_1)
	)}}

happyReduce_166 = happySpecReduce_3  31# happyReduction_166
happyReduction_166 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut55 happy_x_1 of { happy_var_1 -> 
	case happyOut55 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 ([happy_var_3, happy_var_1]
	)}}

happyReduce_167 = happySpecReduce_3  31# happyReduction_167
happyReduction_167 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut55 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	happyIn57
		 ([(Var . getIdent) happy_var_3, happy_var_1]
	)}}

happyReduce_168 = happySpecReduce_3  31# happyReduction_168
happyReduction_168 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut55 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 ([happy_var_3, (Var . getIdent) happy_var_1]
	)}}

happyNewToken action sts stk
	= lexer(\tk -> 
	let cont i = happyDoAction i tk action sts stk in
	case tk of {
	Token _ TEOF -> happyDoAction 86# tk action sts stk;
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
	Token _ TRecv -> cont 36#;
	Token _ TInc -> cont 37#;
	Token _ TDInc -> cont 38#;
	Token _ TEq -> cont 39#;
	Token _ TNEq -> cont 40#;
	Token _ TLEq -> cont 41#;
	Token _ TGEq -> cont 42#;
	Token _ TDeclA -> cont 43#;
	Token _ TLeftSA -> cont 44#;
	Token _ TRightSA -> cont 45#;
	Token _ TLAndNotA -> cont 46#;
	Token _ TLdots -> cont 47#;
	Token _ TBreak -> cont 48#;
	Token _ TCase -> cont 49#;
	Token _ TChan -> cont 50#;
	Token _ TConst -> cont 51#;
	Token _ TContinue -> cont 52#;
	Token _ TDefault -> cont 53#;
	Token _ TDefer -> cont 54#;
	Token _ TElse -> cont 55#;
	Token _ TFallthrough -> cont 56#;
	Token _ TFor -> cont 57#;
	Token _ TFunc -> cont 58#;
	Token _ TGo -> cont 59#;
	Token _ TGoto -> cont 60#;
	Token _ TIf -> cont 61#;
	Token _ TImport -> cont 62#;
	Token _ TInterface -> cont 63#;
	Token _ TMap -> cont 64#;
	Token _ TPackage -> cont 65#;
	Token _ TRange -> cont 66#;
	Token _ TReturn -> cont 67#;
	Token _ TSelect -> cont 68#;
	Token _ TStruct -> cont 69#;
	Token _ TSwitch -> cont 70#;
	Token _ TType -> cont 71#;
	Token _ TVar -> cont 72#;
	Token _ TPrint -> cont 73#;
	Token _ TPrintln -> cont 74#;
	Token _ TAppend -> cont 75#;
	Token _ TLen -> cont 76#;
	Token _ TCap -> cont 77#;
	Token _ (TDecVal _) -> cont 78#;
	Token _ (TOctVal _) -> cont 79#;
	Token _ (THexVal _) -> cont 80#;
	Token _ (TFloatVal _) -> cont 81#;
	Token _ (TRuneVal _) -> cont 82#;
	Token _ (TStringVal _) -> cont 83#;
	Token _ (TRStringVal _) -> cont 84#;
	Token _ (TIdent _) -> cont 85#;
	_ -> happyError' tk
	})

happyError_ 86# tk = happyError' tk
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
  happySomeParser = happyThen (happyParse 0#) (\x -> happyReturn (happyOut26 x))

pId = happySomeParser where
  happySomeParser = happyThen (happyParse 1#) (\x -> happyReturn (happyOut29 x))

pE = happySomeParser where
  happySomeParser = happyThen (happyParse 2#) (\x -> happyReturn (happyOut54 x))

pT = happySomeParser where
  happySomeParser = happyThen (happyParse 3#) (\x -> happyReturn (happyOut30 x))

pEl = happySomeParser where
  happySomeParser = happyThen (happyParse 4#) (\x -> happyReturn (happyOut56 x))

pTDecl = happySomeParser where
  happySomeParser = happyThen (happyParse 5#) (\x -> happyReturn (happyOut28 x))

pTDecls = happySomeParser where
  happySomeParser = happyThen (happyParse 6#) (\x -> happyReturn (happyOut27 x))

pDec = happySomeParser where
  happySomeParser = happyThen (happyParse 7#) (\x -> happyReturn (happyOut31 x))

pDecB = happySomeParser where
  happySomeParser = happyThen (happyParse 8#) (\x -> happyReturn (happyOut34 x))

pFDec = happySomeParser where
  happySomeParser = happyThen (happyParse 9#) (\x -> happyReturn (happyOut38 x))

pSig = happySomeParser where
  happySomeParser = happyThen (happyParse 10#) (\x -> happyReturn (happyOut39 x))

pIDecl = happySomeParser where
  happySomeParser = happyThen (happyParse 11#) (\x -> happyReturn (happyOut32 x))

pPar = happySomeParser where
  happySomeParser = happyThen (happyParse 12#) (\x -> happyReturn (happyOut40 x))

pRes = happySomeParser where
  happySomeParser = happyThen (happyParse 13#) (\x -> happyReturn (happyOut42 x))

pStmt = happySomeParser where
  happySomeParser = happyThen (happyParse 14#) (\x -> happyReturn (happyOut43 x))

pStmts = happySomeParser where
  happySomeParser = happyThen (happyParse 15#) (\x -> happyReturn (happyOut44 x))

pBStmt = happySomeParser where
  happySomeParser = happyThen (happyParse 16#) (\x -> happyReturn (happyOut45 x))

pSStmt = happySomeParser where
  happySomeParser = happyThen (happyParse 17#) (\x -> happyReturn (happyOut48 x))

pIf = happySomeParser where
  happySomeParser = happyThen (happyParse 18#) (\x -> happyReturn (happyOut49 x))

pElses = happySomeParser where
  happySomeParser = happyThen (happyParse 19#) (\x -> happyReturn (happyOut50 x))

pSwS = happySomeParser where
  happySomeParser = happyThen (happyParse 20#) (\x -> happyReturn (happyOut52 x))

pSwB = happySomeParser where
  happySomeParser = happyThen (happyParse 21#) (\x -> happyReturn (happyOut53 x))

pFor = happySomeParser where
  happySomeParser = happyThen (happyParse 22#) (\x -> happyReturn (happyOut51 x))

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
  Token _ (THexVal val) -> val
  Token _ (TStringVal val) -> val
  Token _ (TRStringVal val) -> val
  Token _ (TIdent val) -> val

getInnerFloat :: Token -> Float
getInnerFloat (Token _ (TFloatVal val)) = val

getInnerChar :: Token -> Char
getInnerChar (Token _ (TRuneVal val)) = val

-- Main parse function
parse :: String -> Either String Program
parse s = either (Left . errODef s) Right (runAlex s $ hparse)

-- Extract posn only
ptokl t = case t of
          Token pos _ -> pos

parseError :: (Token) -> Alex a
parseError (Token (AlexPn o l c) t) =
           alexError ("Error: parsing error, unexpected " ++ (humanize t) ++ " at: ", o)
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "templates/GenericTemplate.hs" #-}
{-# LINE 1 "<built-in>" #-}
{-# LINE 1 "<command-line>" #-}
{-# LINE 10 "<command-line>" #-}
# 1 "/usr/include/stdc-predef.h" 1 3 4

# 17 "/usr/include/stdc-predef.h" 3 4











































{-# LINE 10 "<command-line>" #-}
{-# LINE 1 "/usr/lib/ghc-8.6.3/include/ghcversion.h" #-}















{-# LINE 10 "<command-line>" #-}
{-# LINE 1 "/tmp/ghc8353_0/ghc_2.h" #-}




























































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































{-# LINE 10 "<command-line>" #-}
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

{-# LINE 86 "templates/GenericTemplate.hs" #-}

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
