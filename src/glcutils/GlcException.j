.version 52 0 
.class public super glcutils/GlcException 
.super java/lang/RuntimeException 

.method public <init> : ()V 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     invokespecial Method java/lang/RuntimeException <init> ()V 
L4:     return 
L5:     
        .linenumbertable 
            L0 5 
            L4 6 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcException; from L0 to L5 
        .end localvariabletable 
    .end code 
.end method 

.method public <init> : (Ljava/lang/String;)V 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     aload_1 
L2:     invokespecial Method java/lang/RuntimeException <init> (Ljava/lang/String;)V 
L5:     return 
L6:     
        .linenumbertable 
            L0 9 
            L5 10 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcException; from L0 to L6 
            1 is message Ljava/lang/String; from L0 to L6 
        .end localvariabletable 
    .end code 
.end method 

.method public <init> : (Ljava/lang/String;Ljava/lang/Throwable;)V 
    .code stack 3 locals 3 
L0:     aload_0 
L1:     aload_1 
L2:     aload_2 
L3:     invokespecial Method java/lang/RuntimeException <init> (Ljava/lang/String;Ljava/lang/Throwable;)V 
L6:     return 
L7:     
        .linenumbertable 
            L0 13 
            L6 14 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcException; from L0 to L7 
            1 is message Ljava/lang/String; from L0 to L7 
            2 is cause Ljava/lang/Throwable; from L0 to L7 
        .end localvariabletable 
    .end code 
.end method 

.method public <init> : (Ljava/lang/Throwable;)V 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     aload_1 
L2:     invokespecial Method java/lang/RuntimeException <init> (Ljava/lang/Throwable;)V 
L5:     return 
L6:     
        .linenumbertable 
            L0 17 
            L5 18 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcException; from L0 to L6 
            1 is cause Ljava/lang/Throwable; from L0 to L6 
        .end localvariabletable 
    .end code 
.end method 
.sourcefile 'GlcException.java' 
.end class 
