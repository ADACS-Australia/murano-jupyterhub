#!/bin/bash -xeu
# Script to install and set up The Littlest JupyterHub

# Undefined since this is all being run inside the murano-agent systemd service.
# Needs to be defined for mambaforge install script to not halt.
export HOME="/root"

apt-get install -y ansible

url="https://api.github.com/repos/ADACS-Australia/openstack-tljh/releases/latest"
location=$(curl -s "$url" | grep tarball_url | awk '{ print $2 }' | sed 's/,$//' | sed 's/"//g' )
fname="openstack-tljh.tar.gz"
wget "$location" -O "$fname"
tar -xvzf "$fname"

ansible-playbook -vv -c local -i localhost, ADACS-Australia-openstack-tljh*/playbook.yml
