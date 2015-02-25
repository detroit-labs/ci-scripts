#!/bin/bash

display_usage() {
    echo -e "usage: `basename $0` source"
    echo -e "example: `basename $0` mobileprovisions/"
}

if [[ ( $# == "--help") ||  $# == "-h" ]]; then
    display_usage
    exit 0
fi

if [  $# -ne 1 ]; then
    display_usage
    exit 1
fi

echo_separator() {
    echo "================================================================================"
}

process_mobile_provision() {
    echo_separator
    filename="$1"
    echo "==="
    echo "==   `basename \"$filename\"`"
    echo "="

    plist_filename="$(mktemp -d -t mobileprovision)/mobileprovision.plist"
    security cms -D -i "$filename" -o "$plist_filename"

    environment="`/usr/libexec/PlistBuddy -c 'Print :Entitlements:aps-environment' \"$plist_filename\"`"
    echo "     Environment: $environment"

    name="`/usr/libexec/PlistBuddy -c 'Print :Name' \"$plist_filename\"`"
    echo "     Name: $name"

    uuid="`/usr/libexec/PlistBuddy -c 'Print :UUID' \"$plist_filename\"`"
    echo "     UUID: $uuid"

    team_name="`/usr/libexec/PlistBuddy -c 'Print :TeamName' \"$plist_filename\"`"
    echo "     Team Name: $team_name"

    team_identifier="`/usr/libexec/PlistBuddy -c 'Print :Entitlements:com.apple.developer.team-identifier' \"$plist_filename\"`"
    echo "     Team Identifier: $team_identifier"

    expiration_date="`/usr/libexec/PlistBuddy -c 'Print :ExpirationDate' \"$plist_filename\"`"
    echo "     Expiration Date: $expiration_date"
}

source=$1/*.mobileprovision

for f in $source ; do
    process_mobile_provision "$f"
done

echo_separator
