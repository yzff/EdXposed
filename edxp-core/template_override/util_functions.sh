RIRU_PATH="/data/adb/riru"
RIRU_MODULE_ID="%%%RIRU_MODULE_ID%%%"
RIRU_MODULE_PATH="$RIRU_PATH/modules/$RIRU_MODULE_ID"
RIRU_SECONTEXT="u:object_r:magisk_file:s0"

check_riru_version() {
  RIRU_MIN_API_VERSION=%%%RIRU_MIN_API_VERSION%%%
  RIRU_MIN_VERSION_NAME="%%%RIRU_MIN_VERSION_NAME%%%"

  if [ ! -f "$RIRU_PATH/api_version" ] && [ ! -f "$RIRU_PATH/api_version.new" ]; then
    ui_print "${POUNDS}"
    ui_print "! ${LANG_UTIL_ERR_RIRU_NOT_FOUND_1}"
    ui_print "! ${LANG_UTIL_ERR_RIRU_NOT_FOUND_2}"
    [[ ${BOOTMODE} == true ]] && am start -a android.intent.action.VIEW -d https://github.com/RikkaApps/Riru/releases >/dev/null
    abortC   "${POUNDS}"
  fi
  RIRU_API_VERSION=$(cat "$RIRU_PATH/api_version.new") || RIRU_API_VERSION=$(cat "$RIRU_PATH/api_version") || RIRU_API_VERSION=0
  [ "$RIRU_API_VERSION" -eq "$RIRU_API_VERSION" ] || RIRU_API_VERSION=0
  ui_print "- Riru API ${LANG_CUST_INST_VERSION}: $RIRU_API_VERSION"
  if [ "$RIRU_API_VERSION" -lt $RIRU_MIN_API_VERSION ]; then
    ui_print "${POUNDS}"
    ui_print "! Riru $RIRU_MIN_VERSION_NAME ${LANG_UTIL_ERR_RIRU_LOW_1}"
    ui_print "! ${LANG_UTIL_ERR_RIRU_LOW_2}"
    [[ ${BOOTMODE} == true ]] && am start -a android.intent.action.VIEW -d https://github.com/RikkaApps/Riru/releases >/dev/null
    abortC   "${POUNDS}"
  fi
}

check_magisk_version() {
  ui_print "- Magisk ${LANG_CUST_INST_VERSION}: ${MAGISK_VER_CODE}"
  # before Magisk 16e4c67, sepolicy.rule is copied on the second reboot
  if [[ "$MAGISK_VER_CODE" -lt 21006 ]]; then
    touch "${MODPATH}/reboot_twice_flag"
  fi
}

require_new_android() {
    ui_print "${POUNDS}"
    ui_print "! ${LANG_UTIL_ERR_ANDROID_UNSUPPORT_1} ${1} ${LANG_UTIL_ERR_ANDROID_UNSUPPORT_2}"
    ui_print "! ${LANG_UTIL_ERR_ANDROID_UNSUPPORT_3}"
    [[ ${BOOTMODE} == true ]] && am start -a android.intent.action.VIEW -d https://github.com/ElderDrivers/EdXposed/wiki/Available-Android-versions >/dev/null
    abortC   "${POUNDS}"
}

edxp_check_architecture() {
    if [[ "${ARCH}" != "arm" && "${ARCH}" != "arm64" && "${ARCH}" != "x86" && "${ARCH}" != "x64" ]]; then
        abortC "! ${LANG_UTIL_ERR_PLATFORM_UNSUPPORT}: ${ARCH}"
    else
        ui_print "- ${LANG_UTIL_PLATFORM}: ${ARCH}"
    fi
}

check_android_version() {
    if [[ ${API} -ge 26 ]]; then
        ui_print "- Android SDK ${LANG_CUST_INST_VERSION}: ${API}"
    else
        require_new_android "${API}"
    fi
}