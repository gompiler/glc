#!/bin/bash

# Build the compiler
#
# Ensure we are in the directory the script is in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

csstack="/usr/local/pkgs/haskell/stack-1.9.3-linux-x86_64"

# If first arg is loc or local (casing does not matter), compile locally without specifying trottier args
if [ -d "$csstack" ] && [ -d "/mnt/local" ]
then
    PATH=$csstack:$PATH
    STACK_ROOT=/mnt/local
    export STACK_ROOT
    
    make -C src cleantrot
    make -C src allT
else
    echo "Did not find /usr/local/pkgs/haskell/stack-1.9.3-linux-x86_64 and /mnt/local, assuming we are running this locally (not on Trottier), otherwise please use a cs-x.cs.mcgill.ca computer."
    make -C src clean
    make -C src
fi
