#!/bin/bash
# Updates all local project dependencies, i.e. cocoapods.

# Update gems.
bundle update
# Install missing pods.
pod install
# Update pods to newer version.
pod update
