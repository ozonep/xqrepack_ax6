FIRMWARES:=$(shell cd orig-firmwares; ls *.bin | sed 's/\.bin$$//')

TARGETS_MIN:=$(patsubst %,%+MIN.zip,$(FIRMWARES))
TARGETS_MI_OPT:=$(patsubst %,%+MI+OPT.zip,$(FIRMWARES))

TARGETS:=$(shell echo $(TARGETS_MIN) $(TARGETS_MI_OPT) | sed 's/ /\n/g' | sort)

all: $(TARGETS)

%+MIN.zip: orig-firmwares/%.bin repack-min.sh
	rm -f $@
	-rm -rf ubifs-root/$*.bin
	ubireader_extract_images -w orig-firmwares/$*.bin
	fakeroot -- ./repack-min.sh ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs
	./ubinize.sh ubifs-root/$*.bin/img-*_vol-kernel.ubifs ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs.new
	zip -9 $@ ra69-raw-img.bin
	rm -f ra69-raw-img.bin

%+MI+OPT.zip: orig-firmwares/%.bin repack-mi-opt.sh
	rm -f $@
	-rm -rf ubifs-root/$*.bin
	ubireader_extract_images -w orig-firmwares/$*.bin
	fakeroot -- ./repack-mi-opt.sh ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs
	./ubinize.sh ubifs-root/$*.bin/img-*_vol-kernel.ubifs ubifs-root/$*.bin/img-*_vol-ubi_rootfs.ubifs.new
	zip -9 $@ ra69-raw-img.bin
	rm -f ra69-raw-img.bin