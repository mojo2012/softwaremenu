//
//  SMGeneralMethods.m
//  SoftwareMenu
//
//  Created by Thomas on 3/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMGeneralMethods.h"
#define myDomain			(CFStringRef)@"com.apple.frontrow.appliance.SoftwareMenu"


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
	CFStringRef myString = [(CFStringRef)CFPreferencesCopyAppValue((CFStringRef)theKey, myDomain) autorelease];
	return (NSString *)myString;
}

+ (NSArray *)menuItemNames
{
	return [NSArray arrayWithObjects:BRLocalizedString(@"3rd Party Plugins",@"3rd Party Plugins"),BRLocalizedString(@"Manage Built-in",@"Manage Built-in"),BRLocalizedString(@"Scripts",@"Scripts"),BRLocalizedString(@"Restart Finder",@"Restart Finder"),BRLocalizedString(@"FrapMover",@"FrapMover"),BRLocalizedString(@"Console",@"Console"),nil];
}
+ (NSArray *)menuItemOptions
{
	return [NSArray arrayWithObjects:@"downloadable",@"builtin",@"scripts",@"reboot",@"mover",@"console",nil];
}
+ (NSArray *)arrayForKey:(NSString *)theKey
{
	CFArrayRef myArray = [(CFArrayRef)CFPreferencesCopyAppValue((CFStringRef)theKey, myDomain) autorelease];
	return (NSArray *)myArray;
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

+ (void)setArray:(NSArray *)inputArray forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFArrayRef)inputArray, myDomain);
	CFPreferencesAppSynchronize(myDomain);
	CFRelease(inputArray);
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
	NSLog(@"infoDict: %@",infoDict);
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
@end
