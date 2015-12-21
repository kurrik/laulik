#!/usr/bin/env bash

source ./common.sh

METHOD=${METHOD:-server}

case "$METHOD" in
  server)
    output "[main] Running server"
    ./server.sh
    ;;
  laulik)
    output "[main] Running laulik"
    ./laulik.sh
    ;;
  *)
    output "[main] Unknown method $method"
    exit 1
esac
