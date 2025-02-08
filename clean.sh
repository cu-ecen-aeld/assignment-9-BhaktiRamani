#!/bin/bash

cd `dirname $0`

if [ -d buildroot ]; then
    echo "Cleaning the buildroot"
    make -C buildroot distclean
else
    echo "Buildroot directory doesn't exist"
fi

