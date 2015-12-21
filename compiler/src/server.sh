#!/usr/bin/env bash

source ./common.sh

scriptpath=/opt/laulik
cd $scriptpath
output "[server] Running server"
python3 ./server.py
output "[server] Done"
