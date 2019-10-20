#!/usr/bin/env sh

# Useful helpers.
info () {
  printf "\033[1;34m==>\033[0m $1\n"
}

success () {
  printf "\033[32m[✔]\033[0m $1\n"
}

hasCommand() {
  if command -v $1 > /dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

if hasCommand dnf; then
  error "You already have dnf installed."
else
  info "Install dnf as package manager:"
  sudo yum install -y dnf
  success "dnf already exists in the system."
fi

echo "Version of dnf:"
dnf --version
