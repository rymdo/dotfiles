install_pipx_packages() {
  echo "Installing pipx packages"
  cat assets/pipx | xargs -L1 pipx install
}
