#!/bin/bash
echo "frontrow" | sudo -S command
sudo rm -r /System/Library/CoreServices/Finder.app/Contents/Plugins/scripts.frappliance
sudo mv ~/scripts.frappliance /System/Library/CoreServices/Finder.app/Contents/Plugins/scripts.frappliance 
echo "installed please either Killall Finder or sudo Shutdown -r now"
