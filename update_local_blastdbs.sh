#!/bin/bash

#add to crontab: @weekly /path/to/update_local_blastdbs.sh

while :
#Use top to get a snapshot of processes that are running. If a BLAST job is running, sleep for 120s, resample top.
do
    status=`ps -ef | grep blast | grep -v "grep" | wc -l`
    if [ $status -ne 0 ]
    then #BLAST IS RUNNING
        sleep 120
        continue
    else #BLAST NOT RUNNING
        cd /Databases/
        Databases=(`ls | awk -vFS='.' '{ print $1 }' | sort | uniq`)
        date >> /etc/system_scripts/BLASTdb.log
        for entry in  ${Databases[@]}
        do
            update_blastdb --decompress $entry >> /etc/system_scripts/BLASTdb.log
        done
        echo -e "\n" >> /etc/system_scripts/BLASTdb.log
        for folder in /home/*
        do
            rsync /etc/system_scripts/BLASTdb.log $folder/BLASTdb.log
        done
        break
    fi
done
