#!/bin/bash

#rootDir: the root directory you want to scan for git projects
#oldRepo: repo you don’t want to be using anymore
#newRepo: repo you want to use from now on

cwd=$(pwd)
rootDir=~/src
oldRepo=git@ewegithub.sb.karmalab.net:EWE
newRepo=https://github.expedia.biz/Brand-Expedia

cd $rootDir
echo "Finding repos pointing to $oldRepo"
echo ""
find . -type d -name ".git" | while IFS= read -r d; do
  cd $rootDir/$d/..
  remoteUrl=$(git remote get-url --all origin)
  if [[ $remoteUrl == *"$oldRepo"* ]]; then
    pwd
    echo "existing repo: $remoteUrl"
    projectName=${PWD##*/}
    git ls-remote $newRepo/$projectName -q
    if [[ $? == "0" ]]; then
      git remote set-url origin $newRepo/$projectName.git
      remoteUrl=$(git remote get-url --all origin)
      echo "new repo: $remoteUrl"
    else
      echo "aborting migration"
    fi
    echo ""
  fi
done
cd $cwd
echo ""
echo "Done"

