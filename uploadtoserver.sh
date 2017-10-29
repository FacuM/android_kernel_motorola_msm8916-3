#!/bin/bash
#### SCRIPT BY BRENDAN AT SERVERFAULT
DATETIME=`date +%D%H%M | sed 's-/--g'`
cp arch/arm/boot/zImage zImage$DATETIME
cp arch/arm/boot/squid* flashable$DATETIME.zip

# Call 1. Uses the ftp command with the -inv switches. 
#-i turns off interactive prompting. 
#-n Restrains FTP from attempting the auto-login feature. 
#-v enables verbose and progress. 

ftp -invp $HOST << EOF

# Call 2. Here the login credentials are supplied by calling the variables.

user $USER $PASS

# Call 3. Here you will change to the directory where you want to put or get
cd /public_html/files/harpia

# Call4.  Here you will tell FTP to put or get the file.
put zImage$DATETIME
put flashable$DATETIME.zip
# End FTP Connection
bye

EOF
