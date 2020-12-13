#!/bin/bash

if (( 1 == 1 )); then
  echo "a"
else
  echo "b"
fi

if false; then
  echo "a"
else
  echo "b"
fi

if false; then
  echo "a"
elif (( 1 == 1 )); then
  echo "b"
else
  echo "c"
fi

if false; then
  echo "a"
elif (( 1 == 2 )); then
  echo "b"
elif [ "a" == "a" ]; then
  echo "c"
fi
