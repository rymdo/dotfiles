install_rcrc() {
  echo "Setting up rcrc"
  RCRC=$(pwd)/rcrc rcup -v -f -d $(pwd)/rcm
}
