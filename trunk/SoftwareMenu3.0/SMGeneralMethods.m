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
- (BOOL)nitoHelperCheckPerm
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
    return [NSArray arrayWithObjects:@"3rd Party",@"Built-in",@"Scripts",@"Restart Finder",@"Frap Mover",@"Console",@"Tweaks",@"Photos",nil];
}
+ (NSArray *)menuItemOptions
{
	return [NSArray arrayWithObjects:@"SMdownloadable",@"SMbuiltin",@"SMscripts",@"SMreboot",@"SMmover",@"SMconsole",@"SMtweaks",@"SMphotos",nil];
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

+ (SMGeneralMethods *)sharedInstance
{
    return sharedInstance ? sharedInstance : [[self alloc] init];
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
	if(![self helperCheckPerm])
	{
		NSString *launchPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"FixPerm" ofType:@"sh"];
        NSLog(@"launchPath: %@",launchPath);
		NSTask *task = [[NSTask alloc] init];
		NSArray *args = [NSArray arrayWithObjects:launchPath,nil];
		[task setArguments:args];
		[task setLaunchPath:@"/bin/bash"];
		[task launch];
		[task waitUntilExit];
	}
	return;
}
+(void)helperFixPerm
{
	if(![SMGeneralMethods helperCheckPerm])
	{
		NSString *launchPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"FixPerm" ofType:@"sh"];
        NSLog(@"launchPath: %@",launchPath);
		NSTask *task = [[NSTask alloc] init];
		NSArray *args = [NSArray arrayWithObjects:launchPath,nil];
		[task setArguments:args];
		[task setLaunchPath:@"/bin/bash"];
		[task launch];
		[task waitUntilExit];
	}
	return;
}
-(void)toggleUpdate
{
	NSString *helperLaunchPath= [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
	NSTask *task6 = [[NSTask alloc] init];
	NSArray *args6 = [NSArray arrayWithObjects:@"-toggleUpdate",@"0",@"0",nil];
	[task6 setArguments:args6];
	[task6 setLaunchPath:helperLaunchPath];
	[task6 launch];
	[task6 waitUntilExit];
	

	return;
	
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
		return [[NSArray alloc] initWithObjects:@"Movies.frappliance",@"Music.frappliance",@"Photos.frappliance",@"Podcasts.frappliance",@"YT.frappliance",@"TV.frappliance",@"Settings.frappliance",@"SoftwareMenu.frappliance",nil];
	}
	else
	{
		return [[NSArray alloc] initWithObjects:@"Movies.frappliance",@"Music.frappliance",@"Photos.frappliance",@"Podcasts.frappliance",@"YT.frappliance",@"TV.frappliance",@"Settings.frappliance",nil];
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
+(void)checkScreensaver
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
		[NSTask launchedTaskWithLaunchPath:		[[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""] 
								 arguments:		[NSArray arrayWithObjects:@"installScreensaver",@"0",@"0",nil]];
	}
}

@end
