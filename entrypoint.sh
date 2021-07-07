#!/bin/bash

#!/bin/bash

set -eu

REPO_FULLNAME=$(jq -r ".repository.full_name" "$GITHUB_EVENT_PATH")

echo "## Initializing git repo..."
git init
echo "### Adding git remote..."
git remote add origin https://x-access-token:$GITHUB_TOKEN@github.com/$REPO_FULLNAME.git
echo "### Getting branch"
BRANCH=${GITHUB_REF#*refs/heads/}
echo "### git fetch $BRANCH ..."
git fetch origin $BRANCH
echo "### Branch: $BRANCH (ref: $GITHUB_REF )"
git checkout $BRANCH

echo "## Configuring git author..."
git config --global user.email "CI-check@4hypso.no"
git config --global user.name "Check test"

# Ignore workflow files (we may not touch them)
git update-index --assume-unchanged .github/workflows/*

make clean;
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo make clean success
else
  echo make clean failed
  return -1
fi

make;
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo make success
else
  echo make failed
  return -1
fi

make ARCH=arm;
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo make arm success
else
  echo make arm failed
  return -1
fi

make test;
RESULT=$?
if [ $RESULT -eq 0 ]; then
  echo check test success
else
  echo check failed
  return -1
fi
