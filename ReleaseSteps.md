# Steps to release a new version

1. Use `pod install` and `pod update` to update all pods to the latest version.
2. Apply any code changes.
3. Run the `prepareRelease.sh` script and pass the new marketing version (e.g. `1.2`) as argument.
4. Merge branch with master and push to origin.
5. Run the `releaseVersion.sh` script.

