#!/usr/bin/env bash

(cd src && stack test)

chmod +x ./test_local.sh
./test_local.sh 