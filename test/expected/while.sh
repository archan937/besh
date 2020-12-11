#!/bin/bash

bool=true
i=0

while [ $bool ]; do
  echo $i
  i=$(($i+1))

  if [ $i -eq 5 ]; then
    break
  fi
done
