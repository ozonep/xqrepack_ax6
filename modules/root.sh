#!/bin/sh
#
# modules to patch
# 29.07.2021 Andrii Marchuk
# 

FSDIR=$1

# change password for root
ROOTPW='$1$8dQJXnUp$w8GiqwwVcvH0637LibXrs/'  # "admin"

# modify root password
sed -i "s@root:[^:]*@root:${ROOTPW}@" "$FSDIR/etc/shadow"

# stop resetting root password
sed -i '/set_user(/a return 0' "$FSDIR/etc/init.d/system"