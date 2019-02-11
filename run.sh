#!/bin/bash

# Usage: ./run.sh <mode> <file>
# 	mode: scan|tokens|parse|pretty|symbol|typecheck|codegen

# Invoke the compiler with the provided arguments: mode ($1) and file ($2)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
csstack="/usr/local/pkgs/haskell/stack-1.9.3-linux-x86_64/"
if [ "${1^^}" == "LOC" ] || [ "${1^^}" == "LOCAL" ]
then
    stack exec -- "$DIR"/glc "$1" -f "$2"
elif [ -d "$csstack" ]
then
    PATH=$csstack:$PATH
    STACK_ROOT=/mnt/local
    export STACK_ROOT
    STACK_ROOT=/mnt/local stack --allow-different-user exec -- "$DIR"/glc "$1" -f "$2"
else
    echo "Newer version of Stack (1.9.3) not found, please you any of the cs-x computers at Trottier or any other computer with Stack 1.9.3, as the default version on other computers is too old."
    exit 1
fi
