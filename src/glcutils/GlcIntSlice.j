.version 52 0 
.class public super glcutils/GlcIntSlice 
.super glcutils/GlcIntArray 

.method public <init> : ()V 
    .code stack 3 locals 1 
L0:     aload_0 
L1:     iconst_0 
L2:     aconst_null 
L3:     invokespecial Method glcutils/GlcIntSlice <init> (I[I)V 
L6:     return 
L7:     
        .linenumbertable 
            L0 6 
            L6 7 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcIntSlice; from L0 to L7 
        .end localvariabletable 
    .end code 
.end method 

.method private <init> : (I[I)V 
    .code stack 3 locals 3 
L0:     aload_0 
L1:     iload_1 
L2:     aload_2 
L3:     invokespecial Method glcutils/GlcIntArray <init> (I[I)V 
L6:     return 
L7:     
        .linenumbertable 
            L0 10 
            L6 11 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcIntSlice; from L0 to L7 
            1 is length I from L0 to L7 
            2 is array [I from L0 to L7 
        .end localvariabletable 
    .end code 
.end method 

.method public append : (I)Lglcutils/GlcIntSlice; 
    .code stack 5 locals 4 
L0:     aload_0 
L1:     getfield Field glcutils/GlcIntSlice length I 
L4:     aload_0 
L5:     invokevirtual Method glcutils/GlcIntSlice capacity ()I 
L8:     iconst_1 
L9:     isub 
L10:    if_icmplt L78 
L13:    aload_0 
L14:    invokevirtual Method glcutils/GlcIntSlice capacity ()I 
L17:    ifne L24 
L20:    iconst_2 
L21:    goto L30 

        .stack same 
L24:    aload_0 
L25:    invokevirtual Method glcutils/GlcIntSlice capacity ()I 
L28:    iconst_2 
L29:    imul 

        .stack stack_1 Integer 
L30:    istore_2 
L31:    iload_2 
L32:    newarray int 
L34:    astore_3 
L35:    aload_0 
L36:    getfield Field glcutils/GlcIntSlice array [I 
L39:    ifnull L56 
L42:    aload_0 
L43:    getfield Field glcutils/GlcIntSlice array [I 
L46:    iconst_0 
L47:    aload_3 
L48:    iconst_0 
L49:    aload_0 
L50:    getfield Field glcutils/GlcIntSlice length I 
L53:    invokestatic Method java/lang/System arraycopy (Ljava/lang/Object;ILjava/lang/Object;II)V 

        .stack append Integer Object [I 
L56:    aload_3 
L57:    aload_0 
L58:    getfield Field glcutils/GlcIntSlice length I 
L61:    iload_1 
L62:    iastore 
L63:    new glcutils/GlcIntSlice 
L66:    dup 
L67:    aload_0 
L68:    getfield Field glcutils/GlcIntSlice length I 
L71:    iconst_1 
L72:    iadd 
L73:    aload_3 
L74:    invokespecial Method glcutils/GlcIntSlice <init> (I[I)V 
L77:    areturn 

        .stack chop 2 
L78:    aload_0 
L79:    getfield Field glcutils/GlcIntSlice array [I 
L82:    aload_0 
L83:    getfield Field glcutils/GlcIntSlice length I 
L86:    iload_1 
L87:    iastore 
L88:    new glcutils/GlcIntSlice 
L91:    dup 
L92:    aload_0 
L93:    getfield Field glcutils/GlcIntSlice length I 
L96:    iconst_1 
L97:    iadd 
L98:    aload_0 
L99:    getfield Field glcutils/GlcIntSlice array [I 
L102:   invokespecial Method glcutils/GlcIntSlice <init> (I[I)V 
L105:   areturn 
L106:   
        .linenumbertable 
            L0 19 
            L13 22 
            L31 23 
            L35 24 
            L42 25 
            L56 27 
            L63 29 
            L78 32 
            L88 33 
        .end linenumbertable 
        .localvariabletable 
            2 is newLength I from L31 to L78 
            3 is newArray [I from L35 to L78 
            0 is this Lglcutils/GlcIntSlice; from L0 to L106 
            1 is t I from L0 to L106 
        .end localvariabletable 
    .end code 
.end method 
.sourcefile 'GlcIntSlice.java' 
.end class 
