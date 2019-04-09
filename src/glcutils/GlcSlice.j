.version 52 0 
.class public super glcutils/GlcSlice 
.super glcutils/GlcArray 

.method public <init> : (Ljava/lang/Class;)V 
    .code stack 4 locals 2 
L0:     aload_0 
L1:     aload_1 
L2:     iconst_0 
L3:     aconst_null 
L4:     invokespecial Method glcutils/GlcSlice <init> (Ljava/lang/Class;I[Ljava/lang/Object;)V 
L7:     return 
L8:     
        .linenumbertable 
            L0 6 
            L7 7 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcSlice; from L0 to L8 
            1 is clazz Ljava/lang/Class; from L0 to L8 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcSlice<TT;>; from L0 to L8 
            1 is clazz Ljava/lang/Class<+TT;>; from L0 to L8 
        .end localvariabletypetable 
    .end code 
    .signature (Ljava/lang/Class<+TT;>;)V 
.end method 

.method private <init> : (Ljava/lang/Class;I[Ljava/lang/Object;)V 
    .code stack 4 locals 4 
L0:     aload_0 
L1:     aload_1 
L2:     iload_2 
L3:     aload_3 
L4:     invokespecial Method glcutils/GlcArray <init> (Ljava/lang/Class;I[Ljava/lang/Object;)V 
L7:     return 
L8:     
        .linenumbertable 
            L0 10 
            L7 11 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcSlice; from L0 to L8 
            1 is clazz Ljava/lang/Class; from L0 to L8 
            2 is length I from L0 to L8 
            3 is array [Ljava/lang/Object; from L0 to L8 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcSlice<TT;>; from L0 to L8 
            1 is clazz Ljava/lang/Class<+TT;>; from L0 to L8 
            3 is array [TT; from L0 to L8 
        .end localvariabletypetable 
    .end code 
    .signature (Ljava/lang/Class<+TT;>;I[TT;)V 
.end method 

.method public append : (Ljava/lang/Object;)Lglcutils/GlcSlice; 
    .code stack 5 locals 4 
L0:     aload_0 
L1:     getfield Field glcutils/GlcSlice length I 
L4:     aload_0 
L5:     invokevirtual Method glcutils/GlcSlice capacity ()I 
L8:     iconst_1 
L9:     isub 
L10:    if_icmplt L84 
L13:    aload_0 
L14:    invokevirtual Method glcutils/GlcSlice capacity ()I 
L17:    ifne L24 
L20:    iconst_2 
L21:    goto L30 

        .stack same 
L24:    aload_0 
L25:    invokevirtual Method glcutils/GlcSlice capacity ()I 
L28:    iconst_2 
L29:    imul 

        .stack stack_1 Integer 
L30:    istore_2 
L31:    aload_0 
L32:    iload_2 
L33:    invokevirtual Method glcutils/GlcSlice create (I)[Ljava/lang/Object; 
L36:    astore_3 
L37:    aload_0 
L38:    getfield Field glcutils/GlcSlice array [Ljava/lang/Object; 
L41:    ifnull L58 
L44:    aload_0 
L45:    getfield Field glcutils/GlcSlice array [Ljava/lang/Object; 
L48:    iconst_0 
L49:    aload_3 
L50:    iconst_0 
L51:    aload_0 
L52:    getfield Field glcutils/GlcSlice length I 
L55:    invokestatic Method java/lang/System arraycopy (Ljava/lang/Object;ILjava/lang/Object;II)V 

        .stack append Integer Object [Ljava/lang/Object; 
L58:    aload_3 
L59:    aload_0 
L60:    getfield Field glcutils/GlcSlice length I 
L63:    aload_1 
L64:    aastore 
L65:    new glcutils/GlcSlice 
L68:    dup 
L69:    aload_0 
L70:    getfield Field glcutils/GlcSlice clazz Ljava/lang/Class; 
L73:    aload_0 
L74:    getfield Field glcutils/GlcSlice length I 
L77:    iconst_1 
L78:    iadd 
L79:    aload_3 
L80:    invokespecial Method glcutils/GlcSlice <init> (Ljava/lang/Class;I[Ljava/lang/Object;)V 
L83:    areturn 

        .stack chop 2 
L84:    aload_0 
L85:    getfield Field glcutils/GlcSlice array [Ljava/lang/Object; 
L88:    aload_0 
L89:    getfield Field glcutils/GlcSlice length I 
L92:    aload_1 
L93:    aastore 
L94:    new glcutils/GlcSlice 
L97:    dup 
L98:    aload_0 
L99:    getfield Field glcutils/GlcSlice clazz Ljava/lang/Class; 
L102:   aload_0 
L103:   getfield Field glcutils/GlcSlice length I 
L106:   iconst_1 
L107:   iadd 
L108:   aload_0 
L109:   getfield Field glcutils/GlcSlice array [Ljava/lang/Object; 
L112:   invokespecial Method glcutils/GlcSlice <init> (Ljava/lang/Class;I[Ljava/lang/Object;)V 
L115:   areturn 
L116:   
        .linenumbertable 
            L0 19 
            L13 22 
            L31 23 
            L37 24 
            L44 25 
            L58 27 
            L65 29 
            L84 32 
            L94 33 
        .end linenumbertable 
        .localvariabletable 
            2 is newLength I from L31 to L84 
            3 is newArray [Ljava/lang/Object; from L37 to L84 
            0 is this Lglcutils/GlcSlice; from L0 to L116 
            1 is t Ljava/lang/Object; from L0 to L116 
        .end localvariabletable 
        .localvariabletypetable 
            3 is newArray [TT; from L37 to L84 
            0 is this Lglcutils/GlcSlice<TT;>; from L0 to L116 
            1 is t TT; from L0 to L116 
        .end localvariabletypetable 
    .end code 
    .signature (TT;)Lglcutils/GlcSlice<TT;>; 
.end method 
.signature '<T:Ljava/lang/Object;>Lglcutils/GlcArray<TT;>;' 
.sourcefile 'GlcSlice.java' 
.end class 
