#!/bin/bash

for (( counter=10; counter > 0; counter-- )); do
  echo -n "${counter} "
done

for color in "Blue" "Green" "Pink" "White" "Red"; do
  echo "Color = ${color}"
done
colors=("Blue" "Green" "Pink" "White" "Red")

for color in $colors; do

  if [ $color == "Blue" ]; then
    echo "My favorite color is ${color}"
  fi
done
