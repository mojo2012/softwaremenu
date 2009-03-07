#!/bin/bash

cd /System/Library/CoreServices/Finder.app/Contents/Plugins/
mkdir /Users/frontrow/Documents/Backups
echo "frontrow" | sudo -S cp -r $1.frappliance /Users/frontrow/Documents/Backups/$1.bak
cd ~/Documents

echo "backup" > done.txt