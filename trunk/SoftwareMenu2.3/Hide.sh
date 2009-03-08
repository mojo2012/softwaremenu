#!/bin/bash

cd /System/Library/CoreServices/Finder.app/Contents/Plugins/
echo "frontrow" | sudo -S mount -uw /
sudo mkdir /System/Library/CoreServices/Finder.app/Contents/PlugIns\ \(disabled\)
sudo mv  $1.frappliance /System/Library/CoreServices/Finder.app/Contents/PlugIns\ \(disabled\)/$1.bak
