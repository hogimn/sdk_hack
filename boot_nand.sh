#!/bin/bash

DEBUG=$1
D_CUR=$(pwd)
D_UBOOT=$D_CUR/uout
D_EMULATOR=$D_CUR/../bin/adt-bundle-linux-x86_64-20140702/sdk/tools
D_CROSSCOMPILER=$D_CUR/../bin/arm-2013.11/bin

# Boot in debug mode
if [ "$DEBUG" == "d" ]; then
    ddd --debugger $D_CROSSCOMPILER/arm-none-eabi-gdb $D_UBOOT/u-boot &
    $D_EMULATOR/emulator -verbose -show-kernel -netfast -avd hd2 -shell -system ./system.img -ramdisk ./rootfs.img -qemu -s -S -kernel $D_UBOOT/u-boot.bin
# Boot normally
else
    $D_EMULATOR/emulator -verbose -show-kernel -netfast -avd hd2 -shell -system ./system.img -ramdisk ./rootfs.img -qemu -kernel $D_UBOOT/u-boot.bin
fi
