#!/bin/bash

# Usage: ./run.sh <mode> <file>
# 	mode: scan|tokens|parse|pretty|symbol|typecheck|codegen

# Invoke the compiler with the provided arguments: mode ($1) and file ($2)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
    "$DIR"/src/glc "$1" -f "$2"
