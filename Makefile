D_UBOOT=$(shell pwd)/u-boot
D_LINUX=$(shell pwd)/goldfish
D_UOUT=$(shell pwd)/uout
D_LOUT=$(shell pwd)/lout
D_TOOL=$(shell pwd)/../bin/arm-2013.11/bin

all: config u-boot_build linux_build

config: u-boot_config linux_config

clean: u-boot_clean linux_clean

distclean: u-boot_distclean linux_distclean

u-boot_config:
	mkdir -p uout
	make -C ${D_UBOOT} O=${D_UOUT} goldfish_config \
		ARCH=arm CROSS_COMPILE=${D_TOOL}/arm-none-eabi-

u-boot_build:
	make -C ${D_UBOOT} O=${D_UOUT} -j4 \
        ARCH=arm CROSS_COMPILE=${D_TOOL}/arm-none-eabi-

u-boot_clean:
	make -C ${D_UBOOT} O=${D_UOUT} clean \
		ARCH=arm CROSS_COMPILE=${D_TOOL}/arm-none-eabi-

u-boot_distclean:
	make -C ${D_UBOOT} O=${D_UOUT} distclean \
		ARCH=arm CROSS_COMPILE=${D_TOOL}/arm-none-eabi-
	rm -rf ${D_UOUT}

linux_config:
	mkdir -p lout
	make -C ${D_LINUX} O=${D_LOUT} goldfish_armv7_defconfig \
		ARCH=arm CROSS_COMPILE=${D_TOOL}/arm-none-linux-gnueabi-

linux_menuconfig:
	make -C ${D_LINUX} O=${D_LOUT} menuconfig \
		ARCH=arm CROSS_COMPILE=${D_TOOL}/arm-none-linux-gnueabi-

linux_build:
	make -C ${D_LINUX} O=${D_LOUT} -j4 \
		ARCH=arm CROSS_COMPILE=${D_TOOL}/arm-none-linux-gnueabi-

linux_clean:
	make -C ${D_LINUX} O=${D_LOUT} clean \
		ARCH=arm CROSS_COMPILE=${D_TOOL}/arm-none-linux-gnueabi-

linux_distclean:
	make -C ${D_LINUX} O=${D_LOUT} distclean \
		ARCH=arm CROSS_COMPILE=${D_TOOL}/arm-none-linux-gnueabi-
	rm -rf ${D_LOUT}
