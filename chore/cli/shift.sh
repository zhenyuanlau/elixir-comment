#!/usr/bin/env bash

echo "$@, $#"

shift 0

echo "$@, $#"

# shift <=> shift 1
shift

echo "$@, $#"

shift $#

echo "$@, $#"
