//
//  SMGeneralMethods.m
//  SoftwareMenu
//
//  Created by Thomas on 3/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMGeneralMethods.h"
#import "AGProcess.h"
#define myDomain			(CFStringRef)@"com.apple.frontrow.appliance.SoftwareMenu"

@interface ATVSettingsFacade : BRSettingsFacade
- (void)setScreenSaverSelectedPath:(id)fp8;
- (id)screenSaverSelectedPath;
- (id)screenSaverPaths;
- (id)screenSaverCollectionForScreenSaver:(id)fp8;
- (id)versionOS;

@end
@implementation SMGeneralMethods
static SMGeneralMethods *sharedInstance = nil;

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
	CFStringRef myString = [(CFStringRef)CFPreferencesCopyAppValue((CFStringRef)theKey, myDomain) autorelease];
	return (NSString *)myString;
}
+(void)restartFinder;
{
	[NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments:[NSArray arrayWithObjects:@"/System/Library/CoreServices/Finder.app/Contents/Plugins/SoftwareMenu.frappliance/Contents/Resources/reset.sh",nil]];
}

+ (NSArray *)menuItemNames
{
	return [NSArray arrayWithObjects:BRLocalizedString(@"3rd Party Plugins",@"3rd Party Plugins"),BRLocalizedString(@"Manage Built-in",@"Manage Built-in"),BRLocalizedString(@"Scripts",@"Scripts"),BRLocalizedString(@"Restart Finder",@"Restart Finder"),BRLocalizedString(@"FrapMover",@"FrapMover"),BRLocalizedString(@"Console",@"Console"),BRLocalizedString(@"Tweaks",@"Tweaks"),BRLocalizedString(@"Photos",@"Photos"),nil];
}
+ (NSArray *)menuItemOptions
{
	return [NSArray arrayWithObjects:@"downloadable",@"builtin",@"scripts",@"reboot",@"mover",@"console",@"tweaks",@"Photos",nil];
	/*return [NSArray arrayWithObjects:
			[NSNumber numberWithInt:1],
			[NSNumber numberWithInt:2],
			[NSNumber numberWithInt:3],
			[NSNumber numberWithInt:4],
			[NSNumber numberWithInt:5],
			[NSNumber numberWithInt:6],
			[NSNumber numberWithInt:7],
			[NSNumber numberWithInt:8],nil];*/
}
+ (NSArray *)arrayForKey:(NSString *)theKey
{
	CFArrayRef myArray = [(CFArrayRef)CFPreferencesCopyAppValue((CFStringRef)theKey, myDomain) autorelease];
	return (NSArray *)myArray;
}
+(NSDictionary *)dictForKey:(NSString *)theKey
{
	CFDictionaryRef myDict = [(CFDictionaryRef)CFPreferencesCopyAppValue((CFStringRef)theKey, myDomain) autorelease];
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
		finalBOOL=NO;
	}
	else
	{
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
	CFRelease(inputArray);
}
+ (void)setDict:(NSDictionary *)inputDict forKey:(NSString *)theKey
{
	NSLog(@"dict1");
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFDictionaryRef)inputDict, myDomain);
	NSLog(@"dict2");
	CFPreferencesAppSynchronize(myDomain);
	NSLog(@"dict2.5");
	//CFRelease(inputDict);
	NSLog(@"dict3");
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

-(void)helperFixPerm
{
	if(![self helperCheckPerm])
	{
		NSString *launchPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"FixPerm" ofType:@"sh"];
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
	if(![self helperCheckPerm])
	{
		NSString *launchPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"FixPerm" ofType:@"sh"];
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
	if (![man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/" stringByExpandingTildeInPath]])
		[man createDirectoryAtPath:[@"~/Library/Application Support/SoftwareMenu/" stringByExpandingTildeInPath] attributes:nil];
	if(![man fileExistsAtPath:[@"~/Documents" stringByExpandingTildeInPath]])
	{[man createDirectoryAtPath:[@"~/Documents" stringByExpandingTildeInPath] attributes:nil];}
	
	if(![man fileExistsAtPath:[@"~/Documents/Backups" stringByExpandingTildeInPath]])
	{[man createDirectoryAtPath:[@"~/Documents/Backups" stringByExpandingTildeInPath] attributes:nil];}
	
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
		filepath=[IMAGES_FOLDER stringByAppendingPathComponent:[Name stringByAppendingPathExtension:obj]];
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
+(BOOL)checkScreensaver
{
	[[SMGeneralMethods sharedInstance] helperFixPerm];
	NSString *SMPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"SM" ofType:@"frss"];
	int currentVersion = [[[[NSBundle bundleWithPath:SMPath] infoDictionary] valueForKey:@"CFBundleVersion"] intValue];
	NSLog(@"SMVersion In package: %@",[NSNumber numberWithInt:currentVersion]);
	int installedVersion = [[[[NSBundle bundleWithPath:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SM.frss"] infoDictionary] valueForKey:@"CFBundleVersion"] intValue];
	if (currentVersion >installedVersion)
	{
		NSLog(@"Updating Screen Saver to version: %@, (you had : %@)",[NSNumber numberWithInt:currentVersion],[NSNumber numberWithInt:installedVersion],nil);
		[SMGeneralMethods runHelperApp:[NSArray arrayWithObjects:@"installScreensaver",@"0",@"0",nil]];
		NSLog(@"Version %@ is not installed",[[[NSBundle bundleWithPath:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SM.frss"] infoDictionary] valueForKey:@"CFBundleVersion"]);
	}
}

@end
