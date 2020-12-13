#!/bin/bash

bool=true
i=0

while [ $bool ]; do
  echo $i
  ((i++))

  if [ $i == 5 ]; then
    break
  fi
done
