#!/usr/bin/env bash
source `git rev-parse --show-toplevel`/scripts/common.sh

docker tag -f laulik gcr.io/kurrik-apps/laulik

gcloud docker push gcr.io/kurrik-apps/laulik
