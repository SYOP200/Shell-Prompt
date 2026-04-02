set -g SP_ROOT (set -q XDG_CONFIG_HOME; and printf '%s/shell-prompt' $XDG_CONFIG_HOME; or printf '%s/.config/shell-prompt' $HOME)

function fish_prompt
    set -l last_status $status
    "$SP_ROOT/prompt.sh" --print "$last_status"
end
