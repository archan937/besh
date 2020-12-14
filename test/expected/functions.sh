#!/bin/bash

function say_hello() {
  local name="$1"
  greet="Hello, ${name}!"
  echo "${greet}!"
}

hello=$(say_hello "Paul")
echo "Output: ${hello}!"
