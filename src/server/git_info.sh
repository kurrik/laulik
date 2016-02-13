#!/usr/bin/env bash
source ./src/common/common.sh

cd $REPOPATH
output "[info] Writing git info to $INFOPATH"
git log --pretty="[%h] %s - %an %ai" -n1 > $INFOPATH
output "[info] Done"
