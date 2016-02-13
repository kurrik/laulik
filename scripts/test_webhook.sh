#!/usr/bin/env bash
source `git rev-parse --show-toplevel`/scripts/common.sh

url=${1:-"http://192.168.99.100/webhook"}

curl $url \
  -vvv \
  -X POST \
  --header "Content-Type: application/json" \
  --header "User-Agent: GitHub-Hookshot/21f57ba" \
  --header "X-GitHub-Delivery: 9f9a3b00-d280-11e5-8c98-c4066a813c3e" \
  --header "X-GitHub-Event: push" \
   -d @scripts/test_webhook_payload.txt
