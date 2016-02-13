#!/usr/bin/env bash
source ./src/common/common.sh

output "[pull] Pulling repo at $REPOPATH"
cd $REPOPATH
git pull
output "[pull] Done"
./src/server/git_info.sh
