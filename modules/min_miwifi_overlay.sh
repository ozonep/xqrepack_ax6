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
STOP=00

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
stop() {
        [ -d /data/overlay ] && umount -r /overlay
        return 0
}

EOF
chmod 755 $FSDIR/etc/init.d/miwifi_overlay
# $FSDIR/etc/init.d/miwifi_overlay enable
ln -s ../init.d/miwifi_overlay $FSDIR/etc/rc.d/S00miwifi_overlay


#########################
#### BEFORE OVERLAY ####
#########################
# mtd:ubi_rootfs on / type squashfs (ro,noatime)
# proc on /proc type proc (rw,nosuid,nodev,noexec,noatime)
# sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,noatime)
# cgroup on /sys/fs/cgroup type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset,cpu,cpuacct,blkio,memory,devices,freezer,net_cls,pids)
# tmpfs on /tmp type tmpfs (rw,nosuid,nodev,noatime)
# ubi1_0 on /data type ubifs (rw,relatime)
# ubi1_0 on /userdisk type ubifs (rw,relatime)
# mtd:ubi_rootfs on /userdisk/data type squashfs (ro,noatime)
# ubi1_0 on /etc type ubifs (rw,relatime)
# ubi1_0 on /ini type ubifs (rw,relatime)
# tmpfs on /dev type tmpfs (rw,nosuid,relatime,size=512k,mode=755)
# devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,mode=600,ptmxmode=000)
# debugfs on /sys/kernel/debug type debugfs (rw,noatime)
# mtd:ubi_rootfs on /userdisk/appdata/chroot_file/lib type squashfs (ro,noatime)
# mtd:ubi_rootfs on /userdisk/appdata/chroot_file/usr/lib type squashfs (ro,noatime)



#########################
# #### AFTER OVERLAY ####
#########################
# mtd:ubi_rootfs on /rom type squashfs (ro,noatime)
# proc on /proc type proc (rw,nosuid,nodev,noexec,noatime)
# sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,noatime)
# cgroup on /sys/fs/cgroup type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset,cpu,cpuacct,blkio,memory,devices,freezer,net_cls,pids)
# tmpfs on /tmp type tmpfs (rw,nosuid,nodev,noatime)
# ubi1_0 on /data type ubifs (rw,relatime)
# ubi1_0 on /userdisk type ubifs (rw,relatime)
# mtd:ubi_rootfs on /userdisk/data type squashfs (ro,noatime)
# ubi1_0 on /etc type ubifs (rw,relatime)
# ubi1_0 on /ini type ubifs (rw,relatime)
# tmpfs on /dev type tmpfs (rw,nosuid,relatime,size=512k,mode=755)
# devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,mode=600,ptmxmode=000)
# ubi1_0 on /overlay type ubifs (rw,relatime)
# overlayfs:/overlay/upper on / type overlay (rw,noatime,lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work)
# debugfs on /sys/kernel/debug type debugfs (rw,noatime)
# overlayfs:/overlay/upper on /userdisk/appdata/chroot_file/lib type overlay (rw,noatime,lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work)
# overlayfs:/overlay/upper on /userdisk/appdata/chroot_file/usr/lib type overlay (rw,noatime,lowerdir=/,upperdir=/overlay/upper,workdir=/overlay/work)