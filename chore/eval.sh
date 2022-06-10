#!/usr/bin/env bash

E=0

erl_set () {
  eval "E${E}=\$1"
  E=$((E + 1))
}

# --cookie)
#         S=2
#         erl_set "-setcookie"
#         erl_set "$2"
#         ;;

# bash chore/eval.sh --cookie abc

erl_set "-setcookie"
erl_set "$2"

echo $E
echo $E0
echo $E1
