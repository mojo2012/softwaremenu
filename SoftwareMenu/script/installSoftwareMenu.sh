#!/bin/bash
#
# Installer script for SoftwareMenu
# based on (copied from) Sapphire file

die() {
	echo $*
	exit 1
}

COMMAND="${1:-install}"
PREFIX="${2:-}"
DEST="/System/Library/CoreServices/Finder.app/Contents/Plugins"
DESTNAME="SoftwareMenu.frappliance"
VERSION="MYVERSIONSTRINGHERE"
ARCHIVE="SoftwareMenu_$VERSION.zip"
FINDER="Finder"
FINDERGREP="[F]inder"

if [ "$COMMAND" = "help" ]; then
	echo "Usage $0 [action] [prefix]"
	echo
	echo "Install SoftwareMenu $VERSION on the AppleTV"
	echo
	echo "Where action is:"
	echo "  install       Install SoftwareMenu"
	echo "  uninstall     Remove SoftwareMenu"
	echo "  help          Display this message"
	echo "  license       Display the License File"
	echo
	echo "prefix is a root operation system to install.  If not specified, / is assumed"
	exit 0
elif [ "$COMMAND" = "license" ]; then
	cat "LICENSE.txt"
	exit 0
fi

#Root check
if [ "$USER" != "root" ]; then
	echo "This installer must be run with superuser privileges."
	echo
	echo "If your account has access to sudo, then you may enter your password."
	echo "On the AppleTV, this password should be \"frontrow\"."
	sudo $0 $*
	exit 0
fi

ROMOUNT=0
RESTART=0

if [ ! -d "$DEST" ]; then
	DEST="/System/Library/CoreServices/Front Row.app/Contents/PlugIns"
	FINDER="Front Row"
	FINDERGREP="[F]ront Row"
fi

if [ ! -d "$DEST" ]; then
	die "Cannot identify if you are running leopard or AppleTV: Aborting."
fi

#Are we read only?
if mount | grep ' on / ' | grep -q 'read-only'; then
	ROMOUNT=1
	/sbin/mount -uw /
fi

if [ "$COMMAND" = "uninstall" ]; then
	echo "== Removing SoftwareMenu"
	/bin/rm -Rf "$DEST/$DESTNAME" || die "Unable to remove SoftwareMenu"
	
	echo "SoftwareMenu successfully uninstalled"
	echo
	RESTART=1
elif [ "$COMMAND" = "install" ]; then
	
	#Trash old version
	if [ -d "$DEST/$DESTNAME" ]; then
		echo "== Removing old SoftwareMenu"
		/bin/rm -Rf "$DEST/$DESTNAME" || die "Unable to remove $DEST/$DESTNAME"
	fi
	
	echo "== Extracting SoftwareMenu"
	/usr/bin/ditto -k -x --rsrc "$PWD/$ARCHIVE" "$DEST" || die "Unable to install SoftwareMenu"
	/usr/sbin/chown -R root:wheel "$DEST/$DESTNAME"
	/bin/chmod -R 755 "$DEST/$DESTNAME"
	
	echo "SoftwareMenu successfully installed"
	echo
	RESTART=1
fi

if [[ "$RESTART" = "1" && "$PREFIX" = "" ]]; then
	echo "$FINDER must be restarted to complete the installation"
	echo
	echo -n "Would you like to do this now? (Y/n) "
	read -e dorestart
	if [[ "$dorestart" == "" ||  "$dorestart" == "y" ||  "$dorestart" == "Y" ]]; then
		echo
		echo "== Restarting $FINDER"
		
		kill `ps awx | grep "$FINDERGREP" | awk '{print $1}'`
		if [[ "$FINDER" = "Finder" ]]; then
			open /System/Library/CoreServices/Finder.app
		fi
	fi
fi

if [ "$ROMOUNT" = "1" ]; then
	/sbin/mount -ur /
fi