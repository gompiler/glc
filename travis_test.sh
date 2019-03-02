#!/usr/bin/env bash

(cd src && stack test)

chmod +x ./build.sh
./build.sh 