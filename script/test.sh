#!/usr/bin/env bash

initTestVariables() {

    local sourcedir="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    source "$sourcedir"/commons.sh
    initGlobalVariables "$commons.sh"
  
    FILE_1=.test1
    FILE_2=.test2
    DIR_3=tests
    FILE_3=.test3
   
}

testScenario_1() {
    
    out "" "Starting test scenario 1" ""
    
    clearBackupDir
    
    createAllFiles
    
    source $SOURCE_DIR/make.sh "-f"
    
    removeAllFiles
}

createAllFiles() {

    indent "echo "Creating test files:""

    createFile "$FILE_1"
    createFile "$FILE_2"

    [ -d "$SOURCE_DIR/$DIR_3" ] || mkdir "$SOURCE_DIR/$DIR_3"
    
    createFileInHome "$FILE_3"
    createFileInSource "$DIR_3"/"$FILE_3"
}

createFile() {

    createFileInHome "$1"
    
    createFileInSource "$1"
}

createFileInHome() {
    
    local homefile=~/"$1" 
    
    indent echo "- creating "$homefile""
    removeFileInHome "$homefile"
    
    echo "zzz" > "$homefile"
}

createFileInSource() {

    local sourceFile="$SOURCE_DIR"/"$1"
    
    indent echo "- creating "$sourceFile""

    removeFileInSource "$sourceFile"
    
    echo "!!!" > "$sourceFile"
}

removeAllFiles() {
    
    indent "echo "Removing test files.""

    removeFile "$FILE_1"
    removeFile "$FILE_2"

    [ -d "$DIR_3" ] && rm -rfd "$SOURCE_DIR"/"$DIR_3"
    
    removeFile "$FILE_3"
}

removeFile() {

    removeFileInHome "$1"
    
    removeFileInSource "$1"
}

removeFileInHome() {
    [ -e ~/"$1" ] && rm ~/"$1"
}

removeFileInSource() {
    [ -e "$SOURCE_DIR"/"$1" ] && rm -v "$SOURCE_DIR"/"$1"
}

clearBackupDir() {
    [ -d "$BACKUP_DIR" ] && rm -rfd "$BACKUP_DIR"
}

initTestVariables

testScenario_1
