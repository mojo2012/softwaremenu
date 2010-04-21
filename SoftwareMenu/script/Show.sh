#!/bin/bash
cd /System/Library/CoreServices/Finder.app/Contents/Plugins\ \(disabled\)
#cd ~/Documents/Backups/
echo "frontrow" | sudo -S mount -uw /
sudo mv $1.bak /System/Library/CoreServices/Finder.app/Contents/Plugins/$1.frappliance
