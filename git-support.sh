# 
# Source this file to get the following functions:
#
# * prepareGitMirror
# * updateGitMirror
# * getRevision
# * extractBranchToSourceDirectory
# * prepareSource
#
# For most applications, you will simply need to call
# 'prepareSource'; it will do everything you need.

# Source the logger script functions; it is located in the
# same directory as this file.
if [ -z "$(type -t loggerSourced)" ]
then
  . $(dirname $BASH_SOURCE)/logger.sh
fi

#
# Prepare a git repository for mirroring. If the local mirror
# directory already exists, this function will do nothing, 
# otherwise, the repository will be cloned as a mirror.
#
#  Arg 1: Path to where the repository should exist
#  Arg 2: URL to the GitHub repository
#  Arg 3: Name of the repository to create
#
# Side effects:
#
#  1. If the base repository directory does not exist it
#     will be created.
#
prepareGitMirror() {
  local repoDir=$1
  local repository=$2
  local repoName=$3

  if [ ! -d ${repoDir} ]
  then
    mkdir -p ${repoDir}
  fi

  if [ ! -d ${repoDir}/${repoName} ]
  then
    info "Local repo ${localRepo} doesn't exist; cloning"
    git clone --mirror ${repository} ${repoDir}/${repoName}
  fi
}

#
# Update the mirrored repo to match GitHub. This will sync the
# mirror with all branches, tags, etc. Hence the term 'mirror'.
#
#  Arg 1: The path to the base of the repositories
#  Arg 2: The name of the repository
#
updateGitMirror() {
  local repoDir=$1
  local repoName=$2

  info "Updating mirror: ${repoName}"
  (cd ${repoDir}/${repoName} && \
    git remote update)
}

#
# Return the commit hash for the specified branch in the
# specified repository.
#
#  Arg 1: The path to the base of the repositories
#  Arg 2: The name of the repository
#  Arg 3: The branch/tag name for which to get the commmit-hash.
#
getRevision() {
  local repoDir=$1
  local repoName=$2
  local branch=$3

  cd ${repoDir}/${repoName} && \
    git rev-list --max-count=1 --abbrev-commit ${branch}
}

#
# Extracts the source code for a particular branch of code
# into the specified source directory.
#
#  Arg 1: The path to the base of the repositories
#  Arg 2: The path to the base of the source directories
#  Arg 3: The name of the repository from whito to extract the source
#  Arg 4: The branch/tag name to extract.
#
# Side effects:
#  1. If the source directory already exists, its contents will be
#     deleted.
#  2. If the source directory doesn't exist, it will be created.
#  3. If the base of the source directory doesn't exist, it will be created.
#  4. The file REVISION will be created in the source directory containing
#     the commit hash of the branch/tag.
#  5. The file APP_VERSION will be created in the source directory containing
#     the name of the branch/tag.
#
extractBranchToSourceDirectory() {
  local repoDir=$1
  local sourceDir=$2
  local repoName=$3
  local branch=$4

  if [ -d ${sourceDir}/${repoName} ]
  then
    rm -fr ${sourceDir}/${repoName}/*
  else
    mkdir -p ${sourceDir}/${repoName}
  fi

  (cd ${repoDir}/${repoName} && \
    git archive ${branch} | tar -x -f - -C ${sourceDir}/${repoName})

  (cd ${sourceDir}/${repoName} && \
    echo $(getRevision ${repoDir} ${repoName} ${branch}) >> REVISION && \
    echo $branch > APP_VERSION)
}

#
# Prepares a directory of source code from the specified branch
# of a GitHub repository.
#
#  Arg 1: The path to the base of the repositories
#  Arg 2: The path to the base of the source directories
#  Arg 3: The URL of the GitHub repository
#  Arg 4: The name of the repository
#  Arg 5: The desired branch of the code
# 
prepareSource() {
  local repoDir=$1
  local sourceDir=$2
  local repository=$3
  local repoName=$4
  local branch=$5

  info "Preparing project source for ${repoName}"
  prepareGitMirror ${repoDir} ${repository} ${repoName}

  updateGitMirror ${repoDir} ${repoName}

  extractBranchToSourceDirectory ${repoDir} ${sourceDir} ${repoName} ${branch}
}
