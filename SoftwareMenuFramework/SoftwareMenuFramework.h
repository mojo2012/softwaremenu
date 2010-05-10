/*
 *  SoftwareMenuFramework.h
 *  SoftwareMenuFramework
 *
 *  Created by Thomas Cool on 2/2/10.
 *  Copyright 2010 Thomas Cool. All rights reserved.
 *
 */
#import <Security/Security.h>

#include <sys/mount.h>

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
//#define TRUSTED_URL					@"http://web.me.com/tomcool420/Trusted2.plist"

#define UPDATES_AVAILABLE           @"Updates_Availables"

#define DEFAULT_CONTROLLER_TITLE    @"Random Controller"

//#define FrameworkLoadDebug
#define FrameworkAlwaysCopy
//#define FrameworkLoadSame

typedef enum
{
    kSMRemoteMenu	= 1,
    kSMRemoteUp		= 3,
    kSMRemoteDown	= 4,
    kSMRemotePlay	= 5,
    kSMRemoteLeft	= 6,
    kSMRemoteRight	= 7,
}SMRemoteKeys;

#ifdef FrameworkLoadDebug
#define FrameworkLoadPrint(...) NSLog(__VA_ARGS__)
#else
#define FrameworkLoadPrint(...)
#endif

static inline BOOL SMFneedCopy(NSString *lframework, NSString *frameworkPath)
{
    NSFileManager *man = [NSFileManager defaultManager];
    BOOL isDir = NO;
    if (![man fileExistsAtPath:lframework isDirectory:&isDir] || !isDir) {
        FrameworkLoadPrint(@"Software Menu Framework is not installed");
        return YES;
        
    }
    else {
        
//        NSDictionary *vDict=[frameworkPath infoDictionary];
        NSString *cur=[[NSDictionary dictionaryWithContentsOfFile:
                        [[NSBundle bundleWithPath:lframework] 
                         pathForResource:@"Info" ofType:@"plist"]] 
                       objectForKey:@"CFBundleVersion"];
        NSString *ins=[[NSDictionary dictionaryWithContentsOfFile:
                        [[NSBundle bundleWithPath:frameworkPath] 
                         pathForResource:@"Info" ofType:@"plist"]] 
                       objectForKey:@"CFBundleVersion"];
        
        if ([cur compare:ins]==NSOrderedAscending) {
            FrameworkLoadPrint(@"Software Menu Framework needs to be updated");
            return YES;            
        }
        else if([cur compare:ins]==NSOrderedSame){
            FrameworkLoadPrint(@"Software Menu Framework is Up to Date");
#ifdef FrameworkLoadSame
            FrameworkLoadPrint(@"Software Menu Framework is Up to Date but copying anyway");
            return YES;
#else
            return NO;
#endif
            
        }
        else {
            FrameworkLoadPrint(@"Installed is higher that what Plugin is carrying");
            return NO;
        }
        
        
        
        
    }
    return NO;
    
}
static BOOL createDirectoryTree(NSFileManager *fm, NSString *directory)
{
	BOOL isDir;
	if([fm fileExistsAtPath:directory isDirectory:&isDir] && isDir)
		return YES;
	if(!createDirectoryTree(fm, [directory stringByDeletingLastPathComponent]))
        return NO;
	return [fm createDirectoryAtPath:directory attributes:nil];
}
static inline BOOL loadSMFramework(NSString *frapPath)
{
	NSString *frameworkPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Frameworks/SoftwareMenuFramework.framework"];
	FrameworkLoadPrint(@"Path is at %@", frameworkPath);
#ifdef FrameworkAlwaysCopy
	BOOL neededCopy = YES;
#else
	BOOL neededCopy =SMFneedCopy(frameworkPath,[frapPath stringByAppendingPathComponent:@"Contents/Frameworks/SoftwareMenuFramework.framework"]);
#endif
	FrameworkLoadPrint(@"Need copy is %d", neededCopy);
	if(neededCopy)
	{
		NSFileManager *fm = [NSFileManager defaultManager];
		NSString *frameworkInFrap = [frapPath stringByAppendingPathComponent:@"Contents/Frameworks/SoftwareMenuFramework.framework"];
		FrameworkLoadPrint(@"Going to copy %@", frameworkInFrap);
		BOOL success = [fm removeFileAtPath:frameworkPath handler:nil];
		FrameworkLoadPrint(@"Delete success is %d", success);
		success = YES;
		NSString *frameworksDir = [frameworkPath stringByDeletingLastPathComponent];
		BOOL isDir;
		if([fm fileExistsAtPath:frameworksDir isDirectory:&isDir] && isDir)
		{
			//Check permissions
			NSDictionary *attributes = [fm fileAttributesAtPath:frameworksDir traverseLink:YES];
			if([[attributes objectForKey:NSFileOwnerAccountID] intValue] == 0)
			{
				//Owned by root
				AuthorizationItem authItems[2] = {
					{kAuthorizationEnvironmentUsername, strlen("frontrow"), "frontrow", 0},
					{kAuthorizationEnvironmentPassword, strlen("frontrow"), "frontrow", 0},
				};
				AuthorizationEnvironment environ = {2, authItems};
				AuthorizationItem rightSet[] = {{kAuthorizationRightExecute, 0, NULL, 0}};
				AuthorizationRights rights = {1, rightSet};
				AuthorizationRef auth;
				OSStatus result = AuthorizationCreate(&rights, &environ, kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights, &auth);
				if(result == errAuthorizationSuccess)
				{
					char *command = "chown frontrow \"$FWDIR\"";
					setenv("FWDIR", [frameworksDir fileSystemRepresentation], 1);
					char *arguments[] = {"-c", command, NULL};
					result = AuthorizationExecuteWithPrivileges(auth, "/bin/sh", kAuthorizationFlagDefaults, arguments, NULL);
					unsetenv("FWDIR");
				}
				if(result != errAuthorizationSuccess)
				{
					success = NO;
					FrameworkLoadPrint(@"Failed to correct permissions on Frameworks directory");
				}
				AuthorizationFree(auth, kAuthorizationFlagDefaults);
				int status;
				wait(&status);
			}
		}
		else
			success = createDirectoryTree(fm, frameworksDir);
		FrameworkLoadPrint(@"Creation of dir is %d", success);
		success = [fm copyPath:frameworkInFrap toPath:frameworkPath handler:nil];
		FrameworkLoadPrint(@"Copy success is %d", success);
		//Check if we were allowed to distribute the passthrough component
        FrameworkLoadPrint(@"needCopy at end: %d",SMFneedCopy(frameworkPath,[frapPath stringByAppendingPathComponent:@"Contents/Frameworks/SoftwareMenuFramework.framework"]));
		if(!success ||SMFneedCopy(frameworkPath,[frapPath stringByAppendingPathComponent:@"Contents/Frameworks/SoftwareMenuFramework.framework"]))
        {//We failed in our copy too!
            FrameworkLoadPrint(@"Failed Copying");
			return NO;

        }
	}
	FrameworkLoadPrint(@"frameworkPath: %@",frameworkPath);
	NSBundle *framework = [NSBundle bundleWithPath:frameworkPath];
	FrameworkLoadPrint(@"Bundle is %@", framework);
	if([framework isLoaded] && neededCopy)
	{
		//We should restart here
		FrameworkLoadPrint(@"Need to restart");
		[[NSApplication sharedApplication] terminate:nil];
	}
	
	FrameworkLoadPrint(@"Loading framework");
    BOOL r = [framework load];
    FrameworkLoadPrint(@"Loading result %d",r);
	return r;
}

#define kSMFApplianceOrderKey   @"FRAppliancePreferedOrderValue"
#define kSMFApplianceExtension  @"frappliance"

#import "SMFStrings.h"
#import "SMFCompatibilityMethods.h"
#import "SMFPhotoMethods.h"
#import "CoreGraphicsFunctions.h"
/*
 *  Extensions
 */
#import "BackRowExtensions.h"
#import "Extensions.h"
#import "NSArray-SMFExtensions.h"
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
#import "SMFDelegatedDownloader.h"

#import "SMFInvocationCenteredMenuController.h"
#import "SMFSpinnerMenu.h"

