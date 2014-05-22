#!/usr/bin/env bash
exec > /tmp/log_hockeyapp_${PRODUCT_NAME}.txt 2>&1

DSYM="/tmp/Archive.xcarchive/dSYMs/${PRODUCT_NAME}.app.dSYM"
IPA="/tmp/${PRODUCT_NAME}.ipa"
APP="/tmp/Archive.xcarchive/Products/Applications/${PRODUCT_NAME}.app"

# Clear out any old copies of the Archive
echo "Removing old Archive files from /tmp...";
/bin/rm -rf /tmp/Archive.xcarchive*

#Copy over the latest build the bot just created
echo "Copying latest Archive to /tmp/...";
LATESTBUILD=$(ls -1rt /Library/Server/Xcode/Data/BotRuns | tail -1)

/bin/cp -Rp "/Library/Server/Xcode/Data/BotRuns/${LATESTBUILD}/output/Archive.xcarchive" "/tmp/"

echo "Creating .ipa for ${PRODUCT_NAME}"
/bin/rm "${IPA}"
EMBED_PROVISIONING_PROFILE=$(grep -l ${PROVISIONING_PROFILE} /Library/Server/Xcode/Data/ProvisioningProfiles/ | tail -1)
echo "Using provisioning profile: ${EMBED_PROVISIONING_PROFILE}"
/usr/bin/xcrun -sdk iphoneos PackageApplication -v "${APP}" -o "${IPA}" --sign "${CODE_SIGN_IDENTITY}" --embed "${EMBED_PROVISIONING_PROFILE}"

echo "Done with IPA creation."

echo "Zipping .dSYM for ${PRODUCT_NAME}"
/bin/rm "${DSYM}.zip"
/usr/bin/zip -r "${DSYM}.zip" "${DSYM}"

echo "Created .dSYM for ${PRODUCT_NAME}"

echo "*** Uploading ${PRODUCT_NAME} to HockeyApp ***"
/usr/bin/curl "https://rink.hockeyapp.net/api/2/apps/${HOCKEYAPP_APP_ID}/app_versions/upload" \
-F notify="${HOCKEYAPP_NOTIFY:?0}" \
-F status="${HOCKEYAPP_STATUS:?2}" \
-F mandatory="${HOCKEYAPP_MANDATORY:?1}" \
-F ipa=@"${IPA}" \
-F dsym=@"${DSYM}.zip" \
-F notes="Upload by Xcode Bot" \
-H "X-HockeyAppToken: ${HOCKEYAPP_API_TOKEN}"

echo "HockeyApp upload finished!"