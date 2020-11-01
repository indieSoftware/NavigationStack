#!/bin/bash
swift -version | grep -Eo 'Swift version [0-9]+(\.[0-9])*' | grep -Eo '[0-9]+(\.[0-9])*' | tee ../.swift-version