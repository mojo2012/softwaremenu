
#!/bin/sh

# installs.sh
# SoftwareMenu
#
# Created by Thomas on 10/20/08.
# Copyright 2008 __MyCompanyName__. All rights reserved.


#!/bin/bash
cd "$1"
echo "oh shit"
echo $1
echo $2

echo "frontrow" | sudo -S chmod +x $2
sudo ./$2


