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
    # Select all sh files
    for FILE in ./modules/*.sh
    do
        echo "  --> $FILE"
        sh $FILE $FSDIR
    done

>&2 echo "repacking squashfs..."
    rm -f "$IMG.new"
    mksquashfs "$FSDIR" "$IMG.new" -comp xz -b 256K -no-xattrs