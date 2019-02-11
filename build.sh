#!/bin/bash

# Build the compiler
#
# Ensure we are in the directory the script is in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

csstack="/usr/local/pkgs/haskell/stack-1.9.3-linux-x86_64"

# If first arg is loc or local (casing does not matter), compile locally without specifying trottier args
if [ "${1^^}" == "LOC" ] || [ "${1^^}" == "LOCAL" ]
then
    make -C src clean
    make -C src scanparse
elif [ -d "$csstack" ]
then
    PATH=$csstack:$PATH
    STACK_ROOT=/mnt/local
    export STACK_ROOT
    
    make -C src cleantrot
    make -C src
    # Run executable once because it outputs special text on first run, else we'd fail first test
    stack --allow-different-user exec -- "src"/scanparse scan -s <<< ""
else
    echo "Newer version of Stack (1.9.3) not found, please use any of the cs-x computers at Trottier or any other computer with Stack 1.9.3, as the default version on other computers is too old."
    exit 1
fi
