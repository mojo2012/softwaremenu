#!/bin/sh

# FixPerm.sh
# SoftwareMenu
#
# Created by Thomas on 10/22/08.
# Copyright 2008 __MyCompanyName__. All rights reserved.


echo "frontrow" | sudo -S mount -uw /
cd /System/Library/CoreServices/Finder.app/Contents/PlugIns
sudo chmod 755 /System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/installHelper
sudo chown -R root:wheel /System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance
sudo chmod +s /System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/installHelper
##kill `ps awwx | grep [F]inder | awk '{print $1}'`

##open /System/Library/CoreServices/Finder.app