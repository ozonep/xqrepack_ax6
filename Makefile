FIRMWARES:=$(shell cd orig-firmwares; ls *.bin | sed 's/\.bin$$//')

TARGETS_MIN:=$(patsubst %,%+min.zip,$(FIRMWARES))
TARGETS_MAX:=$(patsubst %,%+max.zip,$(FIRMWARES))
TARGETS_CUSTOM:=$(patsubst %,%+custom.zip,$(FIRMWARES))

TARGETS:=$(shell echo $(TARGETS_MIN) $(TARGETS_MAX) $(TARGETS_CUSTOM) | sed 's/ /\n/g' | sort)

all: $(TARGETS)

%+min.zip: orig-firmwares/%.bin repack-min.sh
		rm -f $@
		rm -rf ubifs-root/$*.bin
		ubireader_extract_images -w orig-firmwares/$*.bin
		fakeroot -- ./repack-min.sh ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs
		./ubinize.sh ubifs-root/$*.bin/img-*_vol-kernel.ubifs ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs.new
		rm -rf ubifs-root
		zip -9 $@ ra69-raw-img.bin
		rm -f ra69-raw-img.bin

%+max.zip: orig-firmwares/%.bin repack-max.sh
		rm -f $@
		rm -rf ubifs-root/$*.bin
		ubireader_extract_images -w orig-firmwares/$*.bin
		fakeroot -- ./repack-max.sh ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs
		./ubinize.sh ubifs-root/$*.bin/img-*_vol-kernel.ubifs ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs.new
		rm -rf ubifs-root
		zip -9 $@ ra69-raw-img.bin
		rm -f ra69-raw-img.bin

%+custom.zip: orig-firmwares/%.bin repack-custom.sh
		rm -f $@
		rm -rf ubifs-root/$*.bin
		ubireader_extract_images -w orig-firmwares/$*.bin
		fakeroot -- ./repack-custom.sh ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs
		./ubinize.sh ubifs-root/$*.bin/img-*_vol-kernel.ubifs ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs.new
		rm -rf ubifs-root
		zip -9 $@ ra69-raw-img.bin
		rm -f ra69-raw-img.bin

clean:
		rm -rf *+min.zip
		rm -rf *+max.zip
		rm -rf *+custom.zip
		rm -rf ubifs-root
		rm -f ra69-raw-img.bin
		rm -rf rootfs-test

dependencies:
		sudo apt install -y python3 python3-pip python3-lzo mtd-utils fakeroot zip unzip
		sudo pip install ubi_reader

test:
		./test.sh rootfs-test