#!/usr/bin/env bash

(cd src && stack test --no-install-ghc --system-ghc --coverage --pedantic)

if [[ $? -ne 0 ]]; then
	exit 1
fi

python ./Krakatau/assemble.py main.j
java main
exit 1

chmod +x ./test_custom.sh
./test_custom.sh
