#!/bin/bash -xeu

# Script to install and set up The Littlest JupyterHub

while ! apt-get remove -y unattended-upgrades; do sleep 1; done
apt-get purge -y unattended-upgrades
systemctl stop unattended-upgrades || true
systemctl disable unattended-upgrades || true
apt-get update -y
apt-get install -y ansible

url="https://api.github.com/repos/ADACS-Australia/openstack-tljh/releases/latest"
location=$(curl -s "$url" | grep tarball_url | awk '{ print $2 }' | sed 's/,$//' | sed 's/"//g' )
fname="openstack-tljh.tar.gz"
wget "$location" -O "$fname"
tar -xvzf "$fname"

ansible-playbook -c local -i localhost, ADACS-Australia-openstack-tljh*/playbook.yml
