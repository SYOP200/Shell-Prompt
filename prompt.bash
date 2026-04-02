SP_ROOT=${SP_ROOT:-${XDG_CONFIG_HOME:-"$HOME/.config"}/shell-prompt}

__sp_bash_prompt_command() {
  local last_status=$?
  if [ -n "${__sp_bash_previous_prompt_command:-}" ]; then
    eval "$__sp_bash_previous_prompt_command"
  fi
  PS1="$("$SP_ROOT/prompt.sh" --print "$last_status")"
}

if [ -n "${PROMPT_COMMAND:-}" ]; then
  __sp_bash_previous_prompt_command=$PROMPT_COMMAND
fi

PROMPT_COMMAND=__sp_bash_prompt_command
