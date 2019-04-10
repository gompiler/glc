.version 52 0 
.class public super glcutils/GlcArray 
.super java/lang/Object 
.field length I 
.field array [Ljava/lang/Object; .fieldattributes 
    .signature [TT; 
.end fieldattributes 
.field private final supplier Lglcutils/Supplier; .fieldattributes 
    .signature Lglcutils/Supplier<TT;>; 
.end fieldattributes 
.field final clazz Ljava/lang/Class; .fieldattributes 
    .signature Ljava/lang/Class<+TT;>; 
.end fieldattributes 

.method public <init> : (Ljava/lang/Class;I)V 
    .code stack 4 locals 3 
L0:     aload_0 
L1:     aload_1 
L2:     iload_2 
L3:     aconst_null 
L4:     invokespecial Method glcutils/GlcArray <init> (Ljava/lang/Class;I[Ljava/lang/Object;)V 
L7:     return 
L8:     
        .linenumbertable 
            L0 12 
            L7 13 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L8 
            1 is clazz Ljava/lang/Class; from L0 to L8 
            2 is length I from L0 to L8 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcArray<TT;>; from L0 to L8 
            1 is clazz Ljava/lang/Class<+TT;>; from L0 to L8 
        .end localvariabletypetable 
    .end code 
    .signature (Ljava/lang/Class<+TT;>;I)V 
.end method 

.method public <init> : (Lglcutils/Supplier;Ljava/lang/Class;I)V 
    .code stack 5 locals 4 
L0:     aload_0 
L1:     aload_1 
L2:     aload_2 
L3:     iload_3 
L4:     aconst_null 
L5:     invokespecial Method glcutils/GlcArray <init> (Lglcutils/Supplier;Ljava/lang/Class;I[Ljava/lang/Object;)V 
L8:     return 
L9:     
        .linenumbertable 
            L0 16 
            L8 17 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L9 
            1 is supplier Lglcutils/Supplier; from L0 to L9 
            2 is clazz Ljava/lang/Class; from L0 to L9 
            3 is length I from L0 to L9 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcArray<TT;>; from L0 to L9 
            1 is supplier Lglcutils/Supplier<TT;>; from L0 to L9 
            2 is clazz Ljava/lang/Class<+TT;>; from L0 to L9 
        .end localvariabletypetable 
    .end code 
    .signature (Lglcutils/Supplier<TT;>;Ljava/lang/Class<+TT;>;I)V 
.end method 

.method public <init> : (Ljava/lang/Class;I[Ljava/lang/Object;)V 
    .code stack 5 locals 4 
L0:     aload_0 
L1:     aload_1 
L2:     invokedynamic [id3] 
L7:     aload_1 
L8:     iload_2 
L9:     aload_3 
L10:    invokespecial Method glcutils/GlcArray <init> (Lglcutils/Supplier;Ljava/lang/Class;I[Ljava/lang/Object;)V 
L13:    return 
L14:    
        .linenumbertable 
            L0 20 
            L13 21 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L14 
            1 is clazz Ljava/lang/Class; from L0 to L14 
            2 is length I from L0 to L14 
            3 is array [Ljava/lang/Object; from L0 to L14 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcArray<TT;>; from L0 to L14 
            1 is clazz Ljava/lang/Class<+TT;>; from L0 to L14 
            3 is array [TT; from L0 to L14 
        .end localvariabletypetable 
    .end code 
    .signature (Ljava/lang/Class<+TT;>;I[TT;)V 
.end method 

.method <init> : (Lglcutils/Supplier;Ljava/lang/Class;I[Ljava/lang/Object;)V 
    .code stack 2 locals 5 
L0:     aload_0 
L1:     invokespecial Method java/lang/Object <init> ()V 
L4:     aload_0 
L5:     iload_3 
L6:     putfield Field glcutils/GlcArray length I 
L9:     aload_0 
L10:    aload_1 
L11:    putfield Field glcutils/GlcArray supplier Lglcutils/Supplier; 
L14:    aload_0 
L15:    aload_2 
L16:    putfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L19:    aload_0 
L20:    aload 4 
L22:    putfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L25:    return 
L26:    
        .linenumbertable 
            L0 23 
            L4 24 
            L9 25 
            L14 26 
            L19 27 
            L25 28 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L26 
            1 is supplier Lglcutils/Supplier; from L0 to L26 
            2 is clazz Ljava/lang/Class; from L0 to L26 
            3 is length I from L0 to L26 
            4 is array [Ljava/lang/Object; from L0 to L26 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcArray<TT;>; from L0 to L26 
            1 is supplier Lglcutils/Supplier<TT;>; from L0 to L26 
            2 is clazz Ljava/lang/Class<+TT;>; from L0 to L26 
            4 is array [TT; from L0 to L26 
        .end localvariabletypetable 
    .end code 
    .signature (Lglcutils/Supplier<TT;>;Ljava/lang/Class<+TT;>;I[TT;)V 
.end method 

.method final init : ()V 
    .code stack 3 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L4:     ifnonnull L19 
L7:     aload_0 
L8:     aload_0 
L9:     aload_0 
L10:    getfield Field glcutils/GlcArray length I 
L13:    invokevirtual Method glcutils/GlcArray create (I)[Ljava/lang/Object; 
L16:    putfield Field glcutils/GlcArray array [Ljava/lang/Object; 

        .stack same 
L19:    return 
L20:    
        .linenumbertable 
            L0 34 
            L7 35 
            L19 37 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L20 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcArray<TT;>; from L0 to L20 
        .end localvariabletypetable 
    .end code 
.end method 

.method final create : (I)[Ljava/lang/Object; 
    .code stack 2 locals 2 
L0:     aload_0 
L1:     getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L4:     iload_1 
L5:     invokestatic Method java/lang/reflect/Array newInstance (Ljava/lang/Class;I)Ljava/lang/Object; 
L8:     checkcast [Ljava/lang/Object; 
L11:    checkcast [Ljava/lang/Object; 
L14:    areturn 
L15:    
        .linenumbertable 
            L0 45 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L15 
            1 is length I from L0 to L15 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcArray<TT;>; from L0 to L15 
        .end localvariabletypetable 
    .end code 
    .signature (I)[TT; 
.end method 

.method public supply : ()Ljava/lang/Object; 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/GlcArray supplier Lglcutils/Supplier; 
L4:     invokeinterface InterfaceMethod glcutils/Supplier get ()Ljava/lang/Object; 1 
L9:     areturn 
L10:    
        .linenumbertable 
            L0 53 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L10 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcArray<TT;>; from L0 to L10 
        .end localvariabletypetable 
    .end code 
    .signature ()TT; 
.end method 

.method public final get : (I)Ljava/lang/Object; 
    .code stack 3 locals 2 
L0:     aload_0 
L1:     invokevirtual Method glcutils/GlcArray init ()V 
L4:     aload_0 
L5:     getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L8:     iload_1 
L9:     aaload 
L10:    ifnonnull L23 
L13:    aload_0 
L14:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L17:    iload_1 
L18:    aload_0 
L19:    invokevirtual Method glcutils/GlcArray supply ()Ljava/lang/Object; 
L22:    aastore 

        .stack same 
L23:    aload_0 
L24:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L27:    iload_1 
L28:    aaload 
L29:    areturn 
L30:    
        .linenumbertable 
            L0 60 
            L4 61 
            L13 62 
            L23 64 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L30 
            1 is i I from L0 to L30 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcArray<TT;>; from L0 to L30 
        .end localvariabletypetable 
    .end code 
    .signature (I)TT; 
.end method 

.method public final set : (ILjava/lang/Object;)V 
    .code stack 3 locals 3 
L0:     aload_0 
L1:     invokevirtual Method glcutils/GlcArray init ()V 
L4:     aload_0 
L5:     getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L8:     iload_1 
L9:     aload_2 
L10:    aastore 
L11:    return 
L12:    
        .linenumbertable 
            L0 71 
            L4 72 
            L11 73 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L12 
            1 is i I from L0 to L12 
            2 is t Ljava/lang/Object; from L0 to L12 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcArray<TT;>; from L0 to L12 
            2 is t TT; from L0 to L12 
        .end localvariabletypetable 
    .end code 
    .signature (ITT;)V 
.end method 

.method public final length : ()I 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/GlcArray length I 
L4:     ireturn 
L5:     
        .linenumbertable 
            L0 80 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L5 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcArray<TT;>; from L0 to L5 
        .end localvariabletypetable 
    .end code 
.end method 

.method public final capacity : ()I 
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
            L0 88 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L17 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcArray<TT;>; from L0 to L17 
        .end localvariabletypetable 
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
L30:    getfield Field glcutils/GlcArray length I 
L33:    aload_2 
L34:    getfield Field glcutils/GlcArray length I 
L37:    if_icmpeq L42 
L40:    iconst_0 
L41:    ireturn 

        .stack append Object glcutils/GlcArray 
L42:    aload_0 
L43:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L46:    aload_2 
L47:    getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L50:    invokevirtual Method java/lang/Object equals (Ljava/lang/Object;)Z 
L53:    ifne L58 
L56:    iconst_0 
L57:    ireturn 

        .stack same 
L58:    aload_0 
L59:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L62:    aload_2 
L63:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L66:    if_acmpne L71 
L69:    iconst_1 
L70:    ireturn 

        .stack same 
L71:    aload_0 
L72:    invokevirtual Method glcutils/GlcArray init ()V 
L75:    aload_2 
L76:    invokevirtual Method glcutils/GlcArray init ()V 
L79:    iconst_0 
L80:    istore_3 

        .stack append Integer 
L81:    iload_3 
L82:    aload_0 
L83:    invokevirtual Method glcutils/GlcArray length ()I 
L86:    if_icmpge L171 
L89:    aload_0 
L90:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L93:    iload_3 
L94:    aaload 
L95:    aload_2 
L96:    getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L99:    iload_3 
L100:   aaload 
L101:   if_acmpne L107 
L104:   goto L165 

        .stack same 
L107:   aload_0 
L108:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L111:   iload_3 
L112:   aaload 
L113:   ifnonnull L126 
L116:   aload_0 
L117:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L120:   iload_3 
L121:   aload_0 
L122:   invokevirtual Method glcutils/GlcArray supply ()Ljava/lang/Object; 
L125:   aastore 

        .stack same 
L126:   aload_2 
L127:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L130:   iload_3 
L131:   aaload 
L132:   ifnonnull L145 
L135:   aload_2 
L136:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L139:   iload_3 
L140:   aload_0 
L141:   invokevirtual Method glcutils/GlcArray supply ()Ljava/lang/Object; 
L144:   aastore 

        .stack same 
L145:   aload_0 
L146:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L149:   iload_3 
L150:   aaload 
L151:   aload_2 
L152:   getfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L155:   iload_3 
L156:   aaload 
L157:   invokevirtual Method java/lang/Object equals (Ljava/lang/Object;)Z 
L160:   ifne L165 
L163:   iconst_0 
L164:   ireturn 

        .stack same 
L165:   iinc 3 1 
L168:   goto L81 

        .stack chop 1 
L171:   iconst_1 
L172:   ireturn 
L173:   
        .linenumbertable 
            L0 99 
            L5 100 
            L7 102 
            L22 103 
            L24 105 
            L29 106 
            L40 107 
            L42 109 
            L56 110 
            L58 112 
            L69 113 
            L71 115 
            L75 116 
            L79 117 
            L89 118 
            L104 119 
            L107 121 
            L116 122 
            L126 124 
            L135 125 
            L145 127 
            L163 128 
            L165 117 
            L171 131 
        .end linenumbertable 
        .localvariabletable 
            3 is i I from L81 to L171 
            0 is this Lglcutils/GlcArray; from L0 to L173 
            1 is obj Ljava/lang/Object; from L0 to L173 
            2 is other Lglcutils/GlcArray; from L29 to L173 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcArray<TT;>; from L0 to L173 
        .end localvariabletypetable 
    .end code 
.end method 

.method private static synthetic lambda$new$0 : (Ljava/lang/Class;)Ljava/lang/Object; 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     invokestatic Method glcutils/Utils supply (Ljava/lang/Class;)Ljava/lang/Object; 
L4:     areturn 
L5:     
        .linenumbertable 
            L0 20 
        .end linenumbertable 
        .localvariabletable 
            0 is clazz Ljava/lang/Class; from L0 to L5 
        .end localvariabletable 
    .end code 
.end method 
.signature '<T:Ljava/lang/Object;>Ljava/lang/Object;' 
.sourcefile 'GlcArray.java' 
.innerclasses 
    java/lang/invoke/MethodHandles$Lookup java/lang/invoke/MethodHandles Lookup public static final 
.end innerclasses 
.const [id3] = InvokeDynamic invokeStatic Method java/lang/invoke/LambdaMetafactory metafactory (Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite; MethodType ()Ljava/lang/Object; MethodHandle invokeStatic Method glcutils/GlcArray lambda$new$0 (Ljava/lang/Class;)Ljava/lang/Object; MethodType ()Ljava/lang/Object; : get (Ljava/lang/Class;)Lglcutils/Supplier; 
.end class 
