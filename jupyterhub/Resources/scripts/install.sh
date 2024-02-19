#!/bin/bash
# Script to install and set up The Littlest JupyterHub

set -xeu

# Undefined since this is all being run inside the murano-agent systemd service.
# Needs to be defined for mambaforge install script to not halt.
export HOME="/root"

apt-get install -y ansible

git clone --depth=1 https://github.com/ADACS-Australia/openstack-tljh.git
ansible-playbook -vv -c local -i localhost, -e "tljh_version=1.0.0 ansible_user=ubuntu" openstack-tljh/playbook.yml
