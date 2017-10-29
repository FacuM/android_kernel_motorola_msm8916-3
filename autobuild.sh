#!/bin/bash
# ===================================== #
# Automatically build the kernel.       #
# ===================================== #
# Facundo Montero (facumo.fm@gmail.com) #
# ===================================== #
# Variable definition
DEVCODENAME="$1"
ARG="$2"
# Function definition
function buildkernel {
if [ "$ARG" != '-nc' ]
then
 printf '\nCleaning the build environment...\n'
 make -j8 clean
 printf '\nDone cleaning...\n'
else
 printf '\n'-nc' argument found, not cleaning...\n'
fi
 printf "\nBegin building kernel...\n"
 make -j8 all
 printf "\nDone building kernel...\n"
 printf "\nBuilding flashable ZIP...\n"
 bash build_cwm_zip.sh $DEVCODENAME
 printf "\nDone building flashable ZIP...\n"
}
function default {
 rm -f ".config"
 printf "\n.config file not existing. Loading defaults...\n"
 make -j8 "$DEVCODENAME"_defconfig
 if [ "$?" -ne 0 ]
 then
  exit 1
 else
  buildkernel
 fi
}
function yesno {
 printf '\nWould you like to set it up right now? (type Y for 'yes', or N or everything else for 'no'): '
 read YESNO
 if [ "$YESNO" == 'Y' ]
 then
  :
 else
  exit 1
 fi
}
# Test if asking for help
if [ "$1" == '--help' ] || [ "$1" == '-h' ]
then
 printf "\nUsage: \n\n\nNormal usage: \n\nbash autobuild.sh <devicecodename>\n    i.e.: bash autobuild.sh harpia\n\nYou can also tell the script not to clean the build environment: \n\n bash autobuild.sh <devicecodename> -nc\n    i.e.: bash autobuild.sh harpia -nc\n\n"
 exit 0
fi
# Check if user wrote device name.
if [ -z "$1" ]
then
 printf '\nYou must type your device codename before beginning.\n\n  i.e.: bash autobuild.sh harpia\n'
 yesno
 printf '\nPlease type your device codename: '
 read DEVCODENAME
else
 printf "\nDevice codename: $1\n"
fi
# Check if ARCH is defined.
if [ -z "$ARCH" ]
then
 printf '\nVariable $ARCH is not defined. Define it and try again.\n\n  i.e.: ARCH='arm'\n'
 yesno
 printf '\nPlease type the architecture: '
 read ARCH
else
 printf "\nArchitecture: $ARCH\n"
fi
# Check if CROSS_COMPILE (toolchain) is defined.
if [ -z "$CROSS_COMPILE" ]
then
 printf '\n$CROSS_COMPILE is not defined. Define it and try again.\n\n  i.e.: CROSS_COMPILE='~/toolchain/bin/arm-eabi-'\n'
 yesno
 printf '\nPlease type the toolchain path: '
 read CROSS_COMPILE
else
 printf "\nToolchain path: $CROSS_COMPILE\n"
fi
# Look for .config file in root.
if [ -f ".config" ]
then
 printf "\n.config file found.\n"
 # Check if .config file matches requested device.
 DEVCODENAMEUP=$(printf "$DEVCODENAME" | tr '[:lower:]' '[:upper:]')
 cat .config | grep "$DEVCODENAMEUP" | grep '#'
 if [ "$?" -eq 1 ]
 then
  printf '\nCurrent .config file matches requested device, will keep it untouched.\n'
  buildkernel
 else
  printf "\nCurrent .config file isn't matching the requested device. Will remove it and load defaults.\n"
  default
 fi
else
 default
fi
