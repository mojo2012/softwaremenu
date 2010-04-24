/*
 *  SoftwareMenuFramework.h
 *  SoftwareMenuFramework
 *
 *  Created by Thomas Cool on 2/2/10.
 *  Copyright 2010 Thomas Cool. All rights reserved.
 *
 */
#define BRLocalizedString(key, comment)								[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:nil]
#define BRLocalizedStringFromTable(key, tbl, comment)				[BRLocalizedStringManager appliance:self localizedStringForKey:(key) inFile:(tbl)]
#define BRLocalizedStringFromTableInBundle(key, tbl, obj, comment)	[BRLocalizedStringManager appliance:(obj) localizedStringForKey:(key) inFile:(tbl)]
#define kSMDownloaderDone           @"kSMDownloaderDone"
#define sharedDomain			(CFStringRef)@"com.apple.frontrow.appliance.SMFramework"
#define SMFDictForImage(key)           [NSDictionary dictionaryWithObjectsAndKeys:(key), @"BRMenuIconImageKey",nil]
#define SMFBRImage(name,ext)        [BRImage imageWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:(name) ofType:(ext)]]
#define SHOW_HIDDEN_KEY				@"ShowHidden"
#define ATV_PLUGIN_PATH         @"/System/Library/CoreServices/Finder.app/Contents/PlugIns/"
#define ATV_DEFAULT_IMAGES_PATH		@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/DefaultPhotos/"
#define ATVDCFSTR(key)      (CFStringRef)(key)


#define BASE_URL					@"http://web.me.com/tomcool420/SoftwareMenu/"

#define IMAGES_FOLDER				[@"~/Library/Application Support/SoftwareMenu/Images" stringByExpandingTildeInPath]
#define UPDATE_URL					@"http://web.me.com/tomcool420/SoftwareMenu/updates.plist"
#define TRUSTED_URL					@"http://web.me.com/tomcool420/Trusted2.plist"

#define UPDATES_AVAILABLE           @"Updates_Availables"

#define DEFAULT_CONTROLLER_TITLE    @"Random Controller"

typedef enum {
	// for originator kBREventOriginatorRemote
	kBREventRemoteActionMenu = 1,
	kBREventRemoteActionMenuHold,
	kBREventRemoteActionUp,
	kBREventRemoteActionDown,
	kBREventRemoteActionPlay,
	kBREventRemoteActionLeft,
	kBREventRemoteActionRight,
    
	kBREventRemoteActionPlayHold = 21,
    
	// Gestures, for originator kBREventOriginatorGesture
	kBREventRemoteActionTap = 30,
	kBREventRemoteActionSwipeLeft,
	kBREventRemoteActionSwipeRight,
	kBREventRemoteActionSwipeUp,
	kBREventRemoteActionSwipeDown,
} BREventRemoteAction;
typedef enum
{
    kSMRemoteMenu	= 1,
    kSMRemoteUp		= 3,
    kSMRemoteDown	= 4,
    kSMRemotePlay	= 5,
    kSMRemoteLeft	= 6,
    kSMRemoteRight	= 7,
}SMRemoteKeys;

#define kSMFApplianceOrderKey   @"FRAppliancePreferedOrderValue"
#define kSMFApplianceExtension  @"frappliance"
/*
 *  Extensions
 */
#import "BackRowExtensions.h"
#import "SMFProgressBarMenuItem.h"
#import "SMFPasscodeController.h"
#import "SMFGlobalValues.h"
#import "SMFMediaMenuController.h"
#import "SMFCenteredMenuController.h"
#import "SMFSimpleDirectoryChooserController.h"
#import "SMFTheme.h"
//#import "SMFMedia.h"
#import "SMFMediaPreview.h"
#import "SMFTogglesMenu.h"
#import "SMFCompat.h"
#import "SMFPreferences.h"
#import "SMFSharedFunctions.h"
//#import "SMFDefines.h"
#import "SMFFolderBrowser.h"
#import "SMFPhotoPreview.h"
#import "SMFSharedMethods.h"
#import "SMFProgressBarControl.h"
#import "SMFBaseAsset.h"
#import "SMFController.h"
#import "SMFDownloaderUpdate.h"
#import "SMFInvocationCenteredMenuController.h"

