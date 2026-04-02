#!/bin/sh

SP_ROOT=${SP_ROOT:-${XDG_CONFIG_HOME:-"$HOME/.config"}/shell-prompt}
SP_CONFIG=${SP_CONFIG:-"$SP_ROOT/prompt.conf"}
SP_ITEMS_DIR=${SP_ITEMS_DIR:-"$SP_ROOT/items"}

sp_load_config() {
  set -a
  PROMPT_ITEMS=${PROMPT_ITEMS:-"userhost cwd"}
  PROMPT_ITEM_SEPARATOR=${PROMPT_ITEM_SEPARATOR:-" | "}
  PROMPT_MULTILINE=${PROMPT_MULTILINE:-1}
  PROMPT_SYMBOL_SUCCESS=${PROMPT_SYMBOL_SUCCESS:-">"}
  PROMPT_SYMBOL_ERROR=${PROMPT_SYMBOL_ERROR:-"x"}
  PROMPT_PREFIX=${PROMPT_PREFIX:-""}

  if [ -r "$SP_CONFIG" ]; then
    # shellcheck disable=SC1090
    . "$SP_CONFIG"
  fi
  set +a
}

sp_run_item() {
  item=$1
  last_status=$2
  item_path=$SP_ITEMS_DIR/$item.sh

  [ -x "$item_path" ] || return 0

  SP_LAST_STATUS=$last_status \
  SP_ROOT=$SP_ROOT \
  SP_CONFIG=$SP_CONFIG \
  SP_ITEMS_DIR=$SP_ITEMS_DIR \
  "$item_path"
}

sp_render_items() {
  last_status=$1
  rendered=""

  for item in $PROMPT_ITEMS; do
    value=$(sp_run_item "$item" "$last_status")
    [ -n "$value" ] || continue

    if [ -n "$rendered" ]; then
      rendered=$rendered$PROMPT_ITEM_SEPARATOR$value
    else
      rendered=$value
    fi
  done

  printf '%s' "$rendered"
}

sp_render_prompt() {
  last_status=${1:-0}
  items=$(sp_render_items "$last_status")
  symbol=$PROMPT_SYMBOL_SUCCESS

  if [ "$last_status" -ne 0 ] 2>/dev/null; then
    symbol=$PROMPT_SYMBOL_ERROR
  fi

  if [ -n "$PROMPT_PREFIX" ]; then
    items=$PROMPT_PREFIX$items
  fi

  if [ -n "$items" ] && [ "$PROMPT_MULTILINE" = "1" ]; then
    printf '%s\n%s ' "$items" "$symbol"
    return
  fi

  if [ -n "$items" ]; then
    printf '%s %s ' "$items" "$symbol"
    return
  fi

  printf '%s ' "$symbol"
}

sp_print_usage() {
  cat <<'EOF'
Usage:
  prompt.sh --print [last_status]
  prompt.sh --list-items

Configuration:
  ~/.config/shell-prompt/prompt.conf
EOF
}

sp_list_items() {
  for path in "$SP_ITEMS_DIR"/*.sh; do
    [ -e "$path" ] || continue
    basename "$path" .sh
  done | sort
}

sp_main() {
  sp_load_config

  case ${1:-} in
    --print)
      sp_render_prompt "${2:-0}"
      ;;
    --list-items)
      sp_list_items
      ;;
    *)
      sp_print_usage
      ;;
  esac
}

sp_main "$@"
