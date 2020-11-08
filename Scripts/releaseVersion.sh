#!/bin/bash
# Releases a new version of the lib.
# Intended to be run manually from within the project folder.
# The current branch is the master branch and the code has been pushed.

# Get the lib's marketing version.
libVersionNumber=$(agvtool what-marketing-version -terse1)
echo "Releasing v$libVersionNumber"
# Create a new git tag with the lib's version.
git tag $libVersionNumber
# Push tags.
git push --tags
