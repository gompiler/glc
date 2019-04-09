.version 52 0 
.class public super glcutils/GlcIntArray 
.super java/lang/Object 
.field length I 
.field array [I 

.method public <init> : (I)V 
    .code stack 3 locals 2 
L0:     aload_0 
L1:     iload_1 
L2:     aconst_null 
L3:     invokespecial Method glcutils/GlcIntArray <init> (I[I)V 
L6:     return 
L7:     
        .linenumbertable 
            L0 10 
            L6 11 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcIntArray; from L0 to L7 
            1 is length I from L0 to L7 
        .end localvariabletable 
    .end code 
.end method 

.method <init> : (I[I)V 
    .code stack 2 locals 3 
L0:     aload_0 
L1:     invokespecial Method java/lang/Object <init> ()V 
L4:     aload_0 
L5:     iload_1 
L6:     putfield Field glcutils/GlcIntArray length I 
L9:     aload_0 
L10:    aload_2 
L11:    putfield Field glcutils/GlcIntArray array [I 
L14:    return 
L15:    
        .linenumbertable 
            L0 13 
            L4 14 
            L9 15 
            L14 16 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcIntArray; from L0 to L15 
            1 is length I from L0 to L15 
            2 is array [I from L0 to L15 
        .end localvariabletable 
    .end code 
.end method 

.method final init : ()V 
    .code stack 2 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/GlcIntArray array [I 
L4:     ifnonnull L17 
L7:     aload_0 
L8:     aload_0 
L9:     getfield Field glcutils/GlcIntArray length I 
L12:    newarray int 
L14:    putfield Field glcutils/GlcIntArray array [I 

        .stack same 
L17:    return 
L18:    
        .linenumbertable 
            L0 22 
            L7 23 
            L17 25 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcIntArray; from L0 to L18 
        .end localvariabletable 
    .end code 
.end method 

.method public final get : (I)I 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     invokevirtual Method glcutils/GlcIntArray init ()V 
L4:     aload_0 
L5:     getfield Field glcutils/GlcIntArray array [I 
L8:     iload_1 
L9:     iaload 
L10:    ireturn 
L11:    
        .linenumbertable 
            L0 31 
            L4 32 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcIntArray; from L0 to L11 
            1 is i I from L0 to L11 
        .end localvariabletable 
    .end code 
.end method 

.method public final set : (II)V 
    .code stack 3 locals 3 
L0:     aload_0 
L1:     invokevirtual Method glcutils/GlcIntArray init ()V 
L4:     aload_0 
L5:     getfield Field glcutils/GlcIntArray array [I 
L8:     iload_1 
L9:     iload_2 
L10:    iastore 
L11:    return 
L12:    
        .linenumbertable 
            L0 39 
            L4 40 
            L11 41 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcIntArray; from L0 to L12 
            1 is i I from L0 to L12 
            2 is t I from L0 to L12 
        .end localvariabletable 
    .end code 
.end method 

.method public final length : ()I 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/GlcIntArray length I 
L4:     ireturn 
L5:     
        .linenumbertable 
            L0 48 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcIntArray; from L0 to L5 
        .end localvariabletable 
    .end code 
.end method 

.method public final capacity : ()I 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/GlcIntArray array [I 
L4:     ifnonnull L11 
L7:     iconst_0 
L8:     goto L16 

        .stack same 
L11:    aload_0 
L12:    getfield Field glcutils/GlcIntArray array [I 
L15:    arraylength 

        .stack stack_1 Integer 
L16:    ireturn 
L17:    
        .linenumbertable 
            L0 56 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcIntArray; from L0 to L17 
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
L8:     ifnull L22 
L11:    aload_1 
L12:    invokevirtual Method java/lang/Object getClass ()Ljava/lang/Class; 
L15:    aload_0 
L16:    invokevirtual Method java/lang/Object getClass ()Ljava/lang/Class; 
L19:    if_acmpeq L24 

        .stack same 
L22:    iconst_0 
L23:    ireturn 

        .stack same 
L24:    aload_1 
L25:    checkcast glcutils/GlcIntArray 
L28:    astore_2 
L29:    aload_0 
L30:    getfield Field glcutils/GlcIntArray length I 
L33:    aload_2 
L34:    getfield Field glcutils/GlcIntArray length I 
L37:    if_icmpeq L42 
L40:    iconst_0 
L41:    ireturn 

        .stack append Object glcutils/GlcIntArray 
L42:    aload_0 
L43:    getfield Field glcutils/GlcIntArray array [I 
L46:    aload_2 
L47:    getfield Field glcutils/GlcIntArray array [I 
L50:    if_acmpne L55 
L53:    iconst_1 
L54:    ireturn 

        .stack same 
L55:    aload_0 
L56:    invokevirtual Method glcutils/GlcIntArray init ()V 
L59:    aload_2 
L60:    invokevirtual Method glcutils/GlcIntArray init ()V 
L63:    aload_0 
L64:    getfield Field glcutils/GlcIntArray array [I 
L67:    aload_2 
L68:    getfield Field glcutils/GlcIntArray array [I 
L71:    invokestatic Method java/util/Arrays equals ([I[I)Z 
L74:    ireturn 
L75:    
        .linenumbertable 
            L0 61 
            L5 62 
            L7 64 
            L22 65 
            L24 67 
            L29 68 
            L40 69 
            L42 71 
            L53 72 
            L55 74 
            L59 75 
            L63 76 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcIntArray; from L0 to L75 
            1 is obj Ljava/lang/Object; from L0 to L75 
            2 is other Lglcutils/GlcIntArray; from L29 to L75 
        .end localvariabletable 
    .end code 
.end method 

.method public hashCode : ()I 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/GlcIntArray array [I 
L4:     invokestatic Method java/util/Arrays hashCode ([I)I 
L7:     ireturn 
L8:     
        .linenumbertable 
            L0 81 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcIntArray; from L0 to L8 
        .end localvariabletable 
    .end code 
.end method 

.method public toString : ()Ljava/lang/String; 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/GlcIntArray array [I 
L4:     invokestatic Method java/util/Arrays toString ([I)Ljava/lang/String; 
L7:     areturn 
L8:     
        .linenumbertable 
            L0 86 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcIntArray; from L0 to L8 
        .end localvariabletable 
    .end code 
.end method 
.sourcefile 'GlcIntArray.java' 
.end class 
