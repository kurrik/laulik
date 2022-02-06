#!/usr/bin/env bash

source ./src/common/common.sh

METHOD=${METHOD:-server}
PROJECT=${PROJECT:-voluja}

case "$METHOD" in
  server)
    output "[main] Running server"
    ./src/server/server.sh
    ;;
  laulik)
    output "[main] Running laulik for project $PROJECT"
    ./src/compiler/laulik.sh $PROJECT
    ;;
  *)
    output "[main] Unknown method $METHOD"
    exit 1
esac

output "[main] Done"
exit 0