.version 52 0 
.class public super glcutils/GlcSlice$Char_1 
.super glcutils/GlcArray$Char_1 

.method public <init> : ()V 
    .code stack 3 locals 1 
L0:     aload_0 
L1:     iconst_0 
L2:     aconst_null 
L3:     invokespecial Method glcutils/GlcSlice$Char_1 <init> (I[C)V 
L6:     return 
L7:     
        .linenumbertable 
            L0 6 
            L6 7 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcSlice$Char_1; from L0 to L7 
        .end localvariabletable 
    .end code 
.end method 

.method private <init> : (I[C)V 
    .code stack 3 locals 3 
L0:     aload_0 
L1:     iload_1 
L2:     aload_2 
L3:     invokespecial Method glcutils/GlcArray$Char_1 <init> (I[C)V 
L6:     return 
L7:     
        .linenumbertable 
            L0 10 
            L6 11 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcSlice$Char_1; from L0 to L7 
            1 is length I from L0 to L7 
            2 is array [C from L0 to L7 
        .end localvariabletable 
    .end code 
.end method 

.method public append : (C)Lglcutils/GlcSlice$Char_1; 
    .code stack 4 locals 3 
L0:     aload_0 
L1:     getfield Field glcutils/GlcSlice$Char_1 array [C 
L4:     aload_0 
L5:     getfield Field glcutils/GlcSlice$Char_1 length I 
L8:     iload_1 
L9:     invokestatic Method glcutils/GlcSliceUtils append ([CIC)[C 
L12:    astore_2 
L13:    new glcutils/GlcSlice$Char_1 
L16:    dup 
L17:    aload_0 
L18:    getfield Field glcutils/GlcSlice$Char_1 length I 
L21:    iconst_1 
L22:    iadd 
L23:    aload_2 
L24:    invokespecial Method glcutils/GlcSlice$Char_1 <init> (I[C)V 
L27:    areturn 
L28:    
        .linenumbertable 
            L0 19 
            L13 20 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcSlice$Char_1; from L0 to L28 
            1 is t C from L0 to L28 
            2 is newArray [C from L13 to L28 
        .end localvariabletable 
    .end code 
.end method 
.sourcefile 'GlcSlice$Char_1.java' 
.end class 
