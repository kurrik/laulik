#!/usr/bin/env bash

source ./common/common.sh

METHOD=${METHOD:-server}

case "$METHOD" in
  server)
    output "[main] Running server"
    ./server/server.sh
    ;;
  laulik)
    output "[main] Running laulik"
    ./compiler/laulik.sh
    ;;
  *)
    output "[main] Unknown method $METHOD"
    exit 1
esac
