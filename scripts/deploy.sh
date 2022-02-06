#!/usr/bin/env bash
source `git rev-parse --show-toplevel`/scripts/common.sh

set -e # Exit on nonzero return status

PROJECT=kurrik-apps
SERVICE=laulik-server
IMAGE=laulik-server-gcloud

echo -n "Building on gcloud... "
  gcloud builds submit \
    --project $PROJECT \
    --timeout "20m" \
    --tag gcr.io/$PROJECT/$IMAGE \
    .
green "OK"

echo -n "Deploying to gcloud... "
gcloud beta run deploy \
  $SERVICE \
  --project $PROJECT \
  --region us-central1 \
  --allow-unauthenticated \
  --image gcr.io/$PROJECT/$IMAGE \
  --platform managed
green "OK"
