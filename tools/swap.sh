#!/bin/sh
# Size of swapfile in megabytes

swapsize=4096

# Does the swap file already exist?
grep -q "swapfile" /etc/fstab

# If not then create it
if [ $? -ne 0 ]; then
  echo 'swapfile not found. Adding swapfile.'
  fallocate -l ${swapsize}M /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap defaults 0 0' >> /etc/fstab
else
  echo 'swapfile found. No changes made.'
fi

# Output results to terminal
df -h
cat /proc/swaps
cat /proc/meminfo | grep Swap