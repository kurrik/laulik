#!/usr/bin/env bash

function output {
  echo -e "\033[1;95m$1\033[0m	$2"
}

set -e

scriptpath=/opt/laulik

# UTF-8 paths / env everywhere
export PYTHONIOENCODING=utf_8
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

cd $scriptpath
output "[main] Running server"
python3 ./server.py
output "[main] Done"
