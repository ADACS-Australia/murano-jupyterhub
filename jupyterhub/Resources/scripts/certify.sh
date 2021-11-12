#!/bin/bash -xeu

CERTBOT_DOMAIN="$1"
CERTBOT_EMAIL="$2"

sudo tljh-config set https.enabled true
sudo tljh-config add-item https.letsencrypt.domains "${CERTBOT_DOMAIN}"
sudo tljh-config set https.letsencrypt.email "${CERTBOT_EMAIL}"
sudo tljh-config reload proxy
sudo tljh-config reload hub
