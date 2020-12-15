#!/bin/bash

status=201

case $status in
204)
  echo "No content"
  ;;
2*)
  echo "Success"
  ;;
3*)
  echo "Redirect"
  ;;
401)
  echo "Unauthorized"
  ;;
4*)
  echo "Error"
  ;;
5*)
  echo "Internal error"
  ;;
*)
  echo "Unknown"
  ;;
esac

status=204

case $status in
204)
  echo "No content"
  ;;
2*)
  echo "Success"
  ;;
3*)
  echo "Redirect"
  ;;
401)
  echo "Unauthorized"
  ;;
4*)
  echo "Error"
  ;;
5*)
  echo "Internal error"
  ;;
*)
  echo "Unknown"
  ;;
esac

status=401

case $status in
2*)
  echo "Success"
  ;;
204)
  echo "No content"
  ;;
3*)
  echo "Redirect"
  ;;
401)
  echo "Unauthorized"
  ;;
4*)
  echo "Error"
  ;;
5*)
  echo "Internal error"
  ;;
*)
  echo "Unknown"
  ;;
esac

status=500

case $status in
204)
  echo "No content"
  ;;
2*)
  echo "Success"
  ;;
3*)
  echo "Redirect"
  ;;
401)
  echo "Unauthorized"
  ;;
4*)
  echo "Error"
  ;;
5*)
  echo "Internal error"
  ;;
*)
  echo "Unknown"
  ;;
esac

status=999

case $status in
204)
  echo "No content"
  ;;
2*)
  echo "Success"
  ;;
3*)
  echo "Redirect"
  ;;
401)
  echo "Unauthorized"
  ;;
4*)
  echo "Error"
  ;;
5*)
  echo "Internal error"
  ;;
*)
  echo "Unknown"
  ;;
esac
