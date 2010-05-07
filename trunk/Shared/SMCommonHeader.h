/*
 *  SMCommonHeader.h
 *  
 *
 *  Created by Thomas Cool on 4/24/10.
 *  Copyright 2010 Thomas Cool. All rights reserved.
 *
 */

#ifdef DEBUG
#    define DLog(...) NSLog(__VA_ARGS__)
#else
#    define DLog(...) do {} while (0)
#endif
#define ALog(...) NSLog(__VA_ARGS__)

#ifndef smhlogit

#define smhlogit
#endif

#define smweatherDomain  (CFStringRef)@"com.apple.frontrow.appliance.SoftwareMenu.SMWeather" 
#define BRLocalizedString(key, comment)								[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:nil]
#define BRLocalizedStringFromTable(key, tbl, comment)				[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:(tbl)]
#define BRLocalizedStringFromTableInBundle(key, tbl, obj, comment)	[BRLocalizedStringManager appliance:(obj) localizedStringForKey:(key) inFile:(tbl)]


#define ISString(string,compareString) [string isEqualToString:compareString]

typedef enum _SMTeak {
    kSMTweakSSH = 0,
    kSMTweakReadWrite,
    kSMTweakRowmote,
    kSMTweakAFP,
    kSMTweakVNC,
    kSMTweakFTP,
    kSMTweakUpdates,
//    kSMTweakBlocker,
}   SMTweak;




/*
 *
 *      Defines For the Helper
 *
 */
#define SMH_SCREENSAVER     @"--install-Screensaver"
#define SMH_REMOVE_PLUGIN   @"--remove-plugin"
#define SMH_REMOVE_PLUGIN_1 @"-rp"
#define SMH_REMOVE_BACKUP   @"--remove-backup"
#define SMH_REMOVE_BACKUP_1 @"-rb"
#define SMH_HIDE            @"--make-invisible" 
#define SMH_HIDE_1          @"-h"
#define SMH_SHOW            @"--make-visible"
#define SMH_SHOW_1          @"-s"
#define SMH_BACKUP          @"--backup"
#define SMH_BACKUP_1        @"-b"
#define SMH_RESTORE         @"--restore"
#define SMH_RESTORE_1       @"-re"
#define SMH_ORDER           @"--change-order"
#define SMH_ORDER_1         @"-co"
#define SMH_TWEAK           @"--tweak"
#define SMH_INSTALL         @"--install"
#define SMH_INSTALL_1       @"-i"
#define SMH_UPDATE          @"--update"
#define SMH_SCRIPT          @"--run-script"
#define SMH_RESTART         @"--restart-finder"
#define SMH_RESTART_1       @"-rf"
#define SMH_REBOOT          @"--reboot"
#define SMH_MOUNT           @"--mount"
#define SMH_UNMOUNT         @"--unmount"
#define SMH_MAKE_RO         @"--make-read-only"
#define SMH_MAKE_RO_1       @"-mro"
#define SMH_MAKE_RW         @"--make-read-write"
#define SMH_MAKE_RW_1       @"-mr"
#define SMH_DROPBEAR        @"--install-dropbear"
#define SMH_BINARIES        @"--install-binaries"
#define SMH_ASR             @"--asrscan"
#define SMH_PYTHON          @"--install-python"
#define SMH_PERIAN          @"--install-perian"
#define SMH_EXTRACT         @"--extract"
#define SMH_EXTRACT_1       @"-x"
#define SMH_OSUPDATE        @"--launch-update"
#define SMH_TOGGLE_UPDATE   @"--toggle-update"

