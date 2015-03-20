#########################################################
# Commonly used script functions
#########################################################

function unlock_keychain()
{
  set +x
  CERTS_PATH="$WORKSPACE/../certs"
  PASSWORDPATH="$CERTS_PATH/${KEYCHAIN}.pw"
  KEYCHAIN_PASSWORD=$(cat $PASSWORDPATH)
  echo "unlocking keychain with path ${PASSWORDPATH}"
  security unlock-keychain -p ${KEYCHAIN_PASSWORD} "${KEYCHAIN}"
  security set-keychain-settings -l -u "${KEYCHAIN}"
  set -x
}

function lock_keychain()
{
  security lock-keychain "${KEYCHAIN}"
}
