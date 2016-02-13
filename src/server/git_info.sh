#!/usr/bin/env bash
source ./src/common/common.sh

cd $REPOPATH
git log --pretty="[%h] %s - %an %ar" -n1
