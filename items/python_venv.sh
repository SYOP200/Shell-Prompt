#!/bin/sh

[ -n "$VIRTUAL_ENV" ] || exit 0

printf 'venv:%s' "${VIRTUAL_ENV##*/}"
