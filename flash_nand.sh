#!/bin/bash

CUR_DIR=$(pwd)
UBOOT_DIR=$CUR_DIR/uout
ZIMAGE_DIR=$CUR_DIR/lout/arch/arm/boot
AndroidSDK=$CUR_DIR/../bin/adt-bundle-linux-x86_64-20140702/sdk
RAMDISK_DIR=$AndroidSDK/system-images/android-15/default/armeabi-v7a

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
mkimage -A arm -C none -O linux -T kernel -d $ZIMAGE_DIR/zImage -a 0x00010000 -e 0x00010000 zImage.uimg
mkimage -A arm -C none -O linux -T ramdisk -d rootfs.img.gz -a 0x00800000 -e 0x00800000 ramdisk.uimg
rm ./rootfs.img.gz

# Unyaffs system.img to system directory
rm -rf ./system/
mkdir -p ./system/
cd ./system/
../bin/unyaffs ../images/system.img
cd ..

# Move each image under system directory
mv zImage.uimg ramdisk.uimg ./system/

# Make system.img in yaffs2 format
./bin/mkyaffs2image ./system ./system.img

cd $CUR_DIR
