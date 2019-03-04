#!/usr/bin/env bash

# Trottier wrapper to add stack to path and change STACK_ROOT to /mnt/local

# Ensure we are in the directory the script is in
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

csstack="/usr/local/pkgs/haskell/stack-1.9.3-linux-x86_64"

if [ -d "$csstack" ] && [ -d "/mnt/local" ]
then
    PATH=$csstack:$PATH
    STACK_ROOT=/mnt/local
    export STACK_ROOT

    make -C src "$2"
else
    echo "Did not find /usr/local/pkgs/haskell/stack-1.9.3-linux-x86_64 and /mnt/local, please run on a cs-x.cs.mcgill.ca computer. Exiting."
    exit 1
fi
