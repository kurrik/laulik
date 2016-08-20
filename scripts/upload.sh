#!/usr/bin/env bash
source `git rev-parse --show-toplevel`/scripts/common.sh

OLD_TAG=`git describe --tags --abbrev=0 2>/dev/null`
CURRENT_TAG=`git describe --tags 2>/dev/null`

set -e # Exit on nonzero return status

if [ -z "$OLD_TAG" ]; then
  echo "No existing tags, enter a new version (e.g. 1.0.0)"
else
  echo -n "Last explicit tag: "
  yellow $OLD_TAG
  echo -n "Current tag: "
  yellow $CURRENT_TAG
fi

echo -n "Enter the new tag: "
read NEW_TAG

echo -n "New tag: "
green $NEW_TAG

echo -n "Does this look OK? [Press 'y'] "
read -n 1 CONFIRM
echo

if [ "$CONFIRM" != "y" ]; then
  red "Stopping"
  exit 1
fi
echo

echo -n "Checking for dirty git tree... "
if test -n "$(git status --porcelain)"; then
  red "Uncommitted changes!"
  exit 1
fi
green "OK"

echo -n "Tagging release... "
git tag --annotate $NEW_TAG -m "Version $NEW_TAG"
green "OK"

echo -n "Building Docker container... "
source ./scripts/build.sh
green "OK"

echo -n "Pushing docker container... "
docker tag -f laulik gcr.io/kurrik-apps/laulik:${NEW_TAG} gcr.io/kurrik-apps/laulik:latest
gcloud docker push gcr.io/kurrik-apps/laulik:${NEW_TAG}
gcloud docker push gcr.io/kurrik-apps/laulik:latest
green "OK"

echo -n "Creating release dir if it doesn't exist... "
mkdir -p release
green "OK"

echo -n "Outputting release notes... "
git log --abbrev-commit --pretty=oneline --reverse \
  $OLD_TAG..HEAD > release/notes_${NEW_TAG}.txt
green "OK"

echo -n "Comitting changes... "
git add VERSION release
git commit -m "New release - $NEW_VER"
green "OK"

echo -n "Updating tag... "
git tag --annotate --force $NEW_TAG -m "Version $NEW_TAG"
green "OK"

echo -n "Pushing to origin... "
git push origin
git push origin --tags
green "OK"
