#!/bin/sh

[ "${SP_LAST_STATUS:-0}" -eq 0 ] 2>/dev/null && exit 0
printf 'exit:%s' "$SP_LAST_STATUS"
