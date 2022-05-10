#! /bin/bash

until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

sudo snap refresh
sudo snap install docker