#!/bin/bash

sudo apt update
sudo apt full-upgrade -y

curl -sSL https://get.docker.com | sh

sudo usermod -aG docker $USER

sudo reboot
