install_zsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    _set_default_shell
}

_set_default_shell() {
    local currentShell=$(dscl /Search read /Users/$USER UserShell | cut -d ' ' -f 2)
    echo "current shell: ${currentShell}"
    if [ ! "$currentShell" = "/bin/zsh" ]; then
        echo "Changing default shell for OSX. Requires password...."
        sudo dscl . -create /Users/$USER UserShell /bin/zsh
    fi
}
