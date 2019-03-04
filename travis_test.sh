#!/usr/bin/env bash

(cd src && make test)

chmod +x ./test_custom.sh
./test_custom.sh 
