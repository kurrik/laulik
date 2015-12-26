#!/usr/bin/env bash

source ./common/common.sh

scriptpath=/opt/laulik/server
cd $scriptpath
output "[server] Running server"
python3 ./server.py
output "[server] Done"
