#!/bin/bash

cd /System/Library/CoreServices/Finder.app/Contents/Plugins/

echo "frontrow" | sudo -S mount -uw / 
rm -r $1.frappliance

cd ~/Documents/
echo "removed" > done.txt