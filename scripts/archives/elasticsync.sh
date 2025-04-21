#!/usr/bin/env bash

#
#   Update Elasticsearch instance with json documents found in current and sub folder.
#   Url request follow the file path structure. Document are submitted with a PUT method except for the bulk document (see options below).
#
#   -t: Elasticsearch target host with full http url and port. Required to run the script
#   -b: Post bulk documents (_bulk.json) which makes it possible to perform many index/delete operations in a single API call.
#       Used mainly to create fake data to build and test visualization.
#   -r: Delete the document before making a PUT request. Can be used when you need to update the
#       index mapping which can't be changed once the data is indexed. Didn't apply to bulk document.
#

readCommandArgs() {

    BULK=1
    REMOVE_FIRST=1
    VERBOSE=1
    while getopts 'brt:v' flag; do
        case "${flag}" in
            b) BULK=0 ;;
            t) TARGET="${OPTARG}" ;;
            r) REMOVE_FIRST=0;;
            v) VERBOSE=0;;
            *) error "Unexpected option ${flag}" ;;
        esac
    done
    if [ -z $TARGET ]; then
        echo "No target specified"
        exit
    fi

}

init() {

    shopt -s dotglob

    initSourceDir
}

#
#   Give you the full directory name of the script no matter where it is being called from.
#

initSourceDir() {

    local source="${BASH_SOURCE[0]}"
    # resolve $source until the file is no longer a symlink
    while [ -h "$source" ]; do
        SOURCE_DIR="$( cd -P "$( dirname "$source" )" && pwd )"
        source="$(readlink "$source")"
        # if $source was a relative symlink, we need to resolve it relative to the path where the symlink file was located
        [[ $source != /* ]] && source="$SOURCE_DIR/$source"
    done
    SOURCE_DIR="$( cd -P "$( dirname "$source" )" && pwd )"

}

#
#   Recursive directory scan, current folder files are processed fist since parent index and type need to be updated before document leaf.
#

scan() {

    # need to process file first since there can be index creation
    for file in "$1"/*; do
        if [ ! -d "$file" ] && [ -e "$file" ] && [ ${file: -5} == ".json" ]; then
            submitDocument ${file}
        fi
    done

    for dir in "$1"/*; do
        if [ -d "${dir}" ] && [ -e "$dir" ]; then
           scan "${dir}"
        fi
    done
}

submitDocument() {

    local uri=${1#$SOURCE_DIR/}
    local url=${TARGET}/${uri%.json}

    local method="PUT"
    if [ $( basename ${1%.json} ) == "_bulk" ]; then
        [ "${BULK}" == 1 ] && return
        method="POST"
    fi

    out
    out "======================================================"
    out $(basename "$1")
    out "======================================================"

    # Delete prior to update when activated. Can only be performed prior to a PUT.
    [[ "${method}" == "PUT" ]] && [ "${REMOVE_FIRST}" -eq 0 ] && deleteDocument "${url}"

    transferDocument "${method}" "${url}" "${1}"
}

deleteDocument() {
    out
    out "Deleting: ${1}"
    curl -XDELETE ${1}

}

transferDocument() {
    out
    out ""${1}" "${2}""
    [ "${VERBOSE}" -eq 0 ] && cat ${3}
    curl -X"${1}" "${2}" --data-binary "@$3"
    echo
}

out() {
    [ "${VERBOSE}" -eq 1 ] && return
    echo $1
}

readCommandArgs "$@"

init

scan ${SOURCE_DIR}



