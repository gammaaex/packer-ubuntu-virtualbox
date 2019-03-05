#!/bin/sh

echo "--------------------- Setup environment variable ---------------------"
# SSH password
PASSWORD=ubuntu-pass

# Docker Compose version
DOCKER_COMPOSE_VERSION=1.23.2

# Webhook port and token
WEBHOOK_PORT=9001
WEBHOOK_TOKEN=asdfghjkl

# Promote to root
echo $PASSWORD | sudo -S su

# Copy .env
cp ./docker/.env.default ./docker/.env

# Add execution authority
chmod +x ./docker/deploy.sh

echo "--------------------- Install webhook ---------------------"
# Install adnanh/webhook
# Ref: https://github.com/adnanh/webhook
sudo apt-get install webhook


echo "--------------------- Install docker ---------------------"
# Install docker by official script
# That will install latest docker

# Get script
wget -O get-docker.sh https://get.docker.com

# Run script
sudo sh ./get-docker.sh

# Remove script
rm get-docker.sh


echo "--------------------- Install docker-compose ---------------------"
# Get docker-compose binary
sudo curl -sL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Add execution authority to users
sudo chmod +x /usr/local/bin/docker-compose


echo "--------------------- Setup startup script ---------------------"
# Write startup(when boot) script to crontab configuration
cat <<SCRIPT | sudo tee -a ./cron.conf > /dev/null
@reboot webhook -hooks /home/ubuntu-user/hooks.json -verbose -port $WEBHOOK_PORT
@reboot curl localhost:$WEBHOOK_PORT/hooks/deploy?token=$WEBHOOK_TOKEN

SCRIPT

# Register crontab
crontab cron.conf

# Setup crontab log file
cat <<SCRIPT | sudo tee -a /etc/rsyslog.d/50-default.conf > /dev/null

### Added by user
cron.*    /var/log/cron.log
SCRIPT


echo "--------------------- docker and docker-compose command can execute without sudo ---------------------"
# Add docker group current user
sudo gpasswd -a $USER docker
# Restart docker daemon
sudo systemctl restart docker


echo "--------------------- Open port ---------------------"
# Enable logging to /var/log/ufw.log
sudo ufw logging on

# Allow port 22 for SSH
# But, already allowed this port when installed openssh-server on `preseed.cfg`
sudo ufw allow 22

# Allow port 80 for http
sudo ufw allow 80

# Allow port 443 for https
sudo ufw allow 443

# Allow port 9001 for webhook
sudo ufw allow $WEBHOOK_PORT

# Allow port 8888 for phpMyAdmin
sudo ufw allow 8888

# Enable firewall
yes | sudo ufw enable
