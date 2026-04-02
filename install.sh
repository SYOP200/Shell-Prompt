#!/bin/sh

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TARGET_ROOT=${SP_ROOT:-${XDG_CONFIG_HOME:-"$HOME/.config"}/shell-prompt}

usage() {
  cat <<'EOF'
Usage:
  ./install.sh [bash|zsh|fish]

This copies the prompt runtime into ~/.config/shell-prompt and prints the line
you should add to your shell rc file.
EOF
}

shell_name=${1:-}
if [ -n "$shell_name" ]; then
  case $shell_name in
    bash|zsh|fish) ;;
    *)
      usage
      exit 1
      ;;
  esac
fi

mkdir -p "$TARGET_ROOT"
mkdir -p "$TARGET_ROOT/items"

cp "$SCRIPT_DIR/prompt.sh" "$TARGET_ROOT/prompt.sh"
cp "$SCRIPT_DIR/prompt.bash" "$TARGET_ROOT/prompt.bash"
cp "$SCRIPT_DIR/prompt.zsh" "$TARGET_ROOT/prompt.zsh"
cp "$SCRIPT_DIR/prompt.fish" "$TARGET_ROOT/prompt.fish"

for item in "$SCRIPT_DIR"/items/*.sh; do
  cp "$item" "$TARGET_ROOT/items/"
done

if [ ! -f "$TARGET_ROOT/prompt.conf" ]; then
  cp "$SCRIPT_DIR/prompt.conf" "$TARGET_ROOT/prompt.conf"
fi

chmod +x "$TARGET_ROOT/prompt.sh" "$TARGET_ROOT"/items/*.sh

printf 'Installed to %s\n' "$TARGET_ROOT"

case $shell_name in
  bash)
    printf '%s\n' 'Add this to ~/.bashrc:'
    printf '%s\n' 'source "${XDG_CONFIG_HOME:-$HOME/.config}/shell-prompt/prompt.bash"'
    ;;
  zsh)
    printf '%s\n' 'Add this to ~/.zshrc:'
    printf '%s\n' 'source "${XDG_CONFIG_HOME:-$HOME/.config}/shell-prompt/prompt.zsh"'
    ;;
  fish)
    printf '%s\n' 'Add this to ~/.config/fish/config.fish:'
    printf '%s\n' 'source (set -q XDG_CONFIG_HOME; and echo $XDG_CONFIG_HOME; or echo $HOME/.config)/shell-prompt/prompt.fish'
    ;;
  *)
    printf '%s\n' 'Run one of these after install:'
    printf '%s\n' './bin/shell-prompt init bash'
    printf '%s\n' './bin/shell-prompt init zsh'
    printf '%s\n' './bin/shell-prompt init fish'
    ;;
esac
