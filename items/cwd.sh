#!/bin/sh

cwd=${PWD:-$(pwd)}
home_prefix=${HOME:-}

case $cwd in
  "$home_prefix")
    printf '~'
    ;;
  "$home_prefix"/*)
    printf '~/%s' "${cwd#"$home_prefix"/}"
    ;;
  *)
    printf '%s' "$cwd"
    ;;
esac
