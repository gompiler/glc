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

newtype HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60 = HappyAbsSyn HappyAny
#if __GLASGOW_HASKELL__ >= 607
type HappyAny = Happy_GHC_Exts.Any
#else
type HappyAny = forall a . a
#endif
happyIn29 :: t29 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn29 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn29 #-}
happyOut29 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t29
happyOut29 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut29 #-}
happyIn30 :: t30 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn30 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn30 #-}
happyOut30 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t30
happyOut30 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut30 #-}
happyIn31 :: t31 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn31 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn31 #-}
happyOut31 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t31
happyOut31 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut31 #-}
happyIn32 :: t32 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn32 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn32 #-}
happyOut32 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t32
happyOut32 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut32 #-}
happyIn33 :: t33 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn33 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn33 #-}
happyOut33 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t33
happyOut33 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut33 #-}
happyIn34 :: t34 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn34 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn34 #-}
happyOut34 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t34
happyOut34 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut34 #-}
happyIn35 :: t35 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn35 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn35 #-}
happyOut35 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t35
happyOut35 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut35 #-}
happyIn36 :: t36 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn36 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn36 #-}
happyOut36 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t36
happyOut36 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut36 #-}
happyIn37 :: t37 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn37 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn37 #-}
happyOut37 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t37
happyOut37 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut37 #-}
happyIn38 :: t38 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn38 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn38 #-}
happyOut38 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t38
happyOut38 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut38 #-}
happyIn39 :: t39 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn39 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn39 #-}
happyOut39 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t39
happyOut39 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut39 #-}
happyIn40 :: t40 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn40 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn40 #-}
happyOut40 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t40
happyOut40 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut40 #-}
happyIn41 :: t41 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn41 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn41 #-}
happyOut41 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t41
happyOut41 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut41 #-}
happyIn42 :: t42 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn42 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn42 #-}
happyOut42 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t42
happyOut42 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut42 #-}
happyIn43 :: t43 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn43 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn43 #-}
happyOut43 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t43
happyOut43 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut43 #-}
happyIn44 :: t44 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn44 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn44 #-}
happyOut44 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t44
happyOut44 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut44 #-}
happyIn45 :: t45 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn45 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn45 #-}
happyOut45 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t45
happyOut45 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut45 #-}
happyIn46 :: t46 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn46 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn46 #-}
happyOut46 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t46
happyOut46 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut46 #-}
happyIn47 :: t47 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn47 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn47 #-}
happyOut47 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t47
happyOut47 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut47 #-}
happyIn48 :: t48 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn48 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn48 #-}
happyOut48 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t48
happyOut48 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut48 #-}
happyIn49 :: t49 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn49 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn49 #-}
happyOut49 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t49
happyOut49 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut49 #-}
happyIn50 :: t50 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn50 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn50 #-}
happyOut50 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t50
happyOut50 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut50 #-}
happyIn51 :: t51 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn51 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn51 #-}
happyOut51 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t51
happyOut51 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut51 #-}
happyIn52 :: t52 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn52 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn52 #-}
happyOut52 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t52
happyOut52 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut52 #-}
happyIn53 :: t53 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn53 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn53 #-}
happyOut53 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t53
happyOut53 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut53 #-}
happyIn54 :: t54 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn54 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn54 #-}
happyOut54 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t54
happyOut54 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut54 #-}
happyIn55 :: t55 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn55 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn55 #-}
happyOut55 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t55
happyOut55 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut55 #-}
happyIn56 :: t56 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn56 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn56 #-}
happyOut56 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t56
happyOut56 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut56 #-}
happyIn57 :: t57 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn57 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn57 #-}
happyOut57 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t57
happyOut57 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut57 #-}
happyIn58 :: t58 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn58 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn58 #-}
happyOut58 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t58
happyOut58 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut58 #-}
happyIn59 :: t59 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn59 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn59 #-}
happyOut59 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t59
happyOut59 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut59 #-}
happyIn60 :: t60 -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyIn60 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyIn60 #-}
happyOut60 :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> t60
happyOut60 x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOut60 #-}
happyInTok :: (Token) -> (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60)
happyInTok x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyInTok #-}
happyOutTok :: (HappyAbsSyn t29 t30 t31 t32 t33 t34 t35 t36 t37 t38 t39 t40 t41 t42 t43 t44 t45 t46 t47 t48 t49 t50 t51 t52 t53 t54 t55 t56 t57 t58 t59 t60) -> (Token)
happyOutTok x = Happy_GHC_Exts.unsafeCoerce# x
{-# INLINE happyOutTok #-}


happyActOffsets :: HappyAddr
happyActOffsets = HappyA# "\xe0\x03\x00\x00\x54\x00\xcb\x03\xb9\x00\xf4\x01\xca\x03\xe8\x00\xc4\x03\xd3\x03\x00\x00\xdc\x03\x0a\x04\xbe\x03\xb9\x00\x21\x01\x00\x00\x03\x04\x0f\x04\xbb\x03\xb5\x03\x9b\x03\x9a\x03\x00\x00\xba\x03\xae\x03\x91\x03\x7e\x03\xbd\x03\xde\x06\xb9\x03\x5f\x03\xa5\x03\xa2\x03\xa2\x03\xa2\x03\xa2\x03\xa2\x03\xb8\x03\xb6\x03\xaf\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x9c\x03\xd8\x00\x00\x00\x00\x00\xd3\xff\x55\x03\x13\x02\x55\x03\x07\x02\x55\x03\xf6\xff\x55\x03\x96\x03\x18\x00\x9f\x03\x00\x00\x4c\x03\xc2\x04\x8e\x03\x14\x00\x47\x03\x00\x00\x82\x00\x00\x00\x47\x03\x8c\x03\x00\x00\x69\x03\x5d\x03\x51\x03\x45\x03\x40\x03\xfb\x01\x0e\x00\x09\x00\x3b\x03\x33\x03\x00\x00\x00\x00\xe6\x02\xb9\x00\xa6\x01\x26\x03\x00\x00\x11\x04\xda\x02\x20\x03\x10\x04\xd3\x02\xc5\x02\xd0\x02\xbc\x02\xce\x01\xce\x02\xc2\x01\xb9\x00\xd1\x02\xc7\x02\x8a\x03\xaf\x00\xc7\x02\xa3\x00\xc7\x02\xc7\x02\x04\x00\xc4\x02\xc2\x02\x00\x00\x00\x00\xe0\x00\xc2\x02\x00\x00\x99\x02\x6a\x02\xbb\x02\xb9\x02\xde\x06\x00\x00\x8a\x03\xb7\x02\xb9\x00\xbf\x03\x3a\x03\xb2\x02\xad\x02\x00\x00\x5b\x02\x00\x00\x00\x00\xc5\x06\xb9\x00\xa7\x02\x9a\x01\x8e\x01\x00\x00\x00\x00\x58\x02\xb9\x00\x9b\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xfb\x00\x35\x03\x29\x03\x1d\x03\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x00\x00\x82\x01\x11\x03\x11\x03\x56\x02\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x00\x00\x00\x00\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x11\x03\x00\x00\x05\x03\xb0\x02\xa4\x02\x66\x04\x00\x00\x00\x00\x00\x00\xa4\x02\x66\x04\x76\x01\x25\x04\x00\x00\x98\x02\x9b\x02\x8c\x02\x8c\x02\x8c\x02\xa6\x00\x71\x06\xa6\x00\xa6\x00\xa6\x00\x8c\x02\x80\x02\x97\x02\x00\x00\x2e\x02\xa9\x01\xde\x06\x00\x00\x58\x06\x3f\x06\x26\x06\x00\x00\x0d\x06\x96\x02\x61\x00\x00\x00\xe3\x05\x00\x00\x00\x00\xb9\x05\x61\x02\x8f\x05\x00\x00\x0d\x01\x16\x00\xde\x06\xde\x06\xde\x06\x97\x07\x97\x07\x97\x07\x97\x07\xf7\x06\x10\x07\xde\x06\xde\x06\xde\x06\xde\x06\xde\x06\xde\x06\xde\x06\xde\x06\xa6\x00\xa6\x00\xa6\x00\x97\x07\x97\x07\x00\x00\xde\x06\x65\x05\x3b\x05\x89\x02\x00\x00\xb1\x02\xb1\x02\xa6\x00\xa6\x00\xa6\x00\xa6\x00\xb1\x02\xb1\x02\x00\x00\xde\x06\x03\x01\x12\x00\x00\x00\x00\x00\x82\x02\x34\x00\x06\x00\x22\x05\x87\x02\x7d\x02\x09\x05\x77\x02\x6b\x02\x00\x00\x00\x00\xb9\x00\xf1\xff\xb5\x02\xdc\x00\xb9\x00\x23\x02\x5f\x02\x53\x02\x47\x02\x00\x00\xde\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x34\x02\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2f\x02\x2a\x02\x00\x00\x25\x02\x1c\x02\x00\x00\x12\x02\x10\x02\x00\x00\x00\x00\x00\x00\x00\x00\xd7\x01\x00\x00\x2b\x02\x5e\x00\x00\x00\xfb\xff\x00\x00\x00\x00\x00\x00\x57\x00\x00\x00\x00\x00\x1f\x02\x54\x00\xf0\x04\x2c\x00\x01\x00\x00\x00\xfa\xff\x00\x00\xf3\x01\x94\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyGotoOffsets :: HappyAddr
happyGotoOffsets = HappyA# "\xf0\x01\xff\x01\x7b\x01\xe1\x01\x24\x02\xd3\x01\x02\x01\x99\x01\xb7\x01\xb4\x01\xc1\x01\xaa\x01\xa0\x01\x53\x01\x60\x00\x47\x07\x98\x01\x7f\x01\x78\x07\x87\x01\x73\x01\x4c\x01\x6f\x01\x64\x01\xb1\x03\x73\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xac\x03\xaa\x03\xa3\x03\xa1\x03\x97\x03\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6c\x07\x00\x00\x54\x07\x00\x00\xcf\x00\x00\x00\x68\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4b\x01\x2a\x07\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x95\x03\x00\x00\xde\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x21\x02\x8b\x03\x00\x00\x00\x00\x15\x02\x00\x00\x00\x00\x09\x02\x00\x00\xb4\x00\x00\x00\x00\x00\x58\x01\x00\x00\x00\x00\x06\x02\x00\x00\x00\x00\xb8\x06\x8d\x01\x00\x00\x7e\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x5a\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x8d\x06\x00\x00\xfd\x01\xfa\x01\xb5\x01\x4a\x01\x00\x00\x00\x00\x32\x01\x00\x00\x12\x01\x00\x00\xb3\x01\x00\x00\xff\x05\xab\x05\x00\x00\x14\x01\x0f\x01\xa5\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x2a\x07\x89\x03\x7f\x03\x58\x05\x7d\x03\x77\x03\x74\x03\x71\x03\x31\x03\x2c\x03\x27\x03\x25\x03\x00\x00\xe3\x04\x1e\x03\x1c\x03\x00\x00\x12\x03\x10\x03\x06\x03\x04\x03\xfa\x02\xf8\x02\xf2\x02\xef\x02\xec\x02\x8d\x02\x8b\x02\x81\x02\x7f\x02\x75\x02\x73\x02\x00\x00\x00\x00\x6d\x02\x69\x02\x28\x02\x26\x02\x14\x02\xef\x01\x8f\x01\x00\x00\x83\x01\x5d\x01\x77\x01\x00\x01\x00\x00\x00\x00\x00\x00\x37\x01\xfd\x00\x23\x01\x00\x00\xee\x00\x1d\x01\x00\x00\x16\x01\x09\x01\xda\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa1\x00\x69\x00\x00\x00\xe9\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xf5\x00\x00\x00\x00\x00\x00\x00\xd7\x00\x00\x00\xac\x00\x00\x00\x00\x00\xa0\x00\x9c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x17\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x4e\x01\x96\x00\x20\x01\x0b\x00\x03\x00\x84\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x7d\x00\x00\x00\x17\x07\x00\x00\x50\x00\x00\x00\x00\x00\x33\x00\xfc\xff\x2a\x07\x00\x00\x00\x00\x1c\x00\x5a\x01\x00\x00\x2a\x07\x2a\x07\x00\x00\x00\x00\x00\x00\x05\x00\xf3\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyDefActions :: HappyAddr
happyDefActions = HappyA# "\x00\x00\xe3\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xc7\xff\x00\x00\x00\x00\xc3\xff\xbd\xff\xa9\xff\xab\xff\x00\x00\xa9\xff\x00\x00\x90\xff\x00\x00\x00\x00\x84\xff\x00\x00\x00\x00\x00\x00\x00\x00\x59\xff\x00\x00\x83\xff\x00\x00\x5a\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x67\xff\x66\xff\x65\xff\x64\xff\x63\xff\x62\xff\x61\xff\x82\xff\x00\x00\x83\xff\x82\xff\x00\x00\x00\x00\xa9\xff\x00\x00\xa9\xff\x00\x00\x00\x00\x00\x00\xa9\xff\x59\xff\x00\x00\x95\xff\x00\x00\x00\x00\x00\x00\x82\xff\x00\x00\xab\xff\xa9\xff\xb5\xff\x00\x00\x00\x00\xbb\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xbe\xff\xda\xff\x00\x00\x00\x00\x00\x00\x00\x00\xde\xff\x00\x00\x00\x00\xc4\xff\x00\x00\x00\x00\xc3\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xd1\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xe2\xff\xe1\xff\x00\x00\x00\x00\xe4\xff\x00\x00\x00\x00\x00\x00\x00\x00\xcd\xff\xce\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xbf\xff\x00\x00\xc0\xff\xc7\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xd9\xff\xd2\xff\x00\x00\x00\x00\x00\x00\xad\xff\xb6\xff\xb7\xff\xb8\xff\xb9\xff\xba\xff\xbc\xff\xac\xff\xa9\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x97\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xa8\xff\xa7\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x96\xff\x00\x00\x00\x00\x00\x00\x00\x00\x91\xff\x92\xff\x8f\xff\x00\x00\x00\x00\x00\x00\x00\x00\x84\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x7f\xff\x00\x00\x7e\xff\x80\xff\x81\xff\x00\x00\x00\x00\x00\x00\xe3\xff\x83\xff\x82\xff\x58\xff\x6a\xff\x00\x00\x00\x00\x00\x00\xab\xff\x00\x00\x00\x00\x00\x00\x84\xff\x00\x00\x84\xff\x8e\xff\x00\x00\x90\xff\x00\x00\x99\xff\x83\xff\x82\xff\x9b\xff\x9d\xff\x9e\xff\x76\xff\x78\xff\x7a\xff\x7b\xff\x7d\xff\x7c\xff\xa2\xff\xa3\xff\x9c\xff\x9f\xff\xa0\xff\xa1\xff\xa4\xff\xa5\xff\x6d\xff\x6b\xff\x6c\xff\x79\xff\x77\xff\x69\xff\x9a\xff\x00\x00\x00\x00\x00\x00\x5d\xff\x6f\xff\x70\xff\x6e\xff\x71\xff\x72\xff\x73\xff\x74\xff\x75\xff\xa6\xff\x98\xff\x83\xff\x82\xff\xaa\xff\xae\xff\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xdd\xff\xdb\xff\x00\x00\x00\x00\x00\x00\x00\x00\xbd\xff\x00\x00\x00\x00\x00\x00\x00\x00\xcb\xff\xcf\xff\xd0\xff\xd5\xff\xd4\xff\xe0\xff\xdf\xff\xcc\xff\xc9\xff\xc8\xff\x00\x00\xc5\xff\xc1\xff\xc2\xff\xca\xff\xdc\xff\xaf\xff\x00\x00\x00\x00\xb2\xff\x00\x00\x00\x00\xd3\xff\x00\x00\x00\x00\xd7\xff\x5b\xff\x5c\xff\x68\xff\x90\xff\x93\xff\xa9\xff\x00\x00\x84\xff\x00\x00\x88\xff\xab\xff\xab\xff\xa9\xff\x5e\xff\x5f\xff\x00\x00\xe5\xff\x00\x00\xa9\xff\xa9\xff\x89\xff\x00\x00\x8a\xff\x00\x00\x00\x00\x94\xff\xd6\xff\xd8\xff\xb3\xff\xb4\xff\xb0\xff\xb1\xff\xc6\xff\x8c\xff\x8d\xff\x8b\xff\x60\xff"#

happyCheck :: HappyAddr
happyCheck = HappyA# "\xff\xff\x10\x00\x01\x00\x02\x00\x31\x00\x0f\x00\x13\x00\x04\x00\x35\x00\x08\x00\x10\x00\x10\x00\x0b\x00\x0a\x00\x12\x00\x04\x00\x0f\x00\x10\x00\x0c\x00\x10\x00\x0b\x00\x0a\x00\x12\x00\x16\x00\x13\x00\x0b\x00\x03\x00\x09\x00\x0a\x00\x06\x00\x0c\x00\x09\x00\x0a\x00\x0f\x00\x0c\x00\x11\x00\x12\x00\x0f\x00\x12\x00\x11\x00\x12\x00\x56\x00\x12\x00\x31\x00\x31\x00\x01\x00\x02\x00\x35\x00\x35\x00\x30\x00\x31\x00\x3d\x00\x08\x00\x34\x00\x35\x00\x0b\x00\x1c\x00\x1d\x00\x39\x00\x0f\x00\x10\x00\x2b\x00\x3d\x00\x2b\x00\x0c\x00\x2b\x00\x16\x00\x2b\x00\x43\x00\x12\x00\x55\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x56\x00\x01\x00\x02\x00\x56\x00\x55\x00\x30\x00\x31\x00\x55\x00\x08\x00\x34\x00\x35\x00\x0b\x00\x55\x00\x04\x00\x39\x00\x0f\x00\x10\x00\x56\x00\x3d\x00\x0a\x00\x1b\x00\x56\x00\x16\x00\x10\x00\x43\x00\x10\x00\x10\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x56\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x30\x00\x31\x00\x55\x00\x08\x00\x34\x00\x35\x00\x0b\x00\x3a\x00\x31\x00\x39\x00\x0f\x00\x31\x00\x35\x00\x3d\x00\x18\x00\x35\x00\x13\x00\x16\x00\x03\x00\x43\x00\x47\x00\x48\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x56\x00\x0b\x00\x13\x00\x0d\x00\x0b\x00\x30\x00\x0d\x00\x11\x00\x12\x00\x34\x00\x03\x00\x18\x00\x13\x00\x0b\x00\x39\x00\x0d\x00\x1c\x00\x1d\x00\x3d\x00\x11\x00\x12\x00\x0e\x00\x0f\x00\x0b\x00\x43\x00\x0d\x00\x1b\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x56\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x03\x00\x13\x00\x0b\x00\x06\x00\x0d\x00\x17\x00\x0b\x00\x45\x00\x0d\x00\x01\x00\x13\x00\x14\x00\x15\x00\x12\x00\x17\x00\x18\x00\x19\x00\x1b\x00\x0b\x00\x45\x00\x0d\x00\x1c\x00\x1d\x00\x55\x00\x11\x00\x22\x00\x23\x00\x01\x00\x02\x00\x45\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x08\x00\x55\x00\x03\x00\x0b\x00\x12\x00\x06\x00\x1b\x00\x0f\x00\x10\x00\x09\x00\x0a\x00\x55\x00\x0c\x00\x13\x00\x16\x00\x0f\x00\x13\x00\x11\x00\x12\x00\x09\x00\x0a\x00\x09\x00\x0c\x00\x3a\x00\x07\x00\x0f\x00\x0b\x00\x11\x00\x12\x00\x03\x00\x45\x00\x01\x00\x02\x00\x04\x00\x1c\x00\x1d\x00\x47\x00\x48\x00\x08\x00\x0a\x00\x30\x00\x0b\x00\x45\x00\x56\x00\x34\x00\x0f\x00\x55\x00\x1c\x00\x1d\x00\x39\x00\x03\x00\x56\x00\x16\x00\x3d\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x55\x00\x43\x00\x1c\x00\x1d\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x30\x00\x04\x00\x1c\x00\x1d\x00\x34\x00\x03\x00\x0d\x00\x0a\x00\x56\x00\x39\x00\x03\x00\x02\x00\x12\x00\x3d\x00\x05\x00\x03\x00\x0e\x00\x0f\x00\x56\x00\x43\x00\x19\x00\x0c\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x02\x00\x08\x00\x1b\x00\x05\x00\x0b\x00\x04\x00\x01\x00\x02\x00\x0f\x00\x08\x00\x0c\x00\x0a\x00\x1a\x00\x08\x00\x18\x00\x16\x00\x0b\x00\x0c\x00\x01\x00\x02\x00\x04\x00\x13\x00\x1c\x00\x1d\x00\x08\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x0c\x00\x01\x00\x02\x00\x04\x00\x17\x00\x1c\x00\x1d\x00\x08\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x0c\x00\x01\x00\x02\x00\x04\x00\x12\x00\x1c\x00\x1d\x00\x0d\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x09\x00\x0a\x00\x0e\x00\x0c\x00\x0c\x00\x04\x00\x0f\x00\x04\x00\x11\x00\x12\x00\x16\x00\x0a\x00\x0a\x00\x0a\x00\x09\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0b\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x05\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x03\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x00\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x04\x00\x56\x00\x01\x00\x04\x00\x0f\x00\x08\x00\x0a\x00\x0a\x00\x0b\x00\x0a\x00\x01\x00\x02\x00\x04\x00\x1c\x00\x1d\x00\x04\x00\x37\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x0a\x00\x01\x00\x02\x00\x0f\x00\x55\x00\x56\x00\x04\x00\x0a\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x0a\x00\x01\x00\x02\x00\x0f\x00\x55\x00\x56\x00\x04\x00\x0a\x00\x08\x00\x04\x00\x16\x00\x0b\x00\x0a\x00\x01\x00\x02\x00\x0a\x00\x0a\x00\x1c\x00\x1d\x00\x0f\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x09\x00\x0a\x00\x0a\x00\x0c\x00\x47\x00\x48\x00\x0f\x00\x0a\x00\x11\x00\x12\x00\x16\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x0c\x00\x56\x00\x1c\x00\x1d\x00\x0a\x00\x08\x00\x1c\x00\x1d\x00\x0b\x00\x0a\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x0c\x00\x08\x00\x0c\x00\x16\x00\x0b\x00\x37\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x09\x00\x08\x00\x0a\x00\x16\x00\x0b\x00\x09\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x55\x00\x08\x00\x55\x00\x16\x00\x0b\x00\x55\x00\x01\x00\x02\x00\x0c\x00\x03\x00\x04\x00\x05\x00\x06\x00\x08\x00\x0c\x00\x16\x00\x0b\x00\x0b\x00\x0b\x00\x0d\x00\x55\x00\x0b\x00\x0a\x00\x0d\x00\x0a\x00\x13\x00\x0a\x00\x16\x00\x12\x00\x17\x00\x18\x00\x19\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x12\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x11\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x55\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x45\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x55\x00\x1c\x00\x1d\x00\x08\x00\x1c\x00\x1d\x00\x0b\x00\x55\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x56\x00\x08\x00\x55\x00\x16\x00\x0b\x00\x56\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x56\x00\x08\x00\x56\x00\x16\x00\x0b\x00\x56\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x56\x00\x08\x00\x12\x00\x16\x00\x0b\x00\x0f\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x56\x00\x08\x00\x0b\x00\x16\x00\x0b\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x0b\x00\x0b\x00\x0d\x00\x1c\x00\x1d\x00\x0a\x00\x16\x00\x12\x00\x1c\x00\x1d\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x0a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x45\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x55\x00\x1c\x00\x1d\x00\x08\x00\x1c\x00\x1d\x00\x0b\x00\x0a\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x56\x00\x08\x00\x11\x00\x16\x00\x0b\x00\x56\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x0a\x00\x08\x00\x56\x00\x16\x00\x0b\x00\x12\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x56\x00\x08\x00\x12\x00\x16\x00\x0b\x00\x0b\x00\x01\x00\x02\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x0b\x00\x08\x00\x0b\x00\x16\x00\x0b\x00\x1c\x00\x1d\x00\x1c\x00\x1d\x00\x0b\x00\x12\x00\x0d\x00\x1c\x00\x1d\x00\x12\x00\x16\x00\x12\x00\x41\x00\x55\x00\x39\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x46\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x37\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x3d\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x45\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x01\x00\x02\x00\x0f\x00\x55\x00\x55\x00\x0b\x00\x3a\x00\x08\x00\x45\x00\x55\x00\x0b\x00\x0b\x00\x0b\x00\x0d\x00\x0d\x00\x55\x00\x55\x00\x41\x00\x12\x00\x12\x00\xff\xff\x16\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\x0a\x00\x0b\x00\xff\xff\x0d\x00\xff\xff\x0f\x00\xff\xff\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\xff\xff\x25\x00\x26\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x2c\x00\x2d\x00\x2e\x00\xff\xff\x45\x00\x45\x00\xff\xff\xff\xff\xff\xff\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x55\x00\x55\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\x0a\x00\x0b\x00\xff\xff\x0d\x00\xff\xff\x0f\x00\xff\xff\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\xff\xff\x25\x00\x26\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x2c\x00\x2d\x00\x2e\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\x0f\x00\xff\xff\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\xff\xff\x25\x00\x26\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x2c\x00\x2d\x00\x2e\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\x0a\x00\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x03\x00\x25\x00\x26\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x2c\x00\x2d\x00\x2e\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\x0c\x00\x0d\x00\xff\xff\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x03\x00\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\x0e\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\x0f\x00\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x03\x00\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\x0a\x00\x0b\x00\xff\xff\x0d\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\x0f\x00\xff\xff\xff\xff\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x03\x00\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x09\x00\xff\xff\x0b\x00\xff\xff\x0d\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x12\x00\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\x0c\x00\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x03\x00\xff\xff\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\x0a\x00\x0b\x00\xff\xff\x0d\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x03\x00\xff\xff\x22\x00\x23\x00\xff\xff\xff\xff\xff\xff\x27\x00\x28\x00\x29\x00\x2a\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\x0e\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x23\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x22\x00\x03\x00\x0b\x00\xff\xff\x0d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\xff\xff\x13\x00\x14\x00\x15\x00\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\x14\x00\xff\xff\x03\x00\xff\xff\x05\x00\xff\xff\xff\xff\xff\xff\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\xff\xff\x19\x00\x1a\x00\xff\xff\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x03\x00\xff\xff\x05\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x03\x00\x11\x00\xff\xff\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\xff\xff\x19\x00\x1a\x00\xff\xff\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x13\x00\x14\x00\x15\x00\x16\x00\x03\x00\xff\xff\xff\xff\xff\xff\x03\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\xff\xff\xff\xff\x03\x00\xff\xff\xff\xff\xff\xff\xff\xff\x03\x00\x14\x00\x15\x00\x16\x00\xff\xff\x14\x00\x15\x00\x16\x00\xff\xff\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x14\x00\x15\x00\x16\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\xff\xff\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\xff\xff\xff\xff\x0b\x00\xff\xff\x0d\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\x13\x00\xff\xff\xff\xff\xff\xff\x17\x00\x18\x00\x19\x00\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff\xff"#

happyTable :: HappyAddr
happyTable = HappyA# "\x00\x00\x41\x01\x22\x00\x23\x00\xd2\x00\x46\x00\x6d\x01\x55\x00\xd3\x00\x24\x00\x70\x01\x61\x01\x25\x00\x56\x00\x5e\x01\x3e\x01\x46\x00\x87\xff\x4a\x01\x3d\x01\x90\x00\x56\x00\x7a\x00\x26\x00\x6e\x01\x91\x00\x6b\x00\xdf\xff\xdf\xff\x48\x01\xdf\xff\xe0\xff\xe0\xff\xdf\xff\xe0\xff\xdf\xff\xdf\xff\xe0\xff\x9d\x00\xe0\xff\xe0\xff\xff\xff\xc6\x00\xd2\x00\xd2\x00\x22\x00\x23\x00\xd3\x00\xd3\x00\x4f\x00\x87\xff\x3d\x00\x24\x00\x50\x00\x87\xff\x25\x00\x5d\x01\x32\x00\x39\x00\x46\x00\x86\xff\xdf\xff\x3d\x00\x9e\x00\x4b\x01\xe0\xff\x26\x00\xc7\x00\x51\x00\x5f\x01\x83\x00\x37\x00\x52\x00\x53\x00\x54\x00\x55\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x44\x00\x87\xff\x22\x00\x23\x00\xff\xff\x6e\x00\x4f\x00\x86\xff\x6e\x00\x24\x00\x50\x00\x86\xff\x25\x00\x92\x00\x55\x00\x39\x00\x46\x00\x85\xff\xdf\xff\x3d\x00\x56\x00\x61\x01\xe0\xff\x26\x00\x63\x01\x51\x00\x57\x00\x56\x01\x37\x00\x52\x00\x53\x00\x54\x00\x55\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x44\x00\x86\xff\x22\x00\x23\x00\x1d\x00\xdf\x00\x4f\x00\x85\xff\x81\x00\x24\x00\x50\x00\x85\xff\x25\x00\x64\x00\xd2\x00\x39\x00\x46\x00\xd2\x00\xd3\x00\x3d\x00\x65\x01\xd3\x00\x3c\x01\x26\x00\x81\x00\x51\x00\x52\x00\x53\x00\x37\x00\x52\x00\x53\x00\x54\x00\x55\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x44\x00\x85\xff\x59\x00\x4f\x01\x5a\x00\xa9\x00\x4f\x00\xaa\x00\x6b\x00\x79\x00\x50\x00\x5c\x00\x50\x01\xac\x00\x59\x00\x39\x00\x5a\x00\xe1\x00\x32\x00\x3d\x00\x6b\x00\x7a\x00\x84\x00\x5e\x00\x59\x00\x51\x00\x5a\x00\x52\x01\x37\x00\x52\x00\x53\x00\x54\x00\x55\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x44\x00\xff\xff\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\x6b\x00\xc9\x00\xa9\x00\x8e\x00\xaa\x00\xca\x00\x59\x00\x5b\x00\x5a\x00\x5c\x01\xac\x00\xad\x00\xae\x00\x79\x00\xaf\x00\xb0\x00\xb1\x00\x54\x01\x59\x00\x5b\x00\x5a\x00\xe3\x00\x32\x00\x5c\x00\x6b\x00\xba\x00\xbb\x00\x22\x00\x23\x00\x5b\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x24\x00\x5c\x00\x6b\x00\x25\x00\x58\x01\x6c\x00\xe9\x00\x46\x00\x1d\x01\x54\xff\x54\xff\x5c\x00\x54\xff\xed\x00\x26\x00\x54\xff\xef\x00\x54\xff\x54\xff\x57\xff\x57\xff\x1f\x01\x57\xff\x64\x00\x20\x01\x57\xff\x2a\x01\x57\xff\x57\xff\x1c\x00\x5b\x00\x22\x00\x23\x00\x3f\x01\xe4\x00\x32\x00\x52\x00\x53\x00\x24\x00\x56\x00\x4f\x00\x25\x00\x5b\x00\xff\xff\x50\x00\x46\x00\x5c\x00\xe5\x00\x32\x00\x39\x00\x2b\x01\xff\xff\x26\x00\x3d\x00\xe7\x00\x1e\x00\xe8\x00\x20\x00\x5c\x00\x51\x00\xeb\x00\x32\x00\x37\x00\x52\x00\x53\x00\x54\x00\x55\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x44\x00\x4f\x00\x41\x01\xee\x00\x32\x00\x50\x00\x5c\x00\x2e\x01\x56\x00\x54\xff\x39\x00\x81\x00\x77\x00\x9b\x00\x3d\x00\x73\x00\x1c\x00\x5d\x00\x5e\x00\x57\xff\x51\x00\x37\x00\x74\x00\x37\x00\x52\x00\x53\x00\x54\x00\x55\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x44\x00\x22\x00\x23\x00\x1d\x00\x1e\x00\xf1\x00\x20\x00\x72\x00\x24\x00\x34\x00\x73\x00\x25\x00\x68\x00\x22\x00\x23\x00\xed\x00\x7a\x00\x74\x00\x56\x00\x35\x00\x24\x00\x39\x00\x26\x00\x25\x00\x10\x01\x22\x00\x23\x00\x68\x00\x44\x00\xf0\x00\x32\x00\x7b\x00\x24\x00\x56\x00\x26\x00\x25\x00\x24\x01\x22\x00\x23\x00\x68\x00\x3b\x00\x1d\x00\xf2\x00\x69\x00\x24\x00\x56\x00\x26\x00\x25\x00\x27\x01\x22\x00\x23\x00\x1e\x01\x46\x00\xf4\x00\x32\x00\x60\x00\x24\x00\x56\x00\x26\x00\x25\x00\x55\xff\x55\xff\x8b\x00\x55\xff\x62\x00\x28\x01\x55\xff\x2f\x01\x55\xff\x55\xff\x26\x00\x56\x00\x65\x00\x56\x00\x66\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x64\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x6e\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x70\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x76\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x22\x00\x23\x00\x30\x01\x55\xff\x75\x00\x31\x01\x46\x00\x24\x00\x56\x00\x94\x00\x25\x00\x56\x00\x22\x00\x23\x00\x7f\x00\xf5\x00\x32\x00\x85\x00\x3b\x00\x24\x00\x56\x00\x26\x00\x25\x00\x56\x00\x22\x00\x23\x00\x46\x00\x81\x00\xff\xff\x87\x00\x67\x01\x24\x00\x68\x01\x26\x00\x25\x00\x56\x00\x22\x00\x23\x00\xd1\x00\x83\x00\xff\xff\x8b\x00\x69\x01\x24\x00\x6f\x00\x26\x00\x25\x00\x56\x00\x22\x00\x23\x00\x56\x00\x6a\x01\xf6\x00\x32\x00\x46\x00\x24\x00\x6b\x01\x26\x00\x25\x00\x56\xff\x56\xff\x6c\x01\x56\xff\x52\x00\x53\x00\x56\xff\x6d\x01\x56\xff\x56\xff\x26\x00\xf7\x00\x32\x00\xf8\x00\x32\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x3a\x01\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x44\x00\x3b\x01\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x44\x00\x3c\x01\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x43\x01\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x44\x00\x22\x00\x23\x00\x44\x01\x56\xff\xf9\x00\x32\x00\x46\x01\x24\x00\xfa\x00\x32\x00\x25\x00\x4c\x01\x22\x00\x23\x00\xfb\x00\x32\x00\xfc\x00\x32\x00\x47\x01\x24\x00\x4d\x01\x26\x00\x25\x00\x3b\x00\x22\x00\x23\x00\xfd\x00\x32\x00\xfe\x00\x32\x00\x57\x01\x24\x00\xdf\x00\x26\x00\x25\x00\xe7\x00\x22\x00\x23\x00\xff\x00\x32\x00\x00\x01\x32\x00\x0b\x01\x24\x00\x68\x00\x26\x00\x25\x00\x2d\x01\x22\x00\x23\x00\x28\x01\xa2\x00\xa3\x00\xa4\x00\xa5\x00\x24\x00\x2e\x01\x26\x00\x25\x00\xa9\x00\x62\x00\xaa\x00\x38\x01\x59\x00\x33\x01\x5a\x00\x36\x01\xac\x00\x37\x01\x26\x00\x7a\x00\xaf\x00\xb0\x00\xb1\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\xe1\x00\x79\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x7f\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x39\x01\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x5b\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x22\x00\x23\x00\x01\x01\x32\x00\x5c\x00\x02\x01\x32\x00\x24\x00\x03\x01\x32\x00\x25\x00\x84\x00\x22\x00\x23\x00\x04\x01\x32\x00\x05\x01\x32\x00\xff\xff\x24\x00\x60\x00\x26\x00\x25\x00\xff\xff\x22\x00\x23\x00\x06\x01\x32\x00\x07\x01\x32\x00\xff\xff\x24\x00\xff\xff\x26\x00\x25\x00\xff\xff\x22\x00\x23\x00\x08\x01\x32\x00\x09\x01\x32\x00\xff\xff\x24\x00\x87\x00\x26\x00\x25\x00\x89\x00\x22\x00\x23\x00\x0b\x01\x32\x00\x0c\x01\x32\x00\xff\xff\x24\x00\x8d\x00\x26\x00\x25\x00\x10\x01\x32\x00\x11\x01\x32\x00\x59\x00\x8e\x00\x5a\x00\x12\x01\x32\x00\x95\x00\x26\x00\x79\x00\x13\x01\x32\x00\x96\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\xf4\x00\x97\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x98\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x99\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x5b\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x1c\x01\x22\x00\x23\x00\x14\x01\x32\x00\x5c\x00\x15\x01\x32\x00\x24\x00\x16\x01\x32\x00\x25\x00\x9a\x00\x22\x00\x23\x00\x17\x01\x32\x00\x19\x01\x32\x00\xff\xff\x24\x00\x9f\x00\x26\x00\x25\x00\xff\xff\x22\x00\x23\x00\x1d\x00\x1a\x01\x89\x00\x32\x00\xc5\x00\x24\x00\xff\xff\x26\x00\x25\x00\x9d\x00\x22\x00\x23\x00\x92\x00\x32\x00\xd6\x00\x32\x00\xff\xff\x24\x00\xdc\x00\x26\x00\x25\x00\xd4\x00\x22\x00\x23\x00\xd7\x00\x32\x00\xd8\x00\x32\x00\xd5\x00\x24\x00\xd6\x00\x26\x00\x25\x00\xd9\x00\x32\x00\xda\x00\x32\x00\x59\x00\xdd\x00\x5a\x00\x31\x00\x32\x00\xc6\x00\x26\x00\x7a\x00\x1c\x00\xde\x00\x39\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x37\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x44\x00\x3b\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x3d\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x5b\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x34\x00\x22\x00\x23\x00\x46\x00\x60\x00\x5c\x00\x62\x00\x64\x00\x24\x00\x5b\x00\x68\x00\x25\x00\x59\x00\x59\x00\x5a\x00\x5a\x00\x6e\x00\x72\x00\x1c\x00\x79\x00\x7a\x00\x00\x00\x26\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\x00\x00\xa8\x00\xa9\x00\x00\x00\xaa\x00\x00\x00\xeb\x00\x00\x00\xab\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xb2\x00\xb3\x00\xb4\x00\xb5\x00\xb6\x00\xb7\x00\xb8\x00\xb9\x00\xba\x00\xbb\x00\x00\x00\xbc\x00\xbd\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x00\x00\xc2\x00\xc3\x00\xc4\x00\x00\x00\x5b\x00\x5b\x00\x00\x00\x00\x00\x00\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x44\x00\x5c\x00\x5c\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\x00\x00\xa8\x00\xa9\x00\x00\x00\xaa\x00\x00\x00\x46\x00\x00\x00\xab\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xb2\x00\xb3\x00\xb4\x00\xb5\x00\xb6\x00\xb7\x00\xb8\x00\xb9\x00\xba\x00\xbb\x00\x00\x00\xbc\x00\xbd\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x00\x00\xc2\x00\xc3\x00\xc4\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\x00\x00\x00\x00\xa9\x00\x00\x00\xaa\x00\x00\x00\x46\x00\x00\x00\xab\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xb2\x00\xb3\x00\xb4\x00\xb5\x00\xb6\x00\xb7\x00\xb8\x00\xb9\x00\xba\x00\xbb\x00\x00\x00\xbc\x00\xbd\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x00\x00\xc2\x00\xc3\x00\xc4\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\x00\x00\xa8\x00\xa9\x00\x00\x00\xaa\x00\x00\x00\x00\x00\x00\x00\xab\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xb2\x00\xb3\x00\xb4\x00\xb5\x00\xb6\x00\xb7\x00\xb8\x00\xb9\x00\xba\x00\xbb\x00\x1c\x00\xbc\x00\xbd\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x00\x00\xc2\x00\xc3\x00\xc4\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\x00\x00\x00\x00\xa9\x00\x71\x01\xaa\x00\x00\x00\x0d\x01\x1e\x00\x0e\x01\x20\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xba\x00\xbb\x00\xa9\x00\x45\x01\xaa\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xba\x00\xbb\x00\xa9\x00\x48\x01\xaa\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xba\x00\xbb\x00\xa9\x00\x4e\x01\xaa\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x1c\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\x00\x00\x00\x00\xa9\x00\x00\x00\xaa\x00\x4f\x01\x1d\x00\x1e\x00\x18\x01\x20\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\x00\x00\x00\x00\xa9\x00\x00\x00\xaa\x00\x00\x00\x46\x00\x00\x00\x00\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x1c\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\x00\x00\x52\x01\xa9\x00\x00\x00\xaa\x00\x21\x01\x1e\x00\x22\x01\x20\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\x00\x00\x00\x00\xa9\x00\x00\x00\xaa\x00\x00\x00\x54\x01\x00\x00\x00\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x1c\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\x58\x01\x00\x00\xa9\x00\x00\x00\xaa\x00\x24\x01\x1e\x00\x25\x01\x20\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xba\x00\xbb\x00\xa9\x00\x5a\x01\xaa\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xba\x00\xbb\x00\xa9\x00\x5b\x01\xaa\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xba\x00\xbb\x00\xa9\x00\x00\x00\xaa\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x5c\x01\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xba\x00\xbb\x00\xa9\x00\xe3\x00\xaa\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x1c\x00\x00\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\x00\x00\x1e\x01\xa9\x00\x00\x00\xaa\x00\x33\x01\x1e\x00\x34\x01\x20\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x1c\x00\x00\x00\xba\x00\xbb\x00\x00\x00\x00\x00\x00\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\x00\x00\x00\x00\xa9\x00\x00\x00\xaa\x00\x2a\x01\x7c\x00\x1e\x00\x7d\x00\x20\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xba\x00\xbb\x00\xa9\x00\x00\x00\xaa\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xba\x00\xbb\x00\xa9\x00\x00\x00\xaa\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\xba\x00\x3d\x00\xa9\x00\x00\x00\xaa\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x00\x00\xac\x00\xad\x00\xae\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x63\x01\x00\x00\x3d\x00\x00\x00\x47\x00\x00\x00\x00\x00\x00\x00\x64\x01\x1e\x00\x42\x00\x20\x00\xbe\x00\xbf\x00\xc0\x00\xc1\x00\x9a\x00\x00\x00\x49\x00\x3e\x00\x3f\x00\x4a\x00\x4b\x00\x00\x00\x4c\x00\x4d\x00\x00\x00\x41\x00\x1e\x00\x42\x00\x20\x00\x3d\x00\x00\x00\x47\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x3d\x00\x48\x00\x00\x00\x49\x00\x3e\x00\x3f\x00\x4a\x00\x4b\x00\x00\x00\x4c\x00\x4d\x00\x00\x00\x41\x00\x1e\x00\x42\x00\x20\x00\xcb\x00\x3e\x00\x3f\x00\xcc\x00\x3d\x00\x00\x00\x00\x00\x00\x00\x3d\x00\xcd\x00\x1e\x00\x42\x00\x20\x00\x00\x00\x00\x00\x1c\x00\x00\x00\x00\x00\x00\x00\x00\x00\x3d\x00\x3e\x00\x3f\x00\xc7\x00\x00\x00\x3e\x00\x3f\x00\xce\x00\x00\x00\xc8\x00\x1e\x00\x42\x00\x20\x00\xcf\x00\x1e\x00\x42\x00\x20\x00\x3e\x00\x3f\x00\x40\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x00\x00\x41\x00\x1e\x00\x42\x00\x20\x00\xa0\x00\xa1\x00\xa2\x00\xa3\x00\xa4\x00\xa5\x00\xa6\x00\xa7\x00\x00\x00\x00\x00\xa9\x00\x00\x00\xaa\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xac\x00\x00\x00\x00\x00\x00\x00\xaf\x00\xb0\x00\xb1\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"#

happyReduceArr = Happy_Data_Array.array (26, 171) [
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
	(171 , happyReduce_171)
	]

happy_n_terms = 87 :: Int
happy_n_nonterms = 32 :: Int

happyReduce_26 = happyReduce 4# 0# happyReduction_26
happyReduction_26 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut30 happy_x_4 of { happy_var_4 -> 
	happyIn29
		 (Program {package=getInnerString(happy_var_2), topLevels=(reverse happy_var_4)}
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
	case happyOut57 happy_x_2 of { happy_var_2 -> 
	case happyOut33 happy_x_4 of { happy_var_4 -> 
	happyIn33
		 (((getOffset happy_var_1), ArrayType happy_var_2 (snd happy_var_4))
	) `HappyStk` happyRest}}}

happyReduce_36 = happySpecReduce_3  4# happyReduction_36
happyReduction_36 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut33 happy_x_3 of { happy_var_3 -> 
	happyIn33
		 (((getOffset happy_var_1), SliceType (snd happy_var_3))
	)}}

happyReduce_37 = happySpecReduce_1  4# happyReduction_37
happyReduction_37 happy_x_1
	 =  case happyOut39 happy_x_1 of { happy_var_1 -> 
	happyIn33
		 (((fst happy_var_1), StructType (snd happy_var_1))
	)}

happyReduce_38 = happySpecReduce_2  5# happyReduction_38
happyReduction_38 happy_x_2
	happy_x_1
	 =  case happyOut35 happy_x_2 of { happy_var_2 -> 
	happyIn34
		 (VarDecl [happy_var_2]
	)}

happyReduce_39 = happyReduce 5# 5# happyReduction_39
happyReduction_39 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut36 happy_x_3 of { happy_var_3 -> 
	happyIn34
		 (VarDecl (reverse happy_var_3)
	) `HappyStk` happyRest}

happyReduce_40 = happyReduce 4# 5# happyReduction_40
happyReduction_40 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut33 happy_x_3 of { happy_var_3 -> 
	happyIn34
		 (TypeDef [TypeDef' (getIdent happy_var_2) happy_var_3]
	) `HappyStk` happyRest}}

happyReduce_41 = happyReduce 5# 5# happyReduction_41
happyReduction_41 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut38 happy_x_3 of { happy_var_3 -> 
	happyIn34
		 (TypeDef (reverse happy_var_3)
	) `HappyStk` happyRest}

happyReduce_42 = happySpecReduce_3  6# happyReduction_42
happyReduction_42 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	case happyOut37 happy_x_2 of { happy_var_2 -> 
	happyIn35
		 (VarDecl' ((nonEmpty . reverse) happy_var_1) happy_var_2
	)}}

happyReduce_43 = happySpecReduce_3  6# happyReduction_43
happyReduction_43 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut37 happy_x_2 of { happy_var_2 -> 
	happyIn35
		 (VarDecl' (nonEmpty [getIdent happy_var_1]) happy_var_2
	)}}

happyReduce_44 = happySpecReduce_2  7# happyReduction_44
happyReduction_44 happy_x_2
	happy_x_1
	 =  case happyOut36 happy_x_1 of { happy_var_1 -> 
	case happyOut35 happy_x_2 of { happy_var_2 -> 
	happyIn36
		 (happy_var_2 : happy_var_1
	)}}

happyReduce_45 = happySpecReduce_0  7# happyReduction_45
happyReduction_45  =  happyIn36
		 ([]
	)

happyReduce_46 = happySpecReduce_1  8# happyReduction_46
happyReduction_46 happy_x_1
	 =  case happyOut33 happy_x_1 of { happy_var_1 -> 
	happyIn37
		 (Left (happy_var_1, [])
	)}

happyReduce_47 = happySpecReduce_3  8# happyReduction_47
happyReduction_47 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut33 happy_x_1 of { happy_var_1 -> 
	case happyOut59 happy_x_3 of { happy_var_3 -> 
	happyIn37
		 (Left (happy_var_1, happy_var_3)
	)}}

happyReduce_48 = happySpecReduce_3  8# happyReduction_48
happyReduction_48 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut33 happy_x_1 of { happy_var_1 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn37
		 (Left (happy_var_1, [happy_var_3])
	)}}

happyReduce_49 = happySpecReduce_2  8# happyReduction_49
happyReduction_49 happy_x_2
	happy_x_1
	 =  case happyOut59 happy_x_2 of { happy_var_2 -> 
	happyIn37
		 (Right (nonEmpty happy_var_2)
	)}

happyReduce_50 = happySpecReduce_2  8# happyReduction_50
happyReduction_50 happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_2 of { happy_var_2 -> 
	happyIn37
		 (Right (nonEmpty [happy_var_2])
	)}

happyReduce_51 = happyReduce 4# 9# happyReduction_51
happyReduction_51 (happy_x_4 `HappyStk`
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

happyReduce_52 = happySpecReduce_3  9# happyReduction_52
happyReduction_52 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut33 happy_x_2 of { happy_var_2 -> 
	happyIn38
		 ([TypeDef' (getIdent happy_var_1) happy_var_2]
	)}}

happyReduce_53 = happyReduce 4# 10# happyReduction_53
happyReduction_53 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut40 happy_x_3 of { happy_var_3 -> 
	happyIn39
		 (((getOffset happy_var_1), (reverse happy_var_3))
	) `HappyStk` happyRest}}

happyReduce_54 = happyReduce 4# 11# happyReduction_54
happyReduction_54 (happy_x_4 `HappyStk`
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

happyReduce_55 = happyReduce 4# 11# happyReduction_55
happyReduction_55 (happy_x_4 `HappyStk`
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

happyReduce_56 = happySpecReduce_0  11# happyReduction_56
happyReduction_56  =  happyIn40
		 ([]
	)

happyReduce_57 = happyReduce 5# 12# happyReduction_57
happyReduction_57 (happy_x_5 `HappyStk`
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

happyReduce_58 = happyReduce 4# 13# happyReduction_58
happyReduction_58 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut43 happy_x_2 of { happy_var_2 -> 
	case happyOut45 happy_x_4 of { happy_var_4 -> 
	happyIn42
		 (Signature (Parameters happy_var_2) happy_var_4
	) `HappyStk` happyRest}}

happyReduce_59 = happySpecReduce_1  14# happyReduction_59
happyReduction_59 happy_x_1
	 =  case happyOut44 happy_x_1 of { happy_var_1 -> 
	happyIn43
		 (reverse happy_var_1
	)}

happyReduce_60 = happySpecReduce_0  14# happyReduction_60
happyReduction_60  =  happyIn43
		 ([]
	)

happyReduce_61 = happyReduce 4# 15# happyReduction_61
happyReduction_61 (happy_x_4 `HappyStk`
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

happyReduce_62 = happyReduce 4# 15# happyReduction_62
happyReduction_62 (happy_x_4 `HappyStk`
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

happyReduce_63 = happySpecReduce_2  15# happyReduction_63
happyReduction_63 happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	case happyOut33 happy_x_2 of { happy_var_2 -> 
	happyIn44
		 ([(ParameterDecl ((nonEmpty . reverse) happy_var_1) happy_var_2)]
	)}}

happyReduce_64 = happySpecReduce_2  15# happyReduction_64
happyReduction_64 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut33 happy_x_2 of { happy_var_2 -> 
	happyIn44
		 ([(ParameterDecl (nonEmpty [getIdent happy_var_1]) happy_var_2)]
	)}}

happyReduce_65 = happySpecReduce_1  16# happyReduction_65
happyReduction_65 happy_x_1
	 =  case happyOut33 happy_x_1 of { happy_var_1 -> 
	happyIn45
		 (Just happy_var_1
	)}

happyReduce_66 = happySpecReduce_0  16# happyReduction_66
happyReduction_66  =  happyIn45
		 (Nothing
	)

happyReduce_67 = happySpecReduce_2  17# happyReduction_67
happyReduction_67 happy_x_2
	happy_x_1
	 =  case happyOut48 happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (happy_var_1
	)}

happyReduce_68 = happySpecReduce_1  17# happyReduction_68
happyReduction_68 happy_x_1
	 =  case happyOut51 happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (SimpleStmt happy_var_1
	)}

happyReduce_69 = happySpecReduce_2  17# happyReduction_69
happyReduction_69 happy_x_2
	happy_x_1
	 =  case happyOut52 happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (happy_var_1
	)}

happyReduce_70 = happySpecReduce_2  17# happyReduction_70
happyReduction_70 happy_x_2
	happy_x_1
	 =  case happyOut54 happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (happy_var_1
	)}

happyReduce_71 = happySpecReduce_2  17# happyReduction_71
happyReduction_71 happy_x_2
	happy_x_1
	 =  case happyOut55 happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (happy_var_1
	)}

happyReduce_72 = happySpecReduce_2  17# happyReduction_72
happyReduction_72 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (Break $ getOffset happy_var_1
	)}

happyReduce_73 = happySpecReduce_2  17# happyReduction_73
happyReduction_73 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (Continue $ getOffset happy_var_1
	)}

happyReduce_74 = happySpecReduce_1  17# happyReduction_74
happyReduction_74 happy_x_1
	 =  case happyOut34 happy_x_1 of { happy_var_1 -> 
	happyIn46
		 (Declare happy_var_1
	)}

happyReduce_75 = happyReduce 5# 17# happyReduction_75
happyReduction_75 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut59 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Print happy_var_3
	) `HappyStk` happyRest}

happyReduce_76 = happyReduce 5# 17# happyReduction_76
happyReduction_76 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Print [happy_var_3]
	) `HappyStk` happyRest}

happyReduce_77 = happyReduce 4# 17# happyReduction_77
happyReduction_77 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = happyIn46
		 (Print []
	) `HappyStk` happyRest

happyReduce_78 = happyReduce 5# 17# happyReduction_78
happyReduction_78 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut59 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Println happy_var_3
	) `HappyStk` happyRest}

happyReduce_79 = happyReduce 5# 17# happyReduction_79
happyReduction_79 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn46
		 (Println [happy_var_3]
	) `HappyStk` happyRest}

happyReduce_80 = happyReduce 4# 17# happyReduction_80
happyReduction_80 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = happyIn46
		 (Println []
	) `HappyStk` happyRest

happyReduce_81 = happySpecReduce_3  17# happyReduction_81
happyReduction_81 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_2 of { happy_var_2 -> 
	happyIn46
		 (Return $ Just happy_var_2
	)}

happyReduce_82 = happySpecReduce_2  17# happyReduction_82
happyReduction_82 happy_x_2
	happy_x_1
	 =  happyIn46
		 (Return Nothing
	)

happyReduce_83 = happySpecReduce_2  18# happyReduction_83
happyReduction_83 happy_x_2
	happy_x_1
	 =  case happyOut47 happy_x_1 of { happy_var_1 -> 
	case happyOut46 happy_x_2 of { happy_var_2 -> 
	happyIn47
		 (happy_var_2 : happy_var_1
	)}}

happyReduce_84 = happySpecReduce_0  18# happyReduction_84
happyReduction_84  =  happyIn47
		 ([]
	)

happyReduce_85 = happySpecReduce_3  19# happyReduction_85
happyReduction_85 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut47 happy_x_2 of { happy_var_2 -> 
	happyIn48
		 (BlockStmt (reverse happy_var_2)
	)}

happyReduce_86 = happySpecReduce_0  20# happyReduction_86
happyReduction_86  =  happyIn49
		 (EmptyStmt
	)

happyReduce_87 = happySpecReduce_2  20# happyReduction_87
happyReduction_87 happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn49
		 (Increment (getOffset happy_var_2) happy_var_1
	)}}

happyReduce_88 = happySpecReduce_2  20# happyReduction_88
happyReduction_88 happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn49
		 (Decrement (getOffset happy_var_2) happy_var_1
	)}}

happyReduce_89 = happySpecReduce_3  20# happyReduction_89
happyReduction_89 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut59 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut59 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp Nothing) (nonEmpty happy_var_1) (nonEmpty happy_var_3)
	)}}}

happyReduce_90 = happySpecReduce_3  20# happyReduction_90
happyReduction_90 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just Add) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_91 = happySpecReduce_3  20# happyReduction_91
happyReduction_91 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just Subtract) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_92 = happySpecReduce_3  20# happyReduction_92
happyReduction_92 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just BitOr) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_93 = happySpecReduce_3  20# happyReduction_93
happyReduction_93 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just BitXor) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_94 = happySpecReduce_3  20# happyReduction_94
happyReduction_94 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just Multiply) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_95 = happySpecReduce_3  20# happyReduction_95
happyReduction_95 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just Divide) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_96 = happySpecReduce_3  20# happyReduction_96
happyReduction_96 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just Remainder) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_97 = happySpecReduce_3  20# happyReduction_97
happyReduction_97 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just ShiftL) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_98 = happySpecReduce_3  20# happyReduction_98
happyReduction_98 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just ShiftR) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_99 = happySpecReduce_3  20# happyReduction_99
happyReduction_99 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just BitAnd) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_100 = happySpecReduce_3  20# happyReduction_100
happyReduction_100 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp $ Just BitClear) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_101 = happySpecReduce_3  20# happyReduction_101
happyReduction_101 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (Assign (getOffset happy_var_2) (AssignOp Nothing) (nonEmpty [happy_var_1]) (nonEmpty [happy_var_3])
	)}}}

happyReduce_102 = happySpecReduce_3  20# happyReduction_102
happyReduction_102 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	case happyOut59 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (ShortDeclare ((nonEmpty . reverse) happy_var_1) (nonEmpty happy_var_3)
	)}}

happyReduce_103 = happySpecReduce_3  20# happyReduction_103
happyReduction_103 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn49
		 (ShortDeclare (nonEmpty [getIdent happy_var_1]) (nonEmpty [happy_var_3])
	)}}

happyReduce_104 = happySpecReduce_2  21# happyReduction_104
happyReduction_104 happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	happyIn50
		 (ExprStmt happy_var_1
	)}

happyReduce_105 = happySpecReduce_2  22# happyReduction_105
happyReduction_105 happy_x_2
	happy_x_1
	 =  case happyOut49 happy_x_1 of { happy_var_1 -> 
	happyIn51
		 (happy_var_1
	)}

happyReduce_106 = happySpecReduce_1  22# happyReduction_106
happyReduction_106 happy_x_1
	 =  case happyOut50 happy_x_1 of { happy_var_1 -> 
	happyIn51
		 (happy_var_1
	)}

happyReduce_107 = happyReduce 5# 23# happyReduction_107
happyReduction_107 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut51 happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	case happyOut48 happy_x_4 of { happy_var_4 -> 
	case happyOut53 happy_x_5 of { happy_var_5 -> 
	happyIn52
		 (If (happy_var_2, happy_var_3) happy_var_4 happy_var_5
	) `HappyStk` happyRest}}}}

happyReduce_108 = happyReduce 4# 23# happyReduction_108
happyReduction_108 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut57 happy_x_2 of { happy_var_2 -> 
	case happyOut48 happy_x_3 of { happy_var_3 -> 
	case happyOut53 happy_x_4 of { happy_var_4 -> 
	happyIn52
		 (If (EmptyStmt, happy_var_2) happy_var_3 happy_var_4
	) `HappyStk` happyRest}}}

happyReduce_109 = happySpecReduce_2  24# happyReduction_109
happyReduction_109 happy_x_2
	happy_x_1
	 =  case happyOut52 happy_x_2 of { happy_var_2 -> 
	happyIn53
		 (happy_var_2
	)}

happyReduce_110 = happySpecReduce_2  24# happyReduction_110
happyReduction_110 happy_x_2
	happy_x_1
	 =  case happyOut48 happy_x_2 of { happy_var_2 -> 
	happyIn53
		 (happy_var_2
	)}

happyReduce_111 = happySpecReduce_0  24# happyReduction_111
happyReduction_111  =  happyIn53
		 (blank
	)

happyReduce_112 = happySpecReduce_2  25# happyReduction_112
happyReduction_112 happy_x_2
	happy_x_1
	 =  case happyOut48 happy_x_2 of { happy_var_2 -> 
	happyIn54
		 (For ForInfinite happy_var_2
	)}

happyReduce_113 = happySpecReduce_3  25# happyReduction_113
happyReduction_113 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_2 of { happy_var_2 -> 
	case happyOut48 happy_x_3 of { happy_var_3 -> 
	happyIn54
		 (For (ForCond happy_var_2) happy_var_3
	)}}

happyReduce_114 = happyReduce 6# 25# happyReduction_114
happyReduction_114 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut51 happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	case happyOut49 happy_x_5 of { happy_var_5 -> 
	case happyOut48 happy_x_6 of { happy_var_6 -> 
	happyIn54
		 (For (ForClause happy_var_2 happy_var_3 happy_var_5) happy_var_6
	) `HappyStk` happyRest}}}}

happyReduce_115 = happyReduce 6# 25# happyReduction_115
happyReduction_115 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut51 happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	case happyOut57 happy_x_5 of { happy_var_5 -> 
	case happyOut48 happy_x_6 of { happy_var_6 -> 
	happyIn54
		 (For (ForClause happy_var_2 happy_var_3 (ExprStmt happy_var_5)) happy_var_6
	) `HappyStk` happyRest}}}}

happyReduce_116 = happyReduce 6# 26# happyReduction_116
happyReduction_116 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut51 happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	case happyOut56 happy_x_5 of { happy_var_5 -> 
	happyIn55
		 (Switch happy_var_2 (Just happy_var_3) (reverse happy_var_5)
	) `HappyStk` happyRest}}}

happyReduce_117 = happyReduce 5# 26# happyReduction_117
happyReduction_117 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut51 happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_4 of { happy_var_4 -> 
	happyIn55
		 (Switch happy_var_2 Nothing (reverse happy_var_4)
	) `HappyStk` happyRest}}

happyReduce_118 = happyReduce 5# 26# happyReduction_118
happyReduction_118 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut57 happy_x_2 of { happy_var_2 -> 
	case happyOut56 happy_x_4 of { happy_var_4 -> 
	happyIn55
		 (Switch EmptyStmt (Just happy_var_2) (reverse happy_var_4)
	) `HappyStk` happyRest}}

happyReduce_119 = happyReduce 4# 26# happyReduction_119
happyReduction_119 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut56 happy_x_3 of { happy_var_3 -> 
	happyIn55
		 (Switch EmptyStmt Nothing (reverse happy_var_3)
	) `HappyStk` happyRest}

happyReduce_120 = happyReduce 5# 27# happyReduction_120
happyReduction_120 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut59 happy_x_3 of { happy_var_3 -> 
	case happyOut47 happy_x_5 of { happy_var_5 -> 
	happyIn56
		 ((Case (getOffset happy_var_2) (nonEmpty happy_var_3) (BlockStmt $ reverse happy_var_5)) : happy_var_1
	) `HappyStk` happyRest}}}}

happyReduce_121 = happyReduce 5# 27# happyReduction_121
happyReduction_121 (happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	case happyOut47 happy_x_5 of { happy_var_5 -> 
	happyIn56
		 ((Case (getOffset happy_var_2) (nonEmpty [happy_var_3]) (BlockStmt $ reverse happy_var_5)) : happy_var_1
	) `HappyStk` happyRest}}}}

happyReduce_122 = happyReduce 4# 27# happyReduction_122
happyReduction_122 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut56 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut47 happy_x_4 of { happy_var_4 -> 
	happyIn56
		 ((Default (getOffset happy_var_2) $ BlockStmt (reverse happy_var_4)) : happy_var_1
	) `HappyStk` happyRest}}}

happyReduce_123 = happySpecReduce_0  27# happyReduction_123
happyReduction_123  =  happyIn56
		 ([]
	)

happyReduce_124 = happySpecReduce_1  28# happyReduction_124
happyReduction_124 happy_x_1
	 =  case happyOut58 happy_x_1 of { happy_var_1 -> 
	happyIn57
		 (happy_var_1
	)}

happyReduce_125 = happySpecReduce_1  28# happyReduction_125
happyReduction_125 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn57
		 (Var (getIdent happy_var_1)
	)}

happyReduce_126 = happySpecReduce_2  29# happyReduction_126
happyReduction_126 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut57 happy_x_2 of { happy_var_2 -> 
	happyIn58
		 (Unary (getOffset happy_var_1) Pos happy_var_2
	)}}

happyReduce_127 = happySpecReduce_2  29# happyReduction_127
happyReduction_127 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut57 happy_x_2 of { happy_var_2 -> 
	happyIn58
		 (Unary (getOffset happy_var_1) Neg happy_var_2
	)}}

happyReduce_128 = happySpecReduce_2  29# happyReduction_128
happyReduction_128 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut57 happy_x_2 of { happy_var_2 -> 
	happyIn58
		 (Unary (getOffset happy_var_1) Not happy_var_2
	)}}

happyReduce_129 = happySpecReduce_2  29# happyReduction_129
happyReduction_129 happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut57 happy_x_2 of { happy_var_2 -> 
	happyIn58
		 (Unary (getOffset happy_var_1) BitComplement happy_var_2
	)}}

happyReduce_130 = happySpecReduce_3  29# happyReduction_130
happyReduction_130 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) Or happy_var_1 happy_var_3
	)}}}

happyReduce_131 = happySpecReduce_3  29# happyReduction_131
happyReduction_131 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) And happy_var_1 happy_var_3
	)}}}

happyReduce_132 = happySpecReduce_3  29# happyReduction_132
happyReduction_132 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) Data.EQ happy_var_1 happy_var_3
	)}}}

happyReduce_133 = happySpecReduce_3  29# happyReduction_133
happyReduction_133 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) NEQ happy_var_1 happy_var_3
	)}}}

happyReduce_134 = happySpecReduce_3  29# happyReduction_134
happyReduction_134 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) Data.LT happy_var_1 happy_var_3
	)}}}

happyReduce_135 = happySpecReduce_3  29# happyReduction_135
happyReduction_135 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) LEQ happy_var_1 happy_var_3
	)}}}

happyReduce_136 = happySpecReduce_3  29# happyReduction_136
happyReduction_136 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) Data.GT happy_var_1 happy_var_3
	)}}}

happyReduce_137 = happySpecReduce_3  29# happyReduction_137
happyReduction_137 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) GEQ happy_var_1 happy_var_3
	)}}}

happyReduce_138 = happySpecReduce_3  29# happyReduction_138
happyReduction_138 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) (Arithm Add) happy_var_1 happy_var_3
	)}}}

happyReduce_139 = happySpecReduce_3  29# happyReduction_139
happyReduction_139 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) (Arithm Subtract) happy_var_1 happy_var_3
	)}}}

happyReduce_140 = happySpecReduce_3  29# happyReduction_140
happyReduction_140 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) (Arithm Multiply) happy_var_1 happy_var_3
	)}}}

happyReduce_141 = happySpecReduce_3  29# happyReduction_141
happyReduction_141 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) (Arithm Divide) happy_var_1 happy_var_3
	)}}}

happyReduce_142 = happySpecReduce_3  29# happyReduction_142
happyReduction_142 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) (Arithm Remainder) happy_var_1 happy_var_3
	)}}}

happyReduce_143 = happySpecReduce_3  29# happyReduction_143
happyReduction_143 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) (Arithm BitOr) happy_var_1 happy_var_3
	)}}}

happyReduce_144 = happySpecReduce_3  29# happyReduction_144
happyReduction_144 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) (Arithm BitXor) happy_var_1 happy_var_3
	)}}}

happyReduce_145 = happySpecReduce_3  29# happyReduction_145
happyReduction_145 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) (Arithm BitAnd) happy_var_1 happy_var_3
	)}}}

happyReduce_146 = happySpecReduce_3  29# happyReduction_146
happyReduction_146 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) (Arithm BitClear) happy_var_1 happy_var_3
	)}}}

happyReduce_147 = happySpecReduce_3  29# happyReduction_147
happyReduction_147 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) (Arithm ShiftL) happy_var_1 happy_var_3
	)}}}

happyReduce_148 = happySpecReduce_3  29# happyReduction_148
happyReduction_148 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Binary (getOffset happy_var_2) (Arithm ShiftR) happy_var_1 happy_var_3
	)}}}

happyReduce_149 = happySpecReduce_3  29# happyReduction_149
happyReduction_149 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_2 of { happy_var_2 -> 
	happyIn58
		 (happy_var_2
	)}

happyReduce_150 = happySpecReduce_3  29# happyReduction_150
happyReduction_150 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Selector (getOffset happy_var_2) happy_var_1 $ getIdent happy_var_3
	)}}}

happyReduce_151 = happyReduce 4# 29# happyReduction_151
happyReduction_151 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Index (getOffset happy_var_2) happy_var_1 happy_var_3
	) `HappyStk` happyRest}}}

happyReduce_152 = happySpecReduce_1  29# happyReduction_152
happyReduction_152 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn58
		 (Lit (IntLit (getOffset happy_var_1) Decimal $ getInnerString happy_var_1)
	)}

happyReduce_153 = happySpecReduce_1  29# happyReduction_153
happyReduction_153 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn58
		 (Lit (IntLit (getOffset happy_var_1) Octal $ getInnerString happy_var_1)
	)}

happyReduce_154 = happySpecReduce_1  29# happyReduction_154
happyReduction_154 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn58
		 (Lit (IntLit (getOffset happy_var_1) Hexadecimal $ getInnerString happy_var_1)
	)}

happyReduce_155 = happySpecReduce_1  29# happyReduction_155
happyReduction_155 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn58
		 (Lit (FloatLit (getOffset happy_var_1) $ getInnerString happy_var_1)
	)}

happyReduce_156 = happySpecReduce_1  29# happyReduction_156
happyReduction_156 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn58
		 (Lit (RuneLit (getOffset happy_var_1) $ getInnerString happy_var_1)
	)}

happyReduce_157 = happySpecReduce_1  29# happyReduction_157
happyReduction_157 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn58
		 (Lit (StringLit (getOffset happy_var_1) Interpreted $ getInnerString happy_var_1)
	)}

happyReduce_158 = happySpecReduce_1  29# happyReduction_158
happyReduction_158 happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	happyIn58
		 (Lit (StringLit (getOffset happy_var_1) Raw $ getInnerString happy_var_1)
	)}

happyReduce_159 = happyReduce 6# 29# happyReduction_159
happyReduction_159 (happy_x_6 `HappyStk`
	happy_x_5 `HappyStk`
	happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	case happyOut57 happy_x_5 of { happy_var_5 -> 
	happyIn58
		 (AppendExpr (getOffset happy_var_1) happy_var_3 happy_var_5
	) `HappyStk` happyRest}}}

happyReduce_160 = happyReduce 4# 29# happyReduction_160
happyReduction_160 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (LenExpr (getOffset happy_var_1) happy_var_3
	) `HappyStk` happyRest}}

happyReduce_161 = happyReduce 4# 29# happyReduction_161
happyReduction_161 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (CapExpr (getOffset happy_var_1) happy_var_3
	) `HappyStk` happyRest}}

happyReduce_162 = happySpecReduce_3  29# happyReduction_162
happyReduction_162 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	happyIn58
		 (Arguments (getOffset happy_var_2) happy_var_1 []
	)}}

happyReduce_163 = happyReduce 4# 29# happyReduction_163
happyReduction_163 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Arguments (getOffset happy_var_2) happy_var_1 [happy_var_3]
	) `HappyStk` happyRest}}}

happyReduce_164 = happyReduce 4# 29# happyReduction_164
happyReduction_164 (happy_x_4 `HappyStk`
	happy_x_3 `HappyStk`
	happy_x_2 `HappyStk`
	happy_x_1 `HappyStk`
	happyRest)
	 = case happyOut57 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_2 of { happy_var_2 -> 
	case happyOut59 happy_x_3 of { happy_var_3 -> 
	happyIn58
		 (Arguments (getOffset happy_var_2) happy_var_1 happy_var_3
	) `HappyStk` happyRest}}}

happyReduce_165 = happySpecReduce_1  30# happyReduction_165
happyReduction_165 happy_x_1
	 =  case happyOut60 happy_x_1 of { happy_var_1 -> 
	happyIn59
		 (reverse happy_var_1
	)}

happyReduce_166 = happySpecReduce_1  30# happyReduction_166
happyReduction_166 happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	happyIn59
		 (map Var (reverse happy_var_1)
	)}

happyReduce_167 = happySpecReduce_3  31# happyReduction_167
happyReduction_167 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut60 happy_x_1 of { happy_var_1 -> 
	case happyOut57 happy_x_3 of { happy_var_3 -> 
	happyIn60
		 (happy_var_3 : happy_var_1
	)}}

happyReduce_168 = happySpecReduce_3  31# happyReduction_168
happyReduction_168 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut32 happy_x_1 of { happy_var_1 -> 
	case happyOut58 happy_x_3 of { happy_var_3 -> 
	happyIn60
		 (happy_var_3 : (map Var happy_var_1)
	)}}

happyReduce_169 = happySpecReduce_3  31# happyReduction_169
happyReduction_169 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut58 happy_x_1 of { happy_var_1 -> 
	case happyOut58 happy_x_3 of { happy_var_3 -> 
	happyIn60
		 ([happy_var_3, happy_var_1]
	)}}

happyReduce_170 = happySpecReduce_3  31# happyReduction_170
happyReduction_170 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOut58 happy_x_1 of { happy_var_1 -> 
	case happyOutTok happy_x_3 of { happy_var_3 -> 
	happyIn60
		 ([(Var . getIdent) happy_var_3, happy_var_1]
	)}}

happyReduce_171 = happySpecReduce_3  31# happyReduction_171
happyReduction_171 happy_x_3
	happy_x_2
	happy_x_1
	 =  case happyOutTok happy_x_1 of { happy_var_1 -> 
	case happyOut58 happy_x_3 of { happy_var_3 -> 
	happyIn60
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
  happySomeParser = happyThen (happyParse 18#) (\x -> happyReturn (happyOut51 x))

pIf = happySomeParser where
  happySomeParser = happyThen (happyParse 19#) (\x -> happyReturn (happyOut52 x))

pElses = happySomeParser where
  happySomeParser = happyThen (happyParse 20#) (\x -> happyReturn (happyOut53 x))

pFor = happySomeParser where
  happySomeParser = happyThen (happyParse 21#) (\x -> happyReturn (happyOut54 x))

pSwS = happySomeParser where
  happySomeParser = happyThen (happyParse 22#) (\x -> happyReturn (happyOut55 x))

pSwB = happySomeParser where
  happySomeParser = happyThen (happyParse 23#) (\x -> happyReturn (happyOut56 x))

pE = happySomeParser where
  happySomeParser = happyThen (happyParse 24#) (\x -> happyReturn (happyOut57 x))

pEl = happySomeParser where
  happySomeParser = happyThen (happyParse 25#) (\x -> happyReturn (happyOut59 x))

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
parse :: String -> Either String Program
parse s = either (Left . errODef s) Right (runAlex s $ hparse)

-- Parse function that takes in any parser
parsef :: (Alex a) -> String -> Either String a
parsef f s = either (Left . errODef s) Right (runAlex' s $ f)
-- runAlex' does not insert newline at end if needed

-- parsef but insert newline if needed at end just like main parse function
parsefNL :: (Alex a) -> String -> Either String a
parsefNL f s = either (Left . errODef s) Right (runAlex s $ f)

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
