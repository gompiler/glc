#!/usr/bin/env bash

(cd src && stack test --pedantic --coverage)

chmod +x ./test_custom.sh
./test_custom.sh 
