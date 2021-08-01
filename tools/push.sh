#!/bin/sh

#
# Push to the router. Select firmware zip file and send to 192.168.31.1.
#
# 29.07.2021 Andrii Marchuk
# 

# Select firmware
set -- *.zip
while true; do
    i=0
    for pathname do
        i=$(( i + 1 ))
        printf '%d) %s\n' "$i" "$pathname" >&2
    done

    printf 'Select a zip file to push to the router, or 0 to exit: ' >&2
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
fName=$(unzip -Z1 $1)
rm -f $fName

# Extract firmware
unzip $1

# send to router
scp $fName root@192.168.31.1:/tmp

# Clean temp files
rm -f $fName

# Done
echo "--> Done. The firmvare saved at '/tmp/$fName'. Run the 'xqflash /tmp/$fName'."