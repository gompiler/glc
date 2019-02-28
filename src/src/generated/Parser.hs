{-# OPTIONS_GHC -w #-}
{-# OPTIONS -XMagicHash -XBangPatterns -XTypeSynonymInstances -XFlexibleInstances -cpp #-}
#if __GLASGOW_HASKELL__ >= 710
{-# OPTIONS_GHC -XPartialTypeSignatures #-}
#endif
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
import System.Exit
import System.IO

import           Data.List.NonEmpty (NonEmpty (..))
import qualified Data.List.NonEmpty as NonEmpty
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import qualified GHC.Exts as Happy_GHC_Exts
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.19.9

newtype HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65 = HappyAbsSyn HappyAny
#if __GLASGOW_HASKELL__ >= 607
type HappyAny = Happy_GHC_Exts.Any
#else
type HappyAny = forall a . a
#endif
happyIn26 :: t26 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn26 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn26 #-}
happyOut26 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t26
happyOut26 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut26 #-}
happyIn27 :: t27 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn27 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn27 #-}
happyOut27 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t27
happyOut27 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut27 #-}
happyIn28 :: t28 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn28 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn28 #-}
happyOut28 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t28
happyOut28 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut28 #-}
happyIn29 :: t29 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn29 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn29 #-}
happyOut29 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t29
happyOut29 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut29 #-}
happyIn30 :: t30 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn30 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn30 #-}
happyOut30 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t30
happyOut30 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut30 #-}
happyIn31 :: t31 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn31 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn31 #-}
happyOut31 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t31
happyOut31 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut31 #-}
happyIn32 :: t32 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn32 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn32 #-}
happyOut32 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t32
happyOut32 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut32 #-}
happyIn33 :: t33 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn33 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn33 #-}
happyOut33 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t33
happyOut33 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut33 #-}
happyIn34 :: t34 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn34 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn34 #-}
happyOut34 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t34
happyOut34 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut34 #-}
happyIn35 :: t35 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn35 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn35 #-}
happyOut35 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t35
happyOut35 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut35 #-}
happyIn36 :: t36 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn36 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn36 #-}
happyOut36 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t36
happyOut36 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut36 #-}
happyIn37 :: t37 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn37 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn37 #-}
happyOut37 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t37
happyOut37 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut37 #-}
happyIn38 :: t38 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn38 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn38 #-}
happyOut38 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t38
happyOut38 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut38 #-}
happyIn39 :: t39 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn39 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn39 #-}
happyOut39 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t39
happyOut39 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut39 #-}
happyIn40 :: t40 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn40 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn40 #-}
happyOut40 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t40
happyOut40 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut40 #-}
happyIn41 :: t41 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn41 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn41 #-}
happyOut41 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t41
happyOut41 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut41 #-}
happyIn42 :: t42 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn42 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn42 #-}
happyOut42 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t42
happyOut42 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut42 #-}
happyIn43 :: t43 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn43 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn43 #-}
happyOut43 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t43
happyOut43 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut43 #-}
happyIn44 :: t44 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn44 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn44 #-}
happyOut44 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t44
happyOut44 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut44 #-}
happyIn45 :: t45 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn45 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn45 #-}
happyOut45 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t45
happyOut45 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut45 #-}
happyIn46 :: t46 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn46 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn46 #-}
happyOut46 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t46
happyOut46 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut46 #-}
happyIn47 :: t47 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn47 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn47 #-}
happyOut47 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t47
happyOut47 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut47 #-}
happyIn48 :: t48 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn48 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn48 #-}
happyOut48 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t48
happyOut48 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut48 #-}
happyIn49 :: t49 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn49 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn49 #-}
happyOut49 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t49
happyOut49 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut49 #-}
happyIn50 :: t50 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn50 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn50 #-}
happyOut50 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t50
happyOut50 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut50 #-}
happyIn51 :: t51 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn51 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn51 #-}
happyOut51 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t51
happyOut51 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut51 #-}
happyIn52 :: t52 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn52 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn52 #-}
happyOut52 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t52
happyOut52 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut52 #-}
happyIn53 :: t53 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn53 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn53 #-}
happyOut53 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t53
happyOut53 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut53 #-}
happyIn54 :: t54 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn54 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn54 #-}
happyOut54 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t54
happyOut54 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut54 #-}
happyIn55 :: t55 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn55 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn55 #-}
happyOut55 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t55
happyOut55 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut55 #-}
happyIn56 :: t56 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn56 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn56 #-}
happyOut56 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t56
happyOut56 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut56 #-}
happyIn57 :: t57 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn57 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn57 #-}
happyOut57 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t57
happyOut57 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut57 #-}
happyIn58 :: t58 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn58 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn58 #-}
happyOut58 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t58
happyOut58 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut58 #-}
happyIn59 :: t59 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn59 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn59 #-}
happyOut59 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t59
happyOut59 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut59 #-}
happyIn60 :: t60 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn60 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn60 #-}
happyOut60 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t60
happyOut60 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut60 #-}
happyIn61 :: t61 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn61 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn61 #-}
happyOut61 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t61
happyOut61 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut61 #-}
happyIn62 :: t62 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn62 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn62 #-}
happyOut62 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t62
happyOut62 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut62 #-}
happyIn63 :: t63 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn63 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn63 #-}
happyOut63 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t63
happyOut63 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut63 #-}
happyIn64 :: t64 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn64 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn64 #-}
happyOut64 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t64
happyOut64 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut64 #-}
happyIn65 :: t65 -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyIn65 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn65 #-}
happyOut65 :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> t65
happyOut65 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut65 #-}
happyInTok :: (Token) -> (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65)
happyInTok x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyInTok #-}
happyOutTok :: (HappyAbsSyn t26 t27 t28 t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 t61 t62 t63 t64 t65) -> (Token)
happyOutTok x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOutTok #-}


happyExpList :: HappyAddr
happyExpList = HappyA# "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x80\x41\x02\x10\x00\x00\x00\x00\x00\x00\xfe\x0f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05\x00\x00\x00\x00\x00\x00\x04\x00\x04\x00\x00\x00\x00\x00\x00\x00\x60\x90\x00\x04\x00\x00\x00\x00\x00\x80\xff\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x0c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x28\x02\x00\x00\x00\x00\x00\x20\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x40\x01\x00\x00\x00\x00\x00\x00\x01\x00\x01\x00\x00\x00\x00\x00\x00\x00\x18\x24\x02\x01\x00\x00\x44\x8c\x20\xff\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x83\x04\x20\x00\x00\x00\x00\x00\x00\xfc\x1f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x41\x22\x10\x00\x00\x00\x00\x00\x00\xfe\x0f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x18\x24\x00\x01\x00\x00\x00\x00\x00\xe0\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x41\x02\x10\x00\x00\x00\x00\x00\x00\xfe\x0f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfe\x2d\xba\xff\x8f\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x30\x48\x00\x02\x00\x00\x00\x00\x00\xc0\xff\x01\x00\x00\x00\x00\x00\x00\x00\x18\x24\x00\x01\x00\x00\x00\x00\x00\xe0\xff\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x12\x80\x00\x00\x00\x00\x00\x00\xf0\x7f\x00\x00\x00\x00\x00\x00\x00\x00\x06\x09\x40\x00\x00\x00\x00\x00\x00\xf8\x3f\x00\x00\x00\x00\x00\x00\x00\x00\x83\x04\x20\x00\x00\x00\x00\x00\x00\xfc\x1f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x86\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x06\x89\x40\x00\x00\x00\x11\x23\xc8\xff\x3f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\xa0\x01\x08\x00\x00\x00\x00\x00\x00\xff\x07\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05\x00\x00\x00\x00\x00\x00\x04\x00\x04\x00\x00\x00\x00\x00\x00\x00\x60\x90\x04\x04\x00\x00\x00\x00\x00\x80\xff\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x50\x00\x00\x00\x00\x00\x00\x40\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x85\x00\x00\x00\x00\x00\x00\x04\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x80\x22\x00\x00\x00\x00\x00\x00\x02\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa0\x18\x00\x00\x00\x00\x00\x80\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x30\x48\x00\x02\x00\x00\x00\x00\x00\xc0\xff\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x80\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf0\x4f\xc1\x1d\x60\x3c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\x14\xdc\x01\xc6\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x06\x09\x40\x00\x00\x00\x00\x00\x00\xf8\x3f\x00\x00\x00\x00\x00\x00\x00\x00\x83\x04\x20\x00\x00\x00\x00\x00\x00\xfc\x1f\x00\x00\x00\x00\x00\x00\x00\x80\x41\x02\x10\x00\x00\x00\x00\x00\x00\xfe\x0f\x00\x00\x00\x00\x00\x00\x00\xc0\x20\x01\x08\x00\x00\x00\x00\x00\x00\xff\x07\x00\x00\x00\x00\x00\x00\x00\x60\x90\x00\x04\x00\x00\x00\x00\x00\x80\xff\x03\x00\x00\x00\x00\x00\x00\x00\x30\x48\x00\x02\x00\x00\x00\x00\x00\xc0\xff\x01\x00\x00\x00\x00\x00\x00\x00\x18\x24\x00\x01\x00\x00\x00\x00\x00\xe0\xff\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x12\x80\x00\x00\x00\x00\x00\x00\xf0\x7f\x00\x00\x00\x00\x00\x00\x00\x00\x06\x09\x40\x00\x00\x00\x00\x00\x00\xf8\x3f\x00\x00\x00\x00\x00\x00\x00\x00\x83\x04\x20\x00\x00\x00\x00\x00\x00\xfc\x1f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x00\x00\x00\x00\x00\x00\xc0\x20\x01\x08\x00\x00\x00\x00\x00\x00\xff\x07\x00\x00\x00\x00\x00\x00\x00\x60\x90\x00\x04\x00\x00\x00\x00\x00\x80\xff\x03\x00\x00\x00\x00\x00\x00\x00\x30\x48\x00\x02\x00\x00\x00\x00\x00\xc0\xff\x01\x00\x00\x00\x00\x00\x00\x00\x18\x24\x00\x01\x00\x00\x00\x00\x00\xe0\xff\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x12\x80\x00\x00\x00\x00\x00\x00\xf0\x7f\x00\x00\x00\x00\x00\x00\x00\x00\x06\x09\x40\x00\x00\x00\x00\x00\x00\xf8\x3f\x00\x00\x00\x00\x00\x00\x00\x00\x83\x04\x20\x00\x00\x00\x00\x00\x00\xfc\x1f\x00\x00\x00\x00\x00\x00\x00\x80\x41\x02\x10\x00\x00\x00\x00\x00\x00\xfe\x0f\x00\x00\x00\x00\x00\x00\x00\xc0\x20\x01\x08\x00\x00\x00\x00\x00\x00\xff\x07\x00\x00\x00\x00\x00\x00\x00\x60\x90\x00\x04\x00\x00\x00\x00\x00\x80\xff\x03\x00\x00\x00\x00\x00\x00\x00\x30\x48\x00\x02\x00\x00\x00\x00\x00\xc0\xff\x01\x00\x00\x00\x00\x00\x00\x00\x18\x24\x00\x01\x00\x00\x00\x00\x00\xe0\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfe\x29\xb8\x03\x8c\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x41\x02\x10\x00\x00\x00\x00\x00\x00\xfe\x0f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\x9f\x86\x3b\xc0\x78\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x01\x00\x00\x00\x00\x00\x00\x01\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x12\x80\x00\x00\x00\x00\x00\x00\xf0\x7f\x00\x00\x00\x00\x00\x00\x00\x00\x06\x09\x40\x00\x00\x00\x00\x00\x00\xf8\x3f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x80\x02\x00\x00\x00\x00\x00\x00\x02\x00\x02\x00\x00\x00\x00\x00\x00\x00\xf0\x6f\xc1\x1d\x60\x3c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x41\x02\x10\x00\x00\x00\x00\x00\x00\xfe\x0f\x00\x00\x00\x00\x00\x00\x00\xc0\x20\x01\x08\x00\x00\x00\x00\x00\x00\xff\x07\x00\x00\x00\x00\x00\x00\x00\x60\x90\x00\x04\x00\x00\x00\x00\x00\x80\xff\x03\x00\x00\x00\x00\x00\x00\x00\x30\x48\x00\x02\x00\x00\x00\x00\x00\xc0\xff\x01\x00\x00\x00\x00\x00\x00\x00\x00\xa0\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfc\x73\x70\x07\x18\x0f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x28\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x14\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0a\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\x20\x01\x08\x00\x00\x00\x00\x00\x00\xff\x07\x00\x00\x00\x00\x00\x00\x00\x60\x90\x00\x04\x00\x00\x00\x00\x00\x80\xff\x03\x00\x00\x00\x00\x00\x00\x00\x30\x48\x00\x02\x00\x00\x00\x00\x00\xc0\xff\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x12\x80\x00\x00\x00\x00\x00\x00\xf0\x7f\x00\x00\x00\x00\x00\x00\x00\x00\x06\x09\x40\x00\x00\x00\x00\x00\x00\xf8\x3f\x00\x00\x00\x00\x00\x00\x00\x00\x83\x04\x20\x00\x00\x00\x00\x00\x00\xfc\x1f\x00\x00\x00\x00\x00\x00\x00\x80\x41\x02\x10\x00\x00\x00\x00\x00\x00\xfe\x0f\x00\x00\x00\x00\x00\x00\x00\xc0\x20\x01\x08\x00\x00\x00\x00\x00\x00\xff\x07\x00\x00\x00\x00\x00\x00\x00\x60\x90\x00\x04\x00\x00\x00\x00\x00\x80\xff\x03\x00\x00\x00\x00\x00\x00\x00\x30\x48\x00\x02\x00\x00\x00\x00\x00\xc0\xff\x01\x00\x00\x00\x00\x00\x00\x00\x18\x24\x00\x01\x00\x00\x00\x00\x00\xe0\xff\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x12\x80\x00\x00\x00\x00\x00\x00\xf0\x7f\x00\x00\x00\x00\x00\x00\x00\x00\x06\x09\x40\x00\x00\x00\x00\x00\x00\xf8\x3f\x00\x00\x00\x00\x00\x00\x00\x00\x83\x04\x20\x00\x00\x00\x00\x00\x00\xfc\x1f\x00\x00\x00\x00\x00\x00\x00\x80\x41\x02\x10\x00\x00\x00\x00\x00\x00\xfe\x0f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x90\x00\x04\x00\x00\x00\x00\x00\x80\xff\x03\x00\x00\x00\x00\x00\x00\x00\x30\x48\x00\x02\x00\x00\x00\x00\x00\xc0\xff\x01\x00\x00\x00\x00\x00\x00\x00\x18\x24\x00\x01\x00\x00\x00\x00\x00\xe0\xff\x00\x00\x00\x00\x00\x00\x00\x00\xfc\x5b\x75\xff\x1f\xef\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\xbf\x55\xf7\xff\xf1\x0e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x60\x90\x00\x04\x00\x00\x00\x00\x00\x80\xff\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x12\x80\x00\x00\x00\x00\x00\x00\xf0\x7f\x00\x00\x00\x00\x00\x00\x00\x00\xfe\xad\xba\xff\x8f\x77\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\xdf\x82\x3b\xc0\x78\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf8\xaf\xe0\x0e\x30\x1e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x83\x44\x20\x00\x00\x00\x00\x00\x00\xfc\x1f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\x3f\x15\x77\x80\xf1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfc\x53\x70\x07\x18\x0f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfe\x29\xb8\x03\x8c\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\x14\xdc\x01\xc6\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x7f\x0a\xee\x00\xe3\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\x3f\x05\x77\x80\xf1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\x9f\x82\x3b\xc0\x78\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf0\x4f\xc1\x1d\x60\x3c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf8\xa7\xe0\x0e\x30\x1e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfc\x53\x70\x07\x18\x0f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfe\x29\xb8\x03\x8c\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\x14\xdc\x01\xc6\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x7f\x0a\xee\x00\xe3\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf8\xa7\xe0\x0e\x30\x1e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfe\x29\xbc\x03\x8c\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\x1c\xdc\x01\xc6\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x7f\x0e\xee\x00\xe3\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\x3f\x05\x77\x80\xf1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x14\x00\x00\x00\x00\x00\x00\x10\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\xe0\x9f\x83\x3b\xc0\x78\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf8\xe7\xe0\x0e\x30\x1e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x00\x00\x00\x08\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa0\x00\x00\x00\x00\x00\x00\x80\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x50\x08\x00\x00\x00\x00\x00\x40\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x00\x00\x00\x08\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\x9f\x82\x3b\xc0\x78\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfe\x29\x88\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\x14\xc4\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x7f\x0a\xe2\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\x3f\x05\x71\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\x9f\x82\x3b\x40\x78\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf0\x4f\xc1\x1d\x00\x3c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa0\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x50\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x28\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\x14\xc4\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x7f\x0a\xe2\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\x9f\x86\x3b\xc0\x78\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf0\xcf\xc1\x1d\x60\x3c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf0\x50\x10\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x78\x28\x88\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x14\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0a\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x82\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc0\x43\x41\x1c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe0\xa1\x20\x0e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x50\x00\x00\x00\x00\x00\x00\x40\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x28\x04\x00\x00\x00\x00\x00\x20\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0a\x00\x00\x00\x00\x00\x00\x08\x00\x08\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x12\x80\x00\x00\x00\x00\x00\x00\xf0\x7f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x7f\x2a\xee\x00\xe3\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x0c\x12\x80\x00\x00\x00\x00\x00\x00\xf0\x7f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x40\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x7f\xaa\xee\xff\xe3\x1d\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\x1c\xdc\x01\xc6\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x80\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_hparse","%start_pId","%start_pE","%start_pT","%start_pEl","%start_pTDecl","%start_pTDecls","%start_pDec","%start_pDecB","%start_pFDec","%start_pSig","%start_pIDecl","%start_pPar","%start_pRes","%start_pStmt","%start_pStmts","%start_pBStmt","%start_pSStmt","%start_pIf","%start_pElses","%start_pSwS","%start_pSwB","%start_pFor","Program","TopDecls","TopDeclsR","TopDecl","Idents","IdentsR","Type","Decl","InnerDecl","InnerDecls","InnerDeclsR","DeclBody","TypeDefs","TypeDefsR","Struct","FieldDecls","FieldDeclsR","FuncDecl","Signature","Params","ParamsR","Result","Stmt","Stmts","StmtsR","BlockStmt","SimpleStNE","ExprStmt","SimpleStmt","IfStmt","Elses","ForStmt","SwitchStmt","SwitchBody","SwitchBodyR","Expr","NIExpr","EIList","NIExprList","NIExprListR","'+'","'-'","'*'","'/'","'%'","'&'","'|'","'^'","':'","';'","'('","')'","'['","']'","'{'","'}'","'='","','","'.'","'>'","'<'","'!'","\"<<\"","\">>\"","\"&^\"","\"+=\"","\"-=\"","\"*=\"","\"/=\"","\"%=\"","\"&=\"","\"|=\"","\"^=\"","\"&&\"","\"||\"","\"<-\"","\"++\"","\"--\"","\"==\"","\"!=\"","\"<=\"","\">=\"","\":=\"","\"<<=\"","\">>=\"","\"&^=\"","\"...\"","break","case","chan","const","continue","default","defer","else","fallthrough","for","func","go","goto","if","import","interface","map","package","range","return","select","struct","switch","type","var","print","println","append","len","cap","decv","octv","hexv","fv","rv","sv","rsv","ident","%eof"]
        bit_start = st * 151
        bit_end = (st + 1) * 151
        read_bit = readArrayBit happyExpList
        bits = map read_bit [bit_start..bit_end - 1]
        bits_indexed = zip bits [0..150]
        token_strs_expected = concatMap f bits_indexed
        f (False, _) = []
        f (True, nr) = [token_strs !! nr]

happyActOffsets :: HappyAddr
happyActOffsets = HappyA# "\xd7\xff\xc5\xff\xfb\x00\x4f\x00\x07\x01\xc7\xff\x00\x00\xdb\xff\x56\x00\xe3\xff\x1c\x00\xe2\xff\xe6\xff\x4f\x00\x27\x00\x00\x00\x37\x00\x13\x01\x25\x00\x60\x00\x5d\x00\x00\x00\x61\x00\x68\x00\x57\x00\xba\x00\x7c\x00\xba\x00\xd3\xff\xba\x00\x13\x01\xba\x00\xf6\xff\xba\x00\x13\x01\x85\x00\xa1\x00\xcb\x00\x00\x00\xe1\x00\x99\x03\xdb\x00\x17\x01\x00\x00\x10\x01\x1f\x01\x1f\x01\x1f\x01\x1f\x01\x1f\x01\x27\x01\x29\x01\x2c\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x1a\x00\x3d\x01\x00\x00\x3d\x01\x01\x00\x00\x00\x3d\x01\x36\x01\x00\x00\x3b\x01\x47\x01\x53\x01\x5f\x01\x6b\x01\x82\x01\x8b\x00\x08\x00\x09\x00\x88\x01\x8a\x01\x00\x00\x00\x00\x9f\x01\x4f\x00\x97\x00\x89\x01\x00\x00\x4f\x00\x8f\x01\xab\x01\x92\x01\x14\x00\x7d\x00\xad\x01\x13\x00\xad\x01\x5b\x01\xb9\x01\x70\x01\xb6\x01\xca\x01\x2b\x01\xca\x01\xca\x01\xc7\xff\xca\x01\x00\x00\x00\x00\x00\x00\xfd\x05\xca\x01\xc4\x01\xe2\x01\xf6\x03\x00\x00\x00\x00\xe2\x01\xdc\x01\xbb\x01\xb7\x01\x80\x01\x80\x01\x80\x01\x80\x01\x80\x01\x80\x01\x80\x01\x80\x01\x8c\x01\x98\x01\xc3\x01\x98\x01\x98\x01\x98\x01\x98\x01\x98\x01\x98\x01\x98\x01\x98\x01\x98\x01\x98\x01\x98\x01\xa4\x01\x00\x00\xfd\x05\x00\x00\xb0\x01\xef\x01\x0e\x02\x13\x02\x1a\x02\x00\x00\xd1\x01\xd4\x01\x00\x00\x00\x00\x20\x04\x4f\x00\x24\x02\xb0\x01\xb0\x01\x00\x00\x00\x00\xdd\x01\x4f\x00\x4a\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2e\x02\x00\x00\x00\x00\x05\x02\x05\x02\x05\x02\x05\x02\x93\x00\x63\x04\x93\x00\x93\x00\x93\x00\x05\x02\x11\x02\x1d\x02\x00\x00\x29\x02\x29\x02\x29\x02\x29\x02\x29\x02\x29\x02\x29\x02\x29\x02\x29\x02\x29\x02\x29\x02\x29\x02\x00\x00\x35\x02\x8a\x02\x96\x02\x0f\x03\x00\x00\x00\x00\x2b\x02\x3d\x03\xa2\x02\x00\x00\x00\x00\xae\x02\x6b\x03\x40\x02\x00\x00\x00\x00\x8d\x04\x00\x00\xb7\x04\x52\x02\x00\x00\xa6\x00\x30\x02\xe1\x04\x00\x00\x16\x06\x2f\x06\x48\x06\x48\x06\x48\x06\x48\x06\x48\x06\x48\x06\x48\x06\x48\x06\x48\x06\x48\x06\x48\x06\x48\x06\x61\x06\x7a\x06\x00\x00\x93\x06\x00\x00\xfa\x04\x13\x05\x2c\x05\x93\x06\x00\x00\x00\x00\x69\x02\x73\x02\x3c\x02\x4f\x00\x91\x02\x41\x02\x45\x05\x93\x02\x5e\x05\x9f\x02\x00\x00\x00\x00\x4f\x00\x92\x02\x54\x02\x00\x00\x4f\x00\xa9\x00\x00\x00\x00\x00\x4f\x00\xa6\x02\x93\x06\x00\x00\xac\x06\xc5\x06\x7d\x07\x7d\x07\x7d\x07\x7d\x07\xde\x06\xf7\x06\x93\x00\x93\x00\x93\x00\x7d\x07\x7d\x07\x00\x00\x88\x05\xa1\x05\xab\x02\x94\x07\x94\x07\x93\x00\x93\x00\x93\x00\x93\x00\x94\x07\x94\x07\x00\x00\x00\x00\x00\x00\x00\x00\xa4\x02\x00\x00\x00\x00\x00\x00\x4f\x00\xa9\x00\x00\x00\x00\x00\xb0\x02\xb9\x02\xc5\x02\xc7\x02\x00\x00\xca\x02\xd6\x02\x4f\x00\xe2\x02\x00\x00\x00\x00\x00\x00\xae\x02\xc1\x02\x00\x00\xcb\x05\x00\x00\xf4\x02\x00\x00\x00\x00\xba\x02\x00\x00\x09\x03\xc7\x03\x00\x00\x00\x00\x00\x00\x0b\x03\x00\x00\x00\x00\xe4\x05\x00\x00\x13\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x15\x03\x17\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x25\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyGotoOffsets :: HappyAddr
happyGotoOffsets = HappyA# "\x3a\x03\x29\x00\x1e\x00\x2a\x00\x84\x04\x7e\x00\x64\x00\x1e\x03\xa4\x00\x35\x03\x37\x03\x7b\x00\x02\x00\x04\x00\x0d\x07\x54\x00\x32\x03\x99\x01\x30\x03\x31\x03\x33\x03\xa2\x00\x44\x03\x00\x00\x00\x00\x00\x00\x15\x01\x00\x00\x00\x00\x00\x00\x1e\x02\x00\x00\xf4\xff\x00\x00\xa3\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x79\x00\xb0\x00\xcc\x00\xdd\x00\x02\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xae\x00\x00\x00\x31\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x20\x01\x00\x00\x3a\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x83\x00\x62\x01\x00\x00\x00\x00\xb1\x00\x00\x00\x00\x00\x00\x00\xf9\x00\xb2\x00\x00\x00\xb3\x00\x00\x00\x17\x00\x00\x00\x00\x00\x00\x00\x00\x00\xae\x04\x00\x00\x00\x00\x7f\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x66\x01\x6c\x01\x6e\x01\x78\x01\x84\x01\x86\x01\x93\x01\x9e\x01\x16\x07\xa0\x01\x00\x00\xa5\x01\xe5\x01\xe7\x01\xeb\x01\xf1\x01\xf3\x01\xfd\x01\x09\x02\x0b\x02\x18\x02\x23\x02\x25\x02\x00\x00\x00\x00\x00\x00\x3a\x07\x56\x03\x00\x00\x00\x00\x00\x00\x00\x00\x48\x02\x00\x00\x00\x00\x3f\x02\x00\x00\xfc\x00\x00\x00\x3f\x07\x44\x07\x00\x00\x84\x02\x83\x02\xfe\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x70\x02\x76\x02\x78\x02\x82\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x8e\x02\x4e\x07\x90\x02\x00\x00\x9d\x02\xa8\x02\xaa\x02\xaf\x02\x10\x03\x3e\x03\x6c\x03\x84\x03\x9a\x03\xad\x03\xc8\x03\xdc\x03\x00\x00\xe1\x03\x55\x07\xe3\x03\x5b\x03\x00\x00\x00\x00\x00\x00\x00\x00\x68\x07\xf9\x03\x00\x00\xef\x03\x5e\x03\x00\x00\x13\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf5\x03\x06\x04\x5d\x03\x60\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\x00\x00\x00\x7f\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x05\x01\x00\x00\x2b\x04\x00\x00\x08\x01\x0a\x01\x00\x00\x00\x00\x2e\x00\x64\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x11\x01\x16\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x1d\x01\x00\x00\x00\x00\x00\x00\x00\x00\x1c\x04\x63\x03\x00\x00\x00\x00\x23\x04\x00\x00\x41\x04\x43\x04\x17\x04\x00\x00\x78\x03\x7d\x03\x00\x00\x00\x00\x00\x00\x00\x00\x5c\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyAdjustOffset :: Happy_GHC_Exts.Int# -> Happy_GHC_Exts.Int#
happyAdjustOffset off = off

happyDefActions :: HappyAddr
happyDefActions = HappyA# "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe5\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc1\xff\xbb\xff\xa7\xff\xa9\xff\x00\x00\xa7\xff\x00\x00\x8e\xff\x00\x00\x82\xff\x00\x00\x00\x00\x00\x00\x00\x00\xa7\xff\x00\x00\x86\xff\x00\x00\xa7\xff\x00\x00\x00\x00\x00\x00\xa7\xff\x58\xff\xe2\xff\x00\x00\x93\xff\x00\x00\x00\x00\x81\xff\x00\x00\x59\xff\x57\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x65\xff\x64\xff\x63\xff\x62\xff\x61\xff\x60\xff\x5f\xff\x80\xff\x00\x00\xa9\xff\x00\x00\xab\xff\xb2\xff\x00\x00\x00\x00\xb9\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xbc\xff\xdb\xff\x00\x00\x00\x00\x00\x00\x00\x00\xdf\xff\x00\x00\xe2\xff\x00\x00\xc2\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc1\xff\x00\x00\x00\x00\xd1\xff\x00\x00\x00\x00\x00\x00\x00\x00\xe7\xff\x00\x00\xe4\xff\xe3\xff\x58\xff\x00\x00\x00\x00\x80\xff\x00\x00\x00\x00\x81\xff\x80\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe6\xff\xcd\xff\xce\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xbd\xff\x00\x00\x00\x00\xbe\xff\xc5\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xda\xff\xd2\xff\x00\x00\x00\x00\x00\x00\xac\xff\xb3\xff\xb4\xff\xb5\xff\xb6\xff\xb7\xff\xb8\xff\xba\xff\xaa\xff\x00\x00\xa6\xff\xa5\xff\x00\x00\x00\x00\x00\x00\x00\x00\x7d\xff\x00\x00\x7c\xff\x7e\xff\x7f\xff\x00\x00\x00\x00\x00\x00\x95\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x94\xff\x00\x00\x00\x00\x00\x00\x00\x00\x8f\xff\x90\xff\x00\x00\x00\x00\x00\x00\xa9\xff\x8d\xff\x00\x00\x00\x00\x00\x00\xe5\xff\x8c\xff\x00\x00\x83\xff\x00\x00\x00\x00\x82\xff\x00\x00\x8e\xff\x00\x00\x97\xff\x55\xff\xe1\xff\x99\xff\x9b\xff\x9c\xff\xa0\xff\xa1\xff\x9a\xff\x9d\xff\x9e\xff\x9f\xff\xa2\xff\xa3\xff\x98\xff\x54\xff\x53\xff\xa4\xff\x56\xff\x68\xff\x00\x00\x00\x00\x00\x00\x96\xff\xa8\xff\xad\xff\x00\x00\x00\x00\xcc\xff\x00\x00\x00\x00\xd4\xff\x00\x00\x00\x00\x00\x00\x00\x00\xde\xff\xdc\xff\x00\x00\x00\x00\xc8\xff\xe1\xff\x00\x00\x00\x00\xd6\xff\xd5\xff\xbb\xff\x00\x00\xcf\xff\xd0\xff\x52\xff\xe0\xff\x74\xff\x76\xff\x78\xff\x79\xff\x7b\xff\x7a\xff\x6b\xff\x69\xff\x6a\xff\x77\xff\x75\xff\x67\xff\x00\x00\x00\x00\x00\x00\x6d\xff\x6e\xff\x6c\xff\x6f\xff\x70\xff\x71\xff\x72\xff\x73\xff\xe0\xff\x5a\xff\x5b\xff\x66\xff\x00\x00\xc3\xff\xbf\xff\xc0\xff\x00\x00\x00\x00\xc9\xff\xdd\xff\x00\x00\x00\x00\x00\x00\x00\x00\xd3\xff\x00\x00\x00\x00\x00\x00\x00\x00\xd8\xff\x5c\xff\x5d\xff\x00\x00\x8e\xff\x91\xff\x00\x00\x82\xff\x00\x00\xa9\xff\xa9\xff\xa7\xff\xe8\xff\x00\x00\x00\x00\x84\xff\x85\xff\x87\xff\x00\x00\x82\xff\x92\xff\x00\x00\xd7\xff\x00\x00\xca\xff\xd9\xff\xb0\xff\xb1\xff\xae\xff\xaf\xff\x00\x00\x00\x00\xc4\xff\xc7\xff\xc6\xff\xcb\xff\x5e\xff\x00\x00\x88\xff\x8a\xff\x8b\xff\x89\xff"#

happyCheck :: HappyAddr
happyCheck = HappyA# "\xff\xff\x3a\x00\x01\x00\x02\x00\x31\x00\x0f\x00\x04\x00\x05\x00\x35\x00\x08\x00\x06\x00\x0a\x00\x0b\x00\x19\x00\x47\x00\x48\x00\x0f\x00\x1d\x00\x0e\x00\x0b\x00\x0b\x00\x13\x00\x14\x00\x16\x00\x41\x00\x15\x00\x55\x00\x04\x00\x05\x00\x3a\x00\x0b\x00\x0b\x00\x0d\x00\x0d\x00\x47\x00\x48\x00\x11\x00\x12\x00\x12\x00\x0b\x00\x01\x00\x02\x00\x13\x00\x14\x00\x12\x00\x04\x00\x05\x00\x08\x00\x06\x00\x30\x00\x0b\x00\x3d\x00\x06\x00\x34\x00\x0f\x00\x55\x00\x0e\x00\x38\x00\x39\x00\x55\x00\x0e\x00\x16\x00\x3d\x00\x25\x00\x26\x00\x23\x00\x24\x00\x15\x00\x43\x00\x2b\x00\x0f\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x30\x00\x45\x00\x45\x00\x0b\x00\x34\x00\x0d\x00\x55\x00\x55\x00\x38\x00\x39\x00\x0b\x00\x3d\x00\x0d\x00\x3d\x00\x01\x00\x02\x00\x11\x00\x55\x00\x55\x00\x43\x00\x17\x00\x18\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x04\x00\x05\x00\x03\x00\x03\x00\x08\x00\x08\x00\x07\x00\x07\x00\x0b\x00\x0b\x00\x06\x00\x0d\x00\x0f\x00\x01\x00\x02\x00\x11\x00\x11\x00\x11\x00\x0e\x00\x16\x00\x08\x00\x45\x00\x0a\x00\x0b\x00\x37\x00\x01\x00\x02\x00\x39\x00\x45\x00\x23\x00\x24\x00\x0b\x00\x08\x00\x0d\x00\x16\x00\x0b\x00\x46\x00\x55\x00\x0e\x00\x13\x00\x01\x00\x02\x00\x41\x00\x06\x00\x55\x00\x55\x00\x16\x00\x08\x00\x0b\x00\x2b\x00\x0b\x00\x0e\x00\x12\x00\x0b\x00\x0f\x00\x0d\x00\x06\x00\x06\x00\x06\x00\x00\x00\x12\x00\x16\x00\x0b\x00\x0b\x00\x0e\x00\x0e\x00\x0e\x00\x45\x00\x21\x00\x22\x00\x17\x00\x18\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x55\x00\x23\x00\x24\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x00\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x12\x00\x45\x00\x23\x00\x24\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x55\x00\x06\x00\x23\x00\x24\x00\x06\x00\x08\x00\x06\x00\x06\x00\x0b\x00\x0e\x00\x01\x00\x02\x00\x0e\x00\x06\x00\x0e\x00\x0e\x00\x06\x00\x08\x00\x06\x00\x16\x00\x0b\x00\x0e\x00\x01\x00\x02\x00\x0e\x00\x06\x00\x0e\x00\x04\x00\x05\x00\x08\x00\x06\x00\x16\x00\x0b\x00\x0e\x00\x01\x00\x02\x00\x12\x00\x06\x00\x0e\x00\x23\x00\x24\x00\x08\x00\x11\x00\x16\x00\x0b\x00\x0e\x00\x01\x00\x02\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x0b\x00\x08\x00\x0b\x00\x16\x00\x0b\x00\x0b\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x00\x00\x04\x00\x05\x00\x0a\x00\x16\x00\x08\x00\x23\x00\x24\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x04\x00\x05\x00\x23\x00\x24\x00\x08\x00\x08\x00\x23\x00\x24\x00\x0b\x00\x0a\x00\x01\x00\x02\x00\x23\x00\x24\x00\x23\x00\x24\x00\x0b\x00\x08\x00\x0b\x00\x16\x00\x0b\x00\x0f\x00\x01\x00\x02\x00\x23\x00\x24\x00\x04\x00\x05\x00\x00\x00\x08\x00\x12\x00\x16\x00\x0b\x00\x12\x00\x01\x00\x02\x00\x23\x00\x24\x00\x23\x00\x24\x00\x00\x00\x08\x00\x00\x00\x16\x00\x0b\x00\x55\x00\x01\x00\x02\x00\x1a\x00\x1b\x00\x1c\x00\x23\x00\x24\x00\x08\x00\x00\x00\x16\x00\x0b\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x23\x00\x24\x00\x23\x00\x24\x00\x55\x00\x16\x00\x11\x00\x23\x00\x24\x00\x00\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x12\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x00\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x12\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0b\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x23\x00\x24\x00\x23\x00\x24\x00\x55\x00\x08\x00\x23\x00\x24\x00\x0b\x00\x56\x00\x01\x00\x02\x00\x23\x00\x24\x00\x23\x00\x24\x00\x55\x00\x08\x00\x0c\x00\x16\x00\x0b\x00\x0a\x00\x01\x00\x02\x00\x23\x00\x24\x00\x04\x00\x05\x00\x0a\x00\x08\x00\x55\x00\x16\x00\x0b\x00\x55\x00\x01\x00\x02\x00\x23\x00\x24\x00\x23\x00\x24\x00\x0c\x00\x08\x00\x55\x00\x16\x00\x0b\x00\x0a\x00\x01\x00\x02\x00\x1a\x00\x1b\x00\x1c\x00\x23\x00\x24\x00\x08\x00\x10\x00\x16\x00\x0b\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x23\x00\x24\x00\x23\x00\x24\x00\x0a\x00\x16\x00\x04\x00\x05\x00\x0f\x00\x10\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x09\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x37\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0c\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x09\x00\x0a\x00\x0c\x00\x0d\x00\x55\x00\x08\x00\x23\x00\x24\x00\x0b\x00\x55\x00\x01\x00\x02\x00\x23\x00\x24\x00\x23\x00\x24\x00\x0c\x00\x08\x00\x0c\x00\x16\x00\x0b\x00\x10\x00\x01\x00\x02\x00\x23\x00\x24\x00\x04\x00\x05\x00\x55\x00\x08\x00\x0c\x00\x16\x00\x0b\x00\x0a\x00\x01\x00\x02\x00\x23\x00\x24\x00\x23\x00\x24\x00\x0f\x00\x08\x00\x0c\x00\x16\x00\x0b\x00\x0a\x00\x01\x00\x02\x00\x1a\x00\x1b\x00\x1c\x00\x23\x00\x24\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x23\x00\x24\x00\x23\x00\x24\x00\x0a\x00\x16\x00\x0a\x00\x23\x00\x24\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x37\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x10\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x0f\x00\x0a\x00\x0b\x00\x10\x00\x0d\x00\x0a\x00\x0f\x00\x0a\x00\x11\x00\x0a\x00\x13\x00\x14\x00\x15\x00\x07\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x23\x00\x24\x00\x10\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x00\x00\x2c\x00\x2d\x00\x2e\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x11\x00\x0a\x00\x0b\x00\x12\x00\x0d\x00\x19\x00\x0f\x00\x1d\x00\x11\x00\x1e\x00\x13\x00\x14\x00\x15\x00\x20\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x23\x00\x24\x00\x1f\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x12\x00\x2c\x00\x2d\x00\x2e\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x19\x00\x0a\x00\x0b\x00\x19\x00\x0d\x00\x19\x00\x0f\x00\x1e\x00\x11\x00\x19\x00\x13\x00\x14\x00\x15\x00\x1e\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x23\x00\x24\x00\x19\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x19\x00\x2c\x00\x2d\x00\x2e\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\x0a\x00\x0b\x00\xff\xff\x0d\x00\x23\x00\x24\x00\xff\xff\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x23\x00\x24\x00\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x2c\x00\x2d\x00\x2e\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x23\x00\x24\x00\x0b\x00\xff\xff\x0d\x00\xff\xff\x0f\x00\xff\xff\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x23\x00\x24\x00\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x2c\x00\x2d\x00\x2e\x00\x00\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x23\x00\x24\x00\x0b\x00\xff\xff\x0d\x00\x23\x00\x24\x00\x23\x00\x24\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x17\x00\x18\x00\x23\x00\x24\x00\x01\x00\x02\x00\x21\x00\x22\x00\x22\x00\x23\x00\xff\xff\x04\x00\x05\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x23\x00\x24\x00\x0b\x00\xff\xff\x0d\x00\x0e\x00\x04\x00\x05\x00\x1a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x23\x00\x24\x00\xff\xff\x22\x00\x23\x00\x21\x00\x22\x00\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\x0a\x00\x0b\x00\xff\xff\x0d\x00\x17\x00\x18\x00\x17\x00\x18\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x21\x00\x22\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\x04\x00\x05\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\x0a\x00\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\x04\x00\x05\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x09\x00\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\x0f\x00\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x12\x00\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\x0e\x00\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\x0f\x00\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\xff\xff\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x04\x00\x05\x00\xff\xff\x07\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x04\x00\x05\x00\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x16\x00\xff\xff\xff\xff\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\xff\xff\x1f\x00\x20\x00\xff\xff\xff\xff\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x04\x00\x05\x00\xff\xff\x07\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x04\x00\x05\x00\xff\xff\xff\xff\xff\xff\x04\x00\x05\x00\xff\xff\xff\xff\x16\x00\x04\x00\x05\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\xff\xff\x1f\x00\x20\x00\x04\x00\x05\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x04\x00\x05\x00\xff\xff\xff\xff\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x04\x00\x05\x00\xff\xff\xff\xff\xff\xff\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\xff\xff\xff\xff\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\xff\xff\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x13\x00\xff\xff\xff\xff\xff\xff\x17\x00\x18\x00\x19\x00\x03\x00\x04\x00\x05\x00\x06\x00\xff\xff\xff\xff\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\xff\xff\xff\xff\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff"#

happyTable :: HappyAddr
happyTable = HappyA# "\x00\x00\x63\x00\x2e\x00\x2f\x00\xd5\x00\x3f\x00\x57\x00\x58\x00\xd6\x00\x30\x00\x50\x00\xa7\xff\x31\x00\xd0\x00\x4d\x00\x4e\x00\x3f\x00\xd1\x00\x51\x00\xa4\x00\xa3\x00\x59\x00\x5a\x00\x32\x00\x19\x00\x52\x00\x76\x00\x57\x00\x58\x00\x63\x00\x54\x00\x54\x00\x55\x00\x55\x00\x4d\x00\x4e\x00\x66\x00\x78\x00\x78\x00\x61\x00\x2e\x00\x2f\x00\x94\x00\x5a\x00\x8f\x00\x74\x00\x58\x00\x30\x00\x70\x00\x49\x00\x31\x00\x23\x00\x50\x00\x4a\x00\x3f\x00\x5f\x00\x51\x00\x4b\x00\x1b\x00\x5c\x00\x51\x00\x32\x00\x23\x00\xb1\x00\xb2\x00\x71\x00\x72\x00\x34\x01\x4c\x00\xb3\x00\x3f\x00\x1f\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x49\x00\x56\x00\x56\x00\x54\x00\x4a\x00\x55\x00\xa5\x00\x5f\x00\x4b\x00\x1b\x00\x54\x00\x23\x00\x55\x00\x23\x00\x67\x00\x68\x00\x66\x00\x57\x00\x57\x00\x4c\x00\x3f\x00\x40\x00\x1f\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x2e\x00\x2f\x00\x5c\x00\x58\x00\x69\x00\x8f\x00\x5d\x00\x30\x00\x6a\x00\x6a\x00\x31\x00\x54\x00\x9e\x00\x55\x00\x3f\x00\x2e\x00\x2f\x00\x66\x00\x6b\x00\x6b\x00\x51\x00\x32\x00\x30\x00\x56\x00\xa7\x00\x31\x00\x21\x00\x2e\x00\x2f\x00\x1b\x00\x56\x00\xba\x00\x72\x00\x81\x00\x30\x00\x82\x00\x32\x00\x31\x00\x1f\x00\x57\x00\x9e\x00\x83\x00\x2e\x00\x2f\x00\x19\x00\x63\x00\x57\x00\xda\x00\x32\x00\x30\x00\x64\x00\xce\x00\x31\x00\x51\x00\xcd\x00\x54\x00\x4c\x01\x55\x00\x9a\x00\x63\x00\x63\x00\xff\xff\x78\x00\x32\x00\x96\x00\x95\x00\x51\x00\x51\x00\x51\x00\x56\x00\x1b\x00\x1c\x00\xaf\x00\x40\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x57\x00\xb9\x00\x72\x00\xcc\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x74\x00\xff\xff\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x74\x00\xbe\x00\x56\x00\xb8\x00\x72\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x74\x00\x2e\x00\x2f\x00\x57\x00\x97\x00\xb7\x00\x72\x00\x09\x01\x30\x00\xfe\x00\x41\x01\x31\x00\x51\x00\x2e\x00\x2f\x00\x51\x00\x3a\x01\x51\x00\x51\x00\x36\x01\x30\x00\x35\x01\x32\x00\x31\x00\x51\x00\x2e\x00\x2f\x00\x51\x00\x63\x01\x51\x00\x23\x00\x24\x00\x30\x00\x62\x01\x32\x00\x31\x00\x51\x00\x2e\x00\x2f\x00\xbc\x00\x5b\x01\x51\x00\xb6\x00\x72\x00\x30\x00\xbd\x00\x32\x00\x31\x00\x51\x00\x2e\x00\x2f\x00\xd6\x00\x25\x00\x26\x00\xd7\x00\xb6\x00\x30\x00\xb5\x00\x32\x00\x31\x00\xb4\x00\xd8\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\xff\xff\x5c\x00\x58\x00\xae\x00\x32\x00\xa1\x00\xa5\x00\x72\x00\xad\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x74\x00\xac\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x70\x00\xab\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\xaa\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x74\x00\xa9\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x70\x00\x2e\x00\x2f\x00\x5c\x00\x58\x00\x9c\x00\x72\x00\x3f\x01\x30\x00\x2e\x01\x72\x00\x31\x00\xa8\x00\x2e\x00\x2f\x00\x2d\x01\x72\x00\x2c\x01\x72\x00\xa1\x00\x30\x00\xa0\x00\x32\x00\x31\x00\x9c\x00\x2e\x00\x2f\x00\x2b\x01\x72\x00\x23\x00\x24\x00\xff\xff\x30\x00\x9a\x00\x32\x00\x31\x00\x99\x00\x2e\x00\x2f\x00\x2a\x01\x72\x00\x29\x01\x72\x00\xff\xff\x30\x00\xff\xff\x32\x00\x31\x00\x5c\x00\x2e\x00\x2f\x00\x25\x00\x26\x00\x27\x00\x28\x01\x72\x00\x30\x00\xff\xff\x32\x00\x31\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x27\x01\x72\x00\x24\x01\x72\x00\x94\x00\x32\x00\x93\x00\x22\x01\x72\x00\xff\xff\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x74\x00\x8f\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x70\x00\xff\xff\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x74\x00\x78\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x18\x01\x61\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x70\x00\x2e\x00\x2f\x00\x21\x01\x72\x00\x20\x01\x72\x00\x30\x01\x30\x00\x1f\x01\x72\x00\x31\x00\xff\xff\x2e\x00\x2f\x00\x1e\x01\x72\x00\x1d\x01\x72\x00\x24\x01\x30\x00\x13\x01\x32\x00\x31\x00\x12\x01\x2e\x00\x2f\x00\x1c\x01\x72\x00\x23\x00\x24\x00\x11\x01\x30\x00\x10\x01\x32\x00\x31\x00\x0e\x01\x2e\x00\x2f\x00\x1b\x01\x72\x00\x1a\x01\x72\x00\x09\x01\x30\x00\x02\x01\x32\x00\x31\x00\xe2\x00\x2e\x00\x2f\x00\x25\x00\x26\x00\xd2\x00\x19\x01\x72\x00\x30\x00\xfd\x00\x32\x00\x31\x00\xd3\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x18\x01\x72\x00\x6d\x00\x16\x01\xdb\x00\x32\x00\x0e\x01\x58\x00\x0b\x01\x0c\x01\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x74\x00\x4e\x01\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x70\x00\x21\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\xf5\x00\x45\x01\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x74\x00\x44\x01\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\xe7\x00\x2e\x00\x2f\x00\x02\x01\x03\x01\xff\x00\x00\x01\x43\x01\x30\x00\xfb\x00\x72\x00\x31\x00\x5f\x00\x2e\x00\x2f\x00\xfa\x00\x72\x00\xf9\x00\x72\x00\x41\x01\x30\x00\x3e\x01\x32\x00\x31\x00\x3a\x01\x2e\x00\x2f\x00\xf8\x00\x72\x00\x23\x00\x24\x00\x39\x01\x30\x00\x3c\x01\x32\x00\x31\x00\x65\x01\x2e\x00\x2f\x00\xf6\x00\x72\x00\x6d\x00\xf3\x00\x3f\x00\x30\x00\x31\x01\x32\x00\x31\x00\x62\x01\x2e\x00\x2f\x00\x25\x00\x26\x00\xce\x00\xf2\x00\x72\x00\x30\x00\x61\x01\x32\x00\x31\x00\xcf\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\xf1\x00\x72\x00\xf0\x00\x72\x00\x60\x01\x32\x00\x5f\x01\xef\x00\x72\x00\x5e\x01\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x70\x00\x5d\x01\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x74\x00\x5b\x01\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x70\x00\x21\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x74\x00\x56\x01\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x3f\x00\xbf\x00\x81\x00\x6b\x01\x82\x00\x68\x01\x3f\x00\x67\x01\xc0\x00\x66\x01\x83\x00\x84\x00\x85\x00\x66\x00\x86\x00\x87\x00\x88\x00\xc1\x00\xc2\x00\xc3\x00\xc4\x00\xc5\x00\xc6\x00\xc7\x00\xc8\x00\x89\x00\x8a\x00\xee\x00\x72\x00\x6e\x01\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x76\x00\xc9\x00\xca\x00\xcb\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x61\x00\xbf\x00\x81\x00\x5f\x00\x82\x00\x3d\x00\xe1\x00\x21\x00\xc0\x00\x1f\x00\x83\x00\x84\x00\x85\x00\x1d\x00\x86\x00\x87\x00\x88\x00\xc1\x00\xc2\x00\xc3\x00\xc4\x00\xc5\x00\xc6\x00\xc7\x00\xc8\x00\x89\x00\x8a\x00\xed\x00\x72\x00\x19\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x13\x01\xc9\x00\xca\x00\xcb\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\xe2\x00\xbf\x00\x81\x00\xdb\x00\x82\x00\x48\x01\x3f\x00\x49\x01\xc0\x00\x33\x01\x83\x00\x84\x00\x85\x00\x58\x01\x86\x00\x87\x00\x88\x00\xc1\x00\xc2\x00\xc3\x00\xc4\x00\xc5\x00\xc6\x00\xc7\x00\xc8\x00\x89\x00\x8a\x00\xec\x00\x72\x00\x6c\x01\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x6b\x01\xc9\x00\xca\x00\xcb\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\xbf\x00\x81\x00\x00\x00\x82\x00\xeb\x00\x72\x00\x00\x00\xc0\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\xc1\x00\xc2\x00\xc3\x00\xc4\x00\xc5\x00\xc6\x00\xc7\x00\xc8\x00\x89\x00\x8a\x00\xea\x00\x72\x00\x00\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x00\x00\xc9\x00\xca\x00\xcb\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\xe9\x00\x72\x00\x81\x00\x00\x00\x82\x00\x00\x00\x3f\x00\x00\x00\xc0\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\xc1\x00\xc2\x00\xc3\x00\xc4\x00\xc5\x00\xc6\x00\xc7\x00\xc8\x00\x89\x00\x8a\x00\xe8\x00\x72\x00\x00\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x00\x00\xc9\x00\xca\x00\xcb\x00\xff\xff\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\xe7\x00\x72\x00\x81\x00\x00\x00\x82\x00\x6d\x00\xe5\x00\xe3\x00\x72\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\xdd\x00\x40\x00\xdc\x00\x72\x00\x50\x01\x68\x00\x4c\x01\x1c\x00\x89\x00\x8a\x00\x00\x00\x23\x00\x24\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x4a\x01\x72\x00\x81\x00\x00\x00\x82\x00\x0b\x01\x37\x01\x58\x00\x51\x01\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x52\x01\x29\x00\x2a\x00\x2b\x00\x2c\x00\x59\x01\x72\x00\x00\x00\x89\x00\x8a\x00\x56\x01\x1c\x00\x00\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\xfe\x00\x81\x00\x00\x00\x82\x00\x54\x01\x40\x00\x53\x01\x40\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x89\x00\x8a\x00\x81\x00\xf8\x00\x82\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x69\x01\x1c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x89\x00\x8a\x00\x00\x00\x6c\x00\x24\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x50\x01\x81\x00\x00\x00\x82\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x6d\x00\x29\x00\x6e\x00\x2b\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x89\x00\x8a\x00\x00\x00\x6c\x00\x24\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x4f\x01\x00\x00\x81\x00\x00\x00\x82\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x90\x00\x29\x00\x91\x00\x2b\x00\x2c\x00\x00\x00\x00\x00\x00\x00\x89\x00\x8a\x00\x00\x00\x00\x00\x00\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x00\x00\x81\x00\x00\x00\x82\x00\x00\x00\x3f\x00\x00\x00\x00\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x89\x00\x8a\x00\x81\x00\x00\x00\x82\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x48\x01\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x89\x00\x8a\x00\x81\x00\x47\x01\x82\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x89\x00\x8a\x00\x81\x00\x46\x01\x82\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x89\x00\x8a\x00\x81\x00\x3f\x01\x82\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x89\x00\x8a\x00\x81\x00\x3d\x01\x82\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x89\x00\x8a\x00\x00\x00\x00\x00\x00\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x00\x00\x81\x00\x00\x00\x82\x00\x33\x01\x00\x00\x00\x00\x00\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x89\x00\x8a\x00\x81\x00\x32\x01\x82\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x89\x00\x8a\x00\x00\x00\x00\x00\x00\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x00\x00\x81\x00\x00\x00\x82\x00\x00\x00\x58\x01\x00\x00\x00\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x89\x00\x8a\x00\x81\x00\x69\x01\x82\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x89\x00\x8a\x00\x81\x00\x00\x00\x82\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x81\xff\x81\xff\x81\xff\x81\xff\x81\xff\x81\xff\x81\xff\x81\xff\x89\x00\x8a\x00\x81\xff\x00\x00\x81\xff\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x00\x00\x81\xff\x81\xff\x81\xff\x00\x00\x81\xff\x81\xff\x81\xff\x80\xff\x80\xff\x80\xff\x80\xff\x80\xff\x80\xff\x80\xff\x80\xff\x81\xff\x81\xff\x80\xff\x00\x00\x80\xff\x81\xff\x81\xff\x81\xff\x81\xff\x00\x00\x80\xff\x80\xff\x80\xff\x00\x00\x80\xff\x80\xff\x80\xff\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x80\xff\x80\xff\x81\x00\x00\x00\x82\x00\x80\xff\x80\xff\x80\xff\x80\xff\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x81\xff\x81\xff\x81\xff\x81\xff\x81\xff\x81\xff\x81\xff\x81\xff\x89\x00\x8a\x00\x81\xff\x00\x00\x81\xff\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x00\x00\x81\xff\x81\xff\x81\xff\x00\x00\x81\xff\x81\xff\x81\xff\x80\xff\x80\xff\x80\xff\x80\xff\x80\xff\x80\xff\x80\xff\x80\xff\x81\xff\x81\xff\x80\xff\x00\x00\x80\xff\x81\xff\x81\xff\x81\xff\x81\xff\x00\x00\x80\xff\x80\xff\x80\xff\x00\x00\x80\xff\x80\xff\x80\xff\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x80\xff\x80\xff\x81\x00\x00\x00\x82\x00\x80\xff\x80\xff\x80\xff\x80\xff\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x81\xff\x81\xff\x81\xff\x81\xff\x81\xff\x81\xff\x81\xff\x81\xff\x89\x00\x8a\x00\x81\xff\x00\x00\x81\xff\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x00\x00\x81\xff\x81\xff\x81\xff\x00\x00\x81\xff\x81\xff\x81\xff\x80\xff\x80\xff\x80\xff\x80\xff\x80\xff\x80\xff\x80\xff\x80\xff\x81\xff\x81\xff\x80\xff\x00\x00\x80\xff\x81\xff\x81\xff\x81\xff\x81\xff\x00\x00\x80\xff\x80\xff\x80\xff\x00\x00\x80\xff\x80\xff\x80\xff\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x80\xff\x80\xff\x81\x00\x00\x00\x82\x00\x80\xff\x80\xff\x80\xff\x80\xff\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x89\x00\x00\x00\x81\x00\x00\x00\x82\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x00\x00\x83\x00\x84\x00\x85\x00\x00\x00\x86\x00\x87\x00\x88\x00\x23\x00\x24\x00\x00\x00\x41\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6c\x00\x24\x00\x00\x00\x00\x00\x8b\x00\x8c\x00\x8d\x00\x8e\x00\x00\x00\x42\x00\x00\x00\x00\x00\x43\x00\x25\x00\x26\x00\x44\x00\x45\x00\x00\x00\x46\x00\x47\x00\x00\x00\x00\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x23\x00\x24\x00\x00\x00\x41\x00\x25\x01\x29\x00\x26\x01\x2b\x00\x2c\x00\x6c\x00\x24\x00\x00\x00\x00\x00\x00\x00\x6c\x00\x24\x00\x00\x00\x00\x00\xae\x00\x6c\x00\x24\x00\x43\x00\x25\x00\x26\x00\x44\x00\x45\x00\x00\x00\x46\x00\x47\x00\x6c\x00\x24\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x6c\x00\x24\x00\x00\x00\x00\x00\x14\x01\x29\x00\x15\x01\x2b\x00\x2c\x00\x06\x01\x29\x00\x07\x01\x2b\x00\x2c\x00\x04\x01\x29\x00\x05\x01\x2b\x00\x2c\x00\x6c\x00\x24\x00\x00\x00\x00\x00\x00\x00\x6d\x00\x29\x00\xf5\x00\x2b\x00\x2c\x00\x00\x00\x00\x00\x6d\x00\x29\x00\xe4\x00\x2b\x00\x2c\x00\x00\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00\x80\x00\x00\x00\x00\x00\x81\x00\x00\x00\x82\x00\xde\x00\x29\x00\xdf\x00\x2b\x00\x2c\x00\x83\x00\x00\x00\x00\x00\x00\x00\x86\x00\x87\x00\x88\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x00\x00\x00\x00\x00\x00\x00\x00\x81\x00\x00\x00\x82\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x83\x00\x00\x00\x00\x00\x00\x00\x86\x00\x87\x00\x88\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyReduceArr = Happy_Data_Array.array (23, 173) [
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
	(168 , happyReduce_168),
	(169 , happyReduce_169),
	(170 , happyReduce_170),
	(171 , happyReduce_171),
	(172 , happyReduce_172),
	(173 , happyReduce_173)
	]

happy_n_terms = 87 :: Int
happy_n_nonterms = 40 :: Int

#if __GLASGOW_HASKELL__ >= 710
happyReduce_23 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_23 = happyReduce 4# 0# happyReduction_23
happyReduction_23 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut27 happy_x_4 of { happy_var_4 -> 
	happyIn26
		 (Program {package=getIdent(happy_var_2), topLevels=happy_var_4}
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_24 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_24 = happySpecReduce_1  1# happyReduction_24
happyReduction_24 happy_x_1
	 =  case happyOut28 happy_x_1 of { happy_var_1 -> 
	happyIn27
		 (reverse happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_25 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_25 = happySpecReduce_2  2# happyReduction_25
happyReduction_25 happy_x_2
	happy_x_1
	 =  case happyOut28 happy_x_1 of { happy_var_1 -> 
	case happyOut29 happy_x_2 of { happy_var_2 -> 
	happyIn28
		 (happy_var_2 : happy_var_1
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_26 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_26 = happySpecReduce_0  2# happyReduction_26
happyReduction_26  =  happyIn28
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_27 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_27 = happySpecReduce_1  3# happyReduction_27
happyReduction_27 happy_x_1
	 =  case happyOut33 happy_x_1 of { happy_var_1 -> 
	happyIn29
		 (TopDecl happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_28 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_28 = happySpecReduce_1  3# happyReduction_28
happyReduction_28 happy_x_1
	 =  case happyOut43 happy_x_1 of { happy_var_1 -> 
	happyIn29
		 (TopFuncDecl happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_29 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_29 = happySpecReduce_1  4# happyReduction_29
happyReduction_29 happy_x_1
	 =  case happyOut31 happy_x_1 of { happy_var_1 -> 
	happyIn30
		 ((nonEmpty . reverse) happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_30 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_30 = happySpecReduce_3  5# happyReduction_30
happyReduction_30 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut31 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	happyIn31
		 ((getIdent happy_var_3) : happy_var_1
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_31 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_31 = happySpecReduce_3  5# happyReduction_31
happyReduction_31 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	happyIn31
		 ([getIdent happy_var_3, getIdent happy_var_1]
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_32 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_32 = happySpecReduce_1  6# happyReduction_32
happyReduction_32 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (Type $ getIdent happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_33 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_33 = happySpecReduce_3  6# happyReduction_33
happyReduction_33 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_2 of { happy_var_2 -> 
	happyIn32
		 (happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_34 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_34 = happyReduce 4# 6# happyReduction_34
happyReduction_34 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut61 happy_x_2 of { happy_var_2 -> 
	case happyOut32 happy_x_4 of { happy_var_4 -> 
	happyIn32
		 (ArrayType happy_var_2 happy_var_4
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_35 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_35 = happySpecReduce_3  6# happyReduction_35
happyReduction_35 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_3 of { happy_var_3 -> 
	happyIn32
		 (SliceType happy_var_3
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_36 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_36 = happySpecReduce_1  6# happyReduction_36
happyReduction_36 happy_x_1
	 =  case happyOut40 happy_x_1 of { happy_var_1 -> 
	happyIn32
		 (StructType happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_37 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_37 = happySpecReduce_2  7# happyReduction_37
happyReduction_37 happy_x_2
	happy_x_1
	 =  case happyOut34 happy_x_2 of { happy_var_2 -> 
	happyIn33
		 (VarDecl [happy_var_2]
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_38 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_38 = happyReduce 5# 7# happyReduction_38
happyReduction_38 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut35 happy_x_3 of { happy_var_3 -> 
	happyIn33
		 (VarDecl happy_var_3
	) `HappyStk` happyRest}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_39 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_39 = happyReduce 4# 7# happyReduction_39
happyReduction_39 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut32 happy_x_3 of { happy_var_3 -> 
	happyIn33
		 (TypeDef [TypeDef' (getIdent happy_var_2) happy_var_3]
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_40 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_40 = happyReduce 5# 7# happyReduction_40
happyReduction_40 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut38 happy_x_3 of { happy_var_3 -> 
	happyIn33
		 (TypeDef happy_var_3
	) `HappyStk` happyRest}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_41 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_41 = happySpecReduce_3  8# happyReduction_41
happyReduction_41 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut30 happy_x_1 of { happy_var_1 -> 
	case happyOut37 happy_x_2 of { happy_var_2 -> 
	happyIn34
		 (VarDecl' happy_var_1 happy_var_2
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_42 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_42 = happySpecReduce_3  8# happyReduction_42
happyReduction_42 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut37 happy_x_2 of { happy_var_2 -> 
	happyIn34
		 (VarDecl' (nonEmpty [getIdent happy_var_1]) happy_var_2
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_43 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_43 = happySpecReduce_1  9# happyReduction_43
happyReduction_43 happy_x_1
	 =  case happyOut36 happy_x_1 of { happy_var_1 -> 
	happyIn35
		 (reverse happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_44 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_44 = happySpecReduce_2  10# happyReduction_44
happyReduction_44 happy_x_2
	happy_x_1
	 =  case happyOut36 happy_x_1 of { happy_var_1 -> 
	case happyOut34 happy_x_2 of { happy_var_2 -> 
	happyIn36
		 (happy_var_2 : happy_var_1
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_45 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_45 = happySpecReduce_0  10# happyReduction_45
happyReduction_45  =  happyIn36
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_46 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_46 = happySpecReduce_1  11# happyReduction_46
happyReduction_46 happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	happyIn37
		 (Left (happy_var_1, [])
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_47 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_47 = happySpecReduce_3  11# happyReduction_47
happyReduction_47 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	case happyOut63 happy_x_3 of { happy_var_3 -> 
	happyIn37
		 (Left (happy_var_1, happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_48 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_48 = happySpecReduce_3  11# happyReduction_48
happyReduction_48 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn37
		 (Left (happy_var_1, [happy_var_3])
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_49 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_49 = happySpecReduce_2  11# happyReduction_49
happyReduction_49 happy_x_2
	happy_x_1
	 =  case happyOut63 happy_x_2 of { happy_var_2 -> 
	happyIn37
		 (Right (nonEmpty happy_var_2)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_50 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_50 = happySpecReduce_2  11# happyReduction_50
happyReduction_50 happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_2 of { happy_var_2 -> 
	happyIn37
		 (Right (nonEmpty [happy_var_2])
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_51 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_51 = happySpecReduce_1  12# happyReduction_51
happyReduction_51 happy_x_1
	 =  case happyOut39 happy_x_1 of { happy_var_1 -> 
	happyIn38
		 (reverse happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_52 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_52 = happyReduce 4# 13# happyReduction_52
happyReduction_52 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut39 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut32 happy_x_3 of { happy_var_3 -> 
	happyIn39
		 ((TypeDef' (getIdent happy_var_2) happy_var_3) : happy_var_1
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_53 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_53 = happySpecReduce_3  13# happyReduction_53
happyReduction_53 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut32 happy_x_2 of { happy_var_2 -> 
	happyIn39
		 ([TypeDef' (getIdent happy_var_1) happy_var_2]
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_54 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_54 = happyReduce 4# 14# happyReduction_54
happyReduction_54 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut41 happy_x_3 of { happy_var_3 -> 
	happyIn40
		 (happy_var_3
	) `HappyStk` happyRest}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_55 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_55 = happySpecReduce_1  15# happyReduction_55
happyReduction_55 happy_x_1
	 =  case happyOut42 happy_x_1 of { happy_var_1 -> 
	happyIn41
		 (reverse happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_56 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_56 = happyReduce 4# 16# happyReduction_56
happyReduction_56 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut42 happy_x_1 of { happy_var_1 -> 
	case happyOut30 happy_x_2 of { happy_var_2 -> 
	case happyOut32 happy_x_3 of { happy_var_3 -> 
	happyIn42
		 ((FieldDecl happy_var_2 happy_var_3) : happy_var_1
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_57 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_57 = happyReduce 4# 16# happyReduction_57
happyReduction_57 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut42 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut32 happy_x_3 of { happy_var_3 -> 
	happyIn42
		 ((FieldDecl (nonEmpty [getIdent happy_var_2]) happy_var_3) : happy_var_1
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_58 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_58 = happySpecReduce_0  16# happyReduction_58
happyReduction_58  =  happyIn42
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_59 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_59 = happyReduce 5# 17# happyReduction_59
happyReduction_59 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut44 happy_x_3 of { happy_var_3 -> 
	case happyOut51 happy_x_4 of { happy_var_4 -> 
	happyIn43
		 (FuncDecl (getIdent happy_var_2) happy_var_3 happy_var_4
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_60 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_60 = happyReduce 4# 18# happyReduction_60
happyReduction_60 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut45 happy_x_2 of { happy_var_2 -> 
	case happyOut47 happy_x_4 of { happy_var_4 -> 
	happyIn44
		 (Signature (Parameters happy_var_2) happy_var_4
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_61 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_61 = happySpecReduce_1  19# happyReduction_61
happyReduction_61 happy_x_1
	 =  case happyOut46 happy_x_1 of { happy_var_1 -> 
	happyIn45
		 (reverse happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_62 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_62 = happySpecReduce_0  19# happyReduction_62
happyReduction_62  =  happyIn45
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_63 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_63 = happyReduce 4# 20# happyReduction_63
happyReduction_63 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut46 happy_x_1 of { happy_var_1 -> 
	case happyOut30 happy_x_3 of { happy_var_3 -> 
	case happyOut32 happy_x_4 of { happy_var_4 -> 
	happyIn46
		 ((ParameterDecl happy_var_3 happy_var_4) : happy_var_1
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_64 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_64 = happyReduce 4# 20# happyReduction_64
happyReduction_64 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut46 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	case happyOut32 happy_x_4 of { happy_var_4 -> 
	happyIn46
		 ((ParameterDecl (nonEmpty [getIdent happy_var_3]) happy_var_4) : happy_var_1
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_65 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_65 = happySpecReduce_2  20# happyReduction_65
happyReduction_65 happy_x_2
	happy_x_1
	 =  case happyOut30 happy_x_1 of { happy_var_1 -> 
	case happyOut32 happy_x_2 of { happy_var_2 -> 
	happyIn46
		 ([(ParameterDecl happy_var_1 happy_var_2)]
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_66 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_66 = happySpecReduce_2  20# happyReduction_66
happyReduction_66 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut32 happy_x_2 of { happy_var_2 -> 
	happyIn46
		 ([(ParameterDecl (nonEmpty [getIdent happy_var_1]) happy_var_2)]
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_67 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_67 = happySpecReduce_1  21# happyReduction_67
happyReduction_67 happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	happyIn47
		 (Just happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_68 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_68 = happySpecReduce_0  21# happyReduction_68
happyReduction_68  =  happyIn47
		 (Nothing
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_69 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_69 = happySpecReduce_2  22# happyReduction_69
happyReduction_69 happy_x_2
	happy_x_1
	 =  case happyOut51 happy_x_1 of { happy_var_1 -> 
	happyIn48
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_70 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_70 = happySpecReduce_1  22# happyReduction_70
happyReduction_70 happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	happyIn48
		 (SimpleStmt happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_71 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_71 = happySpecReduce_2  22# happyReduction_71
happyReduction_71 happy_x_2
	happy_x_1
	 =  case happyOut55 happy_x_1 of { happy_var_1 -> 
	happyIn48
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_72 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_72 = happySpecReduce_2  22# happyReduction_72
happyReduction_72 happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	happyIn48
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_73 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_73 = happySpecReduce_2  22# happyReduction_73
happyReduction_73 happy_x_2
	happy_x_1
	 =  case happyOut58 happy_x_1 of { happy_var_1 -> 
	happyIn48
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_74 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_74 = happySpecReduce_2  22# happyReduction_74
happyReduction_74 happy_x_2
	happy_x_1
	 =  happyIn48
		 (Break
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_75 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_75 = happySpecReduce_2  22# happyReduction_75
happyReduction_75 happy_x_2
	happy_x_1
	 =  happyIn48
		 (Continue
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_76 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_76 = happySpecReduce_2  22# happyReduction_76
happyReduction_76 happy_x_2
	happy_x_1
	 =  happyIn48
		 (Fallthrough
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_77 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_77 = happySpecReduce_1  22# happyReduction_77
happyReduction_77 happy_x_1
	 =  case happyOut33 happy_x_1 of { happy_var_1 -> 
	happyIn48
		 (Declare happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_78 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_78 = happyReduce 5# 22# happyReduction_78
happyReduction_78 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut63 happy_x_3 of { happy_var_3 -> 
	happyIn48
		 (Print happy_var_3
	) `HappyStk` happyRest}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_79 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_79 = happyReduce 5# 22# happyReduction_79
happyReduction_79 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn48
		 (Print [happy_var_3]
	) `HappyStk` happyRest}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_80 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_80 = happyReduce 5# 22# happyReduction_80
happyReduction_80 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut63 happy_x_3 of { happy_var_3 -> 
	happyIn48
		 (Println happy_var_3
	) `HappyStk` happyRest}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_81 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_81 = happyReduce 5# 22# happyReduction_81
happyReduction_81 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn48
		 (Println [happy_var_3]
	) `HappyStk` happyRest}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_82 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_82 = happySpecReduce_3  22# happyReduction_82
happyReduction_82 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_2 of { happy_var_2 -> 
	happyIn48
		 (Return $ Just happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_83 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_83 = happySpecReduce_2  22# happyReduction_83
happyReduction_83 happy_x_2
	happy_x_1
	 =  happyIn48
		 (Return Nothing
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_84 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_84 = happySpecReduce_1  23# happyReduction_84
happyReduction_84 happy_x_1
	 =  case happyOut50 happy_x_1 of { happy_var_1 -> 
	happyIn49
		 (reverse happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_85 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_85 = happySpecReduce_2  24# happyReduction_85
happyReduction_85 happy_x_2
	happy_x_1
	 =  case happyOut50 happy_x_1 of { happy_var_1 -> 
	case happyOut48 happy_x_2 of { happy_var_2 -> 
	happyIn50
		 (happy_var_2 : happy_var_1
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_86 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_86 = happySpecReduce_0  24# happyReduction_86
happyReduction_86  =  happyIn50
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_87 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_87 = happySpecReduce_3  25# happyReduction_87
happyReduction_87 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut49 happy_x_2 of { happy_var_2 -> 
	happyIn51
		 (BlockStmt happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_88 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_88 = happySpecReduce_0  26# happyReduction_88
happyReduction_88  =  happyIn52
		 (EmptyStmt
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_89 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_89 = happySpecReduce_2  26# happyReduction_89
happyReduction_89 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn52
		 (Increment $ Var (getIdent happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_90 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_90 = happySpecReduce_2  26# happyReduction_90
happyReduction_90 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn52
		 (Decrement $ Var (getIdent happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_91 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_91 = happySpecReduce_3  26# happyReduction_91
happyReduction_91 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut63 happy_x_1 of { happy_var_1 -> 
	case happyOut63 happy_x_3 of { happy_var_3 -> 
	happyIn52
		 (Assign (AssignOp Nothing) (nonEmpty happy_var_1) (nonEmpty happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_92 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_92 = happySpecReduce_3  26# happyReduction_92
happyReduction_92 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn52
		 (Assign (AssignOp $ Just Add) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_93 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_93 = happySpecReduce_3  26# happyReduction_93
happyReduction_93 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn52
		 (Assign (AssignOp $ Just Subtract) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_94 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_94 = happySpecReduce_3  26# happyReduction_94
happyReduction_94 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn52
		 (Assign (AssignOp $ Just BitOr) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_95 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_95 = happySpecReduce_3  26# happyReduction_95
happyReduction_95 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn52
		 (Assign (AssignOp $ Just BitXor) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_96 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_96 = happySpecReduce_3  26# happyReduction_96
happyReduction_96 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn52
		 (Assign (AssignOp $ Just Multiply) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_97 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_97 = happySpecReduce_3  26# happyReduction_97
happyReduction_97 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn52
		 (Assign (AssignOp $ Just Divide) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_98 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_98 = happySpecReduce_3  26# happyReduction_98
happyReduction_98 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn52
		 (Assign (AssignOp $ Just Remainder) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_99 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_99 = happySpecReduce_3  26# happyReduction_99
happyReduction_99 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn52
		 (Assign (AssignOp $ Just ShiftL) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_100 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_100 = happySpecReduce_3  26# happyReduction_100
happyReduction_100 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn52
		 (Assign (AssignOp $ Just ShiftR) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_101 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_101 = happySpecReduce_3  26# happyReduction_101
happyReduction_101 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn52
		 (Assign (AssignOp $ Just BitAnd) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_102 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_102 = happySpecReduce_3  26# happyReduction_102
happyReduction_102 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn52
		 (Assign (AssignOp $ Just BitClear) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_103 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_103 = happySpecReduce_3  26# happyReduction_103
happyReduction_103 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn52
		 (Assign (AssignOp Nothing) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_104 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_104 = happySpecReduce_3  26# happyReduction_104
happyReduction_104 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut30 happy_x_1 of { happy_var_1 -> 
	case happyOut63 happy_x_3 of { happy_var_3 -> 
	happyIn52
		 (ShortDeclare happy_var_1 (nonEmpty happy_var_3)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_105 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_105 = happySpecReduce_3  26# happyReduction_105
happyReduction_105 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn52
		 (ShortDeclare (nonEmpty [getIdent happy_var_1]) (nonEmpty [happy_var_3])
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_106 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_106 = happySpecReduce_2  27# happyReduction_106
happyReduction_106 happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	happyIn53
		 (ExprStmt happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_107 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_107 = happySpecReduce_2  28# happyReduction_107
happyReduction_107 happy_x_2
	happy_x_1
	 =  case happyOut52 happy_x_1 of { happy_var_1 -> 
	happyIn54
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_108 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_108 = happySpecReduce_1  28# happyReduction_108
happyReduction_108 happy_x_1
	 =  case happyOut53 happy_x_1 of { happy_var_1 -> 
	happyIn54
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_109 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_109 = happyReduce 5# 29# happyReduction_109
happyReduction_109 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut54 happy_x_2 of { happy_var_2 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	case happyOut51 happy_x_4 of { happy_var_4 -> 
	case happyOut56 happy_x_5 of { happy_var_5 -> 
	happyIn55
		 (If (happy_var_2, happy_var_3) happy_var_4 happy_var_5
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_110 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_110 = happyReduce 4# 29# happyReduction_110
happyReduction_110 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut61 happy_x_2 of { happy_var_2 -> 
	case happyOut51 happy_x_3 of { happy_var_3 -> 
	case happyOut56 happy_x_4 of { happy_var_4 -> 
	happyIn55
		 (If (EmptyStmt, happy_var_2) happy_var_3 happy_var_4
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_111 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_111 = happySpecReduce_2  30# happyReduction_111
happyReduction_111 happy_x_2
	happy_x_1
	 =  case happyOut55 happy_x_2 of { happy_var_2 -> 
	happyIn56
		 (happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_112 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_112 = happySpecReduce_2  30# happyReduction_112
happyReduction_112 happy_x_2
	happy_x_1
	 =  case happyOut51 happy_x_2 of { happy_var_2 -> 
	happyIn56
		 (happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_113 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_113 = happySpecReduce_0  30# happyReduction_113
happyReduction_113  =  happyIn56
		 (blank
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_114 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_114 = happySpecReduce_2  31# happyReduction_114
happyReduction_114 happy_x_2
	happy_x_1
	 =  case happyOut51 happy_x_2 of { happy_var_2 -> 
	happyIn57
		 (For ForInfinite happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_115 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_115 = happySpecReduce_3  31# happyReduction_115
happyReduction_115 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_2 of { happy_var_2 -> 
	case happyOut51 happy_x_3 of { happy_var_3 -> 
	happyIn57
		 (For (ForCond happy_var_2) happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_116 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_116 = happyReduce 6# 31# happyReduction_116
happyReduction_116 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut54 happy_x_2 of { happy_var_2 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	case happyOut52 happy_x_5 of { happy_var_5 -> 
	case happyOut51 happy_x_6 of { happy_var_6 -> 
	happyIn57
		 (For (ForClause happy_var_2 happy_var_3 happy_var_5) happy_var_6
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_117 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_117 = happyReduce 6# 31# happyReduction_117
happyReduction_117 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut54 happy_x_2 of { happy_var_2 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	case happyOut61 happy_x_5 of { happy_var_5 -> 
	case happyOut51 happy_x_6 of { happy_var_6 -> 
	happyIn57
		 (For (ForClause happy_var_2 happy_var_3 (ExprStmt happy_var_5)) happy_var_6
	) `HappyStk` happyRest}}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_118 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_118 = happyReduce 7# 32# happyReduction_118
happyReduction_118 (happy_x_7 `HappyStk`
	happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut54 happy_x_2 of { happy_var_2 -> 
	case happyOut61 happy_x_4 of { happy_var_4 -> 
	case happyOut59 happy_x_6 of { happy_var_6 -> 
	happyIn58
		 (Switch happy_var_2 (Just happy_var_4) happy_var_6
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_119 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_119 = happyReduce 6# 32# happyReduction_119
happyReduction_119 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut54 happy_x_2 of { happy_var_2 -> 
	case happyOut59 happy_x_5 of { happy_var_5 -> 
	happyIn58
		 (Switch happy_var_2 Nothing happy_var_5
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_120 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_120 = happyReduce 5# 32# happyReduction_120
happyReduction_120 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut61 happy_x_2 of { happy_var_2 -> 
	case happyOut59 happy_x_4 of { happy_var_4 -> 
	happyIn58
		 (Switch EmptyStmt (Just happy_var_2) happy_var_4
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_121 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_121 = happySpecReduce_1  33# happyReduction_121
happyReduction_121 happy_x_1
	 =  case happyOut60 happy_x_1 of { happy_var_1 -> 
	happyIn59
		 (reverse happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_122 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_122 = happyReduce 5# 34# happyReduction_122
happyReduction_122 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut60 happy_x_1 of { happy_var_1 -> 
	case happyOut63 happy_x_3 of { happy_var_3 -> 
	case happyOut49 happy_x_5 of { happy_var_5 -> 
	happyIn60
		 ((Case (nonEmpty happy_var_3) (BlockStmt happy_var_5)) : happy_var_1
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_123 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_123 = happyReduce 5# 34# happyReduction_123
happyReduction_123 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut60 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	case happyOut49 happy_x_5 of { happy_var_5 -> 
	happyIn60
		 ((Case (nonEmpty [happy_var_3]) (BlockStmt happy_var_5)) : happy_var_1
	) `HappyStk` happyRest}}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_124 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_124 = happySpecReduce_3  34# happyReduction_124
happyReduction_124 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut60 happy_x_1 of { happy_var_1 -> 
	case happyOut49 happy_x_3 of { happy_var_3 -> 
	happyIn60
		 ((Default $ BlockStmt happy_var_3) : happy_var_1
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_125 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_125 = happySpecReduce_0  34# happyReduction_125
happyReduction_125  =  happyIn60
		 ([]
	)

#if __GLASGOW_HASKELL__ >= 710
happyReduce_126 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_126 = happySpecReduce_1  35# happyReduction_126
happyReduction_126 happy_x_1
	 =  case happyOut62 happy_x_1 of { happy_var_1 -> 
	happyIn61
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_127 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_127 = happySpecReduce_1  35# happyReduction_127
happyReduction_127 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn61
		 (Var (getIdent happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_128 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_128 = happySpecReduce_2  36# happyReduction_128
happyReduction_128 happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_2 of { happy_var_2 -> 
	happyIn62
		 (Unary Pos happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_129 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_129 = happySpecReduce_2  36# happyReduction_129
happyReduction_129 happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_2 of { happy_var_2 -> 
	happyIn62
		 (Unary Neg happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_130 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_130 = happySpecReduce_2  36# happyReduction_130
happyReduction_130 happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_2 of { happy_var_2 -> 
	happyIn62
		 (Unary Not happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_131 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_131 = happySpecReduce_2  36# happyReduction_131
happyReduction_131 happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_2 of { happy_var_2 -> 
	happyIn62
		 (Unary BitComplement happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_132 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_132 = happySpecReduce_3  36# happyReduction_132
happyReduction_132 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 Or happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_133 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_133 = happySpecReduce_3  36# happyReduction_133
happyReduction_133 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 And happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_134 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_134 = happySpecReduce_3  36# happyReduction_134
happyReduction_134 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 Data.EQ happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_135 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_135 = happySpecReduce_3  36# happyReduction_135
happyReduction_135 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 NEQ happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_136 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_136 = happySpecReduce_3  36# happyReduction_136
happyReduction_136 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 Data.LT happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_137 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_137 = happySpecReduce_3  36# happyReduction_137
happyReduction_137 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 LEQ happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_138 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_138 = happySpecReduce_3  36# happyReduction_138
happyReduction_138 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 Data.GT happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_139 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_139 = happySpecReduce_3  36# happyReduction_139
happyReduction_139 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 GEQ happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_140 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_140 = happySpecReduce_3  36# happyReduction_140
happyReduction_140 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 (Arithm Add) happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_141 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_141 = happySpecReduce_3  36# happyReduction_141
happyReduction_141 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 (Arithm Subtract) happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_142 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_142 = happySpecReduce_3  36# happyReduction_142
happyReduction_142 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 (Arithm Multiply) happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_143 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_143 = happySpecReduce_3  36# happyReduction_143
happyReduction_143 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 (Arithm Divide) happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_144 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_144 = happySpecReduce_3  36# happyReduction_144
happyReduction_144 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 (Arithm Remainder) happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_145 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_145 = happySpecReduce_3  36# happyReduction_145
happyReduction_145 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 (Arithm BitOr) happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_146 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_146 = happySpecReduce_3  36# happyReduction_146
happyReduction_146 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 (Arithm BitXor) happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_147 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_147 = happySpecReduce_3  36# happyReduction_147
happyReduction_147 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 (Arithm BitAnd) happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_148 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_148 = happySpecReduce_3  36# happyReduction_148
happyReduction_148 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 (Arithm BitClear) happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_149 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_149 = happySpecReduce_3  36# happyReduction_149
happyReduction_149 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 (Arithm ShiftL) happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_150 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_150 = happySpecReduce_3  36# happyReduction_150
happyReduction_150 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Binary happy_var_1 (Arithm ShiftR) happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_151 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_151 = happySpecReduce_3  36# happyReduction_151
happyReduction_151 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_2 of { happy_var_2 -> 
	happyIn62
		 (happy_var_2
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_152 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_152 = happySpecReduce_3  36# happyReduction_152
happyReduction_152 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Selector happy_var_1 $ getIdent happy_var_3
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_153 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_153 = happyReduce 4# 36# happyReduction_153
happyReduction_153 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Index happy_var_1 happy_var_3
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_154 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_154 = happySpecReduce_1  36# happyReduction_154
happyReduction_154 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn62
		 (Lit (IntLit Decimal $ getInnerString happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_155 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_155 = happySpecReduce_1  36# happyReduction_155
happyReduction_155 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn62
		 (Lit (IntLit Octal $ getInnerString happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_156 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_156 = happySpecReduce_1  36# happyReduction_156
happyReduction_156 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn62
		 (Lit (IntLit Hexadecimal $ getInnerString happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_157 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_157 = happySpecReduce_1  36# happyReduction_157
happyReduction_157 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn62
		 (Lit (FloatLit $ getInnerFloat happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_158 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_158 = happySpecReduce_1  36# happyReduction_158
happyReduction_158 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn62
		 (Lit (RuneLit $ getInnerChar happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_159 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_159 = happySpecReduce_1  36# happyReduction_159
happyReduction_159 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn62
		 (Lit (StringLit Interpreted $ getInnerString happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_160 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_160 = happySpecReduce_1  36# happyReduction_160
happyReduction_160 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn62
		 (Lit (StringLit Raw $ getInnerString happy_var_1)
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_161 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_161 = happyReduce 6# 36# happyReduction_161
happyReduction_161 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut61 happy_x_3 of { happy_var_3 -> 
	case happyOut61 happy_x_5 of { happy_var_5 -> 
	happyIn62
		 (AppendExpr happy_var_3 happy_var_5
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_162 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_162 = happyReduce 4# 36# happyReduction_162
happyReduction_162 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (LenExpr happy_var_3
	) `HappyStk` happyRest}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_163 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_163 = happyReduce 4# 36# happyReduction_163
happyReduction_163 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (CapExpr happy_var_3
	) `HappyStk` happyRest}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_164 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_164 = happyReduce 4# 36# happyReduction_164
happyReduction_164 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Arguments happy_var_1 [happy_var_3]
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_165 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_165 = happyReduce 4# 36# happyReduction_165
happyReduction_165 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut61 happy_x_1 of { happy_var_1 -> 
	case happyOut63 happy_x_3 of { happy_var_3 -> 
	happyIn62
		 (Arguments happy_var_1 happy_var_3
	) `HappyStk` happyRest}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_166 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_166 = happySpecReduce_1  37# happyReduction_166
happyReduction_166 happy_x_1
	 =  case happyOut64 happy_x_1 of { happy_var_1 -> 
	happyIn63
		 (happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_167 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_167 = happySpecReduce_1  37# happyReduction_167
happyReduction_167 happy_x_1
	 =  case happyOut30 happy_x_1 of { happy_var_1 -> 
	happyIn63
		 (map varOfI $ NonEmpty.toList happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_168 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_168 = happySpecReduce_1  38# happyReduction_168
happyReduction_168 happy_x_1
	 =  case happyOut65 happy_x_1 of { happy_var_1 -> 
	happyIn64
		 (reverse happy_var_1
	)}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_169 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_169 = happySpecReduce_3  39# happyReduction_169
happyReduction_169 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut65 happy_x_1 of { happy_var_1 -> 
	case happyOut61 happy_x_3 of { happy_var_3 -> 
	happyIn65
		 (happy_var_3 : happy_var_1
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_170 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_170 = happySpecReduce_3  39# happyReduction_170
happyReduction_170 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut31 happy_x_1 of { happy_var_1 -> 
	case happyOut62 happy_x_3 of { happy_var_3 -> 
	happyIn65
		 (happy_var_3 : (map varOfI happy_var_1)
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_171 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_171 = happySpecReduce_3  39# happyReduction_171
happyReduction_171 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut62 happy_x_1 of { happy_var_1 -> 
	case happyOut62 happy_x_3 of { happy_var_3 -> 
	happyIn65
		 ([happy_var_3, happy_var_1]
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_172 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_172 = happySpecReduce_3  39# happyReduction_172
happyReduction_172 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut62 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	happyIn65
		 ([(varOfI . getIdent) happy_var_3, happy_var_1]
	)}}

#if __GLASGOW_HASKELL__ >= 710
happyReduce_173 :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)
#endif
happyReduce_173 = happySpecReduce_3  39# happyReduction_173
happyReduction_173 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut62 happy_x_3 of { happy_var_3 -> 
	happyIn65
		 ([happy_var_3, (varOfI . getIdent) happy_var_1]
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
	_ -> happyError' (tk, [])
	})

happyError_ explist 86# tk = happyError' (tk, explist)
happyError_ explist _ tk = happyError' (tk, explist)

happyThen :: () => Alex a -> (a -> Alex b) -> Alex b
happyThen = (>>=)
happyReturn :: () => a -> Alex a
happyReturn = (return)
#if __GLASGOW_HASKELL__ >= 710
happyParse :: () => Happy_GHC_Exts.Int# -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)

happyNewToken :: () => Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)

happyDoAction :: () => Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _)

happyReduceArr :: () => Happy_Data_Array.Array Int (Happy_GHC_Exts.Int# -> Token -> Happy_GHC_Exts.Int# -> Happy_IntList -> HappyStk (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _) -> Alex (HappyAbsSyn _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _))

#endif
happyThen1 :: () => Alex a -> (a -> Alex b) -> Alex b
happyThen1 = happyThen
happyReturn1 :: () => a -> Alex a
happyReturn1 = happyReturn
happyError' :: () => ((Token), [String]) -> Alex a
happyError' tk = parseError tk
hparse = happySomeParser where
 happySomeParser = happyThen (happyParse 0#) (\x -> happyReturn (happyOut26 x))

pId = happySomeParser where
 happySomeParser = happyThen (happyParse 1#) (\x -> happyReturn (happyOut30 x))

pE = happySomeParser where
 happySomeParser = happyThen (happyParse 2#) (\x -> happyReturn (happyOut61 x))

pT = happySomeParser where
 happySomeParser = happyThen (happyParse 3#) (\x -> happyReturn (happyOut32 x))

pEl = happySomeParser where
 happySomeParser = happyThen (happyParse 4#) (\x -> happyReturn (happyOut63 x))

pTDecl = happySomeParser where
 happySomeParser = happyThen (happyParse 5#) (\x -> happyReturn (happyOut29 x))

pTDecls = happySomeParser where
 happySomeParser = happyThen (happyParse 6#) (\x -> happyReturn (happyOut27 x))

pDec = happySomeParser where
 happySomeParser = happyThen (happyParse 7#) (\x -> happyReturn (happyOut33 x))

pDecB = happySomeParser where
 happySomeParser = happyThen (happyParse 8#) (\x -> happyReturn (happyOut37 x))

pFDec = happySomeParser where
 happySomeParser = happyThen (happyParse 9#) (\x -> happyReturn (happyOut43 x))

pSig = happySomeParser where
 happySomeParser = happyThen (happyParse 10#) (\x -> happyReturn (happyOut44 x))

pIDecl = happySomeParser where
 happySomeParser = happyThen (happyParse 11#) (\x -> happyReturn (happyOut34 x))

pPar = happySomeParser where
 happySomeParser = happyThen (happyParse 12#) (\x -> happyReturn (happyOut45 x))

pRes = happySomeParser where
 happySomeParser = happyThen (happyParse 13#) (\x -> happyReturn (happyOut47 x))

pStmt = happySomeParser where
 happySomeParser = happyThen (happyParse 14#) (\x -> happyReturn (happyOut48 x))

pStmts = happySomeParser where
 happySomeParser = happyThen (happyParse 15#) (\x -> happyReturn (happyOut49 x))

pBStmt = happySomeParser where
 happySomeParser = happyThen (happyParse 16#) (\x -> happyReturn (happyOut51 x))

pSStmt = happySomeParser where
 happySomeParser = happyThen (happyParse 17#) (\x -> happyReturn (happyOut54 x))

pIf = happySomeParser where
 happySomeParser = happyThen (happyParse 18#) (\x -> happyReturn (happyOut55 x))

pElses = happySomeParser where
 happySomeParser = happyThen (happyParse 19#) (\x -> happyReturn (happyOut56 x))

pSwS = happySomeParser where
 happySomeParser = happyThen (happyParse 20#) (\x -> happyReturn (happyOut58 x))

pSwB = happySomeParser where
 happySomeParser = happyThen (happyParse 21#) (\x -> happyReturn (happyOut59 x))

pFor = happySomeParser where
 happySomeParser = happyThen (happyParse 22#) (\x -> happyReturn (happyOut57 x))

happySeq = happyDontSeq


-- Helper functions

varOfI :: Identifier -> Expr
varOfI i = Var i

nonEmpty :: [a] -> NonEmpty a
nonEmpty l = NonEmpty.fromList l

getIdent :: Token -> Identifier
getIdent (Token _ (TIdent id)) = id

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
parse s = runAlex s $ hparse

-- Extract posn only
ptokl t = case t of
          Token pos _ -> pos

-- parseError function for better error messages
parseError :: (Token, [String]) -> Alex a
parseError (Token (AlexPn _ l c) t, strs) =                                           -- Megaparsec error reporting here
  alexError ("Error: parsing error, unexpected " ++ (prettify t) ++ " at line " ++ show l ++ " column " ++ show c ++ ", expecting " ++ show strs)
{-# LINE 1 "templates/GenericTemplate.hs" #-}

















































































































































































































-- Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp 













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


data Happy_IntList = HappyCons Happy_GHC_Exts.Int# Happy_IntList




















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
                                     happyFail (happyExpListPerState ((Happy_GHC_Exts.I# (st)) :: Int)) i tk st
                -1#          -> {- nothing -}
                                     happyAccept i tk st
                n | LT(n,(0# :: Happy_GHC_Exts.Int#)) -> {- nothing -}
                                                   
                                                   (happyReduceArr Happy_Data_Array.! rule) i tk st
                                                   where rule = (Happy_GHC_Exts.I# ((Happy_GHC_Exts.negateInt# ((n Happy_GHC_Exts.+# (1# :: Happy_GHC_Exts.Int#))))))
                n                 -> {- nothing -}
                                     

                                     happyShift new_state i tk st
                                     where new_state = (n Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#))
   where off    = happyAdjustOffset (indexShortOffAddr happyActOffsets st)
         off_i  = (off Happy_GHC_Exts.+#  i)
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




{-# INLINE happyLt #-}
happyLt x y = LT(x,y)


readArrayBit arr bit =
    Bits.testBit (Happy_GHC_Exts.I# (indexShortOffAddr arr ((unbox_int bit) `Happy_GHC_Exts.iShiftRA#` 4#))) (bit `mod` 16)
  where unbox_int (Happy_GHC_Exts.I# x) = x






data HappyAddr = HappyA# Happy_GHC_Exts.Addr#


-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



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
     = happyFail [] 0# tk st sts stk
happySpecReduce_0 nt fn j tk st@((action)) sts stk
     = happyGoto nt j tk st (HappyCons (st) (sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@((HappyCons (st@(action)) (_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happySpecReduce_2 nt fn j tk _ (HappyCons (_) (sts@((HappyCons (st@(action)) (_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happySpecReduce_3 nt fn j tk _ (HappyCons (_) ((HappyCons (_) (sts@((HappyCons (st@(action)) (_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (happyGoto nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Happy_GHC_Exts.-# (1# :: Happy_GHC_Exts.Int#)) sts of
         sts1@((HappyCons (st1@(action)) (_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (happyGoto nt j tk st1 sts1 r)

happyMonadReduce k nt fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k (HappyCons (st) (sts)) of
        sts1@((HappyCons (st1@(action)) (_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> happyGoto nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn 0# tk st sts stk
     = happyFail [] 0# tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k (HappyCons (st) (sts)) of
        sts1@((HappyCons (st1@(action)) (_))) ->
         let drop_stk = happyDropStk k stk

             off = happyAdjustOffset (indexShortOffAddr happyGotoOffsets st1)
             off_i = (off Happy_GHC_Exts.+#  nt)
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
   where off = happyAdjustOffset (indexShortOffAddr happyGotoOffsets st)
         off_i = (off Happy_GHC_Exts.+#  nt)
         new_state = indexShortOffAddr happyTable off_i




-----------------------------------------------------------------------------
-- Error recovery (0# is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist 0# tk old_st _ stk@(x `HappyStk` _) =
     let i = (case Happy_GHC_Exts.unsafeCoerce# x of { (Happy_GHC_Exts.I# (i)) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

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
happyFail explist i tk (action) sts stk =
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

