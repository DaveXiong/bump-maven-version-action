#!/bin/bash

set -e

echo "Goodbye"

echo "hello"

git status
git log

# Script full path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


CURRENT_VERSION=`mvn -s $DIR/settings.xml org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=project.version -q -DforceStdout`
echo "version:"$CURRENT_VERSION

IFS='. ' read -r -a versions <<< "$CURRENT_VERSION"
VERSION_INC=$((versions[1]%2==1?2:1))
NEW_VERSION=${versions[0]}.$[versions[1]+VERSION_INC].0

git log --pretty="%s (%an)" $CURRENT_VERSION.. | grep -i -E "*" > CHANGELOG.md

echo $CHANGE_LOGS
echo -e $CURRENT_VERSION"==>"$NEW_VERSION

mvn -s $DIR/settings.xml versions:set -DnewVersion=$NEW_VERSION -DprocessAllModules
if [ $? -eq 0 ]
then
  echo -e "mvn version $NEW_VERSION successfully"
else
  echo -e "mvn version $NEW_VERSION failed"
  exit 1
fi
git add .
git commit -m "RELEASE:$NEW_VERSION"
git tag -a $NEW_VERSION -F CHANGELOG.md
git push
git push --tags

echo "::set-output name=version::$NEW_VERSION"