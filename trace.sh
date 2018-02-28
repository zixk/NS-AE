#!/bin/bash

correct_trace(){
    while read -r line
    do 
        number="$(cut -d" " -f1 <<<"$line")"
        routerAddr="$(cut -d" " -f3 <<<"$line")"
        if [ "$number" = 1 ] ; then 
            fromIP="$(cut -d" " -f2 <<<"$line")"
            echo AM NUMBA JUAN
            FIRST="\"$routerAddr\""
        elif [ "$number" = "traceroute" ] ; then
            echo AM TRACE
        else
            if [ "$routerAddr" != "*" ] ; then
                SECOND="\"$routerAddr\""
                echo "$FIRST" -- "$SECOND" >> "$outputfile"
                FIRST="$SECOND"
            fi
        fi
    done <<< "$OUTPUT"
}

IP="IPv4"

inputfile="./dnslu/$2.out"
outputfile="./ipv4/$2.dot"
echo "input: $inputfile"
while IFS= read -r line 
do
    ipType="$(cut -d" " -f2-2 <<<"$line")"
    if [ "$ipType" = "$IP" ] ; then
        ipAddress="$(cut -d" " -f3 <<<"$line")"
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

