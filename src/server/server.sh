#!/usr/bin/env bash

source ./src/common/common.sh

cd $SERVERPATH

if [ ! -e "$REPOPATH" ]; then
  output "[server] Repo path $REPOPATH does not exist, cloning"
  mkdir -p $REPOPATH
  git clone https://github.com/kurrik/laulik.git $REPOPATH
  output "[server] Done cloning"
fi

output "[server] Running server"
python3 ./server.py --debug $REPOPATH
output "[server] Done"
