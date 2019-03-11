#!/usr/bin/env bash

(cd src && make test)

if [[ $? != 0 ]]
then
	echo -e "Tests failed"
	exit 1
fi

chmod +x ./test_custom.sh
./test_custom.sh 
