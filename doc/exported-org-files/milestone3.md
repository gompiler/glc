
# Table of Contents

1.  [Language for Code Generation](#orgcd0a320)
2.  [Semantics](#org63cb782)
    1.  [Scoping Rules](#orga3c22e8)
        1.  [Go Semantics](#orge364159)
        2.  [Mapping Strategy](#org598fc92)
    2.  [Switch Statements](#org6a7abcd)
        1.  [Go Semantics](#org0a9375e)
        2.  [Mapping Strategy](#orgec8a33c)
    3.  [Assignments](#org68d7c23)
        1.  [Go Semantics](#org10f65a1)
        2.  [Mapping Strategy](#org7778270)
3.  [Currently Implemented](#org75c8ce3)

This document is for explaining the design decisions we had to make
whilst implementing the components for milestone 3.  \newpage


<a id="orgcd0a320"></a>

# TODO Language for Code Generation

We decided on targeting JVM bytecode for our compiler, through the Krakatau
bytecode assembler. Krakatau bytecode syntax is derived from Jasmin, but with
a more modern codebase (written in Python) and some additional features.

TODO: TALK ABOUT ADDITIONAL FEATURES?

The primary advantages of targeting JVM bytecode are: 1) portability, 2)
execution speed, and 3) (surprisingly to us) its focus on stack
operations as opposed to a more \`straightforward' language, which aids in
overcoming some of the common pain points of GoLite code generation:

1.  The JVM has been ported to many common platforms, meaning code written in
    GoLite, when compiled with our compiler, will be able to run on any
    platform the JVM can run on.
2.  Although Java is often considered slow as opposed to ahead-of-time compiled
    languages such as C and C++ due to its garbage collection and non-native
    compiled code, most implementations of the JVM provide JIT compilation,
    By targeting JVM bytecode, we can take advantage of this, and our generated
    code will likely be faster than if we generated code in a higher-level
    language such as Python.
3.  TODO

The main disadvantages of generating JVM bytecode are its low-level semantics
and its comparatively slow speeds versus an ahead-of-time compiled language,
despite it being faster than other, higher-level languages.
TODO: EXAMPLE OF LOW LEVEL DIFFICULTIES


<a id="org63cb782"></a>

# Semantics


<a id="orga3c22e8"></a>

## Scoping Rules


<a id="orge364159"></a>

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


<a id="org598fc92"></a>

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


<a id="org6a7abcd"></a>

## Switch Statements


<a id="org0a9375e"></a>

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


<a id="orgec8a33c"></a>

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


<a id="org68d7c23"></a>

## TODO Assignments


<a id="org10f65a1"></a>

### TODO Go Semantics


<a id="org7778270"></a>

### TODO Mapping Strategy


<a id="org75c8ce3"></a>

# TODO Currently Implemented
