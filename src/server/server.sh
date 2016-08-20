#!/usr/bin/env bash

source ./src/common/common.sh


if [ ! -e "$REPOPATH" ]; then
  output "[server] Repo path $REPOPATH does not exist, cloning"
  mkdir -p $REPOPATH
  git clone https://github.com/kurrik/laulik.git $REPOPATH
  output "[server] Done cloning"
  ./src/server/git_pull.sh
fi

if [ ! -e "$INFOPATH" ]; then
  ./src/server/git_info.sh
fi

if [ "$DEBUG" == "true" ]; then
  output "[server] Running in debug mode"
  ADDL_FLAGS="--debug"
fi

cd $SERVERPATH
output "[server] Running server"
python3 ./server.py $REPOPATH $ADDL_FLAGS
output "[server] Done"
