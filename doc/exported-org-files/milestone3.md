
# Table of Contents

1.  [Language for Code Generation](#org19ca782)
2.  [Semantics](#orgc3651f5)
    1.  [Scoping Rules](#org4dd408b)
        1.  [Go Semantics](#orgcce9bd2)
        2.  [Mapping Strategy](#org9fb6577)
    2.  [Switch Statements](#org157fd30)
        1.  [Go Semantics](#orgd9685db)
        2.  [Mapping Strategy](#orgcdb7236)
    3.  [Assignments](#orgb88d6a4)
        1.  [Go Semantics](#org64cdedb)
        2.  [Mapping Strategy](#org030e982)
3.  [Currently Implemented](#org93fe2f2)

This document is for explaining the design decisions we had to make
whilst implementing the components for milestone 3.  \newpage


<a id="org19ca782"></a>

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


<a id="orgc3651f5"></a>

# Semantics


<a id="org4dd408b"></a>

## Scoping Rules


<a id="orgcce9bd2"></a>

### TODO Go Semantics

In `GoLite`,


<a id="org9fb6577"></a>

### TODO Mapping Strategy


<a id="org157fd30"></a>

## Switch Statements


<a id="orgd9685db"></a>

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


<a id="orgcdb7236"></a>

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


<a id="orgb88d6a4"></a>

## TODO Assignments


<a id="org64cdedb"></a>

### TODO Go Semantics


<a id="org030e982"></a>

### TODO Mapping Strategy


<a id="org93fe2f2"></a>

# TODO Currently Implemented
