#!/bin/sh
#
# modules to patch
# 10.08.2021 Andrii Marchuk
# 

FSDIR=$1

# create /opt dir
mkdir "$FSDIR/opt"
chmod 755 "$FSDIR/opt"