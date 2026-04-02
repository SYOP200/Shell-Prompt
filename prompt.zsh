SP_ROOT=${SP_ROOT:-${XDG_CONFIG_HOME:-"$HOME/.config"}/shell-prompt}

autoload -Uz add-zsh-hook

__sp_zsh_precmd() {
  local last_status=$?
  local rendered
  rendered="$("$SP_ROOT/prompt.sh" --print "$last_status")"
  PROMPT="${rendered//\%/%%}"
}

add-zsh-hook precmd __sp_zsh_precmd
