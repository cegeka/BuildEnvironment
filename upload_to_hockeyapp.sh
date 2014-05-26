#!/usr/bin/env bash
#exec > /tmp/log_hockeyapp_upload.log 2>&1

IPA="/tmp/${PRODUCT_NAME}.ipa"
APP="${ARCHIVE_PRODUCTS_PATH}/Applications/${PRODUCT_NAME}.app"
EMBED_PROVISIONING_PROFILE=$(grep -rl ${PROVISIONING_PROFILE} /Library/Server/Xcode/Data/ProvisioningProfiles ~"/Library/MobileDevice/Provisioning Profiles" 2>/dev/null | tail -1)
echo "Using provisioning profile: ${EMBED_PROVISIONING_PROFILE}"

echo "Creating .ipa for ${PRODUCT_NAME}"
/bin/rm "${IPA}"
/usr/bin/xcrun -sdk iphoneos PackageApplication -v "${APP}" -o "${IPA}" --sign "${CODE_SIGN_IDENTITY}" --embed "${EMBED_PROVISIONING_PROFILE}"

echo "Done with IPA creation."

echo "Zipping .dSYM for ${PRODUCT_NAME}"
/bin/rm "/tmp/${DWARF_DSYM_FILE_NAME}.zip"
pushd "${ARCHIVE_DSYMS_PATH}"
/usr/bin/zip -r "/tmp/${DWARF_DSYM_FILE_NAME}.zip" "${DWARF_DSYM_FILE_NAME}"
popd

echo "Created .dSYM for ${PRODUCT_NAME}"

echo "*** Uploading ${PRODUCT_NAME} to HockeyApp ***"
/usr/bin/curl "https://rink.hockeyapp.net/api/2/apps/${HOCKEYAPP_APP_ID}/app_versions/upload" \
-F notify="${HOCKEYAPP_NOTIFY:-0}" \
-F status="${HOCKEYAPP_STATUS:-2}" \
-F mandatory="${HOCKEYAPP_MANDATORY:-1}" \
-F ipa=@"${IPA}" \
-F dsym=@"/tmp/${DWARF_DSYM_FILE_NAME}.zip" \
-F notes="Upload by Xcode Bot" \
-H "X-HockeyAppToken: ${HOCKEYAPP_API_TOKEN}"

echo "HockeyApp upload finished!"