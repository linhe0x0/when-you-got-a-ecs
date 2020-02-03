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

info "Install docker:"
curl -fsSL https://get.docker.com | sh
success "Docker has already installed."

info "Configure docker mirror to speed up the pull speed of images."
curl -fsSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://f1361db2.m.daocloud.io

info "Enable docker service to tell systemd to start docker services automatically at boot:"
sudo systemctl enable docker.service

info "Start docker service:"
sudo systemctl start docker.service

isDockerActive=$(systemctl is-active docker.service)

if [ "${isDockerActive}" = "active" ]; then
  success "Docker is running."
else
  error "Failed to start docker service. please check the following logs and restart the docker service with \"systemctl start docker\" again."

  # Show latest logs from docker service.
  journalctl -u docker.service
fi

cd -