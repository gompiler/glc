.version 52 0 
.class public super glcutils/GlcArray 
.super java/lang/Object 
.field length I 
.field array [Ljava/lang/Object; .fieldattributes 
    .signature [TT; 
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
            L0 11 
            L7 12 
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

.method public <init> : (Ljava/lang/Class;I[Ljava/lang/Object;)V 
    .code stack 2 locals 4 
L0:     aload_0 
L1:     invokespecial Method java/lang/Object <init> ()V 
L4:     aload_0 
L5:     iload_2 
L6:     putfield Field glcutils/GlcArray length I 
L9:     aload_0 
L10:    aload_1 
L11:    putfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L14:    aload_0 
L15:    aload_3 
L16:    putfield Field glcutils/GlcArray array [Ljava/lang/Object; 
L19:    return 
L20:    
        .linenumbertable 
            L0 14 
            L4 15 
            L9 16 
            L14 17 
            L19 18 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L20 
            1 is clazz Ljava/lang/Class; from L0 to L20 
            2 is length I from L0 to L20 
            3 is array [Ljava/lang/Object; from L0 to L20 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcArray<TT;>; from L0 to L20 
            1 is clazz Ljava/lang/Class<+TT;>; from L0 to L20 
            3 is array [TT; from L0 to L20 
        .end localvariabletypetable 
    .end code 
    .signature (Ljava/lang/Class<+TT;>;I[TT;)V 
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
            L0 24 
            L7 25 
            L19 27 
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
            L0 35 
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

.method final supply : ()Ljava/lang/Object; 
    .code stack 1 locals 1 
L0:     aload_0 
L1:     getfield Field glcutils/GlcArray clazz Ljava/lang/Class; 
L4:     invokestatic Method glcutils/Utils newInstance (Ljava/lang/Class;)Ljava/lang/Object; 
L7:     areturn 
L8:     
        .linenumbertable 
            L0 43 
        .end linenumbertable 
        .localvariabletable 
            0 is this Lglcutils/GlcArray; from L0 to L8 
        .end localvariabletable 
        .localvariabletypetable 
            0 is this Lglcutils/GlcArray<TT;>; from L0 to L8 
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
            L0 50 
            L4 51 
            L13 52 
            L23 54 
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
            L0 61 
            L4 62 
            L11 63 
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
            L0 70 
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
            L0 78 
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
            L0 89 
            L5 90 
            L7 92 
            L22 93 
            L24 95 
            L29 96 
            L40 97 
            L42 99 
            L56 100 
            L58 102 
            L69 103 
            L71 105 
            L75 106 
            L79 107 
            L89 108 
            L104 109 
            L107 111 
            L116 112 
            L126 114 
            L135 115 
            L145 117 
            L163 118 
            L165 107 
            L171 121 
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
.signature '<T:Ljava/lang/Object;>Ljava/lang/Object;' 
.sourcefile 'GlcArray.java' 
.end class 
