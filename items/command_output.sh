#!/bin/sh

[ -n "${PROMPT_CUSTOM_COMMAND:-}" ] || exit 0

value=$(sh -lc "$PROMPT_CUSTOM_COMMAND" 2>/dev/null)
[ -n "$value" ] || exit 0

printf '%s' "$value"
