#!/bin/bash

set -e

echo "Goodbye"

echo "hello"

git status
git log

# Script full path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


CURRENT_VERSION=`mvn -s $DIR/settings.xml org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=project.version -q -DforceStdout`
echo "version:"+$CURRENT_VERSION