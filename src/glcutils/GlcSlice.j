.version 52 0 
.class public super glcutils/GlcSlice 
.super glcutils/GlcArray 

.method public <init> : (Ljava/lang/Class;)V 
    .code stack 3 locals 2 
L0:     aload_0 
L1:     aload_1 
L2:     invokedynamic [id1] 
L7:     aload_1 
L8:     invokespecial Method glcutils/GlcSlice <init> (Lglcutils/Supplier;Ljava/lang/Class;)V 
L11:    return 
L12:    
        .linenumbertable 
            L0 6 
            L11 7 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcSlice; from L0 to L12 
            1 is clazz Ljava/lang/Class; from L0 to L12 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcSlice<TT;>; from L0 to L12 
            1 is clazz Ljava/lang/Class<+TT;>; from L0 to L12 
        .end localvariabletypetable 
    .end code 
    .signature (Ljava/lang/Class<+TT;>;)V 
.end method 

.method public <init> : (Lglcutils/Supplier;Ljava/lang/Class;)V 
    .code stack 5 locals 3 
L0:     aload_0 
L1:     aload_1 
L2:     aload_2 
L3:     iconst_0 
L4:     aconst_null 
L5:     invokespecial Method glcutils/GlcSlice <init> (Lglcutils/Supplier;Ljava/lang/Class;I[Ljava/lang/Object;)V 
L8:     return 
L9:     
        .linenumbertable 
            L0 10 
            L8 11 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcSlice; from L0 to L9 
            1 is supplier Lglcutils/Supplier; from L0 to L9 
            2 is clazz Ljava/lang/Class; from L0 to L9 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcSlice<TT;>; from L0 to L9 
            1 is supplier Lglcutils/Supplier<TT;>; from L0 to L9 
            2 is clazz Ljava/lang/Class<+TT;>; from L0 to L9 
        .end localvariabletypetable 
    .end code 
    .signature (Lglcutils/Supplier<TT;>;Ljava/lang/Class<+TT;>;)V 
.end method 

.method private <init> : (Lglcutils/Supplier;Ljava/lang/Class;I[Ljava/lang/Object;)V 
    .code stack 5 locals 5 
L0:     aload_0 
L1:     aload_1 
L2:     aload_2 
L3:     iload_3 
L4:     aload 4 
L6:     invokespecial Method glcutils/GlcArray <init> (Lglcutils/Supplier;Ljava/lang/Class;I[Ljava/lang/Object;)V 
L9:     return 
L10:    
        .linenumbertable 
            L0 14 
            L9 15 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcSlice; from L0 to L10 
            1 is supplier Lglcutils/Supplier; from L0 to L10 
            2 is clazz Ljava/lang/Class; from L0 to L10 
            3 is length I from L0 to L10 
            4 is array [Ljava/lang/Object; from L0 to L10 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcSlice<TT;>; from L0 to L10 
            1 is supplier Lglcutils/Supplier<TT;>; from L0 to L10 
            2 is clazz Ljava/lang/Class<+TT;>; from L0 to L10 
            4 is array [TT; from L0 to L10 
        .end localvariabletypetable 
    .end code 
    .signature (Lglcutils/Supplier<TT;>;Ljava/lang/Class<+TT;>;I[TT;)V 
.end method 

.method public append : (Ljava/lang/Object;)Lglcutils/GlcSlice; 
    .code stack 6 locals 4 
L0:     aload_0 
L1:     getfield Field glcutils/GlcSlice length I 
L4:     aload_0 
L5:     invokevirtual Method glcutils/GlcSlice capacity ()I 
L8:     iconst_1 
L9:     isub 
L10:    if_icmplt L88 
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
L70:    getfield Field glcutils/GlcSlice supplier Lglcutils/Supplier; 
L73:    aload_0 
L74:    getfield Field glcutils/GlcSlice clazz Ljava/lang/Class; 
L77:    aload_0 
L78:    getfield Field glcutils/GlcSlice length I 
L81:    iconst_1 
L82:    iadd 
L83:    aload_3 
L84:    invokespecial Method glcutils/GlcSlice <init> (Lglcutils/Supplier;Ljava/lang/Class;I[Ljava/lang/Object;)V 
L87:    areturn 

        .stack chop 2 
L88:    aload_0 
L89:    getfield Field glcutils/GlcSlice array [Ljava/lang/Object; 
L92:    aload_0 
L93:    getfield Field glcutils/GlcSlice length I 
L96:    aload_1 
L97:    aastore 
L98:    new glcutils/GlcSlice 
L101:   dup 
L102:   aload_0 
L103:   getfield Field glcutils/GlcSlice supplier Lglcutils/Supplier; 
L106:   aload_0 
L107:   getfield Field glcutils/GlcSlice clazz Ljava/lang/Class; 
L110:   aload_0 
L111:   getfield Field glcutils/GlcSlice length I 
L114:   iconst_1 
L115:   iadd 
L116:   aload_0 
L117:   getfield Field glcutils/GlcSlice array [Ljava/lang/Object; 
L120:   invokespecial Method glcutils/GlcSlice <init> (Lglcutils/Supplier;Ljava/lang/Class;I[Ljava/lang/Object;)V 
L123:   areturn 
L124:   
        .linenumbertable 
            L0 23 
            L13 26 
            L31 27 
            L37 28 
            L44 29 
            L58 31 
            L65 33 
            L88 36 
            L98 37 
        .end linenumbertable 
        .localvariabletable 
            2 is newLength I from L31 to L88 
            3 is newArray [Ljava/lang/Object; from L37 to L88 
            0 is this Lglcutils/GlcSlice; from L0 to L124 
            1 is t Ljava/lang/Object; from L0 to L124 
        .end localvariabletable 
        .localvariabletypetable 
            3 is newArray [TT; from L37 to L88 
            0 is this Lglcutils/GlcSlice<TT;>; from L0 to L124 
            1 is t TT; from L0 to L124 
        .end localvariabletypetable 
    .end code 
    .signature (TT;)Lglcutils/GlcSlice<TT;>; 
.end method 

.method private static synthetic lambda$new$0 : (Ljava/lang/Class;)Ljava/lang/Object; 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     invokestatic Method glcutils/Utils newInstance (Ljava/lang/Class;)Ljava/lang/Object; 
L4:     areturn 
L5:     
        .linenumbertable 
            L0 6 
        .end linenumbertable 
        .localvariabletable 
            0 is clazz Ljava/lang/Class; from L0 to L5 
        .end localvariabletable 
    .end code 
.end method 
.signature '<T:Ljava/lang/Object;>Lglcutils/GlcArray<TT;>;' 
.sourcefile 'GlcSlice.java' 
.innerclasses 
    java/lang/invoke/MethodHandles$Lookup java/lang/invoke/MethodHandles Lookup public static final 
.end innerclasses 
.const [id1] = InvokeDynamic invokeStatic Method java/lang/invoke/LambdaMetafactory metafactory (Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite; MethodType ()Ljava/lang/Object; MethodHandle invokeStatic Method glcutils/GlcSlice lambda$new$0 (Ljava/lang/Class;)Ljava/lang/Object; MethodType ()Ljava/lang/Object; : get (Ljava/lang/Class;)Lglcutils/Supplier; 
.end class 
