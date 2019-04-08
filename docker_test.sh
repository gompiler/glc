#!/usr/bin/env bash

(cd src && make test)

if [[ $? -ne 0 ]]; then
    exit 1
fi

python3 ./Krakatau/assemble.py main.j
java main

chmod +x ./test_custom.sh
./test_custom.sh
