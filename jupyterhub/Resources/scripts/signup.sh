#!/bin/bash -xeu

# Script to create the first admin user

USERNAME="$1"

# install dependencies
pip3 install --no-input requests beautifulsoup4 argparse

# assign username as admin
sudo tljh-config add-item auth.NativeAuthenticator.admin_users "$USERNAME"
sudo tljh-config reload

# Don't log password
set +x
PASSWORD="$2"

# signup with password and username
python3 signup.py "$USERNAME" "$PASSWORD"

# Nuke the password from the murano log file
sed -i "s/$PASSWORD/******/g" /var/log/murano-agent.log
set -x
