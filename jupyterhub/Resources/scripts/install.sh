#!/bin/bash -xeu

# Script to install and set up The Littlest JupyterHub

apt-get remove -y unattended-upgrades
apt-get update -y
apt-get install -y ansible

url="https://api.github.com/repos/ADACS-Australia/openstack-tljh/releases/latest"
location=$(curl -s "$url" | grep tarball_url | awk '{ print $2 }' | sed 's/,$//' | sed 's/"//g' )
fname="openstack-tljh.tar.gz"
wget "$location" -O "$fname"
tar -xvzf "$fname"

ansible-playbook -c local -i localhost, ADACS-Australia-openstack-tljh*/playbook.yml
