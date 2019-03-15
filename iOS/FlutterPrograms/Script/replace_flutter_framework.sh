#!/bin/sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

RunCommand() {
    if [[ -n "$VERBOSE_SCRIPT_LOGGING" ]]; then
        echo "♦ $*"
    fi
    "$@"
    return $?
}

EchoError() {
    echo "$@" 1>&2
}

AssertExists() {
    if [[ ! -e "$1" ]]; then
        if [[ -h "$1" ]]; then
            EchoError "The path $1 is a symlink to a path that does not exist"
        else
            EchoError "The path $1 does not exist"
        fi
        exit -1
    fi
    return 0
}

# Adds the App.framework as an embedded binary and the flutter_assets as
# resources.
replace_flutter_framework() {
    AssertExists "${FLUTTER_APPLICATION_PATH}"
    
    
    local flutter_ios_out_folder="${FLUTTER_APPLICATION_PATH}/.ios/Flutter"
    local flutter_ios_engine_folder="${FLUTTER_APPLICATION_PATH}/.ios/Flutter/engine"
    if [[ ! -d ${flutter_ios_out_folder} ]]; then
        flutter_ios_out_folder="${FLUTTER_APPLICATION_PATH}/ios/Flutter"
        flutter_ios_engine_folder="${FLUTTER_APPLICATION_PATH}/ios/Flutter"
    fi
    local custom_flutter_ios_engine_folder="$( dirname $( dirname ${DIR} ))/flutter_frameworks"
    AssertExists "${flutter_ios_out_folder}"
    AssertExists "${custom_flutter_ios_engine_folder}"
    
    
    RunCommand rm -rf -- "${flutter_ios_engine_folder}/Flutter.framework"
    RunCommand cp -Rv -- "${custom_flutter_ios_engine_folder}/ios_debug/Flutter.framework" "${flutter_ios_engine_folder}/Flutter.framework"
}

replace_flutter_framework
