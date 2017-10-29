#!/bin/bash
# Save previous dir (unknown before boot).
PREVDIR="$PWD"
# Go to the also random home dir.
cd ~
# Clone UberTC 5.3.
git clone https://bitbucket.org/UBERTC/arm-eabi-5.3.git
# Define CROSS_COMPILE variable properly as it might be used again later.
CROSS_COMPILE='~/arm-eabi-5.3/bin/arm-eabi-'
# Go back to the previously saved working dir.
cd "$PREVDIR"
# Now build.
export LD_LIBRARY_PATH="/usr/local/lib"
sudo ldconfig
make ARCH='arm' CROSS_COMPILE='~/arm-eabi-5.3/bin/arm-eabi-' -j8 all
# bash build_cwm_zip.sh
