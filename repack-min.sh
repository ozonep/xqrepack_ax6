#!/bin/sh
#
# unpack, modify and re-pack the Redmi AX6 firmware
# removes checks for release channel before starting dropbear
#
# 2020.07.20  darell tan, 29.07.2021 Andrii Marchuk
# 

set -e

IMG=$1
ROOTPW='$1$8dQJXnUp$w8GiqwwVcvH0637LibXrs/'  # "admin"

[ -e "$IMG" ] || { echo "rootfs img not found $IMG"; exit 1; }

# verify programs exist
command -v unsquashfs &>/dev/null || { echo "install unsquashfs"; exit 1; }
mksquashfs -version >/dev/null || { echo "install mksquashfs"; exit 1; }

FSDIR=`mktemp -d /tmp/resquash-rootfs.XXXXX`
trap "rm -rf $FSDIR" EXIT

# test mknod privileges
mknod "$FSDIR/foo" c 0 0 2>/dev/null || { echo "need to be run with fakeroot"; exit 1; }
rm -f "$FSDIR/foo"

>&2 echo "unpacking squashfs..."
unsquashfs -f -d "$FSDIR" "$IMG"

>&2 echo "patching squashfs..."

# modify dropbear init
sed -i 's/"release"/"debug"/' "$FSDIR/etc/init.d/dropbear"
# sed -i 's/flg_ssh=.*/flg_ssh=1/' "$FSDIR/etc/init.d/dropbear"

# mark web footer so that users can confirm the right version has been flashed
sed -i 's/romVersion%>/& patched by uamarchuan/;' "$FSDIR/usr/lib/lua/luci/view/web/inc/footer.htm"


# make sure our backdoors are always enabled by default
sed -i '/ssh_en/d;' "$FSDIR/usr/share/xiaoqiang/xiaoqiang-reserved.txt"
sed -i '/ssh_en=/d; /uart_en=/d; /boot_wait=/d; /telnet_en=/d;' "$FSDIR/usr/share/xiaoqiang/xiaoqiang-defaults.txt"
cat <<XQDEF >> "$FSDIR/usr/share/xiaoqiang/xiaoqiang-defaults.txt"
uart_en=1
telnet_en=1
ssh_en=1
boot_wait=on
XQDEF

# # always reset our access nvram variables
grep -q -w enable_dev_access "$FSDIR/lib/preinit/31_restore_nvram" || \
 cat <<NVRAM >> "$FSDIR/lib/preinit/31_restore_nvram"
enable_dev_access() {
	nvram set uart_en=1
    nvram set telnet_en=1
	nvram set ssh_en=1
	nvram set boot_wait=on
	nvram set CountryCode=EU
	nvram commit
}

boot_hook_add preinit_main enable_dev_access
NVRAM

# modify root password
sed -i "s@root:[^:]*@root:${ROOTPW}@" "$FSDIR/etc/shadow"


# add xqflash tool into firmware for easy upgrades
cp xqflash "$FSDIR/sbin"
chmod 0755      "$FSDIR/sbin/xqflash"
chown root:root "$FSDIR/sbin/xqflash"

# add ru and en languages
cp languages/*.lmo "$FSDIR/usr/lib/lua/luci/i18n"
sed -i "s/zh_cn/en/" "$FSDIR/etc/config/luci"

# add overlay
cat >$FSDIR/etc/init.d/miwifi_overlay << EOF
#!/bin/sh /etc/rc.common
START=00
. /lib/functions/preinit.sh
start() {
        [ -e /data/overlay ] || mkdir /data/overlay
        [ -e /data/overlay/upper ] || mkdir /data/overlay/upper
        [ -e /data/overlay/work ] || mkdir /data/overlay/work

        mount --bind /data/overlay /overlay
        fopivot /overlay/upper /overlay/work /rom 1

        #Fixup miwifi misc, and DO NOT use /overlay/upper/etc instead, /etc/uci-defaults/* may be already removed
        /bin/mount -o noatime,move /rom/data /data 2>&-
        /bin/mount -o noatime,move /rom/etc /etc 2>&-
        /bin/mount -o noatime,move /rom/ini /ini 2>&-
        /bin/mount -o noatime,move /rom/userdisk /userdisk 2>&-

        return 0
}
EOF
chmod 755 $FSDIR/etc/init.d/miwifi_overlay
# $FSDIR/etc/init.d/miwifi_overlay enable
ln -s ../init.d/miwifi_overlay $FSDIR/etc/rc.d/S00miwifi_overlay


>&2 echo "repacking squashfs..."
rm -f "$IMG.new"
mksquashfs "$FSDIR" "$IMG.new" -comp xz -b 256K -no-xattrs