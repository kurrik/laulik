#!/usr/bin/env bash

source ./src/common/common.sh

output "[pull] Pulling repo at $REPOPATH"
cd $REPOPATH
git pull -vvv
output "[pull] Done"
