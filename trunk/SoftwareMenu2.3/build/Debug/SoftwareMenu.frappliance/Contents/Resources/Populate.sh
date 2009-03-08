#!/bin/bash
cd /Users/frontrow/Documents/Scripts
FILES=$(find . -name "*.sh")

count=110
tokey=0
echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">
<plist version=\"1.0\">
<array>" > Scripts2.plist
for FILE in *.sh
do 
count=`expr $count + 1`

#echo "$FILE"
echo "
	<dict>
		<key>identifier</key>
		<string>scripts-script-$FILE</string>
		<key>name</key>
		<string>$FILE</string>
		<key>preferred-order</key>
		<real>$count</real>
	</dict>" >> Scripts2.plist	

done
echo "</array>
</plist>" >> Scripts2.plist

sed 's_>./_>_' <Scripts2.plist >Scripts.plist
sed 's_.sh<_<_' <Scripts.plist >Scripts2.plist
sed 's_-./_-_' <Scripts2.plist >Scripts.plist
rm Scripts2.plist
