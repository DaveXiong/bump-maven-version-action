#!/bin/bash

set -e

# Script full path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

git config --global user.name $GIT_USERNAME

echo -e 'Release on branch:$GIT_BRANCH'

git branch
git log -1

git checkout $GIT_BRANCH

git branch
git log -1

CURRENT_VERSION=`mvn org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=project.version -q -DforceStdout`
echo -e "version:"$CURRENT_VERSION

IFS='. ' read -r -a versions <<< "$CURRENT_VERSION"
VERSION_INC=$((versions[1]%2==1?2:1))
NEW_VERSION=${versions[0]}.$[versions[1]+VERSION_INC].0

echo -e $CURRENT_VERSION"==>"$NEW_VERSION
git log --pretty="* %s (%an)" $CURRENT_VERSION.. | grep -v -e "RELEASE:" > CHANGELOG.md

echo -e $(< CHANGELOG.md)

mvn -q versions:set -DnewVersion=$NEW_VERSION -DprocessAllModules
if [ $? -eq 0 ]
then
  echo -e "mvn version $NEW_VERSION successfully"
else
  echo -e "mvn version $NEW_VERSION failed"
  exit 1
fi
git add .

git commit -m "RELEASE:$NEW_VERSION"
git push
if [ $? -eq 0 ]
then
  echo -e "RELEASE:$NEW_VERSION"
  git tag -a $NEW_VERSION -m $NEW_VERSION
  git push --tags
else
  echo -e "Commit version changed into pom.xml failed"
  exit 1
fi


echo "::set-output name=old-version::$CURRENT_VERSION"
echo "::set-output name=new-version::$NEW_VERSION"
echo "::set-output name=change-logs::$(< CHANGELOG.md)"
