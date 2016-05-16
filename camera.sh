#!/bin/sh
PREFIX=/home/pi/camera
DATE=$(date +"%Y-%m-%d_%H%M")
vgrabbj -d /dev/video1 -w 352 -H 292 -z 5 -D 0 -f $PREFIX/pencam1_$DATE.jpg
vgrabbj -d /dev/video0 -i qcif -z 20 -D 0 -f $PREFIX/miniwebcam_$DATE.jpg
curl -T "$PREFIX/{pencam1,miniwebcam}_$DATE.jpg" ftp://ftp.mywebsite.se/camera/ --user myusername:mypassword
if [ ! -s $PREFIX/pencam1_$DATE.jpg -o ! -s $PREFIX/miniwebcam_$DATE.jpg ] ; then /sbin/reboot ; fi
