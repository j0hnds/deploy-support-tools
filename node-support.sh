#
# Source this file to get the following functions:
#
# * prepareNodeModules
#
# Assumes that you are using NVM; who wouldn't be?

. ${HOME}/.nvm/nvm.sh

# Source the logger script functions; it is located in the
# same directory as this file.
if [ -z "$(type -t loggerSourced)" ]
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
  local nodeEnvironment=$4

  if [ -n "$nodeEnvironment" ]
  then
    envArg="-only=$nodeEnvironment"
  fi

  info "Running npm install on ${repoName}"
  cd ${sourceDir}/${repoName} && \
    nvm exec ${nodeVersion} npm install $envArg
}

# 
# Makes sure all the required bower components are loaded for 
# the specified source directory.
#
#  Arg 1: The base path to the source directory.
#  Arg 2: The name of the source directory.
#  Arg 3: The version of node to use.
#
prepareBowerComponents() {
  local sourceDir=$1
  local repoName=$2
  local nodeVersion=$3

  info "Running bower install on ${repoName}"
  cd ${sourceDir}/${repoName} && \
    nvm exec $nodeVersion bower install
}

# 
# Runs gulp prod in the current directory.
#
#  Arg 1: The base path to the source directory.
#  Arg 2: The name of the source directory.
#  Arg 3: The version of node to use.
#
runGulp() {
  local sourceDir=$1
  local repoName=$2
  local nodeVersion=$3

  info "Running gulp prod on ${repoName}"
  cd ${sourceDir}/${repoName} && \
    nvm exec $nodeVersion gulp prod
}
