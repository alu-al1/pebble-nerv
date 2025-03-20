#!/bin/sh


IMAGE="dmorgan81/rebble"
VERSION=latest

ENV_VARS=""

while getopts ":v:e:" opt; do
  case ${opt} in
    v )
      VERSION=$OPTARG
      ;;
    e )
      ENV_VARS="$ENV_VARS --env $OPTARG"  # Store each --env argument
      ;;
    : )
      echo "Invalid option: -$OPTARG requires an argument" 1>&2
      exit 1
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done

shift $((OPTIND -1))

set -e

[ ! -z "$PROJECTS" ] || { export PROJECTS=$(pwd); }
PROJECTS=$(realpath "$PROJECTS")

set -x

docker run -u $(id -u):$(id -g) \
           --rm -it \
           -v "$PROJECTS":/work \
           -v /tmp/.X11-unix:/tmp/.X11-unix \
           \
	   -e DISPLAY=$DISPLAY \
	   $ENV_VARS \
           \
	   $IMAGE:$VERSION $@
