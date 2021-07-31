#!/bin/sh
#
# modules to patch
# 29.07.2021 Andrii Marchuk
# 

FSDIR=$1

# modify dropbear init
sed -i 's/"release"/"debug"/' "$FSDIR/etc/init.d/dropbear"