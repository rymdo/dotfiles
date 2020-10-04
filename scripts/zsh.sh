install_zsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    echo "Change default shell for OSX. Requires password...."
    sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh
}
