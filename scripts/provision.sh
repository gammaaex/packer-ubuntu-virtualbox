#!/bin/sh

# SSH password
PASSWORD=ubuntu-pass
DOCKER_COMPOSE_VERSION=1.23.2
WEBHOOK_PORT=9001

echo "--------------------- Install webhook ---------------------"
# Install adnanh/webhook
# Ref: https://github.com/adnanh/webhook
echo $PASSWORD | sudo -S sudo apt-get install webhook


echo "--------------------- Install docker ---------------------"
# Install docker by official script
# That will install latest docker

# Get script
wget -O get-docker.sh https://get.docker.com

# Run script
echo $PASSWORD | sudo -S sudo sh ./get-docker.sh

# Remove script
sudo rm get-docker.sh


echo "--------------------- Install docker-compose ---------------------"
# Get docker-compose binary
echo $PASSWORD | sudo -S sudo curl -sL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
# Add execution authority to users
echo $PASSWORD | sudo -S sudo chmod +x /usr/local/bin/docker-compose


echo "--------------------- Setup startup script ---------------------"
# Write startup(when boot) script to crontab configuration
cat <<SCRIPT | sudo tee -a ./cron.conf > /dev/null
@reboot webhook -hooks ./hooks.json -verbose -port $WEBHOOK_PORT
SCRIPT

# Register crontab
crontab cron.conf

# Setup crontab log file
cat <<SCRIPT | sudo tee -a /etc/rsyslog.d/50-default.conf > /dev/null

### Added by user
cron.*    /var/log/cron.log
SCRIPT


echo "--------------------- Open port ---------------------"
# Enable logging to /var/log/ufw.log
echo $PASSWORD | sudo -S sudo ufw logging on
# Allow port 22 for SSH
# But, already allowed this port when installed openssh-server on `preseed.cfg`
# echo $PASSWORD | sudo -S sudo ufw allow 22
# Allow port 80 for http
echo $PASSWORD | sudo -S sudo ufw allow 80
# Allow port 443 for https
echo $PASSWORD | sudo -S sudo ufw allow 443
# Allow port 9001 for webhook
echo $PASSWORD | sudo -S sudo ufw allow $WEBHOOK_PORT
# Enable firewall
echo $PASSWORD | yes | sudo -S sudo ufw enable
