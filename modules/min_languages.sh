#!/bin/sh
#
# modules to patch
# 29.07.2021 Andrii Marchuk
# 

FSDIR=$1

# add ru and en languages
cp ./modules/languages/*.lmo "$FSDIR/usr/lib/lua/luci/i18n"
sed -i "1 s/zh_cn/en/" $FSDIR/etc/config/luci
# sed -i "s/zh_cn/en/" "$FSDIR/data/etc/config/luci"