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

# Abort on errors.
set -e

info "Start to install nginx:"

sudo touch /etc/yum.repos.d/nginx.repo

sudo echo >> /etc/yum.repos.d/nginx.repo << EOF
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
EOF

sudo dnf install -y nginx
success "Nginx has already installed."

info "Enable nginx service to tell systemd to start nginx services automatically at boot:"
sudo systemctl enable nginx.service

info "Setup default index page and 50x page."
sudo cp -f ${PWD}/assets/index.html /usr/share/nginx/html/index.html
sudo cp -f ${PWD}/assets/50x.html /usr/share/nginx/html/50x.html

info "Start nginx server:"
sudo systemctl start nginx.service

isNginxActive=$(systemctl is-active nginx.service)

if [ "${isNginxActive}" = "active" ]; then
  success "Nginx is running."
  success "Please look over the /etc/nginx/conf.d/ directory to setup nginx."
else
  error "Failed to start nginx service. please check the following logs and restart the nginx service with \"systemctl start nginx\" again."

  # Show latest logs from nginx service.
  journalctl -u nginx.service
fi

info "Set up the user:www-data, group:www-data, and directories:/var/www that will be needed to deploy web service:"
sudo groupadd -g 3000 www-data
sudo useradd \
  -g www-data --no-user-group \
  --home-dir /var/www --no-create-home \
  --shell /usr/sbin/nologin \
  --system --uid 3000 www-data

# Create the home directory for the server and give it appropriate ownership and permissions:
sudo mkdir /var/www
sudo chown www-data:www-data /var/www
sudo chmod 555 /var/www

info "You can put your website into /var/www for it to be served by nginx:"
info "Example, let's assume you have the contents of your website in a directory called 'example.com'."
text "sudo cp -R example.com /var/www/"
text "sudo chown -R www-data:www-data /var/www/example.com"
text "sudo chmod -R 555 /var/www/example.com"

cd -