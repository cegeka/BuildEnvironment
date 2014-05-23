#!/usr/bin/env bash
exec > /tmp/log_version_update.log 2>&1

NEW_VERSION=`date "+%Y%m%d%H%M%S"`
echo "Updating BundleVersion to ${NEW_VERSION}";
find $PROJECT_DIR -name '*-Info.plist' -not -name '*Tests-Info.plist' -exec /usr/libexec/PListBuddy -c "Set CFBundleVersion $NEW_VERSION" {} \;
