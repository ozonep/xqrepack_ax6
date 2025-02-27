#!/bin/sh
#
# modules to patch
# 29.07.2021 Andrii Marchuk
# 

FSDIR=$1

# make sure our backdoors are always enabled by default
sed -i '/ssh_en/d;' "$FSDIR/usr/share/xiaoqiang/xiaoqiang-reserved.txt"
sed -i '/ssh_en=/d; /uart_en=/d; /boot_wait=/d; /telnet_en=/d; /bootdelay=/d;' "$FSDIR/usr/share/xiaoqiang/xiaoqiang-defaults.txt"
cat <<XQDEF >> "$FSDIR/usr/share/xiaoqiang/xiaoqiang-defaults.txt"
uart_en=1
telnet_en=1
ssh_en=1
boot_wait=on
bootdelay=5
XQDEF

# https://openwrt.org/docs/guide-user/security/dropbear.public-key.auth
cat ./modules/ssh_key/* >> /etc/dropbear/authorized_keys
# cat >$FSDIR/etc/dropbear/authorized_keys << EOF
# or yuor key here
# EOF
chmod 0600 $FSDIR/etc/dropbear/authorized_keys

# # always reset our access nvram variables
grep -q -w enable_dev_access "$FSDIR/lib/preinit/31_restore_nvram" || \
cat <<NVRAM >> "$FSDIR/lib/preinit/31_restore_nvram"

enable_dev_access() {
	nvram set uart_en=1
	nvram set telnet_en=1
	nvram set ssh_en=1
	nvram set boot_wait=on
	nvram set bootdelay=5
	nvram set CountryCode=EU
	nvram commit
}

boot_hook_add preinit_main enable_dev_access
NVRAM