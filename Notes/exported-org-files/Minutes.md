
# Table of Contents

1.  [<span class="timestamp-wrapper"><span class="timestamp">&lt;2019-02-11 Mon&gt;</span></span>](#org8bb85af)
    1.  [Comparison of Allan and Julian's Methods of Writing a Compiler in Haskell](#orgb6e6da3)
        1.  [Compared Parsing Methods (Megaparsec vs Alex &rarr; Happy)](#org20fe821)
        2.  [Discussion of Project Name](#org104d858)

This document is for jotting down quick notes of our meetings an
discussions and is not the design document (although many parts of
here will formally be included in said document).


<a id="org8bb85af"></a>

# <span class="timestamp-wrapper"><span class="timestamp">&lt;2019-02-11 Mon&gt;</span></span>


<a id="orgb6e6da3"></a>

## Comparison of Allan and Julian's Methods of Writing a Compiler in Haskell


<a id="org20fe821"></a>

### Compared Parsing Methods (Megaparsec vs Alex &rarr; Happy)

-   Alex/Happy is much more similar to Flex/Bison
    -   Will be easier for David
-   Could generate tokens with Alex and feed them to Megaparsec
    -   This would be more difficult as we'd have to learn how to use
        Megaparsec in new ways (i.e. with a token stream)
-   Megaparsec errors are much nicer
    -   However, they only require the input string and the offset, all of
        which can be obtained from Alex if using the linepos or monadic wrapper
-   Simplest approach would be to use Alex/Happy
    -   Mainly have David and Julian work on scanning & parsing since they
        are familiar with the toolsets/style


<a id="org104d858"></a>

### Discussion of Project Name

-   Settled on `glc` as package/executable name
-   Project name is either Gophiler, Gompiler or Gopiler
    -   Settled on Gompiler

