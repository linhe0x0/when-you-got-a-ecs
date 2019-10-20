#!/usr/bin/env sh

# Useful helpers.
text () {
  printf "    $1\n"
}

info () {
  printf "\033[1;34m==>\033[0m $1\n"
}

error () {
  printf "\033[31m[✗]\033[0m $1\n"
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

# Abort on errors.
set -e

if hasCommand git; then
  error "You already have Git installed."
  text "$(git --version)"
  exit 0
fi

info "Start to install latest git:"

sudo cat > /etc/yum.repos.d/wandisco-git.repo << EOF
[wandisco-git]
name=Wandisco GIT Repository
baseurl=http://opensource.wandisco.com/centos/\$releasever/git/\$basearch/
enabled=1
gpgcheck=1
gpgkey=http://opensource.wandisco.com/RPM-GPG-KEY-WANdisco
EOF
sudo dnf install -y git

success "Git has already installed."
text "$(git --version)"

info "Setup identity of git:"

read -p "Please enter the user name you want to display in git commit message: " username < /dev/tty
read -p "Please enter the email address you want display in git commit message: " email < /dev/tty

git config --global user.name ${username}
git config --global user.email ${email}

success "Done. Your user name: ${username}, email address: ${email} has been set."

cd -