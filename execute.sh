#!/bin/bash
#
# Execute the generated code
#
# This script takes in the filename of the ORIGINAL program AFTER the codegen has been run
#   i.e. programs/3-semantics+codegen/valid/test.min
#
# It MUST then
#   (a) Compile the GENERATED file
#         i.e. programs/3-semantics+codegen/valid/test.c
#   (b) Execute the compiled code
#
# (if no compilation is needed, then only perform step b)
#
# To conform with the verification script, this script MUST:
#   (a) Output ONLY the execution
#   (b) Exit with status code 0 for success, not 0 otherwise

rm ${1%.*}.class 2> /dev/null

# You MUST replace the following line with the command to compile your generated code
# Note the bash replacement which changes:
#   programs/3-semantics+codegen/valid/test.go -> programs/3-semantics+codegen/valid/test.go.j
# stdout is redirected to /dev/null
file_dir="$(dirname "$1")"
krakatau_abs="$PWD/Krakatau"
cd $file_dir
file="$(basename "$1")"
FILENAME="${file%.*}.j"
python3 "$krakatau_abs/assemble.py" $FILENAME 2> /dev/null > /dev/null

# You MUST replace the following line with the command to execute your compiled code
# Note the bash replacement which changes:
#   programs/3-semantics+codegen/valid/test.min -> programs/3-semantics+codegen/valid/test.go.class
unset _JAVA_OPTIONS # Suppress picked up _JAVA_OPTIONS ...
java Main

# Lastly, we propagate the exit code
exit $?