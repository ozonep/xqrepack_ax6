#!/bin/sh
#
# modules to patch
# 29.07.2021 Andrii Marchuk
# 

FSDIR=$1

# add overlay
cat >$FSDIR/etc/init.d/miwifi_overlay << EOF
#!/bin/sh /etc/rc.common
START=00
STOP=99
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
# stop() {
#         sync
#         /bin/umount /data/overlay
# }
EOF
chmod 755 $FSDIR/etc/init.d/miwifi_overlay
# $FSDIR/etc/init.d/miwifi_overlay enable
ln -s ../init.d/miwifi_overlay $FSDIR/etc/rc.d/S00miwifi_overlay