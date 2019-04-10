.version 52 0 
.class public super glcutils/GlcSliceUtils 
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
            0 is this Lglcutils/GlcSliceUtils; from L0 to L5 
        .end localvariabletable 
    .end code 
.end method 

.method public static append : (Ljava/lang/Class;[Ljava/lang/Object;ILjava/lang/Object;)[Ljava/lang/Object; 
    .code stack 5 locals 7 
L0:     aload_1 
L1:     ifnonnull L8 
L4:     iconst_0 
L5:     goto L10 

        .stack same 
L8:     aload_1 
L9:     arraylength 

        .stack stack_1 Integer 
L10:    istore 4 
L12:    aload_1 
L13:    ifnull L24 
L16:    iload_2 
L17:    iload 4 
L19:    iconst_1 
L20:    isub 
L21:    if_icmplt L74 

        .stack append Integer 
L24:    iload 4 
L26:    ifne L33 
L29:    iconst_2 
L30:    goto L37 

        .stack same 
L33:    iload 4 
L35:    iconst_2 
L36:    imul 

        .stack stack_1 Integer 
L37:    istore 5 
L39:    aload_0 
L40:    iload 5 
L42:    invokestatic Method java/lang/reflect/Array newInstance (Ljava/lang/Class;I)Ljava/lang/Object; 
L45:    checkcast [Ljava/lang/Object; 
L48:    checkcast [Ljava/lang/Object; 
L51:    astore 6 
L53:    aload_1 
L54:    ifnull L66 
L57:    aload_1 
L58:    iconst_0 
L59:    aload 6 
L61:    iconst_0 
L62:    iload_2 
L63:    invokestatic Method java/lang/System arraycopy (Ljava/lang/Object;ILjava/lang/Object;II)V 

        .stack append Integer Object [Ljava/lang/Object; 
L66:    aload 6 
L68:    iload_2 
L69:    aload_3 
L70:    aastore 
L71:    aload 6 
L73:    areturn 

        .stack chop 2 
L74:    aload_1 
L75:    iload_2 
L76:    aload_3 
L77:    aastore 
L78:    aload_1 
L79:    areturn 
L80:    
        .linenumbertable 
            L0 12 
            L12 13 
            L24 16 
            L39 17 
            L53 18 
            L57 19 
            L66 21 
            L71 22 
            L74 24 
            L78 25 
        .end linenumbertable 
        .localvariabletable 
            5 is newLength I from L39 to L74 
            6 is newArray [Ljava/lang/Object; from L53 to L74 
            0 is clazz Ljava/lang/Class; from L0 to L80 
            1 is array [Ljava/lang/Object; from L0 to L80 
            2 is length I from L0 to L80 
            3 is t Ljava/lang/Object; from L0 to L80 
            4 is capacity I from L12 to L80 
        .end localvariabletable 
        .localvariabletypetable 
            6 is newArray [TT; from L53 to L74 
            0 is clazz Ljava/lang/Class<+TT;>; from L0 to L80 
            1 is array [TT; from L0 to L80 
            3 is t TT; from L0 to L80 
        .end localvariabletypetable 
    .end code 
    .signature '<T:Ljava/lang/Object;>(Ljava/lang/Class<+TT;>;[TT;ITT;)[TT;' 
.end method 

.method public static append : ([ZIZ)[Z 
    .code stack 5 locals 6 
L0:     aload_0 
L1:     ifnonnull L8 
L4:     iconst_0 
L5:     goto L10 

        .stack same 
L8:     aload_0 
L9:     arraylength 

        .stack stack_1 Integer 
L10:    istore_3 
L11:    aload_0 
L12:    ifnull L22 
L15:    iload_1 
L16:    iload_3 
L17:    iconst_1 
L18:    isub 
L19:    if_icmplt L62 

        .stack append Integer 
L22:    iload_3 
L23:    ifne L30 
L26:    iconst_2 
L27:    goto L33 

        .stack same 
L30:    iload_3 
L31:    iconst_2 
L32:    imul 

        .stack stack_1 Integer 
L33:    istore 4 
L35:    iload 4 
L37:    newarray boolean 
L39:    astore 5 
L41:    aload_0 
L42:    ifnull L54 
L45:    aload_0 
L46:    iconst_0 
L47:    aload 5 
L49:    iconst_0 
L50:    iload_1 
L51:    invokestatic Method java/lang/System arraycopy (Ljava/lang/Object;ILjava/lang/Object;II)V 

        .stack append Integer Object [Z 
L54:    aload 5 
L56:    iload_1 
L57:    iload_2 
L58:    bastore 
L59:    aload 5 
L61:    areturn 

        .stack chop 2 
L62:    aload_0 
L63:    iload_1 
L64:    iload_2 
L65:    bastore 
L66:    aload_0 
L67:    areturn 
L68:    
        .linenumbertable 
            L0 34 
            L11 35 
            L22 38 
            L35 39 
            L41 40 
            L45 41 
            L54 43 
            L59 44 
            L62 46 
            L66 47 
        .end linenumbertable 
        .localvariabletable 
            4 is newLength I from L35 to L62 
            5 is newArray [Z from L41 to L62 
            0 is array [Z from L0 to L68 
            1 is length I from L0 to L68 
            2 is t Z from L0 to L68 
            3 is capacity I from L11 to L68 
        .end localvariabletable 
    .end code 
.end method 

.method public static append : ([CIC)[C 
    .code stack 5 locals 6 
L0:     aload_0 
L1:     ifnonnull L8 
L4:     iconst_0 
L5:     goto L10 

        .stack same 
L8:     aload_0 
L9:     arraylength 

        .stack stack_1 Integer 
L10:    istore_3 
L11:    aload_0 
L12:    ifnull L22 
L15:    iload_1 
L16:    iload_3 
L17:    iconst_1 
L18:    isub 
L19:    if_icmplt L62 

        .stack append Integer 
L22:    iload_3 
L23:    ifne L30 
L26:    iconst_2 
L27:    goto L33 

        .stack same 
L30:    iload_3 
L31:    iconst_2 
L32:    imul 

        .stack stack_1 Integer 
L33:    istore 4 
L35:    iload 4 
L37:    newarray char 
L39:    astore 5 
L41:    aload_0 
L42:    ifnull L54 
L45:    aload_0 
L46:    iconst_0 
L47:    aload 5 
L49:    iconst_0 
L50:    iload_1 
L51:    invokestatic Method java/lang/System arraycopy (Ljava/lang/Object;ILjava/lang/Object;II)V 

        .stack append Integer Object [C 
L54:    aload 5 
L56:    iload_1 
L57:    iload_2 
L58:    castore 
L59:    aload 5 
L61:    areturn 

        .stack chop 2 
L62:    aload_0 
L63:    iload_1 
L64:    iload_2 
L65:    castore 
L66:    aload_0 
L67:    areturn 
L68:    
        .linenumbertable 
            L0 56 
            L11 57 
            L22 60 
            L35 61 
            L41 62 
            L45 63 
            L54 65 
            L59 66 
            L62 68 
            L66 69 
        .end linenumbertable 
        .localvariabletable 
            4 is newLength I from L35 to L62 
            5 is newArray [C from L41 to L62 
            0 is array [C from L0 to L68 
            1 is length I from L0 to L68 
            2 is t C from L0 to L68 
            3 is capacity I from L11 to L68 
        .end localvariabletable 
    .end code 
.end method 

.method public static append : ([III)[I 
    .code stack 5 locals 6 
L0:     aload_0 
L1:     ifnonnull L8 
L4:     iconst_0 
L5:     goto L10 

        .stack same 
L8:     aload_0 
L9:     arraylength 

        .stack stack_1 Integer 
L10:    istore_3 
L11:    aload_0 
L12:    ifnull L22 
L15:    iload_1 
L16:    iload_3 
L17:    iconst_1 
L18:    isub 
L19:    if_icmplt L62 

        .stack append Integer 
L22:    iload_3 
L23:    ifne L30 
L26:    iconst_2 
L27:    goto L33 

        .stack same 
L30:    iload_3 
L31:    iconst_2 
L32:    imul 

        .stack stack_1 Integer 
L33:    istore 4 
L35:    iload 4 
L37:    newarray int 
L39:    astore 5 
L41:    aload_0 
L42:    ifnull L54 
L45:    aload_0 
L46:    iconst_0 
L47:    aload 5 
L49:    iconst_0 
L50:    iload_1 
L51:    invokestatic Method java/lang/System arraycopy (Ljava/lang/Object;ILjava/lang/Object;II)V 

        .stack append Integer Object [I 
L54:    aload 5 
L56:    iload_1 
L57:    iload_2 
L58:    iastore 
L59:    aload 5 
L61:    areturn 

        .stack chop 2 
L62:    aload_0 
L63:    iload_1 
L64:    iload_2 
L65:    iastore 
L66:    aload_0 
L67:    areturn 
L68:    
        .linenumbertable 
            L0 78 
            L11 79 
            L22 82 
            L35 83 
            L41 84 
            L45 85 
            L54 87 
            L59 88 
            L62 90 
            L66 91 
        .end linenumbertable 
        .localvariabletable 
            4 is newLength I from L35 to L62 
            5 is newArray [I from L41 to L62 
            0 is array [I from L0 to L68 
            1 is length I from L0 to L68 
            2 is t I from L0 to L68 
            3 is capacity I from L11 to L68 
        .end localvariabletable 
    .end code 
.end method 

.method public static append : ([FIF)[F 
    .code stack 5 locals 6 
L0:     aload_0 
L1:     ifnonnull L8 
L4:     iconst_0 
L5:     goto L10 

        .stack same 
L8:     aload_0 
L9:     arraylength 

        .stack stack_1 Integer 
L10:    istore_3 
L11:    aload_0 
L12:    ifnull L22 
L15:    iload_1 
L16:    iload_3 
L17:    iconst_1 
L18:    isub 
L19:    if_icmplt L62 

        .stack append Integer 
L22:    iload_3 
L23:    ifne L30 
L26:    iconst_2 
L27:    goto L33 

        .stack same 
L30:    iload_3 
L31:    iconst_2 
L32:    imul 

        .stack stack_1 Integer 
L33:    istore 4 
L35:    iload 4 
L37:    newarray float 
L39:    astore 5 
L41:    aload_0 
L42:    ifnull L54 
L45:    aload_0 
L46:    iconst_0 
L47:    aload 5 
L49:    iconst_0 
L50:    iload_1 
L51:    invokestatic Method java/lang/System arraycopy (Ljava/lang/Object;ILjava/lang/Object;II)V 

        .stack append Integer Object [F 
L54:    aload 5 
L56:    iload_1 
L57:    fload_2 
L58:    fastore 
L59:    aload 5 
L61:    areturn 

        .stack chop 2 
L62:    aload_0 
L63:    iload_1 
L64:    fload_2 
L65:    fastore 
L66:    aload_0 
L67:    areturn 
L68:    
        .linenumbertable 
            L0 100 
            L11 101 
            L22 104 
            L35 105 
            L41 106 
            L45 107 
            L54 109 
            L59 110 
            L62 112 
            L66 113 
        .end linenumbertable 
        .localvariabletable 
            4 is newLength I from L35 to L62 
            5 is newArray [F from L41 to L62 
            0 is array [F from L0 to L68 
            1 is length I from L0 to L68 
            2 is t F from L0 to L68 
            3 is capacity I from L11 to L68 
        .end localvariabletable 
    .end code 
.end method 
.sourcefile 'GlcSliceUtils.java' 
.end class 
