#!/bin/sh
#
# unpack, modify and re-pack the Redmi AX6 firmware
# 2020.07.20  darell tan, 29.07.2021 Andrii Marchuk
# 

set -e
IMG=$1

>&2 echo "verify data..."
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
    # activate ssh and run dropbear
    sh ./modules/ssh.sh $FSDIR
    sh ./modules/dropbear.sh $FSDIR

    # change password for root
    sh ./modules/root.sh $FSDIR

    # add xqflash tool into firmware for easy upgrades
    sh ./modules/xqflash.sh $FSDIR

    # add overlay
    sh ./modules/miwifi_overlay.sh $FSDIR

    # Add default reposs
    sh ./modules/default_reposs.sh $FSDIR

    # add ru and en languages
    sh ./modules/languages.sh $FSDIR

    # mark web footer so that users can confirm the right version has been flashed
    sh ./modules/footer_version.sh $FSDIR


#####################################################################################################################
############################################ Add your changes here below ############################################
#####################################################################################################################







#####################################################################################################################

>&2 echo "repacking squashfs..."
    rm -f "$IMG.new"
    mksquashfs "$FSDIR" "$IMG.new" -comp xz -b 256K -no-xattrs