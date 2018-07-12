# Enbildstagning med en webbkamera

http://enradare.orbin.se/#post56

Jag har två webbkameror kopplade till en Raspberry Pi som tar enbildstagning och det fungerar bra om man använder lägre upplösning än
den maximala för vissa kameror. Visserligen kraschar kamerorna ibland, men då startas hela systemet om och därefter fungerar den
felande kameran igen. Jag tror detta är ett bra projekt för att visa nyttan med RPi, ty Raspbian har drivrutiner för de flesta tillbehör
till skillnad från t.ex. Android. Många har en massa gamla webbkameror hemma som kan komma till nytta igen. Det står här om hur man
använder en webbkamera från Raspberry Pi:  
http://www.raspberrypi.org/learning/webcam-timelapse-setup/  
Det är dock inte så enkelt som det verkar med de webbkameror jag provat eftersom man oftast får palettfel och att Raspberry Pi med
ARM-processor inte verkar ha samma kapacitet att ta emot högupplösta bilder som en laptop-PC med en Intel-processor. USB verkar också
vara långsammare på Raspberry Pi än på en PC. Problemen med webbkameror och Raspberry Pi kan också bero på strömförsörjning, men jag
har en strömförsörjd USB-hubb så det borde fungera. Först testar jag kamerorna i operativsystemet Ubuntu 14.04 LTS Linux på en
laptop-PC och därefter i Raspbian på Raspberry Pi. Även i Ubuntu måste man ladda in bibliotek som sköter bl.a. palettkonvertering och
det lär bero på att webbkamerorna är gamla. Längst ner i inlägget finns skript för att ta enbildstagning varje minut som laddas upp
till ett webbhotell, göra filmer och hämta dessa från annan dator. Namnen på webbkamerorna kommer från kommandot lsusb och är oftast
inte samma som står på förpackningen.

Ubuntu 14.04:  
STMicroelectronics Imaging Division (VLSI Vision) Aiptek PenCam 1:  
gvfs-mount -s gphoto2; sleep 10; LD_PRELOAD=/usr/lib/i386-linux-gnu/libv4l/v4l2convert.so fswebcam -d v4l2:/dev/video1 -i 0 --jpeg 95 -S 5 -r 352x292 test.jpg  
Works!  
gvfs-mount -s gphoto2; sleep 10; vgrabbj -d /dev/video1 -w 352 -H 292 -D 7 -f test.jpg  
Works!

Microdia Sweex Mini Webcam  
LD_PRELOAD=/usr/lib/i386-linux-gnu/libv4l/v4l2convert.so fswebcam -d v4l2:/dev/video1 -i 0 --jpeg 95 -S 20 -r 352x288 test.jpg  
Works!  
vgrabbj -d /dev/video1 -i cif -z 20 -D 7 -f test.jpg  
Works!  

Pixart Imaging, Inc. Digital camera, CD302N/Elta Medi@ digi-cam/HE-501A:  
gvfs-mount -s gphoto2; sleep 10; LD_PRELOAD=/usr/lib/i386-linux-gnu/libv4l/v4l2convert.so fswebcam -d v4l2:/dev/video1 -i 0 --jpeg 95 -S 2 -r 352x288 test.jpg  
Works!  
gvfs-mount -s gphoto2; sleep 10; vgrabbj -d /dev/video1 -i cif -D 7 -f test.jpg  
Works!  

Pixart Imaging, Inc. Q-TEC WEBCAM 100:  
LD_PRELOAD=/usr/lib/i386-linux-gnu/libv4l/v4l2convert.so fswebcam -d v4l2:/dev/video1 -i 0 --jpeg 95 -S 2 -r 352x288 test.jpg  
Works!  
vgrabbj -d /dev/video1 -i cif -D 7 -f test.jpg  
Works!  

Chicony Electronics Co., Ltd USB 2.0 Camera (built-in to laptop):  
fswebcam -d v4l2:/dev/video0 -i 0 --jpeg 95 -S 20 -r 1280x1024 test.jpg  
Works!  
vgrabbj -d /dev/video0 -i sxga -z 20 -D 7 -f test.jpg  
Works!  

Raspbian Wheezy:  
STMicroelectronics Imaging Division (VLSI Vision) Aiptek PenCam 1:  
LD_PRELOAD=/usr/lib/arm-linux-gnueabihf/libv4l/v4l2convert.so fswebcam -d v4l2:/dev/video0 -i 0 --jpeg 95 -S 5 -r 352x292 test.jpg  
Works!  
vgrabbj -d /dev/video0 -w 352 -H 292 -D 7 -f test.jpg  
Works!  

Microdia Sweex Mini Webcam:  
LD_PRELOAD=/usr/lib/arm-linux-gnueabihf/libv4l/v4l2convert.so fswebcam -d v4l2:/dev/video0 -i 0 --jpeg 95 -S 40 -r 352x288 test.jpg  
Works, but better for lower resolutions.  
vgrabbj -d /dev/video0 -i sif -z 20 -D 7 -f test.jpg  
Works!  

Pixart Imaging, Inc. Digital camera, CD302N/Elta Medi@ digi-cam/HE-501A:  
LD_PRELOAD=/usr/lib/arm-linux-gnueabihf/libv4l/v4l2convert.so fswebcam -d v4l2:/dev/video0 -i 0 --jpeg 95 -S 20 -r 352x288 test.jpg    
Works, but gray.  
vgrabbj -d /dev/video0 -i cif -z 20 -D 7 -f test.jpg  
Works, but gray.  

Pixart Imaging, Inc. Q-TEC WEBCAM 100:  
LD_PRELOAD=/usr/lib/arm-linux-gnueabihf/libv4l/v4l1compat.so fswebcam -d v4l1:/dev/video0 -i 0 --jpeg 95 -S 20 -F 2 -r 176x144 test.jpg    
Works, but necessary skipping leads to:  
"Error synchronising with buffer 0.  
VIDIOCSYNC: Resource temporarily unavailable".  
vgrabbj -d /dev/video0 -i qcif -z 20 -D 7 -f test.jpg  
Works!

Script camera.sh running using crontab:  
#!/bin/sh  
PREFIX=/home/pi/camera  
DATE=$(date +"%Y-%m-%d_%H%M")  
vgrabbj -d /dev/video1 -w 352 -H 292 -z 5 -D 0 -f $PREFIX/pencam1_$DATE.jpg  
vgrabbj -d /dev/video0 -i qcif -z 20 -D 0 -f $PREFIX/miniwebcam_$DATE.jpg  
curl -T "$PREFIX/{pencam1,miniwebcam}_$DATE.jpg" ftp://ftp.mysite.se/mydir/ --user myusername:mypassword  
if [ ! -s $PREFIX/pencam1_$DATE.jpg -o ! -s $PREFIX/miniwebcam_$DATE.jpg ] ; then /sbin/reboot ; fi  
# End of camera.sh

Making movies in Raspbian Wheezy on Raspberry Pi:  
find . -name 'pencam1_*' -empty | xargs rm -f  
ls pencam1_*.jpg > pencam1_stills.txt  
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=88/73:vbitrate=8000000 -vf scale=352:292 -o pencam1_timelapse.avi -mf type=jpeg:fps=24 mf://@pencam1_stills.txt  

find . -name 'miniwebcam_*' -empty | xargs rm -f  
ls miniwebcam_*.jpg > miniwebcam_stills.txt  
mencoder -nosound -ovc lavc -lavcopts vcodec=mpeg4:aspect=11/9:vbitrate=8000000 -vf scale=176:144 -o miniwebcam_timelapse.avi -mf type=jpeg:fps=24 mf://@miniwebcam_stills.txt  

Making movies in Ubuntu MATE on Raspberry Pi:  
find . -name 'pencam1_*' -empty | xargs rm -f  
rm pencam1_stills.txt; for f in pencam1_*.jpg; do echo "file $f" >> pencam1_stills.txt; done  
ffmpeg -r 24 -f concat -i pencam1_stills.txt -r 24 -vcodec libx264 -crf 20 -g 15 -vf scale=352:292 pencam1_timelapse.mp4  

find . -name 'miniwebcam_*' -empty | xargs rm -f  
rm miniwebcam_stills.txt; for f in miniwebcam_*.jpg; do echo "file $f" >> miniwebcam_stills.txt; done  
ffmpeg -r 24 -f concat -i miniwebcam_stills.txt -r 24 -vcodec libx264 -crf 20 -g 15 -vf scale=176:144 miniwebcam_timelapse.mp4  

Download, using other Linux-computer, from Raspberry Pi:  
scp pi@dojopi1.local:camera/pencam1_timelapse.avi .  
scp pi@dojopi1.local:camera/pencam1_stills.txt .  
scp pi@dojopi1.local:camera/miniwebcam_timelapse.avi .  
scp pi@dojopi1.local:camera/miniwebcam_stills.txt .  
ssh pi@aeblapi1.local 'rm -f camera/*.avi'

Om du ser något anmärkningsvärt i videon så kan du hitta ungefär rätt bild bland stillbilderna genom att t.ex. beräkna hur många procent
händelsetiden är av den totala tiden och hitta radnumret i textfilen med stillbilderna med samma procentsats.
