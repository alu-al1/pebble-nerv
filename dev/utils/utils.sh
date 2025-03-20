#!/bin/bash

## standard preamble
## TODO check for dirname, pwd, readlink
## https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
function set_source_and_dir() # arg1: inital $0
{
    ## TODO if (!$1) die()

    SOURCE=
    DIR=
    
    SOURCE=${BASH_SOURCE[1]}
    while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
        SOURCE=$(readlink "$SOURCE")
        [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the sy>
    done
    DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
    
    export SOURCE="$SOURCE"
    export DIR="$DIR"
}

function die_with_message() # arg1: "[msg=""] [code=1] [prefix="[ERROR]"]"
{
    # TODO msg+=\n if len(msg) != 0 and msg[-1] != '\n'
    
    set_source_and_dir "$0"
    echo "[ERROR]: $DIR $SOURCE: die_with_message() is not implemented yet"
    exit 1
}

## TODO deps_error_append, deps_error_clear, has_deps_error, deps_error_next
export DEPS_ERROR=
function check_deps() # arg1: "util_name util_pkg ", ...rest "[...util_tests=type -p <util_name>]"
{
    set_source_and_dir "$0"
    echo "[ERROR]: $DIR $SOURCE: check_deps() is not implemented yet"
    exit 1
}

function check_is_set_or_die_critical() # arg1: "value_to_check" arg2: "else message" arg3 "code"
{
    if [ -z "$1" ]; then
        die_with_message "$2" "$3" "[CRITICAL]"
    fi
}