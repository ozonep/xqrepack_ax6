#!/bin/sh

# unpack, modify and re-pack the Redmi AX6 firmware
# removes checks for release channel before starting dropbear
#
# 2020.07.20  darell tan, 29.07.2021 Andrii Marchuk
# 

fName="ra69-raw-img.bin"
tFolder="rootfs"

# Select firmware
set -- *.zip
while true; do
    i=0
    for pathname do
        i=$(( i + 1 ))
        printf '%d) %s\n' "$i" "$pathname" >&2
    done

    printf 'Select a zip file to extract, or 0 to exit: ' >&2
    read -r reply

    number=$(printf '%s\n' "$reply" | tr -dc '[:digit:]')

    if [ "$number" = "0" ]; then
        echo 'Bye!' >&2
        exit
    elif [ "$number" -gt "$#" ]; then
        echo 'Invalid choice, try again' >&2
    else
        break
    fi
done
shift "$(( number - 1 ))"


# Clean previous results
rm -rf $tFolder
fName="unzip -Z1 $1"
rm -f $fName

# Extract firmware
unzip $1
ubireader_extract_images -w $fName
mkdir $tFolder
fakeroot -- unsquashfs -f -d rootfs ubifs-root/$fName/*_vol-ubi_rootfs.ubifs

# Clean temp files
rm -f $fName
rm -rf ubifs-root

# Done
echo "Done. Go to $tFolder and use 'fakeroot /bin/bash' if needed."