#!/bin/sh

perl -i -pe s/YEAR/$1/g $(grep -rl 2019) 
for d in $(seq 1 25); do
    ./input.sh $d
done
