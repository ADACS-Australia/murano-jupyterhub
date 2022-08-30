#!/bin/bash -xeu

ORIGUSER="ubuntu"

# Assume last disk is our attached storage,
# except /dev/vda which is our root disk
DISK=$(ls /dev/vd[b-z] | tail -n1)

# Check if the disk is mounted (e.g. if ephemeral)
MOUNTPOINT=$(lsblk -n $DISK -o MOUNTPOINT)

# If we have a disk, but it's not mounted, then it's probably
# our external volume for home
if [ ! -z $DISK ] && [ -z $MOUNTPOINT ]; then

  # Partition label
  if [ "$(lsblk -n -o PARTTYPE $DISK)" == "" ]; then
    parted $DISK mklabel msdos
  fi

  # Partition
  if ! lsblk -n $DISK | grep -q " part "; then
    parted -a opt $DISK mkpart primary ext4 0% 100%
  fi

  # Filesystem
  if [ "$(lsblk -n -o FSTYPE ${DISK}1)" == "" ]; then
    mkfs.ext4 ${DISK}1
  fi

  # Move home for 'ubuntu' user
  usermod --home /home.orig --move-home $ORIGUSER

  # Have external mount for /home
  MOUNT="/mnt"
  QUOTA_OPTS="errors=remount-ro,usrjquota=aquota.user,grpjquota=aquota.group,jqfmt=vfsv0"

  # Mount volume
  if ! mount | grep -q $MOUNT ; then
    mkdir -p $MOUNT
    echo "${DISK}1 $MOUNT ext4 defaults,${QUOTA_OPTS} 0 2" >> /etc/fstab
    mount $MOUNT
  fi

  # Create bind mount from /mnt/home to /home
  if ! mount | grep -q /home ; then
    mkdir -p $MOUNT/home /home
    echo "$MOUNT/home /home none defaults,bind 0 0" >> /etc/fstab
    mount /home
  fi

  # Create bind mount from /mnt/shared to /srv/data/shared
  if ! mount | grep -q /srv/data/shared ; then
    mkdir -p $MOUNT/shared /srv/data/shared
    echo "$MOUNT/shared /srv/data/shared none defaults,bind 0 0" >> /etc/fstab
    mount /srv/data/shared
    # Change permissions
    chgrp jupyterhub-admins /srv/data/shared
    chmod g+w /srv/data/shared
  fi

fi
