#!/bin/bash

make clean;
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo make clean success
else
  echo make clean failed
  exit 1
fi

make;
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo make success
else
  echo make failed
  exit 2
fi

make ARCH=arm;
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo make arm success
else
  echo make arm failed
  exit 3
fi


make ARCH=arm64;
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo make arm success
else
  echo make arm for 64-bit failed
  exit 5
fi

make test;
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo check test success
else
  echo check failed
  exit 4
fi
