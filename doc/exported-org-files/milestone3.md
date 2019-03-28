
# Table of Contents

1.  [Language for Code Generation](#orge9764e2)
    1.  [Advantages](#orga078cac)
        1.  [Portability](#orga8fef55)
        2.  [Execution Speed](#org41505d9)
        3.  [Stack Based/Low Level](#orge2b49d7)
    2.  [Disadvantages](#org1fab51c)
2.  [Semantics](#orgc5e899b)
    1.  [Scoping Rules](#orgf1fdf9e)
        1.  [Go Semantics](#org1c79a2d)
        2.  [Mapping Strategy](#org8321afc)
    2.  [Switch Statements](#org0aeaa7c)
        1.  [Go Semantics](#org6736cd5)
        2.  [Mapping Strategy](#org80c741b)
    3.  [Assignments](#org2fd5576)
        1.  [Go Semantics](#orgd2399d5)
        2.  [Mapping Strategy](#orgbfaff21)
3.  [Currently Implemented](#org05de90c)

This document is for explaining the design decisions we had to make
whilst implementing the components for milestone 3.  \newpage


<a id="orge9764e2"></a>

# TODO Language for Code Generation

We decided on targeting JVM bytecode for our compiler, through the Krakatau
bytecode assembler. Krakatau bytecode syntax is derived from Jasmin, but with
a more modern codebase (written in Python) and some additional features.
TODO: TALK ABOUT ADDITIONAL FEATURES?


<a id="orga078cac"></a>

## Advantages

The primary advantages of targeting JVM bytecode are:
[portability](#orga8fef55), [execution speed](#org41505d9),
and (surprisingly to us) its [focus on stack
operations as opposed to a more \`straightforward' language](#orge2b49d7), which
aids in overcoming some of the common pain points of GoLite code
generation:


<a id="orga8fef55"></a>

### Portability

The JVM has been ported to many common platforms, meaning code written in
GoLite, when compiled with our compiler, will be able to run on any
platform the JVM can run on.


<a id="org41505d9"></a>

### Execution Speed

Although Java is often considered slow as opposed to ahead-of-time compiled
languages such as C and C++ due to its garbage collection and non-native
compiled code, most implementations of the JVM provide JIT compilation.
By targeting JVM bytecode, we can take advantage of this, and our generated
code will likely be faster than if we generated code in a higher-level
language such as Python.


<a id="orge2b49d7"></a>

### TODO Stack Based/Low Level

The fact that JVM bytecode is low level gives us lots of granular
control to change the behavior of constructs, especially when
dealing with weird `GoLite` / `GoLang` behavior that doesn't
really comply with the more common programming languages. The fact
that it is a stack based language is even more beneficial, since
it makes it easy to account for things like function arguments,
swapping and comparing, whereas a register based language would
require the use of many temporary registers.


<a id="org1fab51c"></a>

## Disadvantages

The main disadvantages of generating JVM bytecode are its low-level semantics
and its potentially slow speeds versus an ahead-of-time compiled language,
despite it being faster than other, higher-level languages.
TODO: EXAMPLE OF LOW LEVEL DIFFICULTIES


<a id="orgc5e899b"></a>

# Semantics


<a id="orgf1fdf9e"></a>

## Scoping Rules


<a id="org1c79a2d"></a>

### Go Semantics

In `GoLite`, new scopes are opened for block statements, `for`
loops, `if` / `else` statements and function declarations (for the
parameters and the function body). A new scope separates
identifiers (which are associated to type maps, variables,
functions and the constants true/false) from the other scopes'
identifiers.

Whenever we refer to an identifier, it will reference the
identifier declared in the closest scope.

There is nothing very special about scoping in `GoLite`, the main
notable thing is that something like `var a = a` will refer to `a`
in a previous scope, not the current `a` that was just declared,
unlike certain languages like `C`.


<a id="org8321afc"></a>

### Mapping Strategy

JVM bytecode, only has \`\`scoping'' for `methods`, as they have
their own locals and stack. However, block statements and the
statements inside of them do not have any scopes (except of course
method calls), as we do not have any constructs like loops, if
statements or switch statements. In a higher level language, we
could just append the scope to each identifier to keep them all
unique (this would eliminate the need for separate scopes, as we
already typecheck the correct use of identifiers, but the target
language won't have to do extra work to tie break any
identifiers). In our case, we do a similar strategy. Recall that
in the typecheck phase we generate a new checked AST with
simplified information and assumptions. The identifiers in this
AST also change, where they are tuples that contain the original
identifier and the scope they were declared in. Thus, each scoped
identifier refers to a unique declaration of a scoped identifier.

For our intermediate representation, each scoped identifier will
be converted to an offset of the locals and since each scoped
identifier refers to a unique declaration, then the locals won't
refer to the wrong local.


<a id="org0aeaa7c"></a>

## Switch Statements


<a id="org6736cd5"></a>

### Go Semantics

In `GoLite`, `switch` statements consist of an optional simple
statement, an optional expression and a (potentially empty) list
of case statements, where case statements are either a case with a
non-empty list of expressions with a block statement to execute
when matched or a default case with a block statement. This makes
them structurally different when compared to Java, or `C` / `C++`:

-   Simple statements aren't in many languages.
-   Expressions usually aren't optional.
-   Case statements contain a list of expressions, whereas many
    languages such as `Java` only allow a single constant expression.

The simple statement is executed before the case checking and
after that the optional expression is compared with each case
statement, evaluating and comparing expression lists from left to
right. The first match enters that case's body, automatically
breaking at the end of it. This makes cases significantly semantically different:

-   Cases automatically break.
-   Each `case` or `default` block defines its own scope for declarations.
-   Case statement expressions do not need to be a constant expression.


<a id="org80c741b"></a>

### Mapping Strategy

For the structural differences:

-   Simple statements can be the first statement in the new \`\`scope''.
-   Any optional expression can be converted to the constant literal \`true\`.
-   For a list of expressions that is of length greater than one, we
    can compare each element from the list one at a time, duping the
    element we need to compare for each comparison (as otherwise
    we'll lose it).

Semantically:

-   To automatically break, for each case statement, we add a `goto`
    to a label at the end of the switch statement.
-   Simulating new scopes is easy because of how our scoping works,
    the variable names will already be resolved to their correct local.
-   The expressions not being constants does not matter too much for
    us, as we will compare each expression normally (we are
    simulating switch statements and aren't limited by the native
    switch statement of the language).


<a id="org2fd5576"></a>

## Assignments


<a id="orgd2399d5"></a>

### Go Semantics

In `GoLite`, assignments are either an assignment operator with a
LHS expression and a RHS expression or just two non empty
expression lists of equal length. This makes them structurally
different (for the two non empty list case) from classic
assignments that either only allow single expressions whether that
be on both sides or only the RHS (assign many expressions to the
same value). However, this structural difference is a lot more
significant than it seems at first glance, because the assignments
are done in a \`\`simultaneous'' way, that is `a, b = b, a` will
effectively swap the values of `a` and `b`, whereas if the
assignments were done sequentially, `a` and `b` would be the
original value of `b` and wouldn't be swapped.


<a id="orgbfaff21"></a>

### Mapping Strategy

There are two tricky things about assignments:

-   Assignment operators. We cannot just convert `e += e2` to `e =
          e + e2`, where `e` is an expression, because `e` might contain a
    function call with side-effects, which we do not want to call
    twice (note that in some cases, the assignment operator has an
    equivalent instruction, i.e. incrementing and decrementing using
    `iinc`, however we generalize in this discussion as most
    operators do not have an equivalent instruction to operate and
    assign at the same time). There are thus several cases for `e`:
    -   `e` is just an identifier, then we can just convert `e += e2`
        to `e = e + e2`, as there will be no side effects.
    -   `e` is a selector. If `e` is an addressable selector, then it
        is not operating on the direct/anonymous return value of a
        function call and so re-evaluating `e` will not produce any
        side effects. Thus we can do `e = e + e2` again.
    -   `e` is an index, say `e3[e4]`. In this case, `e3` can be an
        anonymous `slice` from a function return and `e4` can also be an
        anonymous `int` from a function return. So in order to avoid
        duplicate side effects, we resolve `e3[e4]` to some base
        expression without function calls, storing the result on the
        stack, then we operate on the stack, adding `e2` and then
        assigning the result to whatever the stack value references.
    -   The other cases for `e` are not lvalues and shouldn't happen
        in the checked AST.
-   Assignment of multiple expressions. As mentioned earlier, we
    cannot do the assignments sequentially. Thus we evaluate the
    entire RHS, pushing each result onto the stack and then
    assigning each stack element one by one to their respective LHS
    expression. This way `a, b = b, a` will not overwrite the values
    used on the RHS. This is one of the advantages of using a stack
    based language, as the stack implicitly acts like temporary
    variables, so we don't need to simulate temporary variables for
    swapping/simulating simultaneous assignment.


<a id="org05de90c"></a>

# TODO Currently Implemented

The main feature that was worked on during this milestone was the
creation of our intermediate representation and the conversion of
the typechecked AST to said IR.
