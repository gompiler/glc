#!/usr/bin/env bash

(cd src && make test)
ret=$?
if [[ ret -ne 0 ]]
then
    exit 1
else
    chmod +x ./test_custom.sh
    ./test_custom.sh
fi
