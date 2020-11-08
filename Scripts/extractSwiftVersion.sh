#!/bin/bash
# Writes the current swift version into a file.
# Intended to be run by Xcdoe to extract the swift version used by SwiftFormat.

swift -version | grep -Eo 'Swift version [0-9]+(\.[0-9])*' | grep -Eo '[0-9]+(\.[0-9])*' | tee .swift-version
