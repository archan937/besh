#!/bin/bash

if [ "a" \== "a" ]; then
  echo "Equal (strings)"
fi

if [ "a" \!= "b" ]; then
  echo "Not equal (strings)"
fi

if [ "b" \> "a" ]; then
  echo "Greater than (strings)"
fi

if [ "a" \< "b" ]; then
  echo "Less than (strings)"
fi

if [ 1 -eq 1 ]; then
  echo "Equal"
fi

if [ 0 -ne 1 ]; then
  echo "Not equal"
fi

if [ 1 -gt 0 ]; then
  echo "Greater than"
fi

if [ 1 -ge 0 ]; then
  echo "Greater or equal (greater)"
fi

if [ 0 -ge 0 ]; then
  echo "Greater or equal (equal)"
fi

if [ 0 -lt 1 ]; then
  echo "Less than"
fi

if [ 0 -le 1 ]; then
  echo "Less or equal (less)"
fi

if [ 1 -le 1 ]; then
  echo "Less or equal (equal)"
fi

if [ -z "" ]; then
  echo "Zero-length"
fi

if [ -n "abc" ]; then
  echo "Not zero-length"
fi

if [ "a" \== "a" ] && [ "b" \== "b" ]; then
  echo "And"
fi

if [ "a" \== "b" ] || [ "c" \== "c" ]; then
  echo "Or"
fi
