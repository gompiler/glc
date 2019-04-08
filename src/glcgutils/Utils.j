.class public super Utils
.super java/lang/Object

.method public <init> : ()V
    .code stack 1 locals 1
L0:     aload_0
L1:     invokespecial Method java/lang/Object <init> ()V
L4:     return
L5:
    .end code
.end method

.method public static boolStr : (I)Ljava/lang/String;
    .code stack 1 locals 1
L0:     iload_0
L1:     ifne L7
L4:     ldc 'false'
L6:     areturn

        .stack same
L7:     ldc 'true'
L9:     areturn
L10:
    .end code
.end method
.end class
