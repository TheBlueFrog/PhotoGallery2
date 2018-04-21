#! /bin/bash

# this goes in the Google Compute Engine VM Details startup-script

iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to 8080
mount /dev/sdc /home/photo/static/users

