#!/usr/bin/env bash
set -e
(cd src && make test)

chmod +x ./test_custom.sh
./test_custom.sh
