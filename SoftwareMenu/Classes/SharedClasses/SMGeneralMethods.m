//
//  SMGeneralMethods.m
//  SoftwareMenu
//
//  Created by Thomas on 3/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "SMDefines.h"
#import "SMGeneralMethods.h"
#include <sys/param.h>
#include <sys/mount.h>
#include <stdio.h>
#import <objc/objc-class.h>
#import <Security/Security.h>
#import "../../External/AGProcess.h"
#define myDomain			(CFStringRef)@"com.apple.frontrow.appliance.SoftwareMenu"

/*@interface ATVSettingsFacade : BRSettingsFacade
- (void)setScreenSaverSelectedPath:(id)fp8;
- (id)screenSaverSelectedPath;
- (id)screenSaverPaths;
- (id)screenSaverCollectionForScreenSaver:(id)fp8;
- (id)versionOS;

@end*/
@implementation SMGeneralMethods
static SMGeneralMethods *sharedInstance = nil;
+ (BOOL)isWithinRangeForDict:(NSDictionary *)dict
{
    BOOL greater =YES;
    BOOL lesser  = NO;
    if([[dict objectForKey:@"osMin"] isEqualToString:@"nil"])
        greater = YES;
    else
        greater = [SMGeneralMethods OSGreaterThan:[dict objectForKey:@"osMin"]];
    
    if([[dict objectForKey:@"osMax"] isEqualToString:@"nil"])
        lesser = YES;
    else
        lesser = [SMGeneralMethods OSLessThan:[dict objectForKey:@"osMax"]];
    if(lesser && greater)
        return YES;
    return NO;
}
+ (BOOL)isWithinRangeWithMin:(NSString *)osMin withMax:(NSString *)osMax
{
    NSLog(@"min %@, max %@, current %@",osMin,osMax,[SMPreferences appleTVVersion]);
    BOOL greater    = [SMGeneralMethods OSGreaterThan:osMin];
    if(greater)
    {
        NSLog(@"greater than min");
    }
    BOOL lower      = [SMGeneralMethods OSLessThan:osMax];
    if(lower)
    {
        NSLog(@"lower than max");
    }
    if (lower && greater)
        return YES;
    return NO;
}
+ (BOOL)OSGreaterThan:(NSString *)value
{
	NSComparisonResult theResult = [value compare:[SMPreferences appleTVVersion] options:NSNumericSearch];
	if ( theResult == NSOrderedDescending ){
		return NO;
	} else if ( theResult == NSOrderedAscending ){
		return YES;
	} else if ( theResult == NSOrderedSame ) {

		return YES;
	}
	return NO;
}
+ (BOOL)OSLessThan:(NSString *)value
{
    NSComparisonResult theResult = [value compare:[SMPreferences appleTVVersion] options:NSNumericSearch];
	if ( theResult == NSOrderedDescending ){
                NSLog(@"descending");
		return YES;
	} else if ( theResult == NSOrderedAscending ){
                NSLog(@"ascending");
		return NO;
	} else if ( theResult == NSOrderedSame ) {
                NSLog(@"same");
		return YES;
	}
	return NO;
}
+ (BOOL)threePointZeroOrGreater
{
	
	NSComparisonResult theResult = [@"3.0" compare:[SMPreferences appleTVVersion] options:NSNumericSearch];
	if ( theResult == NSOrderedDescending ){
		return NO;
	} else if ( theResult == NSOrderedAscending ){
		return YES;
	} else if ( theResult == NSOrderedSame ) {
		return YES;
	}
	return NO;
}
- (BOOL)SMHelperCheckPerm
{
	NSString *helperPath = [[NSBundle bundleForClass:[SMInfo class]] pathForResource:@"installHelper" ofType:@""];
	NSFileManager *man = [NSFileManager defaultManager];
	NSDictionary *attrs = [man fileAttributesAtPath:helperPath traverseLink:YES];
	NSNumber *curPerms = [attrs objectForKey:NSFilePosixPermissions];
	//NSLog(@"curPerms: %@", curPerms);
	if (![[attrs objectForKey:NSFileOwnerAccountName] isEqualToString:@"root"] || [curPerms intValue] < 2541)
	{
		
        /* Permissions are incorrect */
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
            char *command = "mount -uw / && chown root:wheel \"$HELP\" && chmod 4755 \"$HELP\" && chmod +s \"$HELP\"";
            setenv("HELP", [helperPath fileSystemRepresentation], 1);
            char *arguments[] = {"-c", command, NULL};
            result = AuthorizationExecuteWithPrivileges(auth, "/bin/sh", kAuthorizationFlagDefaults, arguments, NULL);
            unsetenv("HELP");
        }
		if(result != errAuthorizationSuccess)
		{
			NSLog(@"nitoHelper permissions: %@ are not sufficient, dying", curPerms);
			/*Need to present the error dialog here telling the user to fix the permissions*/
			return NO;
		}
		//
		//return (NO);
	}
	
	return (YES);
	
}
+(void)checkPhotoDirPath
{
    NSString *a=[SMGeneralMethods stringForKey:PHOTO_DIRECTORY_KEY];
    if ([a isEmpty]) {
        NSLog(@"blah");
    }
    NSLog(@"a");
}
+(NSDate *)dateForKey:(NSString *)theKey
{
	//CFPreferencesAppSynchronize(myDomain);
	NSDate * myString = [(NSDate *)CFPreferencesCopyAppValue((CFStringRef)theKey, myDomain) autorelease];
	return (NSDate *)myString;
}
+ (int)integerForKey:(NSString *)theKey
{
	Boolean temp;
	
	int outInt = CFPreferencesGetAppIntegerValue((CFStringRef)theKey, myDomain, &temp);
	return outInt;
	
}
+(BOOL)boolForKey:(NSString *)theKey
{
	Boolean temp;
	Boolean outBool = CFPreferencesGetAppBooleanValue((CFStringRef)theKey, myDomain, &temp);
	return outBool;
}


+ (NSString *)stringForKey:(NSString *)theKey
{
	//CFPreferencesAppSynchronize(myDomain);
	NSString * myString = [(NSString *)CFPreferencesCopyAppValue((CFStringRef)theKey, myDomain) autorelease];
	return (NSString *)myString;
}
+(void)restartFinder;
{
	[NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments:[NSArray arrayWithObjects:@"/System/Library/CoreServices/Finder.app/Contents/Plugins/SoftwareMenu.frappliance/Contents/Resources/reset.sh",nil]];
}

//+ (NSArray *)menuItemNames
//{
//	return [NSArray arrayWithObjects:BRLocalizedString(@"3rd Party Plugins",@"3rd Party Plugins"),BRLocalizedString(@"Manage Built-in",@"Manage Built-in"),BRLocalizedString(@"Scripts",@"Scripts"),BRLocalizedString(@"Restart Finder",@"Restart Finder"),BRLocalizedString(@"FrapMover",@"FrapMover"),BRLocalizedString(@"Console",@"Console"),BRLocalizedString(@"Tweaks",@"Tweaks"),BRLocalizedString(@"Photos",@"Photos"),nil];
//}
+(NSArray *)menuItemNames
{
    return [NSArray arrayWithObjects:@"3rd Party",@"Built-in",@"Scripts",@"Restart Finder",@"Frap Mover",@"Console",@"Tweaks",@"Photos",@"Upgrader",nil];
}
+ (NSArray *)menuItemOptions
{
	return [NSArray arrayWithObjects:@"SMdownloadable",@"SMbuiltin",@"SMscripts",@"SMreboot",@"SMmover",@"SMconsole",@"SMtweaks",@"SMphotos",@"SMUpgrader",nil];
}
+ (NSArray *)arrayForKey:(NSString *)theKey
{
	NSArray  *myArray = [(NSArray *)CFPreferencesCopyAppValue((CFStringRef)theKey, myDomain) autorelease];
	return (NSArray *)myArray;
}
+(NSDictionary *)dictForKey:(NSString *)theKey
{
	NSDictionary * myDict = [(NSDictionary *)CFPreferencesCopyAppValue((CFStringRef)theKey, myDomain) autorelease];
	return (NSDictionary *)myDict;
}
+ (NSArray *)getPrefKeys
{
	NSArray *myArray = (NSArray *)CFPreferencesCopyKeyList(myDomain,kCFPreferencesCurrentUser,kCFPreferencesAnyHost);
	return (NSArray *)myArray;
}

+ (void)switchBoolforKey:(NSString *)theKey
{
	BOOL finalBOOL;
	if([self boolForKey:theKey])
	{
        NSLog(@"switching to NO");
		finalBOOL=NO;
	}
	else
	{
        NSLog(@"switching to YES");
		finalBOOL = YES;
	}
	[self setBool:finalBOOL	forKey:theKey];
}
+ (void)setBool:(BOOL)inputBool forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithBool:inputBool], myDomain);
	CFPreferencesAppSynchronize(myDomain);
}
+ (void)setBool:(BOOL)inputBool forKey:(NSString *)theKey forDomain:(NSString *)theDomain
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithBool:inputBool], (CFStringRef)theDomain);
	CFPreferencesAppSynchronize((CFStringRef)theDomain);
}
+ (void)setArray:(NSArray *)inputArray forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFArrayRef)inputArray, myDomain);
	CFPreferencesAppSynchronize(myDomain);
	//CFRelease(inputArray);
}
+ (void)setDict:(NSDictionary *)inputDict forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFDictionaryRef)inputDict, myDomain);
	CFPreferencesAppSynchronize(myDomain);
	//CFRelease(inputDict);
}
+ (void)setDate:(NSDate *)inputDict forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFDateRef)inputDict, myDomain);
	CFPreferencesAppSynchronize(myDomain);
	//CFRelease(inputDict);
}
+ (void)setString:(NSString *)inputString forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFStringRef)inputString, myDomain);
	CFPreferencesAppSynchronize(myDomain);
	CFRelease(inputString);
}

+ (void)setInteger:(int)theInt forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithInt:theInt], myDomain);
	CFPreferencesAppSynchronize(myDomain);
}
+(int)remoteActionForBREvent:(BREvent *)event
{
    int remoteAction =[event remoteAction];
    if([SMPreferences threePointZeroOrGreater] && [event originator]==3)
        remoteAction--;
    return remoteAction;
}
+ (SMGeneralMethods *)sharedInstance
{
    return sharedInstance ? sharedInstance : [[self alloc] init];
}
-(id)init
{
    self=[super init];
//    browser=[[NSNetServiceBrowser alloc]init];
//    services=[[NSMutableArray array] retain];
//    [browser setDelegate:self];
//    [browser searchForServicesOfType:@"_afpovertcp._tcp." inDomain:@"local."];
    return self;
}
- (BOOL)helperCheckPerm
{
	NSString *helperPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
	NSFileManager *man = [NSFileManager defaultManager];
	NSDictionary *attrs = [man fileAttributesAtPath:helperPath traverseLink:YES];
	NSNumber *curPerms = [attrs objectForKey:NSFilePosixPermissions];
	////NSLog(@"curPerms: %@", curPerms);
	if ([curPerms intValue] < 2541)
	{
		//NSLog(@"installHelper permissions: %@ are not sufficient, dying", curPerms);
		return (NO);
	}
	
	return (YES);
	
}
+ (BOOL)helperCheckPerm
{
	NSString *helperPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
	NSFileManager *man = [NSFileManager defaultManager];
	NSDictionary *attrs = [man fileAttributesAtPath:helperPath traverseLink:YES];
	NSNumber *curPerms = [attrs objectForKey:NSFilePosixPermissions];
	////NSLog(@"curPerms: %@", curPerms);
	if ([curPerms intValue] < 2541)
	{
		NSLog(@"installHelper permissions: %@ are not sufficient, dying", curPerms);
		return (NO);
	}
	
	return (YES);
	
}

-(void)helperFixPerm
{
//	if(![self helperCheckPerm])
//	{
//		NSString *launchPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"FixPerm" ofType:@"sh"];
//        NSLog(@"launchPath: %@",launchPath);
//		NSTask *task = [[NSTask alloc] init];
//		NSArray *args = [NSArray arrayWithObjects:launchPath,nil];
//		[task setArguments:args];
//		[task setLaunchPath:@"/bin/bash"];
//		[task launch];
//		[task waitUntilExit];
//	}
    [self SMHelperCheckPerm];
	return;
}
+(void)helperFixPerm
{
//	if(![SMGeneralMethods helperCheckPerm])
//	{
//		NSString *launchPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"FixPerm" ofType:@"sh"];
//        NSLog(@"launchPath: %@",launchPath);
//		NSTask *task = [[NSTask alloc] init];
//		NSArray *args = [NSArray arrayWithObjects:launchPath,nil];
//		[task setArguments:args];
//		[task setLaunchPath:@"/bin/bash"];
//		[task launch];
//		[task waitUntilExit];
//	}
    [[SMGeneralMethods sharedInstance] SMHelperCheckPerm];
	return;
}
-(void)toggleUpdate
{
    [[SMHelper helperManager] toggleUpdate];
	
}
-(BOOL)isRW
{
	struct statfs statBuf; 
	
	//if ( pModified != NULL ) 
	//		*pModified = NO; 
	
	if ( statfs("/", &statBuf) == -1 ) 
	{ 
		NSLog( @"statfs(\"/\"): %d", errno ); 
		return ( NO ); 
	} 
	
	// check mount flags -- do we even need to make a modification ? 
	if ( (statBuf.f_flags & MNT_RDONLY) == 0 ) 
	{ 
		NSLog( @"Root filesystem already writable\n\n" );
		return ( YES ); 
	} 
	return (NO);
}
-(void)blockUpdate
{
	NSString *helperLaunchPath= [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
	NSTask *task6 = [[NSTask alloc] init];
	NSArray *args6 = [NSArray arrayWithObjects:@"-blockUpdate",@"0",@"0",nil];
	[task6 setArguments:args6];
	[task6 setLaunchPath:helperLaunchPath];
	[task6 launch];
	[task6 waitUntilExit];
	[NSTask launchedTaskWithLaunchPath:@"/usr/sbin/lookupd" arguments:[NSArray arrayWithObjects:@"-flushcache",nil]];

	return;
	
}
-(BOOL)usingTakeTwoDotThree
{
	if([(Class)NSClassFromString(@"BRController") instancesRespondToSelector:@selector(wasExhumed)])
	{
		return YES;
	}
	else
	{
		return NO;
	}
	
}
-(NSString *)getImagePathforDict:(NSDictionary *)infoDict;
{
	//NSLog(@"infoDict: %@",infoDict);
	NSString *TYPE=[infoDict valueForKey:TYPE_KEY];
	if ([TYPE isEqualToString:FRAP_KEY])
	{
		
		NSString *appPng = [[NSBundle bundleForClass:[self class]] pathForResource:[infoDict valueForKey:NAME_KEY] ofType:@"png"];
		if(![[NSFileManager defaultManager] fileExistsAtPath:appPng])
			appPng = [[NSBundle bundleForClass:[self class]] pathForResource:@"package" ofType:@"png"];
		return appPng;
	}
	else if([TYPE isEqualToString:SCRIPT_KEY])
	{
		return [[NSBundle bundleForClass:[self class]] pathForResource:@"script" ofType:@"png"];
	}
	else if([TYPE isEqualToString:MISC_KEY])
	{
		NSString *actualName=[infoDict valueForKey:NAME_KEY];
		if([actualName isEqualToString:@"restore"]||[actualName isEqualToString:@"backup"])
		{
			return [[NSBundle bundleForClass:[self class]] pathForResource:@"timemachine" ofType:@"png"];
		}
		else if([actualName isEqualToString:@"remove"])
		{
			return [[NSBundle bundleForClass:[self class]] pathForResource:@"trashempty" ofType:@"png"];
		}
		else if([actualName isEqualToString:@"info"])
		{
			return [[NSBundle bundleForClass:[self class]] pathForResource:@"info" ofType:@"png"];
		}
		else if([actualName isEqualToString:@"reboot"]||[actualName isEqualToString:@"restart"])
		{
			return [[NSBundle bundleForClass:[self class]] pathForResource:@"power" ofType:@"png"];
		}
		else if([actualName isEqualToString:@"license"])
		{
			return [[NSBundle bundleForClass:[self class]] pathForResource:@"scriptLicense" ofType:@"png"];
		}
		else
		{
			return [[NSBundle bundleForClass:[self class]] pathForResource:@"package" ofType:@"png"];
		}
	}
	else if([TYPE isEqualToString:SM_KEY])
	{
		return [[NSBundle bundleForClass:[self class]] pathForResource:@"SoftwareMenu" ofType:@"png"];
	}
	
	return [[NSBundle bundleForClass:[self class]] pathForResource:@"package" ofType:@"png"];
}
-(BOOL)checkblocker
{
	
	NSMutableString *hosts = [[NSMutableString alloc] initWithContentsOfFile:@"/etc/hosts"]; 
	NSMutableArray *hostArray = [[NSMutableArray alloc] initWithArray:[hosts componentsSeparatedByString:@"\n"]]; 
	int i; 
	for (i = 0; i < [hostArray count]; i++) 
	{ 
		NSString *currentItem = [hostArray objectAtIndex:i]; 
		currentItem = [currentItem stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; 
		NSArray *items = [currentItem componentsSeparatedByString:@" "]; 
		if ([items containsObject:@"mesu.apple.com"]) 
		{ 
			return YES; 
			
		} 
	} 
	return NO;
}
+(BOOL)installPackage:(NSString *)targz fromType:(int)updateType
{
	switch (updateType)
	{
		case 0:
			break;
		case 1:
			break;
		default:
			break;
	}
	return NO;
}
+(int)convertDMG:(NSString *)initLocation toFormat:(NSString *)dmgFormat withOutputLocation:(NSString *)outputLocation
{
	NSTask *mdTask = [[NSTask alloc] init];
	NSPipe *mdip = [[NSPipe alloc] init];
	[mdTask setLaunchPath:@"/usr/bin/hdiutil"];
	[mdTask setArguments:[NSArray arrayWithObjects:@"convert", initLocation, @"-format", dmgFormat, @"-o", outputLocation, nil]];
	[mdTask setStandardOutput:mdip];
	[mdTask setStandardError:mdip];
	[mdTask launch];
	[mdTask waitUntilExit];
	int theTerm=[mdTask terminationStatus];
	return theTerm;
}
+(NSArray *)builtinfrapsWithSettings:(BOOL)settings
{
	if(settings)
	{
		return [[NSArray alloc] initWithObjects:@"Movies.frappliance",@"Music.frappliance",@"Photos.frappliance",@"Podcasts.frappliance",@"YT.frappliance",@"TV.frappliance",@"Settings.frappliance",@"Internet.frappliance",@"SoftwareMenu.frappliance",nil];
	}
	else
	{
		return [[NSArray alloc] initWithObjects:@"Movies.frappliance",@"Music.frappliance",@"Photos.frappliance",@"Podcasts.frappliance",@"YT.frappliance",@"TV.frappliance",@"Settings.frappliance",@"Internet.frappliance",nil];
	}
}
+(int)runHelperApp:(NSArray *)options
{
	NSLog(@"helper app");
	NSString *helperLaunchPath= [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
	NSLog(@"helper app Path: %@",helperLaunchPath);
	if(![[NSFileManager defaultManager] fileExistsAtPath:helperLaunchPath])
		NSLog(@"the helper does not exist..... what did you do?");
	NSTask *task8 = [[NSTask alloc] init];
	[task8 setArguments:options];
	[task8 setLaunchPath:helperLaunchPath];
	[task8 launch];
	[task8 waitUntilExit];
	int theTerm = [task8 terminationStatus];
	return theTerm;
}
+(void)checkFolders
{
	NSFileManager *man =[NSFileManager defaultManager];
//	if (![man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/" stringByExpandingTildeInPath]])
//		[man createDirectoryAtPath:[@"~/Library/Application Support/SoftwareMenu/" stringByExpandingTildeInPath] attributes:nil];
    [man constructPath:[@"~/Library/Application Support/SoftwareMenu/" stringByExpandingTildeInPath]];
    [man constructPath:[@"~/Documents/Backups" stringByExpandingTildeInPath]];
    [man constructPath:[@"~/Library/Application Support/SoftwareMenu/Images" stringByExpandingTildeInPath]];
//	if(![man fileExistsAtPath:[@"~/Documents" stringByExpandingTildeInPath]])
//	{[man createDirectoryAtPath:[@"~/Documents" stringByExpandingTildeInPath] attributes:nil];}
	
//	if(![man fileExistsAtPath:[@"~/Documents/Backups" stringByExpandingTildeInPath]])
//	{[man createDirectoryAtPath:[@"~/Documents/Backups" stringByExpandingTildeInPath] attributes:nil];}
	
	if(![man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/Trusted" stringByExpandingTildeInPath]])
		[man createDirectoryAtPath:[@"~/Library/Application Support/SoftwareMenu/Trusted" stringByExpandingTildeInPath] attributes:nil];
	if(![man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/unTrusted" stringByExpandingTildeInPath]])
		[man createDirectoryAtPath:[@"~/Library/Application Support/SoftwareMenu/unTrusted" stringByExpandingTildeInPath] attributes:nil];
	if(![man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/Images" stringByExpandingTildeInPath]])
		[man createDirectoryAtPath:[@"~/Library/Application Support/SoftwareMenu/Images" stringByExpandingTildeInPath] attributes:nil];
	
}
+(NSString *)getImagePath:(NSString *)Name
{
    if([Name isEqualToString:@"SoftwareMenu"])
        return [[NSBundle bundleForClass:[self class]] pathForResource:IMAGE_SM_SHELF ofType:@"png"];
	NSFileManager *man =[NSFileManager defaultManager];
	NSString *filepath = nil;
	NSArray *imageExtensions = [NSArray arrayWithObjects:
							   @"png",
							   @"jpeg",
							   @"tif",
							   @"tiff",
							   @"jpg",
							   @"gif",
							   nil];
	NSEnumerator *objEnum = [imageExtensions objectEnumerator];
	id obj;
	while((obj = [objEnum nextObject]) != nil) 
	{
		filepath=[[SMPreferences ImagesPath] stringByAppendingPathComponent:[Name stringByAppendingPathExtension:obj]];
        //NSLog(@"filepath: %@",filepath);
		if([man fileExistsAtPath:filepath])
		{
			return (filepath);
		}
	}
	return filepath;
}
+(void)terminateFinder
{
	if([SMGeneralMethods boolForKey:@"ARF"])
	{
		AGProcess *finder = [AGProcess processForCommand:@"Finder"];
		[finder terminate];
	}
}
+(NSString *)checkUpdatesPath
{
    return [@"~/Library/Application Support/SoftwareMenu/updater.log" stringByExpandingTildeInPath];
}
+(void)checkScreensaver
{
    if([SMGeneralMethods OSGreaterThan:@"3.0"])
    {
        [[SMGeneralMethods sharedInstance] helperFixPerm];
        NSString *SMPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"SMM" ofType:@"frss"];
        int currentVersion = [[[[NSBundle bundleWithPath:SMPath] infoDictionary] valueForKey:@"CFBundleVersion"] intValue];
        NSLog(@"SMVersion In package: %@",[NSNumber numberWithInt:currentVersion]);
        int installedVersion = [[[[NSBundle bundleWithPath:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SMM.frss"] infoDictionary] valueForKey:@"CFBundleVersion"] intValue];
        if (currentVersion >installedVersion)
        {
            NSLog(@"Updating Screen Saver to version: %@, (you had : %@)",[NSNumber numberWithInt:currentVersion],[NSNumber numberWithInt:installedVersion],nil);
            //[SMGeneralMethods runHelperApp:[NSArray arrayWithObjects:@"installScreensaver",@"0",@"0",nil]];
            [[SMHelper helperManager]installScreensaver];
//            [NSTask launchedTaskWithLaunchPath:		[[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""] 
//                                     arguments:		[NSArray arrayWithObjects:@"installScreensaver",@"0",@"0",nil]];
        }
    }
}
#pragma mark NETWORK
- (NSArray *)availableBonjourMounts;
{
    return services; 
}
- (BOOL)mountManualPointWithDictionary:(NSDictionary *)theDict
{
    return [self mountManualPointWithDictionary:theDict softLink:TRUE returnString:nil];
}
- (BOOL)mountManualPointWithDictionary:(NSDictionary *)theDict returnString:(NSString * *)rstring
{
    return [self mountManualPointWithDictionary:theDict softLink:TRUE returnString:rstring];
}
- (BOOL)mountManualPointWithDictionary:(NSDictionary *)theDict softLink:(BOOL)link returnString:(NSString * *)rstring
{
    BRTextWithSpinnerController *theController = [[BRTextWithSpinnerController alloc]initWithTitle:BRLocalizedString(@"Mounting Volume",@"Mounting Volume") 
                                                                                              text:BRLocalizedString(@"Mounting Volume Please Wait...", @"text for spinning progress controller while waiting for mount to finish")];
    [[[BRApplicationStackManager singleton] stack] pushController:theController];
	NSDictionary *mountProps = theDict;
	int mountTypes = [[mountProps valueForKey:@"mountType"] intValue];
	int requiresAuth = [[mountProps valueForKey:@"requiresAuth"] intValue];
	NSString *mountLocation = [mountProps valueForKey:@"mountAddress"];
	NSString *userName = [mountProps valueForKey:@"userLogin"];
	NSString *userPassword = [mountProps valueForKey:@"userPassword"];
	NSString *volumeName = [mountProps valueForKey:@"mountVolume"];
	
	int customMount = [[mountProps valueForKey:@"customMount"] intValue];
	
	if (customMount == nil)
		customMount = 0;
	NSString *customPath = [mountProps valueForKey:@"customPath"];
	
	if (customPath == nil)
		customPath = @"";

	
	
	NSString *newDevice = [@"/Volumes" stringByAppendingPathComponent:[volumeName lastPathComponent]];
	NSString *newDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Movies"];//[[RUIPreferenceManager sharedPreferences] stringForKey:@"mountLocation" forDomain:@"com.apple.frontrow.appliance.nitoTV"];
	NSMutableString *mutString = [[NSMutableString alloc] init];
	
	switch (mountTypes) {
            
        case 0:
            [mutString appendString:@"afp://"];
            if (requiresAuth == 0)
            {
//                [mutString appendString:userName];
//                [mutString appendString:@":"];
//                [mutString appendString:userPassword];
//                [mutString appendString:@"@"];
                [mutString appendString:[NSString stringWithFormat:@"%@:%@@",userName,userPassword,nil]];
            }
                 
            [mutString appendString:mountLocation];
            [mutString appendString:@"/"];
            [mutString appendString:volumeName];
            break;
            
        case 1:
            
            if (requiresAuth == 0)
            {
                //[mutString appendString:userName];
                //[mutString appendString:@":"];
                //[mutString appendString:userPassword];
                //[mutString appendString:@"@"];
            }
            [mutString appendString:mountLocation];
            [mutString appendString:@":"];
            [mutString appendString:volumeName];
            break;
            
        case 2:
            [mutString appendString:@"//"];
            if (requiresAuth == 0)
            {
                [mutString appendString:userName];
                [mutString appendString:@":"];
                [mutString appendString:userPassword];
                [mutString appendString:@"@"];
            }
            [mutString appendString:mountLocation];
            [mutString appendString:@"/"];
            [mutString appendString:volumeName];
            break;
	}
	
	
	//[mutString appendString:@" "];
	//[mutString appendString:newDevice];
	
	
	
	//NSLog(@"mount_afp %@", mutString);
	NSFileManager *man = [NSFileManager defaultManager];
	
	if (![man fileExistsAtPath:newDevice])
		[man createDirectoryAtPath:newDevice attributes:nil];
	//NSString *zstring;
	BOOL success= [self mountPoint:mutString atPoint:newDevice ofType:mountTypes returnString:rstring];
    [[[BRApplicationStackManager singleton]stack]popController];
    //returnString=rstring;

    /*
     *  Need to define Failure Response HERE
     */
    
	if (!success) //mount failed
	{
        BRAlertController *alertController = [BRAlertController alertOfType:0 
                                                     titled:BRLocalizedString(@"Network Mount Failed!", @"alert when network mount fails") 
                                                primaryText:*rstring 
                                              secondaryText:BRLocalizedString(@"Popping this Alert in 10 secs", @"secondary text when network mount fails")];
		[alertController retain];
        [[[BRApplicationStackManager singleton] stack] pushController:alertController];
		[self performSelector:@selector(popController:) withObject:alertController afterDelay:10.0];
		return FALSE;
	}
    
    
    
    //NSLog(@"returnString: %@",*rstring);
	if (customMount == 1)
	{
		newDevice = [newDevice stringByAppendingPathComponent:customPath];
		//NSLog(@"customDir: %@", newDevice);
	}
    if (link) {
        NSLog(@"linking %@ to %@",newDevice,newDir);
        [self linkDirectory:newDevice toPath:newDir];
    }
    NSLog(@"ending");
	return TRUE;
	
}
- (BOOL)mountPoint:(NSString *)inpoint atPoint:(NSString *)outPoint ofType:(int)theType returnString:(NSString * *)rstring
{
	NSString *errorString = nil;
	NSFileManager *man = [NSFileManager defaultManager];
	NSTask *afpTask = [[NSTask alloc] init];
	NSPipe *afpPipe = [[NSPipe alloc] init];
	NSFileHandle *afpHandle = [afpPipe fileHandleForReading];
	NSMutableArray *afpArray = [[NSMutableArray alloc] init];
	NSString *mountTool = nil;
	if (theType == SMAFPMount)
	{
		mountTool = @"/sbin/mount_afp";
		if ([man fileExistsAtPath:mountTool])
		{
			[afpTask setLaunchPath:mountTool];
		} else {
			NSLog(@"FIXME: mount_afp missing, cannot mount");
			return FALSE;
		}
		
	} else if (theType == SMNFSMount) {
		mountTool = @"/sbin/mount_nfs";
		if ([man fileExistsAtPath:mountTool])
		{
			[afpTask setLaunchPath:mountTool];
			[afpArray addObject:@"-T"];
			[afpArray addObject:@"-b"];
			[afpArray addObject:@"-R"];
			[afpArray addObject:@"100"];
		} else {
			NSLog(@"FIXME: mount_nfs missing, cannot mount");
			return FALSE;
		}
        
        
	} else if (theType == SMSMBMount) {
		mountTool = @"/sbin/mount_smbfs";
		if ([man fileExistsAtPath:mountTool])
		{
			[afpTask setLaunchPath:mountTool];
		} else {
			NSLog(@"FIXME: mount_smbfs missing, cannot mount");
			return FALSE;
		}
		
		
	}
	[afpArray addObject:inpoint];
	[afpArray addObject:outPoint];
	[afpTask setArguments:afpArray];
	[afpTask setStandardError:afpPipe];
	[afpTask setStandardOutput:afpPipe];
	//NSLog(@"%@ %@", mountTool, [afpArray componentsJoinedByString:@" "]);
	//NSLog(@"mount %@", [afpArray componentsJoinedByString:@" "]);
	[afpTask launch];
	
	[afpTask waitUntilExit];
	NSData *outData;
	outData = [afpHandle readDataToEndOfFile];
	NSString *temp = [[NSString alloc] initWithData:outData encoding:NSASCIIStringEncoding];
	temp = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	int theTerm = [afpTask terminationStatus];
	NSLog(@"mountTask terminated with status: %i", theTerm);
    [afpArray release];
	[afpTask release];
	afpTask = nil;
	[afpPipe release];
	afpPipe = nil;
    if (rstring!=nil) {
        *rstring=[NSString stringWithString:temp];
    }
    //[temp release];
	switch (theTerm)
	{
		case 0: //success
			
			NSLog(@"mount success!");
			return TRUE;
			break;
			
		default: //anything BUT success
			errorString = temp;
			NSLog(@"failed with error: %@", temp);
			return FALSE;
			
			break;
			
	}
    

	
    return FALSE;
	
}
- (BOOL)linkDirectory:(NSString *)theDir toPath:(NSString *)thePath
{
	return [[NSFileManager defaultManager]createSymbolicLinkAtPath:thePath pathContent:theDir];
} 
- (void)popController:(BRController *)controller
{
    if ([[[BRApplicationStackManager singleton] stack] peekController]==controller) {
        [[[BRApplicationStackManager singleton] stack] popController];
        if (controller!=nil) {
            [controller release];
        }
    }
}
+ (BOOL)pythonIsInstalled
{
    return NO;
}
+ (NSString *)defaultScriptsDirectory
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Scripts"];
}
+ (BOOL)isLocalDrive:(NSString *)theDrive
{
	const char * volPath = [theDrive UTF8String];
	struct statfs statBuf;
	const char *fsType;
	
	
	if ( statfs(volPath, &statBuf) == -1 ) 
	{ 
		NSLog( @"statfs(\"/\"): %d", errno ); 
		return ( NO ); 
	} 
	fsType = statBuf.f_fstypename;
	NSString *volumeType = [NSString stringWithCString:fsType];
	NSLog(@"volume type: %@", volumeType);
	// check mount flags -- do we even need to make a modification ? 
	if ( (statBuf.f_flags & MNT_LOCAL) > 0 ) 
	{ 
		NSLog(@"drive mounted locally!");
		
		return (YES);
	} 
	
	return (NO);
}
#pragma mark NSServiceBrowserDelegate
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser 
           didFindService:(NSNetService *)netService 
               moreComing:(BOOL)moreServicesComing
{
    NSLog(@"adding New Service");
    [services addObject:netService];
}
- (void)netServiceBrowser:(NSNetServiceBrowser *)netServiceBrowser didRemoveService:(NSNetService *)netService
{
    NSLog(@"removing Service");
    NSEnumerator *enumerator = [services objectEnumerator];
    NSNetService *currentNetService;
    while (currentNetService = [enumerator nextObject]) {
        if ([[currentNetService name] isEqual:[netService name]] && 
            [[currentNetService type] isEqual:[netService type]] && 
            [[currentNetService domain] isEqual:[netService domain]]) {
            [services removeObject:currentNetService];
            break;
        }
    }
}
@end
