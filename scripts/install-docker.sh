#!/bin/bash
# Script to install Docker on TrueNAS Scale
sudo apt update
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker
