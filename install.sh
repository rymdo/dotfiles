#!/usr/bin/env bash

source ./scripts/brew.sh
source ./scripts/pipx.sh
source ./scripts/rcrc.sh
source ./scripts/vscode.sh
source ./scripts/zsh.sh

install_brew
install_rcrc
install_vscode_extensions
install_pipx_packages
install_zsh

echo "done!"
