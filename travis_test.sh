#!/usr/bin/env bash

(cd src && stack test)

chmod +x ./test_custom.sh
./test_custom.sh 
