#!/bin/bash

if [ "a" == "a" ]; then
  echo "Equal (strings)"
fi

if [ "a" != "b" ]; then
  echo "Not equal (strings)"
fi

if [ "b" \> "a" ]; then
  echo "Greater than (strings)"
fi

if [ "a" \< "b" ]; then
  echo "Less than (strings)"
fi

if (( 1 == 1 )); then
  echo "Equal"
fi

if (( 0 != 1 )); then
  echo "Not equal"
fi

if (( 1 > 0 )); then
  echo "Greater than"
fi

if (( 1 >= 0 )); then
  echo "Greater or equal (greater)"
fi

if (( 0 >= 0 )); then
  echo "Greater or equal (equal)"
fi

if (( 0 < 1 )); then
  echo "Less than"
fi

if (( 0 <= 1 )); then
  echo "Less or equal (less)"
fi

if (( 1 <= 1 )); then
  echo "Less or equal (equal)"
fi

if [ -z "" ]; then
  echo "Zero-length"
fi

if [ -n "abc" ]; then
  echo "Not zero-length"
fi

if [ "a" == "a" ] && [ "b" == "b" ]; then
  echo "And"
fi

if [ "a" == "b" ] || (( 1 < 2 )); then
  echo "Or"
fi

if [ "c" == "c" ]; then
  echo "true"
else
  echo "false"
fi

if [ "a" == "c" ]; then
  echo "false"
else
  echo "true"
fi
