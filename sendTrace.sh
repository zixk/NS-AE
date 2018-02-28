#!/bin/bash

for an_arg in "$@" ; do
    echo "Executing: ${an_arg}"
    ./trace.sh -4 "${an_arg}"
done

