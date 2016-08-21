#
# Source this file to get the following functions:
#
# *

# Source the logger script functions; it is located in the
# same directory as this file.
if [ -z "$(type -t warn)" ]
then
  . $(dirname $BASH_SOURCE)/logger.sh
fi

#
# Creates a tar ball of the specified source code.
#
#  Arg 1: The base path of the source directory
#  Arg 2: The name of the source directory
#  Arg 3: The version number of the tar ball
#  Arg 4: The directory in which to create the tar ball.
#
createReleasePackage() {
  local sourceDir=$1
  local repoName=$2
  local version=$3
  local packageDir=$4

  if [ ! -d ${packageDir} ]
  then
    info "Creating ${packageDir}"
    mkdir -p ${packageDir}
  fi

  if [ -f ${packageDir}/${repoName}-${version}.tar.bz2 ]
  then
    info "Removing existing package: ${packageDir}/${repoName}-${version}.tar.bz2"
    rm -f ${packageDir}/${repoName}-${version}.tar.bz2
  fi

  info "Creating package: ${packageDir}/${repoName}-${version}.tar.bz2"
  cd ${sourceDir}/${repoName} && \
    tar jcf ${packageDir}/${repoName}-${version}.tar.bz2 *
}
