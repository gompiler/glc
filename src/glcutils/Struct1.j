.version 52 0 
.class public super glcutils/Struct1 
.super java/lang/Object 
.implements glcutils/GlcCopy 
.field private intField I 
.field private stringField Ljava/lang/String; 
.field private structField Lglcutils/Struct2; 

.method public <init> : ()V 
    .code stack 2 locals 1 
L0:     aload_0 
L1:     invokespecial Method java/lang/Object <init> ()V 
L4:     aload_0 
L5:     iconst_0 
L6:     putfield Field glcutils/Struct1 intField I 
L9:     aload_0 
L10:    aconst_null 
L11:    putfield Field glcutils/Struct1 stringField Ljava/lang/String; 
L14:    aload_0 
L15:    aconst_null 
L16:    putfield Field glcutils/Struct1 structField Lglcutils/Struct2; 
L19:    return 
L20:    
        .linenumbertable 
            L0 9 
            L4 11 
            L9 14 
            L14 17 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/Struct1; from L0 to L20 
        .end localvariabletable 
    .end code 
.end method 

.method public setIntField : (I)V 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     iload_1 
L2:     putfield Field glcutils/Struct1 intField I 
L5:     return 
L6:     
        .linenumbertable 
            L0 24 
            L5 25 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/Struct1; from L0 to L6 
            1 is o I from L0 to L6 
        .end localvariabletable 
    .end code 
.end method 

.method public getIntField : ()I 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/Struct1 intField I 
L4:     ireturn 
L5:     
        .linenumbertable 
            L0 28 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/Struct1; from L0 to L5 
        .end localvariabletable 
    .end code 
.end method 

.method public setStringField : (Ljava/lang/String;)V 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     aload_1 
L2:     putfield Field glcutils/Struct1 stringField Ljava/lang/String; 
L5:     return 
L6:     
        .linenumbertable 
            L0 32 
            L5 33 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/Struct1; from L0 to L6 
            1 is o Ljava/lang/String; from L0 to L6 
        .end localvariabletable 
    .end code 
.end method 

.method public getStringField : ()Ljava/lang/String; 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/Struct1 stringField Ljava/lang/String; 
L4:     areturn 
L5:     
        .linenumbertable 
            L0 37 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/Struct1; from L0 to L5 
        .end localvariabletable 
    .end code 
.end method 

.method public setStructField : (Lglcutils/Struct2;)V 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     aload_1 
L2:     putfield Field glcutils/Struct1 structField Lglcutils/Struct2; 
L5:     return 
L6:     
        .linenumbertable 
            L0 43 
            L5 44 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/Struct1; from L0 to L6 
            1 is o Lglcutils/Struct2; from L0 to L6 
        .end localvariabletable 
    .end code 
.end method 

.method public getStructField : ()Lglcutils/Struct2; 
    .code stack 2 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/Struct1 structField Lglcutils/Struct2; 
L4:     ifnonnull L19 
L7:     aload_0 
L8:     ldc Class glcutils/Struct2 
L10:    invokestatic Method glcutils/Utils supply (Ljava/lang/Class;)Ljava/lang/Object; 
L13:    checkcast glcutils/Struct2 
L16:    putfield Field glcutils/Struct1 structField Lglcutils/Struct2; 

        .stack same 
L19:    aload_0 
L20:    getfield Field glcutils/Struct1 structField Lglcutils/Struct2; 
L23:    areturn 
L24:    
        .linenumbertable 
            L0 47 
            L7 48 
            L19 50 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/Struct1; from L0 to L24 
        .end localvariabletable 
    .end code 
.end method 

.method public copy : ()Ljava/lang/Object; 
    .code stack 2 locals 2 
L0:     new glcutils/Struct1 
L3:     dup 
L4:     invokespecial Method glcutils/Struct1 <init> ()V 
L7:     astore_1 
L8:     aload_1 
L9:     aload_0 
L10:    getfield Field glcutils/Struct1 intField I 
L13:    putfield Field glcutils/Struct1 intField I 
L16:    aload_1 
L17:    aload_0 
L18:    getfield Field glcutils/Struct1 stringField Ljava/lang/String; 
L21:    putfield Field glcutils/Struct1 stringField Ljava/lang/String; 
L24:    aload_1 
L25:    aload_0 
L26:    getfield Field glcutils/Struct1 structField Lglcutils/Struct2; 
L29:    invokestatic Method glcutils/Utils copy (Ljava/lang/Object;)Ljava/lang/Object; 
L32:    checkcast glcutils/Struct2 
L35:    putfield Field glcutils/Struct1 structField Lglcutils/Struct2; 
L38:    aload_1 
L39:    areturn 
L40:    
        .linenumbertable 
            L0 55 
            L8 56 
            L16 57 
            L24 58 
            L38 59 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/Struct1; from L0 to L40 
            1 is s Lglcutils/Struct1; from L8 to L40 
        .end localvariabletable 
    .end code 
.end method 

.method public equals : (Ljava/lang/Object;)Z 
    .code stack 2 locals 3 
L0:     aload_0 
L1:     aload_1 
L2:     if_acmpne L7 
L5:     iconst_1 
L6:     ireturn 

        .stack same 
L7:     aload_1 
L8:     instanceof glcutils/Struct1 
L11:    ifne L16 
L14:    iconst_0 
L15:    ireturn 

        .stack same 
L16:    aload_1 
L17:    checkcast glcutils/Struct1 
L20:    astore_2 
L21:    aload_0 
L22:    getfield Field glcutils/Struct1 intField I 
L25:    aload_2 
L26:    getfield Field glcutils/Struct1 intField I 
L29:    if_icmpeq L34 
L32:    iconst_0 
L33:    ireturn 

        .stack append Object glcutils/Struct1 
L34:    aload_0 
L35:    getfield Field glcutils/Struct1 stringField Ljava/lang/String; 
L38:    aload_2 
L39:    getfield Field glcutils/Struct1 stringField Ljava/lang/String; 
L42:    invokestatic Method java/util/Objects equals (Ljava/lang/Object;Ljava/lang/Object;)Z 
L45:    ifne L50 
L48:    iconst_0 
L49:    ireturn 

        .stack same 
L50:    aload_0 
L51:    getfield Field glcutils/Struct1 structField Lglcutils/Struct2; 
L54:    aload_2 
L55:    getfield Field glcutils/Struct1 structField Lglcutils/Struct2; 
L58:    if_acmpeq L77 
L61:    aload_0 
L62:    invokevirtual Method glcutils/Struct1 getStructField ()Lglcutils/Struct2; 
L65:    aload_2 
L66:    invokevirtual Method glcutils/Struct1 getStructField ()Lglcutils/Struct2; 
L69:    invokevirtual Method glcutils/Struct2 equals (Ljava/lang/Object;)Z 
L72:    ifne L77 
L75:    iconst_0 
L76:    ireturn 

        .stack same 
L77:    iconst_1 
L78:    ireturn 
L79:    
        .linenumbertable 
            L0 64 
            L5 65 
            L7 67 
            L14 68 
            L16 70 
            L21 72 
            L32 73 
            L34 77 
            L48 78 
            L50 85 
            L75 86 
            L77 88 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/Struct1; from L0 to L79 
            1 is obj Ljava/lang/Object; from L0 to L79 
            2 is other Lglcutils/Struct1; from L21 to L79 
        .end localvariabletable 
    .end code 
.end method 
.sourcefile 'Struct1.java' 
.end class 
