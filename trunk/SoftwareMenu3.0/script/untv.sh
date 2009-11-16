#!/bin/bash

# untv.sh
# SoftwareMenu
#
# Created by Thomas Cool on 11/3/09.
# Copyright 2009 Thomas Cool. All rights reserved.


mount -uw /

sudo rm -rf /System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance

sudo cp -rf /Volumes/build/Debug/SoftwareMenu.frappliance  /System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance

killall Finder

open /System/Library/CoreServices/Finder.app