#!/bin/bash

# this file goes in
# /usr/local/bin/photogallery2.sh


# sudo lsblk
# will show the available extra disks

# get our extra big disk mounted, this is where
# uploads are stored, this is safe to do multiple times (I think)
#
# the big disk must mount here /dev/sdc /home/photo/static/users

# run a minecraft server for the guys, in the background
#
cd /home/photo/static/users/minecraft
java -Xmx1024M -Xms1024M -jar minecraft-server.1.13.1.jar  nogui &

ps uax | grep java >> status.txt

# start the photo server
#
cd /home/photo/website
java -jar website.jar --delayStartup
