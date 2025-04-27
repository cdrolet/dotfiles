#!/usr/bin/env bash
################################################################################
# File: dotsync.sh - Dotfiles Synchronization Script
# Author: Charles Drolet
# GitHub: @cdrolet
#
# Description: A script for managing dotfiles through symlinks
# This script automates the process of managing dotfiles by:
#
# 1. File Discovery:
#    - Recursively scans the repository for dotfiles (files/folders starting with '.')
#    - Limited to root and first level of subfolders for safety
#    - Respects .dotignore file for excluded files
#
# 2. Change Preview:
#    The script provides a detailed preview of proposed changes:
#    - New symlinks to be created in home directory
#    - Broken symlinks to be removed
#    - Files rejected due to naming conflicts
#    - Files ignored based on .dotignore
#    - Files already properly symlinked
#    - Requires user confirmation before applying changes (unless -f flag is used)
#
# Usage:
#   Direct execution:
#     sh dotsync.sh /path/to/dotfiles [-f] [-t filename]
#
#   Sourcing:
#     source /path/to/dotsync.sh /path/to/dotfiles [-f] [-t filename]
#     or
#     . /path/to/dotsync.sh /path/to/dotfiles [-f] [-t filename]
#
# Arguments:
#   First argument must be the path to the dotfiles directory
#   This path will be used as the source directory for dotfiles
#
# Options:
#   -f    Force mode: Skip confirmation prompts
#   -t    Target mode: Only process specified filename
#
# Dependencies:
#   - Bash shell
#   - Standard Unix utilities (ln, rm, mv, etc.)
#
################################################################################

# Get the absolute path of the directory containing dotsync.sh
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source common functions
source "$SCRIPT_DIR/lib/_common.sh"

# Initialize variables
SOURCE_DIR=""
TARGET=""

# Function to read command line arguments
read_command_args() {
    # Reset OPTIND in case the script is sourced multiple times
    OPTIND=1

    # Check if we have the required dotfiles directory argument
    if [ $# -eq 0 ]; then
        local error="Error: Path to dotfiles directory is required"
        failure "$error"
        ERRORS+=("$error")
        exit 1
    fi

    # Set the source directory from the first argument
    SOURCE_DIR="$( cd "${1}" && pwd )"
    shift  # Remove the source directory from arguments

    while getopts 'ft:v' flag; do
        case "${flag}" in
            t) TARGET="${OPTARG}" ;;
            *) local error="Error: Unexpected option ${flag}"
               failure "$error"
               ERRORS+=("$error")
               exit 1 ;;
        esac
    done

    # Shift off the processed options
    shift $((OPTIND-1))
}

initialize_sync_state() {
    shopt -s dotglob
   
    SELECTED_FILES=()
    SKIPPED_FILES=()
    OVERWRITTEN_FILES=()
    REJECTED_FILES=()
    BROKEN_FILES=()
    IGNORED_FILES=($(awk -F= '{print $1}' $SOURCE_DIR/.dotignore))
    MAX_SCAN_LEVEL=2
}

find_dotfiles() {
    if [ -z $TARGET ]; then
        local title="Scanning dot files"
        local title_length=${#title}
        printf "\n$title"
        separator $title_length
    else
        info "targeting dot file: "$TARGET""
    fi

    scan_dotfile_tree "$SOURCE_DIR"
}

scan_dotfile_tree() {
    if is_valid_dotfile "$1"; then
        process_dotfile "$1"
        return
    fi

    local level=${2:-0}

    # look for dotfiles in subfolders
    if [ -d "$1" ] && [ "$level" -lt $MAX_SCAN_LEVEL ]; then
        if ! is_in_ignore_list $(basename "$1"); then
            scan_directory "$1" $((level+1))
        fi
    fi
}

scan_directory() {
    for file in $1/*;do
      scan_dotfile_tree "$file" $2
    done
}

is_valid_dotfile() {
    [[ "$SOURCE_DIR" == "$1" ]] && return 1

    local filename=$(basename "$1")
    local parent_dir=$(dirname "$1")
    local parent_name=$(basename "$parent_dir")

    # false if the file is a directory and is in the source directory
    [[ -d "$filename" ]] && [[ "$parent_dir" == "$SOURCE_DIR" ]] && return 1

    # false if the file is not itself a dotfile and its parent is not a dotfolder
    # (non-dotfiles under a dotfolder might be illegible)
    [[ "$filename" != .* ]] && [[ "$parent_name" != .* ]] && return 1

    # false if target is defined the file is not the target file
    [[ ! -z $TARGET ]] && [[ "$filename" != $TARGET ]] && return 1
    
    # false if the file is in the ignored list
    if is_in_ignore_list "$filename";then
        ind; printf "${SKIPPED}${GRAY}Ignoring "$1"${white}\n"
        return 1
    fi

    # false if the file is in conflict with another selected file
    if has_naming_conflict "$1" SELECTED_FILES; then
        return 1
    fi
    
    # false if the file is in conflict with a skipped file    
    if has_naming_conflict "$1" SKIPPED_FILES; then
        return 1
    fi
    
    if [[ "$parent_name" == .* ]];then
        # false if the parent dir is already a symlink to our dotfiles
        if is_linked_to_dotfiles $HOME/"$parent_name" "$SOURCE_DIR";then
            SKIPPED_FILES+=($1)
            ind; skipped "${GRAY}Skipping $1" "(already symlinked)"
            return 1
        fi
        # false if the file is already a symlink to our dotfiles
        if is_linked_to_dotfiles $HOME/"$parent_name/$filename" "$SOURCE_DIR";then
            SKIPPED_FILES+=($1)
            ind; skipped "${GRAY}Skipping $1" "(already symlinked)"
            return 1
        fi
    else
        # false if the file is already a symlink to our dotfiles
        if is_linked_to_dotfiles $HOME/"$filename" "$SOURCE_DIR";then
            SKIPPED_FILES+=($1)
            ind; skipped "${GRAY}Skipping $1" "(already symlinked)"
            return 1
        fi
    fi

    return 0
}

has_naming_conflict() {
    local filename=$(basename "$1")
    local arrayname=$2[@]
    
    files=("${!arrayname}")
    
    for element in "${files[@]}"; do
        if [[ $(basename "$element") == "$filename" ]]; then
            ind; failure "Rejecting $1" "(in conflict with $element)"   
            REJECTED_FILES+=($1)
            return 0
        fi
    done
    
    return 1
}

is_linked_to_dotfiles() {
    if [[ -L "$1" ]] && [[ "$(readlink $1)" == "$2"* ]];then
        return 0;
    fi
    return 1;
}

is_in_ignore_list() {
    for element in "${IGNORED_FILES[@]}";do
        if [[ "$1" == "$element" ]];then
            return 0;
        fi
    done;
    return 1;
}

process_dotfile() {
    SELECTED_FILES+=("$1")

    local filename=$(basename "$1")
    local parent_name=$(basename "$(dirname "$1")")
    local homefile=$HOME/$filename

    if [[ "$parent_name" == .* ]];then
        homefile=$HOME/$parent_name/$filename
    fi

    # check if file exist in home
    if [ -e "$homefile" ];then
        OVERWRITTEN_FILES+=("$1")
        ind; printf "${SUCCESS_SYMBOL}${WHITE} Selecting $1 ${GRAY}(exist in home)${WHITE}\n"
        return
    fi

    ind; printf "${SUCCESS_SYMBOL}${WHITE} Selecting $1 ${GRAY}(new dotfile)${WHITE}\n"
}

clean_broken_links() {
 
    find_broken_links

    if [ "${#BROKEN_FILES[@]}" -eq 0 ];then
        success "No broken symbolic links detected."
        return
    else
        confirm_broken_link_cleanup
    fi
}

find_broken_links() {
    for file in "$HOME"/*; do
        if [ ! -e "$file" ]; then
            if is_linked_to_dotfiles "$file" "$SOURCE_DIR"; then
                BROKEN_FILES+=("$file")
                #ind; echo "- $file"
           fi
        fi
    done
}

confirm_broken_link_cleanup() {
    info "These broken symbolic links are still pointing to $SOURCE_DIR:"

    for file in "${BROKEN_FILES[@]}"; do
        ind; warning "$file"
    done
    printf "\n"
    confirm "Do you want to remove them?"
    if [[ $confirm =~ ^[Yy]$ ]];then
        remove_broken_links
    fi
}

remove_broken_links() {
    for file in "${BROKEN_FILES[@]}"; do
        if rm -f "$file" >/dev/null 2>&1; then
            success "Removed broken symlink" "$file"
        else
            failure "Failed to remove broken symlink" "$file"
        fi
    done
}

create_dotfile_links() {
    find_dotfiles
    
    if [ "${#SELECTED_FILES[@]}" -eq 0 ];then
        printf "\n"
        success "No new symbolic links required."
    else
        confirm_link_creation
    fi
}

confirm_link_creation() {
    info "${green}+${white} ${#SELECTED_FILES[@]} symbolic links to be added in home."

    if [ "${#REJECTED_FILES[@]}" -gt 0 ];then
        warning "${#REJECTED_FILES[@]} dot files in conflict."
    fi

    confirm "Do you want to proceed?"
    if [[ $confirm =~ ^[Yy]$ ]];then
        create_home_symlinks
    fi
}

create_home_symlinks() {
    info "Creating symbolic links in home:"
    for file in "${SELECTED_FILES[@]}";do
        create_dotfile_symlink "${file}"
    done
}

create_dotfile_symlink() {
    local source="$1"
    local source_dir=$(basename "$(dirname "${source}")")
    local filename=$(basename "${source}")
    local target="$HOME/${filename}"

    # Check if source exists
    if [[ ! -e "${source}" ]]; then
        local error="Source file does not exist: ${source}"
        ind; failure "$error"
        ERRORS+=("$error")
        return 1
    fi
    
    if [[ "${source_dir}" == .* ]]; then
        target="$HOME/${source_dir}"
        mkdir -p "${target}"
    fi

    ind

    # Create symlink and suppress its output
    if ! ln -sfn "${source}" "${target}" >/dev/null 2>&1; then
        local error="Failed to create symlink for ${filename}"
        ind; failure "$error"
        ERRORS+=("$error")
        return 1
    fi

    # Add our own success message
    success "Symlink" "${source} -> ${target}"
}

clean_sync_state() {
    # Unset all defined functions
    unset -f read_command_args
    unset -f initialize_sync_state
    unset -f find_dotfiles
    unset -f scan_dotfile_tree
    unset -f scan_directory
    unset -f is_valid_dotfile
    unset -f has_naming_conflict
    unset -f is_linked_to_dotfiles
    unset -f is_in_ignore_list
    unset -f process_dotfile
    unset -f clean_broken_links
    unset -f find_broken_links
    unset -f confirm_broken_link_cleanup
    unset -f remove_broken_links
    unset -f create_dotfile_links
    unset -f confirm_link_creation
    unset -f create_home_symlinks
    unset -f create_dotfile_symlink
    unset -f clean_sync_state
    unset -f sync_dotfiles

    # Unset all defined variables

    unset SELECTED_FILES
    unset SKIPPED_FILES
    unset OVERWRITTEN_FILES
    unset REJECTED_FILES
    unset BROKEN_FILES
    unset IGNORED_FILES
    unset MAX_SCAN_LEVEL
    unset SKIP_CONFIRMATION
    unset TARGET
    unset SOURCE_DIR
}

sync_dotfiles() {

    read_command_args "$@"

    initialize_sync_state

    clean_broken_links

    create_dotfile_links

    clean_sync_state
}


