#!/bin/sh
#
# modules to patch
# 29.07.2021 Andrii Marchuk
# 

FSDIR=$1

# add xqflash tool into firmware for easy upgrades
cp ../modules/sbin/xqflash "$FSDIR/sbin"
chmod 0755      "$FSDIR/sbin/xqflash"
chown root:root "$FSDIR/sbin/xqflash"