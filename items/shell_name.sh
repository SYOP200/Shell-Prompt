#!/bin/sh

shell_name=${SHELL##*/}
[ -n "$shell_name" ] || exit 0

printf '%s' "$shell_name"
