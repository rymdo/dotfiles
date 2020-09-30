#!/usr/bin/env bash
set -e

if ! [ -x "$(which brew)" ]; then
  /usr/bin/ruby -e \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

source ./scripts/brew.sh
source ./scripts/zsh.sh
source ./scripts/vscode.sh

install_brew

RCRC=$(pwd)/rcrc rcup -v -f -d $(pwd)/rcm

install_vscode_extensions
install_zsh
