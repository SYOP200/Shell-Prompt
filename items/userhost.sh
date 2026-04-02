#!/bin/sh

user_name=${USER:-$(id -un 2>/dev/null)}
host_name=$(hostname -s 2>/dev/null || hostname 2>/dev/null)

[ -n "$user_name" ] || exit 0
[ -n "$host_name" ] || exit 0

printf '%s@%s' "$user_name" "$host_name"
