#!/bin/sh

plistBuddy=/usr/libexec/PlistBuddy
rootPlist=$2
versionNumber=`${plistBuddy} -c "Print :CFBundleShortVersionString" "$1"`

git=$(which git)
buildNumber=$("${git}" log --oneline | wc -l | tr -d ' ')

# add build number to settings screen
"${plistBuddy}" -c "Set PreferenceSpecifiers:0:DefaultValue ${versionNumber}, build: ${buildNumber}" "${rootPlist}"
