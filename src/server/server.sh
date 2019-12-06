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
  export DEBUG=true
fi

cd $SERVERPATH
output "[server] Running server"
gunicorn --bind :$PORT --workers 1 --threads 8 server:app
output "[server] Done"
