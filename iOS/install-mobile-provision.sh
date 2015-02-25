#!/bin/bash

display_usage() {
    echo -e "usage: `basename $0` environment name source"
    echo -e "example: `basename $0` development \"My Profile Name\" mobileprovisions/"
    echo -e "example: `basename $0` distribution \"My Profile Name\" mobileprovisions/"
}

function install_mobileprovision() {
    filename="$1"
    uuid="$2"
    cp -f "$1" ~/Library/MobileDevice/Provisioning\ Profiles/$2.mobileprovision
}

if [[ ( $# == "--help") || ( $# == "-h" ) ]]; then
    display_usage
    exit 1
fi

if [  $# -ne 3 ]; then
    display_usage
    exit 2
fi

if [[ ( $1 != "development") && ( $1 != "distribution" ) ]]; then
    display_usage
    exit 3
fi

search_environment=$1
if [[ ( $search_environment == "distribution" ) ]]; then
    search_environment="production"
fi

search_name=$2

source=$3/*.mobileprovision

uuid=""

for f in $source ; do

    plist_filename="$(mktemp -d -t mobileprovision)/mobileprovision.plist"
    security cms -D -i "$f" -o "$plist_filename"

    environment="`/usr/libexec/PlistBuddy -c 'Print :Entitlements:aps-environment' \"$plist_filename\"`"
    if [[ ( $environment == $search_environment ) ]]; then

        name="`/usr/libexec/PlistBuddy -c 'Print :Name' \"$plist_filename\"`"
        if [[ ( $name == $search_name ) ]]; then

            uuid="`/usr/libexec/PlistBuddy -c 'Print :UUID' \"$plist_filename\"`"

            install_mobileprovision "$f" "$uuid"

        fi

    fi

done

if [[ -z $uuid ]]; then
    exit 4
fi

echo "${uuid}"
