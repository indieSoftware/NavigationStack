#!/bin/bash
# Releases a new version of the lib.
# Intended to be run manually from within the project folder.
# The current branch is the master branch and the code has been pushed.

# Get the lib's marketing version.
LIB_VERSION=$(agvtool what-marketing-version -terse1)
echo "Releasing v$LIB_VERSION"
# Create a new git tag with the lib's version.
git tag $LIB_VERSION
# Push tags.
git push --tags
# Update pod.
pod trunk push
