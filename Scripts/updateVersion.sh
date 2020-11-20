#!/bin/bash
# Prepares the project for a new version of the lib.
# Intended to be run manually from within the project folder.
# Arguments: 
# string: The new marketing version, e.g. 1.2

# Assure 1 argument is passed.
if [ $# -ne 1 ]
  then
    echo "Requires marketing version as argument."
    exit 1
fi

# Increment the lib's version number.
agvtool next-version
# Sets the lib's marketing version to the value passed as argument.
agvtool new-marketing-version $1
