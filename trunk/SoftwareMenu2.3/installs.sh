#!/bin/sh

# installs.sh
# SoftwareMenu
#
# Created by Thomas on 10/20/08.
# Copyright 2008 __MyCompanyName__. All rights reserved.


#!/bin/bash

cd /System/Library/CoreServices/Finder.app/Contents/Plugins/
echo "frontrow" | sudo -S mount -uw /
sudorm -rf $2
cd $1
sudo mv $2 /System/Library/CoreServices/Finder.app/Contents/Plugins/
