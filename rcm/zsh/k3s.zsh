source <(kubectl completion zsh)
source <(helm completion zsh)

export K3S_KUBECONFIG_PATH=~/.k3s
export K3S_KUBECONFIG_FILE=k3s.yaml
export K3S_LEADER_0=k3s-leader-0
export K3S_FOLLOWER_0=k3s-follower-0
export K3S_FOLLOWER_1=k3s-follower-1

# Based on these guides:
# https://medium.com/@jyeee/kubernetes-on-your-macos-laptop-with-multipass-k3s-and-rancher-2-4-6e9cbf013f58
# https://levelup.gitconnected.com/kubernetes-cluster-with-k3s-and-multipass-7532361affa3

# k3s [up, down, config]
function k3s() {
  local arg=$1
  if [ "$arg" = "" ]; then 
    echo "k3s [up, down, config, status]"
    _k3s_status
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
  if [ "$arg" = "config" ]; then
    _k3s_config
    return
  fi
  if [ "$arg" = "status" ]; then
    _k3s_status
    return
  fi
  echo "invalid argument '$arg'"
  echo "k3s [up, down, config, status]"
}

function _k3s_up() {
  local is_up=$(_k3s_is_up)
  if [ "$is_up" = "true" ]; then
    echo "k3s already up!"
    return
  fi

  echo "Bring up k3s cluster"

  echo "Launching nodes"
  multipass launch --name ${K3S_LEADER_0} --cpus 1 --mem 1g --disk 5g
  multipass launch --name ${K3S_FOLLOWER_0} --cpus 1 --mem 1g --disk 5g
  multipass launch --name ${K3S_FOLLOWER_1} --cpus 1 --mem 1g --disk 5g

  echo "Initializing leader nodes"
  multipass exec ${K3S_LEADER_0} -- bash -c "curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -"
  local k3s_leader_ip=$(multipass info ${K3S_LEADER_0} | grep IPv4 | awk '{print $2}')
  local k3s_leader_token="$(multipass exec ${K3S_LEADER_0} -- /bin/bash -c "sudo cat /var/lib/rancher/k3s/server/node-token")"

  echo "Initializing follower nodes"
  multipass exec ${K3S_FOLLOWER_0} -- /bin/bash -c "curl -sfL https://get.k3s.io | K3S_TOKEN=${k3s_leader_token} K3S_URL=https://${k3s_leader_ip}:6443 sh -"
  multipass exec ${K3S_FOLLOWER_1} -- /bin/bash -c "curl -sfL https://get.k3s.io | K3S_TOKEN=${k3s_leader_token} K3S_URL=https://${k3s_leader_ip}:6443 sh -"

  multipass list

  echo "Setting up KUBECONFIG"
  _k3s_config

  kubectl get nodes
  echo "Done"
}

function _k3s_down() {
  echo "Bring down k3s cluster"
  multipass delete ${K3S_LEADER_0}
  multipass delete ${K3S_FOLLOWER_0}
  multipass delete ${K3S_FOLLOWER_1}
  multipass purge
  echo "Done"
}

function _k3s_config() {
  local is_up=$(_k3s_is_up)
  if [ "$is_up" = "false" ]; then
    echo "k3s is not up!"
    return
  fi
  local K3S_IP=$(multipass info ${K3S_LEADER_0} | grep IPv4 | awk '{print $2}')
  mkdir -p ${K3S_KUBECONFIG_PATH}
  multipass exec ${K3S_LEADER_0} sudo cat /etc/rancher/k3s/k3s.yaml > ${K3S_KUBECONFIG_PATH}/${K3S_KUBECONFIG_FILE}
  sed -i '' "s/127.0.0.1/${K3S_IP}/" ${K3S_KUBECONFIG_PATH}/${K3S_KUBECONFIG_FILE}
  chmod 600 ${K3S_KUBECONFIG_PATH}/${K3S_KUBECONFIG_FILE}
  export KUBECONFIG=${K3S_KUBECONFIG_PATH}/${K3S_KUBECONFIG_FILE}
  echo "KUBECONFIG=${KUBECONFIG}"
}

function _k3s_status() {
  local is_up=$(_k3s_is_up)
  if [ "$is_up" = "false" ]; then
    echo "k3s is not up!"
    return
  fi
  echo ""
  echo "multipass list: "
  multipass list
  echo ""
  echo "kubectl get nodes:"
  kubectl get nodes
}

function _k3s_is_up() {
  multipass info ${K3S_LEADER_0} &> /dev/null
  local exists=$?
  if [ "$exists" -eq 0 ]; then
    echo "true"
    return
  fi
  echo "false"
}
