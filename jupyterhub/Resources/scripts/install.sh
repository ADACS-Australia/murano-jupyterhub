#!/bin/bash
# Script to install and set up The Littlest JupyterHub

set -xeu

# Undefined since this is all being run inside the murano-agent systemd service.
# Needs to be defined for mambaforge install script to not halt.
export HOME="/root"

apt-get install -y ansible

url="https://api.github.com/repos/ADACS-Australia/ansible-jupyterhub/releases/latest"
location=$(curl -s "$url" | grep tarball_url | awk '{ print $2 }' | sed 's/,$//' | sed 's/"//g' )
fname="ansible-jupyterhub.tar.gz"
wget "$location" -O "$fname"
tar -xvzf "$fname"

ansible-playbook -vv -c local -i localhost, -e "tljh_version=1.0.0 ansible_user=ubuntu" ADACS-Australia-ansible-jupyterhub*/playbook.yml
