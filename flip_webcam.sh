#!/bin/bash
###############################################################################
# @author Radu Cotescu                                                        #
# @version 1.1 Fri Jul 30 23:42:13 EEST 2009                                  #
#                                                                             #
# Details: http://radu.cotescu.com/?p=745                                     #
#                                                                             #
# This script provides installation for uvcvideo driver in Ubuntu. It should  #
# be used if the images acquired through your webcam are flipped vertically.  #
# The script comes with no warranties of any kind.                            #
#                                                                             #
# Instructions: just run the script using the options in the Usage section,   #
# providing your user password when needed.                                   #
#                                                                             #
# This script must be run with super-user privileges.                         #
# Usage: ./flip_webcam {OPTION}                                               #
#	 1		this applies patch1 file                              #
#	 2		this applies patch2 file                              #
#	-h, --help	displays this beautiful help section                  #
###############################################################################
WORKSPACE="`dirname $0`/tmp"
if [[ ("$1" -eq "1" || "$1" -eq "2") && ($# < 2) ]]; then
	mkdir $WORKSPACE
	echo "Extracting the archive..."
	tar xfvj uvcvideo.tar.bz2 -C $WORKSPACE
	echo "Applying the patch..."
	patch $WORKSPACE/uvcvideo/linux/drivers/media/video/uvc/uvc_video.c < patch$1
	echo "Starting to compile the module..."
	make -C $WORKSPACE/uvcvideo
	make -C $WORKSPACE/uvcvideo install
	make -C $WORKSPACE/uvcvideo unload
	echo "Loading the module into your kernel..."
	modprobe uvcvideo
	echo "Housekeeping..."
	rm -rf $WORKSPACE
	echo "Done!"
else
	echo "This script must be run with super-user privileges."
	echo "Usage: ./flip_webcam {OPTION}"
	echo -e "\t 1\t\tthis applies patch1 file"
	echo -e "\t 2\t\tthis applies patch2 file"
	echo -e "\t-h, --help\tdisplays this beautiful help section"
fi
exit 0

