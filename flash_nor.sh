#!/bin/bash

D_CUR=$(pwd)
UBOOT_DIR=$D_CUR/uout
ZIMAGE_DIR=$D_CUR/lout/arch/arm/boot
AndroidSDK=$D_CUR/../bin/adt-bundle-linux-x86_64-20140702/sdk
RAMDISK_DIR=$AndroidSDK/system-images/android-15/armeabi-v7a

# Make symbolic link for images
mkdir -p images
ln -s $AndroidSDK/system-images/android-15/armeabi-v7a/ramdisk.img images/ramdisk.img
ln -s $AndroidSDK/system-images/android-15/armeabi-v7a/system.img images/system.img

# RAMDISK
mkdir -p initrd
cd initrd
gzip -dc < ../images/ramdisk.img | cpio --extract
find . > ../initrd.list
cpio -o -H newc -O ../ramdisk.img < ../initrd.list
cd ..
gzip ramdisk.img
mv ramdisk.img.gz rootfs.img
gzip -c rootfs.img > rootfs.img.gz

# Repackage each images in the u-boot image format
cp $UBOOT_DIR/u-boot.bin .
mkimage -A arm -C none -O linux -T kernel -d $ZIMAGE_DIR/zImage -a 0x00010000 -e 0x00010000 zImage.uimg
mkimage -A arm -C none -O linux -T ramdisk -d rootfs.img.gz -a 0x00800000 -e 0x00800000 rootfs.uimg
rm rootfs.img.gz

# Generate a flash image
dd if=/dev/zero of=flash.bin bs=1 count=6M
dd if=u-boot.bin of=flash.bin conv=notrunc bs=1
dd if=zImage.uimg of=flash.bin conv=notrunc bs=1 seek=2M
dd if=rootfs.uimg of=flash.bin conv=notrunc bs=1 seek=4M

# Remove unnecessary by-products
rm u-boot.bin zImage.uimg rootfs.uimg rootfs.img
