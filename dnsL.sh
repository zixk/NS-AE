#!/bin/bash

for an_arg in "$@" ; do
    address="$(cut -d"." -f2 <<<"${an_arg}")"
    outputfile="./dnslu/$address.out"
    echo "Executing: $address"
    ./dnslookup "${an_arg}" > "$outputfile"
done

