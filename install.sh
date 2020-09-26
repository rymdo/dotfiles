#!/usr/bin/env bash

if ! [ -x "$(which brew)" ]; then
  /usr/bin/ruby -e \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

source ./scripts/brew.sh

install_brew
