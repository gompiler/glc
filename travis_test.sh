#!/usr/bin/env bash

(cd src && stack test --coverage)

chmod +x ./test_custom.sh
./test_custom.sh 
