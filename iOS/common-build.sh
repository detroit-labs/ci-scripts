#########################################################
# Commonly used build script functions
#########################################################

function install_dependencies()
{
  if [ ! -f .ruby-version ]; then
    echo ${RUBYVERSION} >> .ruby-version
  fi

  bundle install --path=.bundle --binstubs=bin
  #run pods
  bin/pod install
  pod_status=$?

  if [ $pod_status != 0 ]; then
    echo "Failed to install pods."
    exit $pod_status
  fi
}

function install_xctool()
{
  if [ ! -z "${xctool_path}" ]; then
    current_xctool_version="$("${xctool_path}" --version)"

    if [ "${current_xctool_version}" != "${xctool_version}" ]; then
      download_xctool
    fi
  else
    download_xctool
  fi
}

function download_xctool()
{
  xctool_dir="$(mktemp -d -t xctool)"

  git clone -q git@github.com:facebook/xctool.git -b v${xctool_version} \
            --single-branch "${xctool_dir}"

  xctool_path="${xctool_dir}/xctool.sh"
}

function calculate_filename()
{
  outputFilenamePathWithoutExtension="${OUTPUTPATH}/build/${OUTPUTFILENAME}"
}

function compile_build()
{
  CONFIGURATION_BUILD_DIR="$OUTPUTPATH/build/${SCHEME}-${CONFIGURATION}-iphoneos"
  rm -rf "${CONFIGURATION_BUILD_DIR}"

  ${xctool_path} -workspace "${XCODEWORKSPACE}" \
    -scheme "${SCHEME}" \
    -configuration "${CONFIGURATION}" \
    PROJECT_TEMP_DIR="$OUTPUTPATH/temp" \
    CONFIGURATION_BUILD_DIR="${CONFIGURATION_BUILD_DIR}" \
    ONLY_ACTIVE_ARCH=NO \
    OTHER_CODE_SIGN_FLAGS="--keychain $KEYCHAIN" \
    PROVISIONING_PROFILE="$PROVISIONINGPROFILE" \
    CODE_SIGN_IDENTITY="$CODESIGNIDENTITY" \
    GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=NO \
    GCC_GENERATE_TEST_COVERAGE_FILES=NO \
    clean build
    
  build_success=$?
  
  rm -rf "$OUTPUTPATH/temp"
  
  return $build_success
}

function create_app_file()
{
  app_file_created=0
  
  ipa_path="${outputFilenamePathWithoutExtension}.ipa"
  
  # Codesign the test app
  "${PACKAGEAPPLICATION}" \
        "${CONFIGURATION_BUILD_DIR}/${SCHEME}.app" \
        -o "${ipa_path}" \
        --keychain "${KEYCHAIN}" \
        --sign "${CODESIGNIDENTITY}" \
        --embed ~/Library/MobileDevice/Provisioning\ Profiles/${PROVISIONINGPROFILE}.mobileprovision
  
  app_file_created=$((app_file_created+$?))
  
  return $app_file_created
}
