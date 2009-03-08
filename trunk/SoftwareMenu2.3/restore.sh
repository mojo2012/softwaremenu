#!/bin/bash

echo "frontrow" | sudo -S mount -uw /
sudo cp -r /Users/frontrow/Documents/Backups/$1.bak /System/Library/CoreServices/Finder.app/Contents/Plugins/$1.frappliance
cd ~/Documents/
echo "restore" > done.txt
