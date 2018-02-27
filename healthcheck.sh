#!/bin/sh

validateStatus (){
  if [ $1 -ne 0 ]; then
    exit 1
  fi
}

rndc status | grep "up and running" > /dev/null
validateStatus $?

named-checkconf -z > /dev/null
validateStatus $?