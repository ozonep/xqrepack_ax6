#!/bin/sh
#
# Install all necessary dependencies for xqrepack
#
# 29.07.2021 Andrii Marchuk
#

sudo apt install -y python3-pip python3-lzo mtd-utils fakeroot zip 
sudo pip install ubi_reader