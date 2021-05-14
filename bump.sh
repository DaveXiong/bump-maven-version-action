set -e

echo "Goodbye"

echo "hello"

git status
git log

CURRENT_VERSION=`./mvnw org.apache.maven.plugins:maven-help-plugin:3.2.0:evaluate -Dexpression=project.version -q -DforceStdout`
echo "version:"+$CURRENT_VERSION