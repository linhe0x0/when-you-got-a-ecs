#!/usr/bin/env sh

success () {
  printf "\033[32m[✔]\033[0m $1\n"
}

info "Install zsh:"
sudo dnf install -y zsh

info "Install oh my zsh:"
curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

success "zsh has already installed."