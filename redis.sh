#!/usr/bin/env sh

# Useful helpers.
info () {
  printf "\033[1;34m==>\033[0m $1\n"
}

error () {
  printf "\033[31m[✗]\033[0m $1\n"
}

success () {
  printf "\033[32m[✔]\033[0m $1\n"
}

info "Add REMI repisitory:"
sudo dnf install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm

info "Install latest Redis from the REMI repository:"
sudo dnf --enablerepo=remi install -y redis

info "Enable the service to start on system boot:"
sudo systemctl enable redis

info "Start to redis service:"
sudo systemctl start redis

info "Edit the file /etc/redis.conf if you want to configure redis."
success "Redis has already installed."
