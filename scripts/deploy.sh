#!/usr/bin/env bash
source `git rev-parse --show-toplevel`/scripts/common.sh

set -e # Exit on nonzero return status

echo -n "Deploying to gcloud... "
gcloud beta run deploy \
  laulik-server \
  --project kurrik-apps \
  --region us-central1 \
  --allow-unauthenticated \
  --image gcr.io/kurrik-apps/laulik:latest \
  --platform managed
green "OK"
