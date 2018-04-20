#!/bin/bash

#cd /home/mike/photoGallery/photos/minecraft
#java -jar minecraft_server.jar nogui &

# sudo lsblk
# will show the available extra disks

# get our extra big disk mounted, this is where
# uploads are stored, this is safe to do multiple times (I think)
#
cd /home/photo/static
sudo mount /dev/sdc users

# start the server
#
cd /home/photo/website
java -jar website.jar --delayStartup
