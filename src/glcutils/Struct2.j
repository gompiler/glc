.version 52 0 
.class public super glcutils/Struct2 
.super java/lang/Object 
.implements glcutils/GlcCopy 
.field private floatField F 

.method public <init> : ()V 
    .code stack 2 locals 1 
L0:     aload_0 
L1:     invokespecial Method java/lang/Object <init> ()V 
L4:     aload_0 
L5:     fconst_0 
L6:     putfield Field glcutils/Struct2 floatField F 
L9:     return 
L10:    
        .linenumbertable 
            L0 7 
            L4 8 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/Struct2; from L0 to L10 
        .end localvariabletable 
    .end code 
.end method 

.method public setFloatField : (F)V 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     fload_1 
L2:     putfield Field glcutils/Struct2 floatField F 
L5:     return 
L6:     
        .linenumbertable 
            L0 15 
            L5 16 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/Struct2; from L0 to L6 
            1 is o F from L0 to L6 
        .end localvariabletable 
    .end code 
.end method 

.method public getFloatField : ()F 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/Struct2 floatField F 
L4:     freturn 
L5:     
        .linenumbertable 
            L0 19 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/Struct2; from L0 to L5 
        .end localvariabletable 
    .end code 
.end method 

.method public copy : ()Ljava/lang/Object; 
    .code stack 2 locals 2 
L0:     new glcutils/Struct2 
L3:     dup 
L4:     invokespecial Method glcutils/Struct2 <init> ()V 
L7:     astore_1 
L8:     aload_1 
L9:     aload_0 
L10:    getfield Field glcutils/Struct2 floatField F 
L13:    putfield Field glcutils/Struct2 floatField F 
L16:    aload_1 
L17:    areturn 
L18:    
        .linenumbertable 
            L0 24 
            L8 25 
            L16 26 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/Struct2; from L0 to L18 
            1 is s Lglcutils/Struct2; from L8 to L18 
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
L8:     instanceof glcutils/Struct2 
L11:    ifne L16 
L14:    iconst_0 
L15:    ireturn 

        .stack same 
L16:    aload_1 
L17:    checkcast glcutils/Struct2 
L20:    astore_2 
L21:    aload_0 
L22:    getfield Field glcutils/Struct2 floatField F 
L25:    aload_2 
L26:    getfield Field glcutils/Struct2 floatField F 
L29:    fcmpl 
L30:    ifeq L35 
L33:    iconst_0 
L34:    ireturn 

        .stack append Object glcutils/Struct2 
L35:    iconst_1 
L36:    ireturn 
L37:    
        .linenumbertable 
            L0 31 
            L5 32 
            L7 34 
            L14 35 
            L16 37 
            L21 39 
            L33 40 
            L35 42 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/Struct2; from L0 to L37 
            1 is obj Ljava/lang/Object; from L0 to L37 
            2 is other Lglcutils/Struct2; from L21 to L37 
        .end localvariabletable 
    .end code 
.end method 
.sourcefile 'Struct2.java' 
.end class 
