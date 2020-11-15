#!/bin/bash
# Generate the lib's documentation.
# Intended to be run manually from within the project folder.

# Generate the documentation.
bundle exec jazzy
# Copy the images linked in the readme to the docs.
cp -R img/ docs/img