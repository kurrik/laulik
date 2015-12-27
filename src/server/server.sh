#!/usr/bin/env bash

source ./common/common.sh

scriptpath=/opt/laulik/server
commonpath=/opt/laulik/common
datapath=/opt/laulik/data
rootpath=/opt/laulik

export PYTHONPATH=$PYTHONPATH:$commonpath

cd $scriptpath
output "[server] Running server"
python3 ./server.py --debug $datapath $rootpath
output "[server] Done"
