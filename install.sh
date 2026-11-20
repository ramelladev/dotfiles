#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
ln -sf "$SCRIPT_DIR/.gitconfig" ~/.gitconfig
mkdir -p ~/.config/
ln -sf "$SCRIPT_DIR/shells/bash" ~/.config/
ln -sf "$SCRIPT_DIR/shells/bashrc" ~/.bashrc
NONINTERACTIVE=1 /bin/bash -c \
   "$(curl -fsSL \
      https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
cd $SCRIPT_DIR
brew bundle install
