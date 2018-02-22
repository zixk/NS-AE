#!/bin/bash

correct_trace(){
    while read -r line
    do 
        echo  print "$line"
    done <<< "$OUTPUT"
}

if [ $1 -eq "-4" ] ; then
    IP="IPv4"
fi
if [ $1 -eq "-6" ] ; then
    IP="IPv6"
fi
echo 'IP --> '$IP

inputfile="./test.out"
while IFS= read -r line 
do
    ipType="$(cut -d" " -f2-2 <<<"$line")"
    if [ "$ipType" = "$IP" ] ; then
        ipAddress="$(cut -d" " -f3 <<<"$line")"
        echo "$ipAddress"
        if [ "$IP" = "IPv4" ] ; then
            OUTPUT="$(traceroute -4 -q 1 -n "$ipAddress")"
            correct_trace
        fi
        if [ "$IP" = "IPv6" ] ; then
            OUTPUT="$(traceroute -6 -q 1 -n "$ipAddress")"
            correct_trace
        fi
    fi 
done < "$inputfile"

