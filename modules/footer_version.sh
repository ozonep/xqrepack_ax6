#!/bin/sh
#
# modules to patch
# 29.07.2021 Andrii Marchuk
# 

FSDIR=$1

# mark web footer so that users can confirm the right version has been flashed
sed -i 's/romVersion%>/& patched by uamarchuan/;' "$FSDIR/usr/lib/lua/luci/view/web/inc/footer.htm"