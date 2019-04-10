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

.method public static supply : (Ljava/lang/Class;)Ljava/lang/Object; 
    .code stack 3 locals 2 
L0:     aload_0 
L1:     ldc Class java/lang/String 
L3:     if_acmpne L8 
L6:     aconst_null 
L7:     areturn 
        .catch java/lang/InstantiationException from L8 to L12 using L13 
        .catch java/lang/IllegalAccessException from L8 to L12 using L13 

        .stack same 
L8:     aload_0 
L9:     invokevirtual Method java/lang/Class newInstance ()Ljava/lang/Object; 
L12:    areturn 

        .stack stack_1 Object java/lang/ReflectiveOperationException 
L13:    astore_1 
L14:    new java/lang/RuntimeException 
L17:    dup 
L18:    aload_1 
L19:    invokespecial Method java/lang/RuntimeException <init> (Ljava/lang/Throwable;)V 
L22:    athrow 
L23:    
        .linenumbertable 
            L0 18 
            L6 19 
            L8 22 
            L13 23 
            L14 24 
        .end linenumbertable 
        .localvariabletable 
            1 is e Ljava/lang/ReflectiveOperationException; from L14 to L23 
            0 is clazz Ljava/lang/Class; from L0 to L23 
        .end localvariabletable 
        .localvariabletypetable 
            0 is clazz Ljava/lang/Class<+TT;>; from L0 to L23 
        .end localvariabletypetable 
    .end code 
    .signature '<T:Ljava/lang/Object;>(Ljava/lang/Class<+TT;>;)TT;' 
.end method 
.sourcefile 'Utils.java' 
.end class 
