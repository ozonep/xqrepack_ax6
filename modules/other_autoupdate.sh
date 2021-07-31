#!/bin/sh
#
# modules to patch
# 29.07.2021 Andrii Marchuk
# 

FSDIR=$1

#prevent auto-update
> $FSDIR/usr/sbin/otapredownload