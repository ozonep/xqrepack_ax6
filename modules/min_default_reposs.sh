#!/bin/sh
#
# modules to patch
# 29.07.2021 Andrii Marchuk
# 

FSDIR=$1

# Add default reposs
cat <<EOF >> "$FSDIR/etc/opkg/distfeeds.conf"
src/gz openwrt_luci http://downloads.openwrt.org/releases/18.06-SNAPSHOT/packages/aarch64_cortex-a53/luci
src/gz openwrt_telephony http://downloads.openwrt.org/releases/18.06-SNAPSHOT/packages/aarch64_cortex-a53/telephony
EOF