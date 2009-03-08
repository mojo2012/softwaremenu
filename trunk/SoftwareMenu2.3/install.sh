#!/bin/bash

cd ~/Library/Caches/SoftDownloads/$2.download/
tar -xvf $2.gz
echo "frontrow" | sudo -S mount -uw /
sudo mv  $1.frappliance /System/Library/CoreServices/Finder.app/Contents/Plugins/


cd ~/Documents/
echo $2 >done.txt
echo "install" >>done.txt
echo $1 >>done.txt
echo /SoftDownloads/$2/>>done.txt