#!/usr/bin/env bash

(cd src && make test)

if [[ $? -ne 0 ]]; then
    exit 1
fi

chmod +x ./test_custom.sh
./test_custom.sh
if [[ $? -ne 0 ]]; then
    exit 1
fi
