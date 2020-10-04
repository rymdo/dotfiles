install_brew() {
  if ! [ -x "$(which brew)" ]; then
    echo "Installing brew"
    /usr/bin/ruby -e \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi

  echo "Installing brew applications"
  brew bundle --file assets/Brewfile
}
