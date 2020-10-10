source <(kubectl completion zsh)

export _k3s_multipass_node_name=k3s

# k3s [up, down]
function k3s() {
  local arg=$1
  if [ "$arg" = "" ]; then 
    echo "k3s [up, down]"
    return
  fi
  if [ "$arg" = "up" ]; then 
    _k3s_up
    return
  fi
  if [ "$arg" = "down" ]; then 
    _k3s_down
    return
  fi
  echo "invalid argument '$arg'"
  echo "k3s [up, down]"
}

function _k3s_up() {
  local exists=$(_k3s_exists)
  echo $exists
  if [ "$exists" -eq 0 ]; then
    echo "'${_k3s_multipass_node_name}' already up!"
    return
  fi

  # based on guide from https://medium.com/@jyeee/kubernetes-on-your-macos-laptop-with-multipass-k3s-and-rancher-2-4-6e9cbf013f58
  echo "Creating '${_k3s_multipass_node_name}'"
  multipass launch --name ${_k3s_multipass_node_name} --cpus 4 --mem 4g --disk 20g
  multipass exec ${_k3s_multipass_node_name} -- bash -c "curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -"

  echo "Setting up KUBECONFIG"
  local K3S_IP=$(multipass info ${_k3s_multipass_node_name} | grep IPv4 | awk '{print $2}')
  mkdir -p ~/.k3s
  multipass exec ${_k3s_multipass_node_name} sudo cat /etc/rancher/k3s/k3s.yaml > ~/.k3s/k3s.yaml
  sed -i '' "s/127.0.0.1/${K3S_IP}/" ~/.k3s/k3s.yaml
  export KUBECONFIG=~/.k3s/k3s.yaml

  kubectl get nodes
  echo "Done"
}

function _k3s_down() {
  echo "Destroying '${_k3s_multipass_node_name}'"
  
  multipass delete ${_k3s_multipass_node_name}
  multipass purge
  export KUBECONFIG=

  echo "Done"
}

function _k3s_exists() {
  multipass info ${_k3s_multipass_node_name} &> /dev/null
  echo $?
}
