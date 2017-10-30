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
 make ARCH=arm -j10 modules
 rm -rf squid_install
 mkdir -p squid_install
 make ARCH=arm -j10 modules_install INSTALL_MOD_PATH=squid_install INSTALL_MOD_STRIP=1
 mkdir -p "$ZIPPATH/system/lib/modules/pronto"
 find squid_install/ -name '*.ko' -type f -exec cp '{}' "$ZIPPATH/system/lib/modules/" \;
 mv "$ZIPPATH/system/lib/modules/wlan.ko" "$ZIPPATH/system/lib/modules/pronto/pronto_wlan.ko"
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
