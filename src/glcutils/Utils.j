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
            L0 5 
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
            L0 7 
            L4 8 
            L7 10 
        .end linenumbertable 
        .localvariabletable 
            0 is b I from L0 to L10 
        .end localvariabletable 
    .end code 
.end method 

.method public static tail : ([I)[I 
    .code stack 3 locals 1 
L0:     aload_0 
L1:     iconst_1 
L2:     aload_0 
L3:     arraylength 
L4:     invokestatic Method java/util/Arrays copyOfRange ([III)[I 
L7:     areturn 
L8:     
        .linenumbertable 
            L0 15 
        .end linenumbertable 
        .localvariabletable 
            0 is array [I from L0 to L8 
        .end localvariabletable 
    .end code 
.end method 

.method public static varargs fail : (Ljava/lang/String;[Ljava/lang/Object;)V 
    .code stack 4 locals 2 
L0:     new java/lang/RuntimeException 
L3:     dup 
L4:     aload_0 
L5:     aload_1 
L6:     invokestatic Method java/lang/String format (Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String; 
L9:     invokespecial Method java/lang/RuntimeException <init> (Ljava/lang/String;)V 
L12:    athrow 
L13:    
        .linenumbertable 
            L0 19 
        .end linenumbertable 
        .localvariabletable 
            0 is s Ljava/lang/String; from L0 to L13 
            1 is args [Ljava/lang/Object; from L0 to L13 
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
            L0 28 
            L6 29 
            L8 32 
            L13 33 
            L14 34 
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

.method public static supplyObj : (Ljava/lang/Class;)Ljava/lang/Object; 
    .code stack 3 locals 2 
L0:     aload_0 
L1:     ldc Class java/lang/String 
L3:     if_acmpne L8 
L6:     aconst_null 
L7:     areturn 

        .stack same 
L8:     aload_0 
L9:     ldc Class java/lang/Integer 
L11:    if_acmpne L19 
L14:    iconst_0 
L15:    invokestatic Method java/lang/Integer valueOf (I)Ljava/lang/Integer; 
L18:    areturn 

        .stack same 
L19:    aload_0 
L20:    ldc Class java/lang/Boolean 
L22:    if_acmpne L30 
L25:    iconst_0 
L26:    invokestatic Method java/lang/Boolean valueOf (Z)Ljava/lang/Boolean; 
L29:    areturn 

        .stack same 
L30:    aload_0 
L31:    ldc Class java/lang/Float 
L33:    if_acmpne L41 
L36:    fconst_0 
L37:    invokestatic Method java/lang/Float valueOf (F)Ljava/lang/Float; 
L40:    areturn 

        .stack same 
L41:    aload_0 
L42:    ldc Class java/lang/Character 
L44:    if_acmpne L52 
L47:    iconst_0 
L48:    invokestatic Method java/lang/Character valueOf (C)Ljava/lang/Character; 
L51:    areturn 
        .catch java/lang/InstantiationException from L52 to L56 using L57 
        .catch java/lang/IllegalAccessException from L52 to L56 using L57 

        .stack same 
L52:    aload_0 
L53:    invokevirtual Method java/lang/Class newInstance ()Ljava/lang/Object; 
L56:    areturn 

        .stack stack_1 Object java/lang/ReflectiveOperationException 
L57:    astore_1 
L58:    new java/lang/RuntimeException 
L61:    dup 
L62:    aload_1 
L63:    invokespecial Method java/lang/RuntimeException <init> (Ljava/lang/Throwable;)V 
L66:    athrow 
L67:    
        .linenumbertable 
            L0 39 
            L6 40 
            L8 42 
            L14 43 
            L19 45 
            L25 46 
            L30 48 
            L36 49 
            L41 51 
            L47 52 
            L52 55 
            L57 56 
            L58 57 
        .end linenumbertable 
        .localvariabletable 
            1 is e Ljava/lang/ReflectiveOperationException; from L58 to L67 
            0 is clazz Ljava/lang/Class; from L0 to L67 
        .end localvariabletable 
    .end code 
.end method 
.sourcefile 'Utils.java' 
.end class 
