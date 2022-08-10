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

  # Have external mount for /home
  MOUNT="/home"

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

  # Mount volume
  if ! mount | grep -q $MOUNT; then
    mkdir -p $MOUNT
    echo "${DISK}1 $MOUNT ext4 defaults 0 2" >> /etc/fstab
    mount $MOUNT
  fi

fi
