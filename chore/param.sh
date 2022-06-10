#!/usr/bin/env bash

# bash chore/param.sh --a -b +c d

echo "$#, $@"

# for param in $@; do
#   echo $param
# done

set -- "$@"

echo "$@"

echo "E, $E"
