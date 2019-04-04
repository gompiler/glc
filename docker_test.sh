#!/usr/bin/env bash

(cd src && stack test --no-install-ghc --system-ghc --coverage --pedantic)

if [[ $? -ne 0 ]]; then
    exit 1
fi

python3.5 ./Krakatau/assemble.py main.j
java main

chmod +x ./test_custom.sh
./test_custom.sh
