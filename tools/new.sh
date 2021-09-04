#!/bin/sh

# The purpose of this script is to refresh framework...

# copy this sctipt one directory up of the main project
# ..
# ..some_folder
# ....new.sh
# ....ax6_xqrepack

rm -rf *xqrepack*
git clone https://github.com/ozonep/xqrepack_ax6.git

if [ -d ~/xqrepack_ax6 ]; then
    cp miwifi_ra69_*.bin ./xqrepack_ax6/orig-firmwares/
    cp ~/.ssh/id_rsa.pub ./ax6_xqrepack/modules/ssh_key/
    cd ./xqrepack_ax6
    exit
fi