# Steps to release a new version

1. Use `pod install` and `pod update` to update all pods to the latest version.
2. Apply any code changes.
3. Run the `Scripts/updateVersion.sh` script and pass the new marketing version (e.g. `1.2`) as argument to prepare a new release version.
4. Run the `Scripts/generateDocs.sh` script to update the documentation.
4. Merge branch with master and push to origin.
5. Run the `Scripts/releaseVersion.sh` script to create and push a new git tag for the lib's new version.

