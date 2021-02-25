export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced  
autoload -U promptinit; promptinit

sed "
s|<AWS_EKS_CLUSTER_ARN>|$AWS_EKS_CLUSTER_ARN|g
s|<AWS_EKS_CLUSTER_LIVE>|$AWS_EKS_CLUSTER_LIVE|g
s|<AWS_EKS_CLUSTER_STAGING>|$AWS_EKS_CLUSTER_STAGING|g
s|<AWS_EKS_CLUSTER_TEST>|$AWS_EKS_CLUSTER_TEST|g
s|<AWS_EKS_CLUSTER_DEV>|$AWS_EKS_CLUSTER_DEV|g
" ~/.config/starship.template.toml > ~/.config/starship.toml

eval "$(starship init zsh)"
