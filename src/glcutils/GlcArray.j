.version 52 0 
.class public super glcutils/GlcArray 
.super java/lang/Object 
.implements glcutils/GlcCopy 
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
            L0 45 
            L7 46 
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
            L0 49 
            L29 50 
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
            L0 52 
            L4 53 
            L10 54 
            L15 55 
            L20 56 
            L25 57 
            L31 58 
            L37 59 
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
            L0 65 
            L7 66 
            L18 68 
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
            L0 75 
            L8 76 
            L16 78 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L36 
        .end localvariabletable 
    .end code 
.end method 

.method public copy : ()Ljava/lang/Object; 
    .code stack 8 locals 3 
L0:     aconst_null 
L1:     astore_1 
L2:     aload_0 
L3:     getfield Field glcutils/GlcArray isSlice Z 
L6:     ifeq L17 
L9:     aload_0 
L10:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L13:    astore_1 
L14:    goto L131 

        .stack append Object [Ljava/lang/Object; 
L17:    aload_0 
L18:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L21:    ifnull L131 
L24:    aload_0 
L25:    getfield Field glcutils/GlcArray length I 
L28:    anewarray java/lang/Object 
L31:    astore_1 
L32:    aload_0 
L33:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L36:    ldc Class java/lang/Boolean 
L38:    if_acmpeq L86 
L41:    aload_0 
L42:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L45:    ldc Class java/lang/Character 
L47:    if_acmpeq L86 
L50:    aload_0 
L51:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L54:    ldc Class java/lang/Integer 
L56:    if_acmpeq L86 
L59:    aload_0 
L60:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L63:    ldc Class java/lang/Float 
L65:    if_acmpeq L86 
L68:    aload_0 
L69:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L72:    ldc Class java/lang/Double 
L74:    if_acmpeq L86 
L77:    aload_0 
L78:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L81:    ldc Class java/lang/String 
L83:    if_acmpne L103 

        .stack same_extended 
L86:    aload_0 
L87:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L90:    iconst_0 
L91:    aload_1 
L92:    iconst_0 
L93:    aload_0 
L94:    getfield Field glcutils/GlcArray length I 
L97:    invokestatic Method java/lang/System arraycopy (Ljava/lang/Object;ILjava/lang/Object;II)V 
L100:   goto L131 

        .stack same 
L103:   iconst_0 
L104:   istore_2 

        .stack append Integer 
L105:   iload_2 
L106:   aload_0 
L107:   getfield Field glcutils/GlcArray length I 
L110:   if_icmpge L131 
L113:   aload_1 
L114:   iload_2 
L115:   aload_0 
L116:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L119:   iload_2 
L120:   aaload 
L121:   invokestatic Method glcutils/Utils copy (Ljava/lang/Object;)Ljava/lang/Object; 
L124:   aastore 
L125:   iinc 2 1 
L128:   goto L105 

        .stack chop 1 
L131:   new glcutils/GlcArray 
L134:   dup 
L135:   aload_0 
L136:   getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L139:   aload_0 
L140:   getfield Field glcutils/GlcArray isSlice Z 
L143:   aload_0 
L144:   getfield Field glcutils/GlcArray subSizes [I 
L147:   aload_0 
L148:   getfield Field glcutils/GlcArray length I 
L151:   aload_1 
L152:   aload_0 
L153:   getfield Field glcutils/GlcArray debug Z 
L156:   invokespecial Method glcutils/GlcArray <init> (Ljava/lang/Class;Z[II[Ljava/lang/Object;Z)V 
L159:   areturn 
L160:   
        .linenumbertable 
            L0 83 
            L2 84 
            L9 85 
            L17 86 
            L24 87 
            L32 88 
            L86 90 
            L103 92 
            L113 93 
            L125 92 
            L131 97 
        .end linenumbertable 
        .localvariabletable 
            2 is i I from L105 to L131 
            0 is this Lglcutils/GlcArray; from L0 to L160 
            1 is newArray [Ljava/lang/Object; from L2 to L160 
        .end localvariabletable 
    .end code 
.end method 

.method public final get : (I)Ljava/lang/Object; 
    .code stack 3 locals 2 
L0:     aload_0 
L1:     iload_1 
L2:     invokespecial Method glcutils/GlcArray verifyIndex (I)V 
L5:     aload_0 
L6:     invokespecial Method glcutils/GlcArray init ()V 
L9:     aload_0 
L10:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L13:    iload_1 
L14:    aaload 
L15:    ifnonnull L28 
L18:    aload_0 
L19:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L22:    iload_1 
L23:    aload_0 
L24:    invokespecial Method glcutils/GlcArray supply ()Ljava/lang/Object; 
L27:    aastore 

        .stack same 
L28:    aload_0 
L29:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L32:    iload_1 
L33:    aaload 
L34:    areturn 
L35:    
        .linenumbertable 
            L0 104 
            L5 105 
            L9 106 
            L18 107 
            L28 110 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L35 
            1 is i I from L0 to L35 
        .end localvariabletable 
    .end code 
    .signature '<T:Ljava/lang/Object;>(I)TT;' 
.end method 

.method final getArray : (I)Lglcutils/GlcArray; 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     iload_1 
L2:     invokevirtual Method glcutils/GlcArray get (I)Ljava/lang/Object; 
L5:     checkcast glcutils/GlcArray 
L8:     areturn 
L9:     
        .linenumbertable 
            L0 117 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L9 
            1 is i I from L0 to L9 
        .end localvariabletable 
    .end code 
.end method 

.method public final getBoolean : (I)Z 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     iload_1 
L2:     invokevirtual Method glcutils/GlcArray get (I)Ljava/lang/Object; 
L5:     checkcast java/lang/Boolean 
L8:     invokevirtual Method java/lang/Boolean booleanValue ()Z 
L11:    ireturn 
L12:    
        .linenumbertable 
            L0 121 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L12 
            1 is i I from L0 to L12 
        .end localvariabletable 
    .end code 
.end method 

.method public final getChar : (I)C 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     iload_1 
L2:     invokevirtual Method glcutils/GlcArray get (I)Ljava/lang/Object; 
L5:     checkcast java/lang/Character 
L8:     invokevirtual Method java/lang/Character charValue ()C 
L11:    ireturn 
L12:    
        .linenumbertable 
            L0 125 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L12 
            1 is i I from L0 to L12 
        .end localvariabletable 
    .end code 
.end method 

.method public final getInt : (I)I 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     iload_1 
L2:     invokevirtual Method glcutils/GlcArray get (I)Ljava/lang/Object; 
L5:     checkcast java/lang/Integer 
L8:     invokevirtual Method java/lang/Integer intValue ()I 
L11:    ireturn 
L12:    
        .linenumbertable 
            L0 129 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L12 
            1 is i I from L0 to L12 
        .end localvariabletable 
    .end code 
.end method 

.method public final getFloat : (I)F 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     iload_1 
L2:     invokevirtual Method glcutils/GlcArray get (I)Ljava/lang/Object; 
L5:     checkcast java/lang/Float 
L8:     invokevirtual Method java/lang/Float floatValue ()F 
L11:    freturn 
L12:    
        .linenumbertable 
            L0 133 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L12 
            1 is i I from L0 to L12 
        .end localvariabletable 
    .end code 
.end method 

.method public final getDouble : (I)D 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     iload_1 
L2:     invokevirtual Method glcutils/GlcArray get (I)Ljava/lang/Object; 
L5:     checkcast java/lang/Double 
L8:     invokevirtual Method java/lang/Double doubleValue ()D 
L11:    dreturn 
L12:    
        .linenumbertable 
            L0 137 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L12 
            1 is i I from L0 to L12 
        .end localvariabletable 
    .end code 
.end method 

.method private verify : (Ljava/lang/Object;)V 
    .code stack 5 locals 3 
L0:     aload_0 
L1:     getfield Field glcutils/GlcArray debug Z 
L4:     ifne L8 
L7:     return 

        .stack same 
L8:     aload_1 
L9:     ifnonnull L13 
L12:    return 

        .stack same 
L13:    aload_0 
L14:    getfield Field glcutils/GlcArray subSizes [I 
L17:    arraylength 
L18:    ifne L64 
L21:    aload_0 
L22:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L25:    aload_1 
L26:    invokevirtual Method java/lang/Class isInstance (Ljava/lang/Object;)Z 
L29:    ifne L64 
L32:    ldc 'Set value of class %s in 1D GlcArray, expected class %s' 
L34:    iconst_2 
L35:    anewarray java/lang/Object 
L38:    dup 
L39:    iconst_0 
L40:    aload_1 
L41:    invokevirtual Method java/lang/Object getClass ()Ljava/lang/Class; 
L44:    invokevirtual Method java/lang/Class getName ()Ljava/lang/String; 
L47:    aastore 
L48:    dup 
L49:    iconst_1 
L50:    aload_0 
L51:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L54:    invokevirtual Method java/lang/Class getName ()Ljava/lang/String; 
L57:    aastore 
L58:    invokestatic Method glcutils/Utils fail (Ljava/lang/String;[Ljava/lang/Object;)V 
L61:    goto L139 

        .stack same 
L64:    aload_0 
L65:    getfield Field glcutils/GlcArray subSizes [I 
L68:    arraylength 
L69:    ifle L139 
L72:    aload_1 
L73:    instanceof glcutils/GlcArray 
L76:    ifne L88 
L79:    ldc 'Set value in multi GlcArray, but not of class GlcArray' 
L81:    iconst_0 
L82:    anewarray java/lang/Object 
L85:    invokestatic Method glcutils/Utils fail (Ljava/lang/String;[Ljava/lang/Object;)V 

        .stack same 
L88:    aload_1 
L89:    checkcast glcutils/GlcArray 
L92:    astore_2 
L93:    aload_2 
L94:    getfield Field glcutils/GlcArray subSizes [I 
L97:    aload_0 
L98:    getfield Field glcutils/GlcArray subSizes [I 
L101:   invokestatic Method glcutils/Utils tail ([I)[I 
L104:   invokestatic Method java/util/Arrays equals ([I[I)Z 
L107:   ifne L139 
L110:   ldc 'Set GlcArray of sizes %s in GlcArray of sizes %s' 
L112:   iconst_2 
L113:   anewarray java/lang/Object 
L116:   dup 
L117:   iconst_0 
L118:   aload_2 
L119:   getfield Field glcutils/GlcArray subSizes [I 
L122:   invokestatic Method java/util/Arrays toString ([I)Ljava/lang/String; 
L125:   aastore 
L126:   dup 
L127:   iconst_1 
L128:   aload_0 
L129:   getfield Field glcutils/GlcArray subSizes [I 
L132:   invokestatic Method java/util/Arrays toString ([I)Ljava/lang/String; 
L135:   aastore 
L136:   invokestatic Method glcutils/Utils fail (Ljava/lang/String;[Ljava/lang/Object;)V 

        .stack same 
L139:   return 
L140:   
        .linenumbertable 
            L0 141 
            L7 142 
            L8 144 
            L12 145 
            L13 147 
            L32 148 
            L64 149 
            L72 150 
            L79 151 
            L88 153 
            L93 154 
            L110 155 
            L139 158 
        .end linenumbertable 
        .localvariabletable 
            2 is v Lglcutils/GlcArray; from L93 to L139 
            0 is this Lglcutils/GlcArray; from L0 to L140 
            1 is t Ljava/lang/Object; from L0 to L140 
        .end localvariabletable 
    .end code 
.end method 

.method private verifyIndex : (I)V 
    .code stack 5 locals 2 
L0:     iload_1 
L1:     iflt L14 
L4:     iload_1 
L5:     aload_0 
L6:     getfield Field glcutils/GlcArray length I 
L9:     iconst_1 
L10:    isub 
L11:    if_icmple L40 

        .stack same 
L14:    ldc 'Slice index %d out of range (length %d)' 
L16:    iconst_2 
L17:    anewarray java/lang/Object 
L20:    dup 
L21:    iconst_0 
L22:    iload_1 
L23:    invokestatic Method java/lang/Integer valueOf (I)Ljava/lang/Integer; 
L26:    aastore 
L27:    dup 
L28:    iconst_1 
L29:    aload_0 
L30:    getfield Field glcutils/GlcArray length I 
L33:    invokestatic Method java/lang/Integer valueOf (I)Ljava/lang/Integer; 
L36:    aastore 
L37:    invokestatic Method glcutils/Utils fail (Ljava/lang/String;[Ljava/lang/Object;)V 

        .stack same 
L40:    return 
L41:    
        .linenumbertable 
            L0 161 
            L14 162 
            L40 164 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L41 
            1 is i I from L0 to L41 
        .end localvariabletable 
    .end code 
.end method 

.method public set : (ILjava/lang/Object;)V 
    .code stack 3 locals 3 
L0:     aload_0 
L1:     iload_1 
L2:     invokespecial Method glcutils/GlcArray verifyIndex (I)V 
L5:     aload_0 
L6:     aload_2 
L7:     invokespecial Method glcutils/GlcArray verify (Ljava/lang/Object;)V 
L10:    aload_0 
L11:    invokespecial Method glcutils/GlcArray init ()V 
L14:    aload_0 
L15:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L18:    iload_1 
L19:    aload_2 
L20:    aastore 
L21:    return 
L22:    
        .linenumbertable 
            L0 170 
            L5 171 
            L10 172 
            L14 173 
            L21 174 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L22 
            1 is i I from L0 to L22 
            2 is t Ljava/lang/Object; from L0 to L22 
        .end localvariabletable 
    .end code 
.end method 

.method public set : (IZ)V 
    .code stack 3 locals 3 
L0:     aload_0 
L1:     iload_1 
L2:     iload_2 
L3:     invokestatic Method java/lang/Boolean valueOf (Z)Ljava/lang/Boolean; 
L6:     invokevirtual Method glcutils/GlcArray set (ILjava/lang/Object;)V 
L9:     return 
L10:    
        .linenumbertable 
            L0 177 
            L9 178 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L10 
            1 is i I from L0 to L10 
            2 is t Z from L0 to L10 
        .end localvariabletable 
    .end code 
.end method 

.method public set : (IC)V 
    .code stack 3 locals 3 
L0:     aload_0 
L1:     iload_1 
L2:     iload_2 
L3:     invokestatic Method java/lang/Character valueOf (C)Ljava/lang/Character; 
L6:     invokevirtual Method glcutils/GlcArray set (ILjava/lang/Object;)V 
L9:     return 
L10:    
        .linenumbertable 
            L0 181 
            L9 182 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L10 
            1 is i I from L0 to L10 
            2 is t C from L0 to L10 
        .end localvariabletable 
    .end code 
.end method 

.method public set : (II)V 
    .code stack 3 locals 3 
L0:     aload_0 
L1:     iload_1 
L2:     iload_2 
L3:     invokestatic Method java/lang/Integer valueOf (I)Ljava/lang/Integer; 
L6:     invokevirtual Method glcutils/GlcArray set (ILjava/lang/Object;)V 
L9:     return 
L10:    
        .linenumbertable 
            L0 185 
            L9 186 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L10 
            1 is i I from L0 to L10 
            2 is t I from L0 to L10 
        .end localvariabletable 
    .end code 
.end method 

.method public set : (IF)V 
    .code stack 3 locals 3 
L0:     aload_0 
L1:     iload_1 
L2:     fload_2 
L3:     invokestatic Method java/lang/Float valueOf (F)Ljava/lang/Float; 
L6:     invokevirtual Method glcutils/GlcArray set (ILjava/lang/Object;)V 
L9:     return 
L10:    
        .linenumbertable 
            L0 189 
            L9 190 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L10 
            1 is i I from L0 to L10 
            2 is t F from L0 to L10 
        .end localvariabletable 
    .end code 
.end method 

.method public set : (ID)V 
    .code stack 4 locals 4 
L0:     aload_0 
L1:     iload_1 
L2:     dload_2 
L3:     invokestatic Method java/lang/Double valueOf (D)Ljava/lang/Double; 
L6:     invokevirtual Method glcutils/GlcArray set (ILjava/lang/Object;)V 
L9:     return 
L10:    
        .linenumbertable 
            L0 193 
            L9 194 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L10 
            1 is i I from L0 to L10 
            2 is t D from L0 to L10 
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
            L0 201 
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
            L0 209 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L17 
        .end localvariabletable 
    .end code 
.end method 

.method public append : (Ljava/lang/Object;)Lglcutils/GlcArray; 
    .code stack 8 locals 3 
L0:     aload_0 
L1:     aload_1 
L2:     invokespecial Method glcutils/GlcArray verify (Ljava/lang/Object;)V 
L5:     aload_0 
L6:     getfield Field glcutils/GlcArray isSlice Z 
L9:     ifne L21 
L12:    ldc 'Cannot append to nonslice' 
L14:    iconst_0 
L15:    anewarray java/lang/Object 
L18:    invokestatic Method glcutils/Utils fail (Ljava/lang/String;[Ljava/lang/Object;)V 

        .stack same 
L21:    aload_0 
L22:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L25:    aload_0 
L26:    getfield Field glcutils/GlcArray length I 
L29:    aload_1 
L30:    invokestatic Method glcutils/GlcArray append ([Ljava/lang/Object;ILjava/lang/Object;)[Ljava/lang/Object; 
L33:    astore_2 
L34:    new glcutils/GlcArray 
L37:    dup 
L38:    aload_0 
L39:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L42:    iconst_1 
L43:    aload_0 
L44:    getfield Field glcutils/GlcArray subSizes [I 
L47:    aload_0 
L48:    getfield Field glcutils/GlcArray length I 
L51:    iconst_1 
L52:    iadd 
L53:    aload_2 
L54:    aload_0 
L55:    getfield Field glcutils/GlcArray debug Z 
L58:    invokespecial Method glcutils/GlcArray <init> (Ljava/lang/Class;Z[II[Ljava/lang/Object;Z)V 
L61:    areturn 
L62:    
        .linenumbertable 
            L0 218 
            L5 219 
            L12 220 
            L21 222 
            L34 223 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L62 
            1 is t Ljava/lang/Object; from L0 to L62 
            2 is newArray [Ljava/lang/Object; from L34 to L62 
        .end localvariabletable 
    .end code 
.end method 

.method public append : (Z)Lglcutils/GlcArray; 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     iload_1 
L2:     invokestatic Method java/lang/Boolean valueOf (Z)Ljava/lang/Boolean; 
L5:     invokevirtual Method glcutils/GlcArray append (Ljava/lang/Object;)Lglcutils/GlcArray; 
L8:     areturn 
L9:     
        .linenumbertable 
            L0 227 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L9 
            1 is t Z from L0 to L9 
        .end localvariabletable 
    .end code 
.end method 

.method public append : (C)Lglcutils/GlcArray; 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     iload_1 
L2:     invokestatic Method java/lang/Character valueOf (C)Ljava/lang/Character; 
L5:     invokevirtual Method glcutils/GlcArray append (Ljava/lang/Object;)Lglcutils/GlcArray; 
L8:     areturn 
L9:     
        .linenumbertable 
            L0 231 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L9 
            1 is t C from L0 to L9 
        .end localvariabletable 
    .end code 
.end method 

.method public append : (I)Lglcutils/GlcArray; 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     iload_1 
L2:     invokestatic Method java/lang/Integer valueOf (I)Ljava/lang/Integer; 
L5:     invokevirtual Method glcutils/GlcArray append (Ljava/lang/Object;)Lglcutils/GlcArray; 
L8:     areturn 
L9:     
        .linenumbertable 
            L0 235 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L9 
            1 is t I from L0 to L9 
        .end localvariabletable 
    .end code 
.end method 

.method public append : (F)Lglcutils/GlcArray; 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     fload_1 
L2:     invokestatic Method java/lang/Float valueOf (F)Ljava/lang/Float; 
L5:     invokevirtual Method glcutils/GlcArray append (Ljava/lang/Object;)Lglcutils/GlcArray; 
L8:     areturn 
L9:     
        .linenumbertable 
            L0 239 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L9 
            1 is t F from L0 to L9 
        .end localvariabletable 
    .end code 
.end method 

.method public append : (D)Lglcutils/GlcArray; 
    .code stack 3 locals 3 
L0:     aload_0 
L1:     dload_1 
L2:     invokestatic Method java/lang/Double valueOf (D)Ljava/lang/Double; 
L5:     invokevirtual Method glcutils/GlcArray append (Ljava/lang/Object;)Lglcutils/GlcArray; 
L8:     areturn 
L9:     
        .linenumbertable 
            L0 243 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L9 
            1 is t D from L0 to L9 
        .end localvariabletable 
    .end code 
.end method 

.method private static append : ([Ljava/lang/Object;ILjava/lang/Object;)[Ljava/lang/Object; 
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
L19:    if_icmple L56 

        .stack append Integer 
L22:    iload_3 
L23:    invokestatic Method glcutils/GlcArray newCapacity (I)I 
L26:    istore 4 
L28:    iload 4 
L30:    anewarray java/lang/Object 
L33:    astore 5 
L35:    aload_0 
L36:    ifnull L48 
L39:    aload_0 
L40:    iconst_0 
L41:    aload 5 
L43:    iconst_0 
L44:    iload_1 
L45:    invokestatic Method java/lang/System arraycopy (Ljava/lang/Object;ILjava/lang/Object;II)V 

        .stack append Integer Object [Ljava/lang/Object; 
L48:    aload 5 
L50:    iload_1 
L51:    aload_2 
L52:    aastore 
L53:    aload 5 
L55:    areturn 

        .stack chop 2 
L56:    aload_0 
L57:    iload_1 
L58:    aload_2 
L59:    aastore 
L60:    aload_0 
L61:    areturn 
L62:    
        .linenumbertable 
            L0 251 
            L11 252 
            L22 255 
            L28 256 
            L35 257 
            L39 258 
            L48 260 
            L53 261 
            L56 263 
            L60 264 
        .end linenumbertable 
        .localvariabletable 
            4 is newLength I from L28 to L56 
            5 is newArray [Ljava/lang/Object; from L35 to L56 
            0 is array [Ljava/lang/Object; from L0 to L62 
            1 is length I from L0 to L62 
            2 is t Ljava/lang/Object; from L0 to L62 
            3 is capacity I from L11 to L62 
        .end localvariabletable 
    .end code 
.end method 

.method private static newCapacity : (I)I 
    .code stack 2 locals 1 
L0:     iload_0 
L1:     ifgt L8 
L4:     iconst_2 
L5:     goto L11 

        .stack same 
L8:     iconst_2 
L9:     iload_0 
L10:    imul 

        .stack stack_1 Integer 
L11:    ireturn 
L12:    
        .linenumbertable 
            L0 273 
        .end linenumbertable 
        .localvariabletable 
            0 is capacity I from L0 to L12 
        .end localvariabletable 
    .end code 
.end method 

.method public equals : (Ljava/lang/Object;)Z 
    .code stack 3 locals 4 
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
L30:    getfield Field glcutils/GlcArray isSlice Z 
L33:    aload_2 
L34:    getfield Field glcutils/GlcArray isSlice Z 
L37:    if_icmpeq L42 
L40:    iconst_0 
L41:    ireturn 

        .stack append Object glcutils/GlcArray 
L42:    aload_0 
L43:    getfield Field glcutils/GlcArray length I 
L46:    aload_2 
L47:    getfield Field glcutils/GlcArray length I 
L50:    if_icmpeq L55 
L53:    iconst_0 
L54:    ireturn 

        .stack same 
L55:    aload_0 
L56:    getfield Field glcutils/GlcArray subSizes [I 
L59:    aload_2 
L60:    getfield Field glcutils/GlcArray subSizes [I 
L63:    invokestatic Method java/util/Arrays equals ([I[I)Z 
L66:    ifne L71 
L69:    iconst_0 
L70:    ireturn 

        .stack same 
L71:    aload_0 
L72:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L75:    aload_2 
L76:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L79:    if_acmpeq L84 
L82:    iconst_0 
L83:    ireturn 

        .stack same 
L84:    aload_0 
L85:    invokespecial Method glcutils/GlcArray init ()V 
L88:    aload_2 
L89:    invokespecial Method glcutils/GlcArray init ()V 
L92:    iconst_0 
L93:    istore_3 

        .stack append Integer 
L94:    iload_3 
L95:    aload_0 
L96:    getfield Field glcutils/GlcArray length I 
L99:    if_icmpge L184 
L102:   aload_0 
L103:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L106:   iload_3 
L107:   aaload 
L108:   aload_2 
L109:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L112:   iload_3 
L113:   aaload 
L114:   if_acmpne L120 
L117:   goto L178 

        .stack same 
L120:   aload_0 
L121:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L124:   iload_3 
L125:   aaload 
L126:   ifnonnull L139 
L129:   aload_0 
L130:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L133:   iload_3 
L134:   aload_0 
L135:   invokespecial Method glcutils/GlcArray supply ()Ljava/lang/Object; 
L138:   aastore 

        .stack same 
L139:   aload_2 
L140:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L143:   iload_3 
L144:   aaload 
L145:   ifnonnull L158 
L148:   aload_2 
L149:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L152:   iload_3 
L153:   aload_0 
L154:   invokespecial Method glcutils/GlcArray supply ()Ljava/lang/Object; 
L157:   aastore 

        .stack same 
L158:   aload_0 
L159:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L162:   iload_3 
L163:   aaload 
L164:   aload_2 
L165:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L168:   iload_3 
L169:   aaload 
L170:   invokevirtual Method java/lang/Object equals (Ljava/lang/Object;)Z 
L173:   ifne L178 
L176:   iconst_0 
L177:   ireturn 

        .stack same 
L178:   iinc 3 1 
L181:   goto L94 

        .stack chop 1 
L184:   iconst_1 
L185:   ireturn 
L186:   
        .linenumbertable 
            L0 284 
            L5 285 
            L7 287 
            L22 288 
            L24 290 
            L29 291 
            L40 292 
            L42 294 
            L53 295 
            L55 297 
            L69 298 
            L71 300 
            L82 301 
            L84 303 
            L88 304 
            L92 305 
            L102 306 
            L117 307 
            L120 309 
            L129 310 
            L139 312 
            L148 313 
            L158 315 
            L176 316 
            L178 305 
            L184 319 
        .end linenumbertable 
        .localvariabletable 
            3 is i I from L94 to L184 
            0 is this Lglcutils/GlcArray; from L0 to L186 
            1 is obj Ljava/lang/Object; from L0 to L186 
            2 is other Lglcutils/GlcArray; from L29 to L186 
        .end localvariabletable 
    .end code 
.end method 

.method public hashCode : ()I 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L4:     invokestatic Method java/util/Arrays hashCode ([Ljava/lang/Object;)I 
L7:     ireturn 
L8:     
        .linenumbertable 
            L0 324 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L8 
        .end localvariabletable 
    .end code 
.end method 

.method public toString : ()Ljava/lang/String; 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/GlcArray debug Z 
L4:     ifeq L12 
L7:     aload_0 
L8:     invokevirtual Method glcutils/GlcArray contentString ()Ljava/lang/String; 
L11:    areturn 

        .stack same 
L12:    aload_0 
L13:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L16:    invokestatic Method java/util/Arrays toString ([Ljava/lang/Object;)Ljava/lang/String; 
L19:    areturn 
L20:    
        .linenumbertable 
            L0 329 
            L7 330 
            L12 332 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L20 
        .end localvariabletable 
    .end code 
.end method 

.method contentString : ()Ljava/lang/String; 
    .code stack 3 locals 6 
L0:     new java/lang/StringBuilder 
L3:     dup 
L4:     invokespecial Method java/lang/StringBuilder <init> ()V 
L7:     astore_1 
L8:     aload_1 
L9:     bipush 91 
L11:    invokevirtual Method java/lang/StringBuilder append (C)Ljava/lang/StringBuilder; 
L14:    pop 
L15:    aload_0 
L16:    getfield Field glcutils/GlcArray isSlice Z 
L19:    ifne L31 
L22:    aload_1 
L23:    aload_0 
L24:    getfield Field glcutils/GlcArray length I 
L27:    invokevirtual Method java/lang/StringBuilder append (I)Ljava/lang/StringBuilder; 
L30:    pop 

        .stack append Object java/lang/StringBuilder 
L31:    aload_1 
L32:    bipush 93 
L34:    invokevirtual Method java/lang/StringBuilder append (C)Ljava/lang/StringBuilder; 
L37:    pop 
L38:    aload_0 
L39:    getfield Field glcutils/GlcArray subSizes [I 
L42:    astore_2 
L43:    aload_2 
L44:    arraylength 
L45:    istore_3 
L46:    iconst_0 
L47:    istore 4 

        .stack append Object [I Integer Integer 
L49:    iload 4 
L51:    iload_3 
L52:    if_icmpge L93 
L55:    aload_2 
L56:    iload 4 
L58:    iaload 
L59:    istore 5 
L61:    aload_1 
L62:    bipush 91 
L64:    invokevirtual Method java/lang/StringBuilder append (C)Ljava/lang/StringBuilder; 
L67:    pop 
L68:    iload 5 
L70:    ifle L80 
L73:    aload_1 
L74:    iload 5 
L76:    invokevirtual Method java/lang/StringBuilder append (I)Ljava/lang/StringBuilder; 
L79:    pop 

        .stack append Integer 
L80:    aload_1 
L81:    bipush 93 
L83:    invokevirtual Method java/lang/StringBuilder append (C)Ljava/lang/StringBuilder; 
L86:    pop 
L87:    iinc 4 1 
L90:    goto L49 

        .stack full 
            locals Object glcutils/GlcArray Object java/lang/StringBuilder 
            stack 
        .end stack 
L93:    aload_1 
L94:    aload_0 
L95:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L98:    invokevirtual Method java/lang/Class getName ()Ljava/lang/String; 
L101:   invokevirtual Method java/lang/StringBuilder append (Ljava/lang/String;)Ljava/lang/StringBuilder; 
L104:   pop 
L105:   aload_0 
L106:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L109:   ifnonnull L124 
L112:   aload_1 
L113:   ldc ' - null' 
L115:   invokevirtual Method java/lang/StringBuilder append (Ljava/lang/String;)Ljava/lang/StringBuilder; 
L118:   pop 
L119:   aload_1 
L120:   invokevirtual Method java/lang/StringBuilder toString ()Ljava/lang/String; 
L123:   areturn 

        .stack same 
L124:   iconst_0 
L125:   istore_2 

        .stack append Integer 
L126:   iload_2 
L127:   aload_0 
L128:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L131:   arraylength 
L132:   if_icmpge L207 
L135:   aload_0 
L136:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L139:   iload_2 
L140:   aaload 
L141:   astore_3 
L142:   aload_1 
L143:   ldc '\n\t' 
L145:   invokevirtual Method java/lang/StringBuilder append (Ljava/lang/String;)Ljava/lang/StringBuilder; 
L148:   iload_2 
L149:   invokevirtual Method java/lang/StringBuilder append (I)Ljava/lang/StringBuilder; 
L152:   ldc ': ' 
L154:   invokevirtual Method java/lang/StringBuilder append (Ljava/lang/String;)Ljava/lang/StringBuilder; 
L157:   pop 
L158:   aload_3 
L159:   instanceof glcutils/GlcArray 
L162:   ifeq L195 
L165:   aload_3 
L166:   checkcast glcutils/GlcArray 
L169:   invokevirtual Method glcutils/GlcArray contentString ()Ljava/lang/String; 
L172:   astore 4 
L174:   aload 4 
L176:   ldc '\n' 
L178:   ldc '\n\t' 
L180:   invokevirtual Method java/lang/String replace (Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String; 
L183:   astore 4 
L185:   aload_1 
L186:   aload 4 
L188:   invokevirtual Method java/lang/StringBuilder append (Ljava/lang/String;)Ljava/lang/StringBuilder; 
L191:   pop 
L192:   goto L201 

        .stack append Object java/lang/Object 
L195:   aload_1 
L196:   aload_3 
L197:   invokevirtual Method java/lang/StringBuilder append (Ljava/lang/Object;)Ljava/lang/StringBuilder; 
L200:   pop 

        .stack chop 1 
L201:   iinc 2 1 
L204:   goto L126 

        .stack chop 1 
L207:   aload_1 
L208:   invokevirtual Method java/lang/StringBuilder toString ()Ljava/lang/String; 
L211:   areturn 
L212:   
        .linenumbertable 
            L0 336 
            L8 337 
            L15 338 
            L22 339 
            L31 341 
            L38 342 
            L61 343 
            L68 344 
            L73 345 
            L80 347 
            L87 342 
            L93 349 
            L105 350 
            L112 351 
            L119 352 
            L124 354 
            L135 355 
            L142 356 
            L158 357 
            L165 358 
            L174 359 
            L185 360 
            L192 361 
            L195 362 
            L201 354 
            L207 365 
        .end linenumbertable 
        .localvariabletable 
            5 is i I from L61 to L87 
            4 is so Ljava/lang/String; from L174 to L192 
            3 is o Ljava/lang/Object; from L142 to L201 
            2 is i I from L126 to L207 
            0 is this Lglcutils/GlcArray; from L0 to L212 
            1 is s Ljava/lang/StringBuilder; from L8 to L212 
        .end localvariabletable 
    .end code 
.end method 
.sourcefile 'GlcArray.java' 
.end class 
