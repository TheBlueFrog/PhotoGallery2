#!/bin/bash

#cd /home/mike/photoGallery/photos/minecraft
#java -jar minecraft_server.jar nogui &

# sudo lsblk
# will show the available extra disks

# get our extra big disk mounted, this is where
# uploads are stored, this is safe to do multiple times (I think)
#
# this doesn't work, do it in the VM startup script
#
#sudo mount /dev/sdc /home/photo/static/users

# start the server
#
cd /home/photo/website
java -jar website.jar --delayStartup
