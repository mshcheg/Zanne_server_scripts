#!/bin/sh

#add to crontab: @daily /path/to/backup.sh

todays=$(date +'%Y-%m-%d') #get the date
BACKUP_DIR="/mnt/Shared_Research_Drive/Zanne Lab/HomeDir_Backups" #define the backup directory
 
for i in /home/* #loop through the folders in the home directory
do
    mydir="$BACKUP_DIR"/${i##*/} #define the user's folder in the backup directory
    cd "$mydir"
    last=$(ls -r | head -1)
    to_delete=$(ls -r | tail -n +7) #keep the last 6 backups
    #run the backup using rsync
    ionice -c 3 nice -n +19 rsync -aq --link-dest="$mydir"/${last} $i "$mydir"/${todays} > /dev/null 2>&1
    [ -z "$to_delete" ] || rm -rf $to_delete
    #remove the old backups
    done
       
#send email to myemail@email.com when the backups finish.
echo "Home directory backups to Research drive completed successfully." | mail -s "Debian Message" myemail@email.com
