#!/usr/bin/env bash
source `git rev-parse --show-toplevel`/scripts/common.sh

CURRENT_TAG=`git describe --tags 2>/dev/null`
echo $CURRENT_TAG > VERSION

docker build -t laulik .
