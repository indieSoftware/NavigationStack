#!/bin/bash
# Sets the lib's marketing version to the value passed as argument.
# Intended to be run manually from within the project folder.
# Arguments: 
# string: The new marketing version, e.g. 1.2

agvtool new-marketing-version $1
