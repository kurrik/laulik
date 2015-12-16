function red {
  echo -e "\033[1;31m$1\033[0m	$2"
}

function green {
  echo -e "\033[1;32m$1\033[0m	$2"
}

function yellow {
  echo -e "\033[1;33m$1\033[0m	$2"
}

ROOT=`git rev-parse --show-toplevel`

eval "$(docker-machine env default)"

cd $ROOT
