ROOT=`git rev-parse --show-toplevel`

eval "$(docker-machine env default)"

cd $ROOT
