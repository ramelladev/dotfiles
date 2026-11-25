#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

# --- Symlinks (same on both platforms) ---
mkdir -p ~/.config/vim ~/.config/tmux
ln -sf  "$SCRIPT_DIR/vim/vimrc"      ~/.config/vim/vimrc
ln -sfn "$SCRIPT_DIR/shells/bash"    ~/.config/bash
ln -sf  "$SCRIPT_DIR/shells/bashrc"  ~/.bashrc
ln -sf  "$SCRIPT_DIR/shells/bashrc"  ~/.bash_profile
ln -sf  "$SCRIPT_DIR/tmux/tmux.conf" ~/.config/tmux/tmux.conf

# --- Find Homebrew wherever it lives, install only if missing ---
find_brew() {
  local p
  for p in /opt/homebrew/bin/brew \
           /usr/local/bin/brew \
           /home/linuxbrew/.linuxbrew/bin/brew \
           "$HOME/.linuxbrew/bin/brew"; do
    if [[ -x "$p" ]]; then echo "$p"; return 0; fi
  done
  command -v brew
}

BREW="$(find_brew || true)"
if [[ -z "$BREW" ]]; then
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  BREW="$(find_brew)"
fi
eval "$("$BREW" shellenv bash)"

# --- Per-platform Brewfile ---
case "$OS" in
  Darwin) BUNDLE="$SCRIPT_DIR/homebrew/mac-bundle" ;;
  Linux)  BUNDLE="$SCRIPT_DIR/homebrew/devcontainer-bundle" ;;
  *) echo "Unsupported OS: $OS" >&2; exit 1 ;;
esac

brew bundle install --file "$BUNDLE"
