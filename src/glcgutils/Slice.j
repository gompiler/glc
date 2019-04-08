.class public super Slice
.super java/lang/Object
.field public length I
.field private array [Ljava/lang/Object;

.method public <init> : ()V
    .code stack 2 locals 1
L0:     aload_0
L1:     invokespecial Method java/lang/Object <init> ()V
L4:     aload_0
L5:     iconst_0
L6:     putfield Field Slice length I
L9:     aload_0
L10:    iconst_0
L11:    anewarray java/lang/Object
L14:    putfield Field Slice array [Ljava/lang/Object;
L17:    return
L18:
    .end code
.end method

.method public getSlice : ()LSlice;
    .code stack 2 locals 2
L0:     new Slice
L3:     dup
L4:     invokespecial Method Slice <init> ()V
L7:     astore_1
L8:     aload_1
L9:     aload_0
L10:    getfield Field Slice length I
L13:    putfield Field Slice length I
L16:    aload_1
L17:    aload_0
L18:    getfield Field Slice array [Ljava/lang/Object;
L21:    putfield Field Slice array [Ljava/lang/Object;
L24:    aload_1
L25:    areturn
L26:
    .end code
.end method

.method public get : (I)Ljava/lang/Object;
    .code stack 3 locals 2
L0:     iload_1
L1:     aload_0
L2:     getfield Field Slice length I
L5:     iconst_1
L6:     isub
L7:     if_icmple L18
L10:    new java/lang/IndexOutOfBoundsException
L13:    dup
L14:    invokespecial Method java/lang/IndexOutOfBoundsException <init> ()V
L17:    athrow

        .stack same
L18:    aload_0
L19:    getfield Field Slice array [Ljava/lang/Object;
L22:    iload_1
L23:    aaload
L24:    areturn
L25:
    .end code
.end method

.method public set : (ILjava/lang/Object;)V
    .code stack 3 locals 3
L0:     iload_1
L1:     aload_0
L2:     getfield Field Slice length I
L5:     iconst_1
L6:     isub
L7:     if_icmple L18
L10:    new java/lang/IndexOutOfBoundsException
L13:    dup
L14:    invokespecial Method java/lang/IndexOutOfBoundsException <init> ()V
L17:    athrow

        .stack same
L18:    aload_0
L19:    getfield Field Slice array [Ljava/lang/Object;
L22:    iload_1
L23:    aload_2
L24:    aastore
L25:    return
L26:
    .end code
.end method

.method public append : (Ljava/lang/Object;)LSlice;
    .code stack 5 locals 4
L0:     aload_0
L1:     getfield Field Slice length I
L4:     aload_0
L5:     getfield Field Slice array [Ljava/lang/Object;
L8:     arraylength
L9:     iconst_1
L10:    isub
L11:    if_icmplt L62
L14:    iconst_0
L15:    istore_2
L16:    aload_0
L17:    getfield Field Slice array [Ljava/lang/Object;
L20:    arraylength
L21:    ifne L29
L24:    iconst_2
L25:    istore_2
L26:    goto L37

        .stack append Integer
L29:    iconst_2
L30:    aload_0
L31:    getfield Field Slice array [Ljava/lang/Object;
L34:    arraylength
L35:    imul
L36:    istore_2

        .stack same
L37:    iload_2
L38:    anewarray java/lang/Object
L41:    astore_3
L42:    aload_0
L43:    getfield Field Slice array [Ljava/lang/Object;
L46:    iconst_0
L47:    aload_3
L48:    iconst_0
L49:    aload_0
L50:    getfield Field Slice array [Ljava/lang/Object;
L53:    arraylength
L54:    invokestatic Method java/lang/System arraycopy (Ljava/lang/Object;ILjava/lang/Object;II)V
L57:    aload_0
L58:    aload_3
L59:    putfield Field Slice array [Ljava/lang/Object;

        .stack chop 1
L62:    aload_0
L63:    dup
L64:    getfield Field Slice length I
L67:    iconst_1
L68:    iadd
L69:    putfield Field Slice length I
L72:    aload_0
L73:    getfield Field Slice array [Ljava/lang/Object;
L76:    aload_0
L77:    getfield Field Slice length I
L80:    aload_1
L81:    aastore
L82:    aload_0
L83:    areturn
L84:
    .end code
.end method

.method public capacity : ()I
    .code stack 1 locals 1
L0:     aload_0
L1:     getfield Field Slice array [Ljava/lang/Object;
L4:     arraylength
L5:     ireturn
L6:
    .end code
.end method
.end class
