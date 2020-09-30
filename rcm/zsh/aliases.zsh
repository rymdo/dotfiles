# ZSH
alias reload='source ~/.zshrc'
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"

# Dev
alias g="git"
alias y="yarn"

# Git
alias gst="git status"
alias gl="git pull"
alias gp="git push"
alias gg="git pull --rebase --autostash"

# Brew
alias brewup="brew update; brew upgrade; brew cleanup; brew doctor"

# AWS
alias ava="aws-vault add"
alias ave="aws-vault exec --no-session"
alias avl="aws-vault list"
alias asp="echo \"use aws-vault! ava, ave, avl\""

# Terragrunt
alias ti="terragrunt init"
alias tp="terragrunt plan"
alias ta="terragrunt apply"
alias td="terragrunt destroy"

# tmux
alias tmh="tmux splitw -h"
alias tmv="tmux splitw -v"
