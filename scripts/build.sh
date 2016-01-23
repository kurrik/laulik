#!/usr/bin/env bash
source `git rev-parse --show-toplevel`/scripts/common.sh

docker build -t laulik src
