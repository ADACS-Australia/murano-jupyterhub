# JupyterHub Murano package

This repo contains a Murano (OpenStack) package for the Nectar research cloud. It allows you to set up a JupyterHub server (The Littlest JupyterHub distribution) easily from the dashboard.

It uses a custom image that is created by https://github.com/ADACS-Australia/openstack-tljh.

## Build
You can build the package with the makefile
```
make build
```
This will create a `.zip` file that you can [manually upload](#manual-upload) to your Nectar project in the dashboard.

Alternatively, if you have user/application credentials loaded in your environment and have the Murano CLI installed, you can build + upload with
```
make upload
```

## Manual upload
Each release contains a `zip` file that can be uploaded to your Nectar/OpenStack account. You can upload a release directly using a URL.

On you Nectar/OpenStack account, navigate to `Applications > Manage > Packages`. Then press `+ Import Package` and choose URL as the Package Source. Use the following link address:

https://github.com/ADACS-Australia/murano-jupyterhub/releases/latest/download/jupyterhub.zip

Alternatively, go to the releases for this repo, and select your preferred release. Under assests, right click on `jupyterhub.zip` and then copy the link address.
