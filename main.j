.version 52 0
.class public main
.super java/lang/Object

.method public <init> : ()V
    .code stack 1 locals 1
L0:     aload_0
L1:     invokespecial Method java/lang/Object <init> ()V
L4:     return
L5:
        .linenumbertable
            L0 1
        .end linenumbertable
    .end code
.end method

.method public static main : ([Ljava/lang/String;)V
     .code stack 2 locals 1
L0:     getstatic Field java/lang/System out Ljava/io/PrintStream;
L3:     ldc 'hello'
L5:     invokevirtual Method java/io/PrintStream println (Ljava/lang/String;)V
L8:     return
L9:
        .linenumbertable
            L0 3
            L8 4
        .end linenumbertable
    .end code
.end method
.sourcefile 'Main.java'
.end class
