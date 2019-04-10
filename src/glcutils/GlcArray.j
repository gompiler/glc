.version 52 0 
.class public super glcutils/GlcArray 
.super java/lang/Object 
.field private final length I 
.field private final isSlice Z 
.field private final subSizes [I 
.field private final debug Z 
.field private array [Ljava/lang/Object; 
.field private final clazz Ljava/lang/Class; 

.method public <init> : (Ljava/lang/Class;[I)V 
    .code stack 4 locals 3 
L0:     aload_0 
L1:     aload_1 
L2:     aload_2 
L3:     iconst_0 
L4:     invokespecial Method glcutils/GlcArray <init> (Ljava/lang/Class;[IZ)V 
L7:     return 
L8:     
        .linenumbertable 
            L0 25 
            L7 26 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L8 
            1 is clazz Ljava/lang/Class; from L0 to L8 
            2 is sizes [I from L0 to L8 
        .end localvariabletable 
    .end code 
.end method 

.method <init> : (Ljava/lang/Class;[IZ)V 
    .code stack 7 locals 4 
L0:     aload_0 
L1:     aload_1 
L2:     aload_2 
L3:     iconst_0 
L4:     iaload 
L5:     ifge L12 
L8:     iconst_1 
L9:     goto L13 

        .stack full 
            locals UninitializedThis Object java/lang/Class Object [I Integer 
            stack UninitializedThis Object java/lang/Class 
        .end stack 
L12:    iconst_0 

        .stack full 
            locals UninitializedThis Object java/lang/Class Object [I Integer 
            stack UninitializedThis Object java/lang/Class Integer 
        .end stack 
L13:    aload_2 
L14:    invokestatic Method glcutils/Utils tail ([I)[I 
L17:    iconst_0 
L18:    aload_2 
L19:    iconst_0 
L20:    iaload 
L21:    invokestatic Method java/lang/Math max (II)I 
L24:    aconst_null 
L25:    iload_3 
L26:    invokespecial Method glcutils/GlcArray <init> (Ljava/lang/Class;Z[II[Ljava/lang/Object;Z)V 
L29:    return 
L30:    
        .linenumbertable 
            L0 29 
            L29 30 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L30 
            1 is clazz Ljava/lang/Class; from L0 to L30 
            2 is sizes [I from L0 to L30 
            3 is debug Z from L0 to L30 
        .end localvariabletable 
    .end code 
.end method 

.method private <init> : (Ljava/lang/Class;Z[II[Ljava/lang/Object;Z)V 
    .code stack 2 locals 7 
L0:     aload_0 
L1:     invokespecial Method java/lang/Object <init> ()V 
L4:     aload_0 
L5:     iload 4 
L7:     putfield Field glcutils/GlcArray length I 
L10:    aload_0 
L11:    iload_2 
L12:    putfield Field glcutils/GlcArray isSlice Z 
L15:    aload_0 
L16:    aload_3 
L17:    putfield Field glcutils/GlcArray subSizes [I 
L20:    aload_0 
L21:    aload_1 
L22:    putfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L25:    aload_0 
L26:    aload 5 
L28:    putfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L31:    aload_0 
L32:    iload 6 
L34:    putfield Field glcutils/GlcArray debug Z 
L37:    return 
L38:    
        .linenumbertable 
            L0 32 
            L4 33 
            L10 34 
            L15 35 
            L20 36 
            L25 37 
            L31 38 
            L37 39 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L38 
            1 is clazz Ljava/lang/Class; from L0 to L38 
            2 is isSlice Z from L0 to L38 
            3 is subSizes [I from L0 to L38 
            4 is length I from L0 to L38 
            5 is array [Ljava/lang/Object; from L0 to L38 
            6 is debug Z from L0 to L38 
        .end localvariabletable 
    .end code 
.end method 

.method private init : ()V 
    .code stack 2 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L4:     ifnonnull L18 
L7:     aload_0 
L8:     aload_0 
L9:     getfield Field glcutils/GlcArray length I 
L12:    anewarray java/lang/Object 
L15:    putfield Field glcutils/GlcArray array [Ljava/lang/Object; 

        .stack same 
L18:    return 
L19:    
        .linenumbertable 
            L0 45 
            L7 46 
            L18 48 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L19 
        .end localvariabletable 
    .end code 
.end method 

.method private supply : ()Ljava/lang/Object; 
    .code stack 5 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/GlcArray subSizes [I 
L4:     arraylength 
L5:     ifne L16 
L8:     aload_0 
L9:     getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L12:    invokestatic Method glcutils/Utils supplyObj (Ljava/lang/Class;)Ljava/lang/Object; 
L15:    areturn 

        .stack same 
L16:    new glcutils/GlcArray 
L19:    dup 
L20:    aload_0 
L21:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L24:    aload_0 
L25:    getfield Field glcutils/GlcArray subSizes [I 
L28:    aload_0 
L29:    getfield Field glcutils/GlcArray debug Z 
L32:    invokespecial Method glcutils/GlcArray <init> (Ljava/lang/Class;[IZ)V 
L35:    areturn 
L36:    
        .linenumbertable 
            L0 55 
            L8 56 
            L16 58 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L36 
        .end localvariabletable 
    .end code 
.end method 

.method public final get : (I)Ljava/lang/Object; 
    .code stack 3 locals 2 
L0:     aload_0 
L1:     invokespecial Method glcutils/GlcArray init ()V 
L4:     aload_0 
L5:     getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L8:     iload_1 
L9:     aaload 
L10:    ifnonnull L23 
L13:    aload_0 
L14:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L17:    iload_1 
L18:    aload_0 
L19:    invokespecial Method glcutils/GlcArray supply ()Ljava/lang/Object; 
L22:    aastore 

        .stack same 
L23:    aload_0 
L24:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L27:    iload_1 
L28:    aaload 
L29:    areturn 
L30:    
        .linenumbertable 
            L0 65 
            L4 66 
            L13 67 
            L23 69 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L30 
            1 is i I from L0 to L30 
        .end localvariabletable 
    .end code 
    .signature '<T:Ljava/lang/Object;>(I)TT;' 
.end method 

.method public set : (ILjava/lang/Object;)V 
    .code stack 5 locals 4 
L0:     aload_0 
L1:     getfield Field glcutils/GlcArray debug Z 
L4:     ifeq L123 
L7:     aload_0 
L8:     getfield Field glcutils/GlcArray subSizes [I 
L11:    arraylength 
L12:    ifne L48 
L15:    aload_0 
L16:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L19:    aload_2 
L20:    invokevirtual Method java/lang/Class isInstance (Ljava/lang/Object;)Z 
L23:    ifne L48 
L26:    ldc 'Set value in 1D GlcArray, but not of class %s' 
L28:    iconst_1 
L29:    anewarray java/lang/Object 
L32:    dup 
L33:    iconst_0 
L34:    aload_0 
L35:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L38:    invokevirtual Method java/lang/Class getName ()Ljava/lang/String; 
L41:    aastore 
L42:    invokestatic Method glcutils/Utils fail (Ljava/lang/String;[Ljava/lang/Object;)V 
L45:    goto L123 

        .stack same 
L48:    aload_0 
L49:    getfield Field glcutils/GlcArray subSizes [I 
L52:    arraylength 
L53:    ifle L123 
L56:    aload_2 
L57:    instanceof glcutils/GlcArray 
L60:    ifne L72 
L63:    ldc 'Set value in multi GlcArray, but not of class GlcArray' 
L65:    iconst_0 
L66:    anewarray java/lang/Object 
L69:    invokestatic Method glcutils/Utils fail (Ljava/lang/String;[Ljava/lang/Object;)V 

        .stack same 
L72:    aload_2 
L73:    checkcast glcutils/GlcArray 
L76:    astore_3 
L77:    aload_3 
L78:    getfield Field glcutils/GlcArray subSizes [I 
L81:    aload_0 
L82:    getfield Field glcutils/GlcArray subSizes [I 
L85:    invokestatic Method glcutils/Utils tail ([I)[I 
L88:    invokestatic Method java/util/Arrays equals ([I[I)Z 
L91:    ifne L123 
L94:    ldc 'Set GlcArray of sizes %s in GlcArray of sizes %s' 
L96:    iconst_2 
L97:    anewarray java/lang/Object 
L100:   dup 
L101:   iconst_0 
L102:   aload_3 
L103:   getfield Field glcutils/GlcArray subSizes [I 
L106:   invokestatic Method java/util/Arrays toString ([I)Ljava/lang/String; 
L109:   aastore 
L110:   dup 
L111:   iconst_1 
L112:   aload_0 
L113:   getfield Field glcutils/GlcArray subSizes [I 
L116:   invokestatic Method java/util/Arrays toString ([I)Ljava/lang/String; 
L119:   aastore 
L120:   invokestatic Method glcutils/Utils fail (Ljava/lang/String;[Ljava/lang/Object;)V 

        .stack same 
L123:   aload_0 
L124:   invokespecial Method glcutils/GlcArray init ()V 
L127:   aload_0 
L128:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L131:   iload_1 
L132:   aload_2 
L133:   aastore 
L134:   return 
L135:   
        .linenumbertable 
            L0 76 
            L7 77 
            L26 78 
            L48 79 
            L56 80 
            L63 81 
            L72 83 
            L77 84 
            L94 85 
            L123 89 
            L127 90 
            L134 91 
        .end linenumbertable 
        .localvariabletable 
            3 is v Lglcutils/GlcArray; from L77 to L123 
            0 is this Lglcutils/GlcArray; from L0 to L135 
            1 is i I from L0 to L135 
            2 is t Ljava/lang/Object; from L0 to L135 
        .end localvariabletable 
    .end code 
.end method 

.method public final length : ()I 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/GlcArray length I 
L4:     ireturn 
L5:     
        .linenumbertable 
            L0 98 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L5 
        .end localvariabletable 
    .end code 
.end method 

.method public capacity : ()I 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L4:     ifnonnull L11 
L7:     iconst_0 
L8:     goto L16 

        .stack same 
L11:    aload_0 
L12:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L15:    arraylength 

        .stack stack_1 Integer 
L16:    ireturn 
L17:    
        .linenumbertable 
            L0 106 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L17 
        .end localvariabletable 
    .end code 
.end method 

.method public append : (Ljava/lang/Object;)Lglcutils/GlcArray; 
    .code stack 8 locals 3 
L0:     aload_0 
L1:     getfield Field glcutils/GlcArray isSlice Z 
L4:     ifne L17 
L7:     new java/lang/RuntimeException 
L10:    dup 
L11:    ldc 'Cannot append to nonslice' 
L13:    invokespecial Method java/lang/RuntimeException <init> (Ljava/lang/String;)V 
L16:    athrow 

        .stack same 
L17:    aload_0 
L18:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L21:    aload_0 
L22:    getfield Field glcutils/GlcArray length I 
L25:    aload_1 
L26:    invokestatic Method glcutils/GlcSliceUtils append ([Ljava/lang/Object;ILjava/lang/Object;)[Ljava/lang/Object; 
L29:    astore_2 
L30:    new glcutils/GlcArray 
L33:    dup 
L34:    aload_0 
L35:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L38:    iconst_1 
L39:    aload_0 
L40:    getfield Field glcutils/GlcArray subSizes [I 
L43:    aload_0 
L44:    getfield Field glcutils/GlcArray length I 
L47:    iconst_1 
L48:    iadd 
L49:    aload_2 
L50:    aload_0 
L51:    getfield Field glcutils/GlcArray debug Z 
L54:    invokespecial Method glcutils/GlcArray <init> (Ljava/lang/Class;Z[II[Ljava/lang/Object;Z)V 
L57:    areturn 
L58:    
        .linenumbertable 
            L0 115 
            L7 116 
            L17 118 
            L30 119 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L58 
            1 is t Ljava/lang/Object; from L0 to L58 
            2 is newArray [Ljava/lang/Object; from L30 to L58 
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
L25:    checkcast glcutils/GlcArray 
L28:    astore_2 
L29:    aload_0 
L30:    aload_2 
L31:    invokevirtual Method glcutils/GlcArray lightEquals (Lglcutils/GlcArray;)Z 
L34:    ifne L39 
L37:    iconst_0 
L38:    ireturn 

        .stack append Object glcutils/GlcArray 
L39:    aload_0 
L40:    invokespecial Method glcutils/GlcArray init ()V 
L43:    aload_2 
L44:    invokespecial Method glcutils/GlcArray init ()V 
L47:    aload_0 
L48:    aload_2 
L49:    invokevirtual Method glcutils/GlcArray arrayEquals (Lglcutils/GlcArray;)Z 
L52:    ireturn 
L53:    
        .linenumbertable 
            L0 130 
            L5 131 
            L7 133 
            L22 134 
            L24 136 
            L29 137 
            L37 138 
            L39 140 
            L43 141 
            L47 142 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L53 
            1 is obj Ljava/lang/Object; from L0 to L53 
            2 is other Lglcutils/GlcArray; from L29 to L53 
        .end localvariabletable 
    .end code 
.end method 

.method lightEquals : (Lglcutils/GlcArray;)Z 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     getfield Field glcutils/GlcArray isSlice Z 
L4:     aload_1 
L5:     getfield Field glcutils/GlcArray isSlice Z 
L8:     if_icmpeq L13 
L11:    iconst_0 
L12:    ireturn 

        .stack same 
L13:    aload_0 
L14:    getfield Field glcutils/GlcArray length I 
L17:    aload_1 
L18:    getfield Field glcutils/GlcArray length I 
L21:    if_icmpeq L26 
L24:    iconst_0 
L25:    ireturn 

        .stack same 
L26:    aload_0 
L27:    getfield Field glcutils/GlcArray subSizes [I 
L30:    aload_1 
L31:    getfield Field glcutils/GlcArray subSizes [I 
L34:    invokestatic Method java/util/Arrays equals ([I[I)Z 
L37:    ifne L42 
L40:    iconst_0 
L41:    ireturn 

        .stack same 
L42:    aload_0 
L43:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L46:    aload_1 
L47:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L50:    invokevirtual Method java/lang/Object equals (Ljava/lang/Object;)Z 
L53:    ifne L58 
L56:    iconst_0 
L57:    ireturn 

        .stack same 
L58:    iconst_1 
L59:    ireturn 
L60:    
        .linenumbertable 
            L0 149 
            L11 150 
            L13 152 
            L24 153 
            L26 155 
            L40 156 
            L42 158 
            L56 159 
            L58 161 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L60 
            1 is other Lglcutils/GlcArray; from L0 to L60 
        .end localvariabletable 
    .end code 
.end method 

.method arrayEquals : (Lglcutils/GlcArray;)Z 
    .code stack 3 locals 3 
L0:     iconst_0 
L1:     istore_2 

        .stack append Integer 
L2:     iload_2 
L3:     aload_0 
L4:     getfield Field glcutils/GlcArray length I 
L7:     if_icmpge L92 
L10:    aload_0 
L11:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L14:    iload_2 
L15:    aaload 
L16:    aload_1 
L17:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L20:    iload_2 
L21:    aaload 
L22:    if_acmpne L28 
L25:    goto L86 

        .stack same 
L28:    aload_0 
L29:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L32:    iload_2 
L33:    aaload 
L34:    ifnonnull L47 
L37:    aload_0 
L38:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L41:    iload_2 
L42:    aload_0 
L43:    invokespecial Method glcutils/GlcArray supply ()Ljava/lang/Object; 
L46:    aastore 

        .stack same 
L47:    aload_1 
L48:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L51:    iload_2 
L52:    aaload 
L53:    ifnonnull L66 
L56:    aload_1 
L57:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L60:    iload_2 
L61:    aload_0 
L62:    invokespecial Method glcutils/GlcArray supply ()Ljava/lang/Object; 
L65:    aastore 

        .stack same 
L66:    aload_0 
L67:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L70:    iload_2 
L71:    aaload 
L72:    aload_1 
L73:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L76:    iload_2 
L77:    aaload 
L78:    invokevirtual Method java/lang/Object equals (Ljava/lang/Object;)Z 
L81:    ifne L86 
L84:    iconst_0 
L85:    ireturn 

        .stack same 
L86:    iinc 2 1 
L89:    goto L2 

        .stack chop 1 
L92:    iconst_1 
L93:    ireturn 
L94:    
        .linenumbertable 
            L0 165 
            L10 166 
            L25 167 
            L28 169 
            L37 170 
            L47 172 
            L56 173 
            L66 175 
            L84 176 
            L86 165 
            L92 179 
        .end linenumbertable 
        .localvariabletable 
            2 is i I from L2 to L92 
            0 is this Lglcutils/GlcArray; from L0 to L94 
            1 is other Lglcutils/GlcArray; from L0 to L94 
        .end localvariabletable 
    .end code 
.end method 
.sourcefile 'GlcArray.java' 
.end class 
