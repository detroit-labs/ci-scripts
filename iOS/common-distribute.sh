#########################################################
# Commonly used distribution script functions
#########################################################

function generate_build_notes() {
  echo ${EMAIL_HEADER} > build/notes.txt
  echo "\n" >> build/notes.txt
  echo $(git rev-parse --abbrev-ref HEAD) >> build/notes.txt
  echo "\n\n" >> build/notes.txt
  echo $CHANGES_SINCE_SUCCESS >> build/notes.txt
}

function upload_build()
{
  ${CRASHLYTICS_SUBMIT_PATH} \
    $CRASHLYTICS_API_KEY $CRASHLYTICS_BUILD_SECRET \
    -ipaPath build/$IPA \
    -notesPath build/notes.txt \
    -groupAliases ${EMAIL_GROUPS}

  return $?
}
