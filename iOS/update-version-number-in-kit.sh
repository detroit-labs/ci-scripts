#!/bin/sh

plistBuddy=/usr/libexec/PlistBuddy
git=$(which git)
buildNumber=$("${git}" log --oneline | wc -l | tr -d ' ')

# add build number to kit

"${plistBuddy}" -c "Set :CFBundleVersion ${buildNumber}" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
