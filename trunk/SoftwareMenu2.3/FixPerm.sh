#!/bin/sh

# FixPerm.sh
# SoftwareMenu
#
# Created by Thomas on 10/22/08.
# Copyright 2008 __MyCompanyName__. All rights reserved.


echo "frontrow" | sudo -S mount -uw /
cd /System/Library/CoreServices/Finder.app/Contents/PlugIns
sudo chown -R root:wheel SoftwareMenu.frappliance
sudo chmod u+s SoftwareMenu.frappliance/Contents/Resources/installHelper
##kill `ps awwx | grep [F]inder | awk '{print $1}'`

##open /System/Library/CoreServices/Finder.app