#!/bin/bash

make clean;
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo make clean success
else
  echo make clean failed
  return -1
fi

make;
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo make success
else
  echo make failed
  return -1
fi

make ARCH=arm;
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo make arm success
else
  echo make arm failed
  return -1
fi

make test;
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo check test success
else
  echo check failed
  return -1
fi
