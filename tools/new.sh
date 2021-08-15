#!/bin/sh

# The purpose of this script is to refresh framework...

# copy this sctipt one directory up of the main project
# ..
# ..some_folder
# ....new.sh
# ....ax6_xqrepack

rm -rf *xqrepack*
# git clone https://github.com/uamarchuan/xqrepack_ax6.git
git clone https://gitea.marchukan.com/ax6/ax6_xqrepack.git

if [ -d ~/ax6_xqrepack ]; then
    cp miwifi_ra69_*.bin ./ax6_xqrepack/orig-firmwares/
    cp ~/.ssh/id_rsa.pub ./ax6_xqrepack/modules/ssh_key/
    cd ./ax6_xqrepack
    exit
fi

if [ -d ~/xqrepack_ax6 ]; then
    cp miwifi_ra69_*.bin ./xqrepack_ax6/orig-firmwares/
    cp ~/.ssh/id_rsa.pub ./ax6_xqrepack/modules/ssh_key/
    cd ./xqrepack_ax6
    exit
fi