CI Scripts
==========

## Sample Build Scripts 

 
## Utility Scripts

 - [summary-of-mobile-provisions.sh](iOS/summary-of-mobile-provisions.sh)
 - [install-mobile-provision.sh](iOS/install-mobile-provision.sh)
 - [update-version-number-in-kit.sh](iOS/update-version-number-in-kit.sh)
 - [update-version-number-in-settings.sh](iOS/update-version-number-in-settings.sh)

## Functions

 - [install_dependencies](#install_dependencies)
 - [install_xctool](#install_xctool)
 - [download_xctool](#download_xctool)
 - [calculate_filename](#calculate_filename)
 - [compile_build](#compile_build)
 - [create_app_file](#create_app_file)
 - [generate_build_notes](#generate_build_notes)
 - [upload_build](#upload_build)
 - [unlock_keychain](#unlock_keychain)
 - [lock_keychain](#lock_keychain)
 

#####install_dependencies
Sets up ruby environment and all Ruby/Gem dependencies (incl. Cocoapods).

_File: [common-build.sh](common-build.sh)_

#####install_xctool
Checks system version of xctool & downloads a specific version of xctool if system version doesn't match the version required for the project.

_File: [common-build.sh](common-build.sh)_

#####download_xctool
Downloads a specific version of xctool.

_File: [common-build.sh](common-build.sh)_

#####calculate_filename
Determines absolute path to build filename.

_File: [common-build.sh](common-build.sh)_

#####compile_build
Runs Xctool clean + build.

_File: [common-build.sh](common-build.sh)_

#####create_app_file
Archives & exports a signed *.ipa.

_File: [common-build.sh](common-build.sh)_

#####generate_build_notes
Compiles build notes into a text file, including CHANGES_SINCE_SUCCESS.

_File: [common-distribute.sh](common-distribute.sh)_

#####upload_build
Uploads *.ipa to Crashlytics Beta w/ notes; notifies test groups.

_File: [common-distribute.sh](common-distribute.sh)_

#####unlock_keychain
Unlocks a given keychain.

_File: [common-shared.sh](common-shared.sh)_

#####lock_keychain
Locks a given keychain.

_File: [common-shared.sh](common-shared.sh)_
