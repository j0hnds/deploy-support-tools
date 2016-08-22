#
# Source this file to get the following functions:
#
# * packageName
# * createReleasePackage

# Source the logger script functions; it is located in the
# same directory as this file.
if [ -z "$(type -t loggerSourced)" ]
then
  . $(dirname $BASH_SOURCE)/logger.sh
fi

#
# Constructs the name of a release package.
#
#  Arg 1: repository name
#  Arg 2: version of repository
#
packageName() {
  local repoName=$1
  local version=$2

  echo ${repoName}-${version}.tar.bz2
}

#
# Creates a tar ball of the specified source code.
#
#  Arg 1: The base path of the source directory
#  Arg 2: The name of the source directory
#  Arg 3: The directory in which to create the tar ball.
#  Arg 4: The name of the package to create
#
createReleasePackage() {
  local sourceDir=$1
  local repoName=$2
  local packageDir=$3
  local packageName=$4

  if [ ! -d ${packageDir} ]
  then
    info "Creating ${packageDir}"
    mkdir -p ${packageDir}
  fi

  if [ -f ${packageDir}/${packageName} ]
  then
    info "Removing existing package: ${packageDir}/${packageName}"
    rm -f ${packageDir}/${packageName}
  fi

  info "Creating package: ${packageDir}/${packageName}"
  cd ${sourceDir}/${repoName} && \
    tar jcf ${packageDir}/${packageName} *
}
