#
# Source this file to get the following functions:
#
# * identityParameter
# * releaseDirectory
# * copyReleasePackage
# * startCommandCapture
# * queueCommand
# * invokeQueuedCommands
# * clearQueuedCommands
# * invokeRemoteCommand

# Source the logger script functions; it is located in the
# same directory as this file.
if [ -z "$(type -t loggerSourced)" ]
then
  . $(dirname $BASH_SOURCE)/logger.sh
fi

#
# The identity parameter for the ssh/scp commands. Returns the identity
# parameter if the _REMOTE_IDENTITY environment variable is defined, otherwise
# displays an empty string.
#
identityParameter() {
  if [ -n "${_REMOTE_IDENTITY}" ]
  then
    echo "-i ${_REMOTE_IDENTITY}"
  fi
}

#
# The name of the release directory. This will be a timestamp.
#
#  Arg 1: The base path for the server releases.
#
releaseDirectory() {
  local serverReleaseDir=$1

  echo ${serverReleaseDir}/$(date +%Y%m%d%H%M%S)
}

#
# Copy the release package to the specified server release destination.
#
#  Arg 1: The base path for packages
#  Arg 2: The name of the package file to copy
#  Arg 3: The FQDN of the server to copy to
#  Arg 4: The release directory to put the code into 
#
copyReleasePackage() {
  local packageDir=$1
  local packageName=$2
  local server=$3
  local releaseDir=$4

  info "Copying ${packageName} to ${server}"
  scp $(identityParameter) ${packageDir}/${packageName} ${server}:/tmp

  # RELEASE_DIR="${SERVER_RELEASE_DIR}/$(date +%Y%m%d%H%M%S)"

  # Create the releases directory
  info "Creating the release directory ${releaseDir}"
  ssh $(identityParameter) ${server} "umask 002 && mkdir -p ${releaseDir}"

  # Now unpack the release package into the release directory
  info "Unpacking the package..."
  ssh $(identityParameter) ${server} "umask 002 && tar jxf /tmp/${packageName} -C ${releaseDir}"
}

#
# Starts a new remote command file construction. Any subsequent
# 'queueCommand' calls will be placed in the file identified by
# this call.
#
startCommandCapture() {
  info "Starting to queue commands"
  commandFile=/tmp/$(date +%Y%m%d%H%M%S)
  echo "# Queued commands" > ${commandFile}
}

#
# The commands provided as arguments to this function will be placed in the
# remote command queue.
#
#  Arg *: all arguments are assumed to be commands to be executed on the
#         remote server.
#
queueCommand() {
  if [ -z "${commandFile}" ]
  then
    echo "Please use startCommandCapture before queueing commands"
    exit 1
  fi

  echo "$*" >> ${commandFile}
}

#
# Copies the queued commands to the server and executes
# them there.
#
#  Arg 1: server on which commands should be invoked.
#
invokeQueuedCommands() {
  local server=$1

  if [ -z "${commandFile}" ]
  then
    echo "Please use startCommandCapture before queueing commands"
    exit 1
  fi

  info "Invoking the queued commands"

  # Copy the command file over there
  scp $(identityParameter) ${commandFile} ${server}:${commandFile}

  # Now, run it
  ssh $(identityParameter) ${server} "/bin/bash ${commandFile}"

  # Better yet, delete the remote queued file
  ssh $(identityParameter) ${server} "rm ${commandFile}"
}

#
# Clears the currently queued commands.
#
clearQueuedCommands() {
  if [ -z "${commandFile}" ]
  then
    # Nothing to do
    return 0
  fi

  info "Clearing queued commands"

  # Remove the queued commands
  rm -f $commandFile

  # Clear the queued commands environment
  unset commandFile
}

#
# Invokes the specified command on the specified server.
#
#  Arg 1: The FQDN of the server on which to invoke the command
#  Arg *: The command to be invoked on the server.
#
invokeRemoteCommand() {
  local server=$1
  shift 1

  info "Invoking remote command: '$*'"
  ssh $(identityParameter) ${server} "$*"
}
