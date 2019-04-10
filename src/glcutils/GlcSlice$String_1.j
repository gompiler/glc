.version 52 0 
.class public super glcutils/GlcSlice$String_1 
.super glcutils/GlcArray$String_1 

.method public <init> : ()V 
    .code stack 3 locals 1 
L0:     aload_0 
L1:     iconst_0 
L2:     aconst_null 
L3:     invokespecial Method glcutils/GlcSlice$String_1 <init> (I[Ljava/lang/String;)V 
L6:     return 
L7:     
        .linenumbertable 
            L0 6 
            L6 7 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcSlice$String_1; from L0 to L7 
        .end localvariabletable 
    .end code 
.end method 

.method private <init> : (I[Ljava/lang/String;)V 
    .code stack 3 locals 3 
L0:     aload_0 
L1:     iload_1 
L2:     aload_2 
L3:     invokespecial Method glcutils/GlcArray$String_1 <init> (I[Ljava/lang/String;)V 
L6:     return 
L7:     
        .linenumbertable 
            L0 10 
            L6 11 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcSlice$String_1; from L0 to L7 
            1 is length I from L0 to L7 
            2 is array [Ljava/lang/String; from L0 to L7 
        .end localvariabletable 
    .end code 
.end method 

.method public append : (Ljava/lang/String;)Lglcutils/GlcSlice$String_1; 
    .code stack 4 locals 3 
L0:     ldc Class java/lang/String 
L2:     aload_0 
L3:     getfield Field glcutils/GlcSlice$String_1 array [Ljava/lang/String; 
L6:     aload_0 
L7:     getfield Field glcutils/GlcSlice$String_1 length I 
L10:    aload_1 
L11:    invokestatic Method glcutils/GlcSliceUtils append (Ljava/lang/Class;[Ljava/lang/Object;ILjava/lang/Object;)[Ljava/lang/Object; 
L14:    checkcast [Ljava/lang/String; 
L17:    astore_2 
L18:    new glcutils/GlcSlice$String_1 
L21:    dup 
L22:    aload_0 
L23:    getfield Field glcutils/GlcSlice$String_1 length I 
L26:    iconst_1 
L27:    iadd 
L28:    aload_2 
L29:    invokespecial Method glcutils/GlcSlice$String_1 <init> (I[Ljava/lang/String;)V 
L32:    areturn 
L33:    
        .linenumbertable 
            L0 19 
            L18 20 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcSlice$String_1; from L0 to L33 
            1 is t Ljava/lang/String; from L0 to L33 
            2 is newArray [Ljava/lang/String; from L18 to L33 
        .end localvariabletable 
    .end code 
.end method 
.sourcefile 'GlcSlice$String_1.java' 
.end class 
