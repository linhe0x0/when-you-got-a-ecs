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

# Add your public key to authorized_keys file for non-password login.
info "Configure non-password with ssh public key:"
read -p "Please enter your public key: " key < /dev/tty
echo "${key}" >> ~/.ssh/authorized_keys
success "Done. You can login the server without password."

# Generate the new SSH key only when the key file does not exist.
if [ ! -f ~/.ssh/id_rsa.pub ] ; then
  info "Generating a new SSH key to use for authentication:"
  read -p "Please enter the email: " email < /dev/tty
  ssh-keygen -t rsa -b 4096 -C "${email}"
  success "Your key file is generated."
fi

info "Configure port of ssh with a random port to imporve security:"

ssh_config_file="/etc/ssh/sshd_config"
is_port_configured=$(grep -n '^Port' ${ssh_config_file})
random_ssh_port=${RANDOM}

cp ${ssh_config_file} ${ssh_config_file}.bak

if [ -n "${is_port_configured}" ];then
  error "You have configured it with your own port. this action will be skipped."
else
  info "Configure ssh port with a random port: ${random_ssh_port}"
  echo "\nPort ${random_ssh_port}" >> ${ssh_config_file}
fi

password_authentication_line=$(awk '/^PasswordAuthentication yes/ {print NR}' ${ssh_config_file})

if [ -n "${password_authentication_line}" ];then
  info "Disable password authentication, please make sure you have add your public key to ~/.ssh/authorized_keys."
  info "If you haven't added your key yet, you can revoke this option manual."
  sed -i 's/^PasswordAuthentication yes/# &/' ${ssh_config_file}
  sed -i "${password_authentication_line}a PasswordAuthentication no" ${ssh_config_file}
else
  error "You have disabled password authentication. this action will be skipped."
fi

info "The following configurations will be applied after your ssh service restarts:"

if [ -z "${is_port_configured}" ];then
  text "Port ${random_ssh_port}"
fi

if [ -z "${password_authentication_line}" ];then
  text "PasswordAuthentication no"
fi

success "Your ssh configurations has been changed but not overloaded. This means that the new configuration has not been enabled yet. You need to restart the ssh service manually to apply the changes with following commands:"
text ""
text "sudo systemctl restart sshd.service"
text "sudo systemctl status sshd.service  # Check status of sshd service"
text "journalctl -u sshd.service          # Check the logs of sshd service if it is failed."
