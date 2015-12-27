#!/usr/bin/env bash

source ./common/common.sh

cd $SERVERPATH
output "[server] Running server"
python3 ./server.py --debug $ROOTPATH
output "[server] Done"
