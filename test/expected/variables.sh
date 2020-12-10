#!/bin/bash

a=1
b="string"
c="Con""cat"
echo ${a@Q}
echo ${b@Q}
echo ${c@Q}
a=$((1+2))
b=$(($a*7))
c=(1 2 "str" true false)
echo "A: "${a@Q}
echo "B: "${b@Q}
echo "C: "${c[@]}
d="${a}:${b}"
e="${a}${c[@]}"
f=1.1
echo ${d@Q}
echo ${e@Q}
echo ${f@Q}
