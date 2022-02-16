#!/usr/bin/env bash

source `git rev-parse --show-toplevel`/scripts/common.sh

cd scripts/process_unconverted && cargo build

FILES="$ROOT/data/unconverted/songs/*"
for f in $FILES
do
  echo "Converting $f..."
  $ROOT/scripts/process_unconverted/target/debug/process_unconverted $f $ROOT/data/laulud
done