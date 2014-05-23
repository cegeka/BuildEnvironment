#!/usr/bin/env bash
#exec > /tmp/log_version_update.log 2>&1

NEW_VERSION=`date "+%Y%m%d%H%M%S"`
echo "Updating BundleVersion to ${NEW_VERSION}";

/usr/libexec/PListBuddy -c "Set CFBundleVersion $NEW_VERSION" ${SRCROOT}/${PRODUCT_NAME}/${PRODUCT_NAME}-Info.plist
