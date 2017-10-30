#!/bin/bash
# set -e
if [ -z "$1" ]
then
 printf "\nNo device picked, please type device name as an argument.\n\n  i.e.: bash build_cwm_zip.sh harpia\n"
 exit 1
else
 DEVCDN="$1"
 if [ "$DEVCDN" == 'harpia' ]
 then
  ZIPPATH='cwm_flash_zip'
 else
  ZIPPATH='cwm_flash_zip_nla'
 fi
 rm -f arch/arm/boot/dts/*.dtb
 rm -f arch/arm/boot/dt.img
 rm -f "$ZIPPATH/boot.img"
 make ARCH=arm -j10 zImage
 make ARCH=arm -j10 dtimage
 rm -rf squid_install
 mkdir -p squid_install
 cp arch/arm/boot/zImage "$ZIPPATH/tools/"
 cp arch/arm/boot/dt.img "$ZIPPATH/tools/"
 VERSION=$(cat Makefile | grep "EXTRAVERSION = -" | sed 's/EXTRAVERSION = -//')
 rm -f "arch/arm/boot/SomeFeaK$VERSION-$DEVCDN.zip"
 cd "$ZIPPATH"
 zip -r "../arch/arm/boot/SomeFeaK$VERSION-$DEVCDN.zip" ./
 cd ..
 mkdir -p ../builds/
 mv "arch/arm/boot/SomeFeaK$VERSION-$DEVCDN.zip" ../builds/
 exit 0
fi
