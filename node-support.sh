#
# Source this file to get the following functions:
#
# * prepareNodeModules
#
# Assumes that you are using NVM; who wouldn't be?

# Source the logger script functions; it is located in the
# same directory as this file.
if [ -z "$(type -t warn)" ]
then
  . $(dirname $BASH_SOURCE)/logger.sh
fi

# 
# Makes sure all the required NPM modules are loaded for 
# the specified source directory.
#
#  Arg 1: The base path to the source directory.
#  Arg 2: The name of the source directory.
#  Arg 3: The version of node to use.
#
prepareNodeModules() {
  local sourceDir=$1
  local repoName=$2
  local nodeVersion=$3

  info "Running npm install on ${repoName}"
  cd ${sourceDir}/${repoName} && \
    nvm exec ${nodeVersion} npm install
}
