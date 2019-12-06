function output {
  echo -e "\033[1;95m$1\033[0m	$2"
}

set -e

ROOTPATH=/opt/laulik
export REPOPATH=/opt/laulik-repo

BUILDPATH=$REPOPATH/build
DATAPATH=$REPOPATH/data
INFOPATH=$REPOPATH/gitinfo.txt

COMMONPATH=$ROOTPATH/src/common
COMPILERPATH=$ROOTPATH/src/compiler
SERVERPATH=$ROOTPATH/src/server

# UTF-8 paths / env everywhere
export PYTHONIOENCODING=utf_8
export LC_CTYPE=en_US.UTF-8
export LANG=en_US.UTF-8

# Allow imports from `common` without path
export PYTHONPATH=$PYTHONPATH:$COMMONPATH
