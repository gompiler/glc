.version 52 0 
.class public super glcutils/Utils 
.super java/lang/Object 

.method public <init> : ()V 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     invokespecial Method java/lang/Object <init> ()V 
L4:     return 
L5:     
        .linenumbertable 
            L0 3 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/Utils; from L0 to L5 
        .end localvariabletable 
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
        .linenumbertable 
            L0 5 
            L4 6 
            L7 8 
        .end linenumbertable 
        .localvariabletable 
            0 is b I from L0 to L10 
        .end localvariabletable 
    .end code 
.end method 

.method public static newInstance : (Ljava/lang/Class;)Ljava/lang/Object; 
    .code stack 3 locals 2 
        .catch java/lang/InstantiationException from L0 to L4 using L5 
        .catch java/lang/IllegalAccessException from L0 to L4 using L5 
L0:     aload_0 
L1:     invokevirtual Method java/lang/Class newInstance ()Ljava/lang/Object; 
L4:     areturn 

        .stack stack_1 Object java/lang/ReflectiveOperationException 
L5:     astore_1 
L6:     new java/lang/RuntimeException 
L9:     dup 
L10:    aload_1 
L11:    invokespecial Method java/lang/RuntimeException <init> (Ljava/lang/Throwable;)V 
L14:    athrow 
L15:    
        .linenumbertable 
            L0 14 
            L5 15 
            L6 16 
        .end linenumbertable 
        .localvariabletable 
            1 is e Ljava/lang/ReflectiveOperationException; from L6 to L15 
            0 is clazz Ljava/lang/Class; from L0 to L15 
        .end localvariabletable 
        .localvariabletypetable 
            0 is clazz Ljava/lang/Class<+TT;>; from L0 to L15 
        .end localvariabletypetable 
    .end code 
    .signature '<T:Ljava/lang/Object;>(Ljava/lang/Class<+TT;>;)TT;' 
.end method 
.sourcefile 'Utils.java' 
.end class 
