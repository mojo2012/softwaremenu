#!/bin/sh

echo "frontrow" | sudo -S command

sudo kill `ps awwx | grep [F]inder | awk '{print $1}'`

sudo open /System/Library/CoreServices/Finder.app
