#!/usr/bin/env bash

out() {
    printf "\n"
    for text in "$@";do
        printf "$text\n"
    done
}

ind() {
    printf "    "
}

readCommandArgs() {
    FORCE=1 
    REVERT=1
    

    while getopts 'frt:v' flag; do
        case "${flag}" in
            f) FORCE=0 ;;
            r) REVERT=0 ;;
            t) TARGET="${OPTARG}" ;;
            *) error "Unexpected option ${flag}" ;;
        esac
    done
}
