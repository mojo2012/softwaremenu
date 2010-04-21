//
//  SMFPreferences.m
//  SoftwareMenuFramework
//
//  Created by Thomas on 5/4/09.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "AGProcess.h"
const NSString * kSMFBla= @"hey";
@implementation SMFPreferences
//+(CGColorRef)color
//{
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB ();
//	NSColor *deviceColor = [[NSColor redColor] colorUsingColorSpaceName: 
//							NSDeviceRGBColorSpace];
//	
//	float components[4];
//	[deviceColor getRed: &components[0] green: &components[1] blue: 
//	 &components[2] alpha: &components[3]];
//	
//	CGColorRef cgColor = CGColorCreate (colorSpace, components);
//	[myDict setValue:cgColor forKey:@"NSColor"];
//	CGColorSpaceRelease (colorSpace);
//	CGColorRelease (cgColor);	
//}
+ (NSString *)appleTVVersion
{
	NSDictionary *finderDict = [[NSBundle mainBundle] infoDictionary];
	NSString *theVersion = [finderDict objectForKey: @"CFBundleVersion"];
	return theVersion;
}

+ (BOOL)threePointZeroOrGreater
{
	
	NSComparisonResult theResult = [@"3.0" compare:[SMFPreferences appleTVVersion] options:NSNumericSearch];
	if ( theResult == NSOrderedDescending ){
		return NO;
	} else if ( theResult == NSOrderedAscending ){
		return YES;
	} else if ( theResult == NSOrderedSame ) {
		return YES;
	}
	return NO;
}
+ (BOOL)twoPointThreeOrGreater
{
	
	NSComparisonResult theResult = [@"2.3" compare:[SMFPreferences appleTVVersion] options:NSNumericSearch];
	if ( theResult == NSOrderedDescending ){
		return NO;
	} else if ( theResult == NSOrderedAscending ){
		return YES;
	} else if ( theResult == NSOrderedSame ) {
		return YES;
	}
	return NO;
}

+ (NSArray *)arrayForKey:(NSString *)theKey
{
	NSArray  *myArray = [(NSArray *)CFPreferencesCopyAppValue((CFStringRef)theKey, sharedDomain) autorelease];
	return (NSArray *)myArray;
}
+(NSDictionary *)dictForKey:(NSString *)theKey
{
	NSDictionary * myDict = [(NSDictionary *)CFPreferencesCopyAppValue((CFStringRef)theKey, sharedDomain) autorelease];
	return (NSDictionary *)myDict;
}
+ (NSArray *)getPrefKeys
{
	NSArray *myArray = (NSArray *)CFPreferencesCopyKeyList(sharedDomain,kCFPreferencesCurrentUser,kCFPreferencesAnyHost);
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
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithBool:inputBool], sharedDomain);
	CFPreferencesAppSynchronize(sharedDomain);
}
+ (void)setBool:(BOOL)inputBool forKey:(NSString *)theKey forDomain:(NSString *)theDomain
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithBool:inputBool], (CFStringRef)theDomain);
	CFPreferencesAppSynchronize((CFStringRef)theDomain);
}
+ (void)setArray:(NSArray *)inputArray forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFArrayRef)inputArray, sharedDomain);
	CFPreferencesAppSynchronize(sharedDomain);
	//CFRelease(inputArray);
}
+ (void)setDict:(NSDictionary *)inputDict forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFDictionaryRef)inputDict, sharedDomain);
	CFPreferencesAppSynchronize(sharedDomain);
	//CFRelease(inputDict);
}
+ (void)setDate:(NSDate *)inputDict forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFDateRef)inputDict, sharedDomain);
	CFPreferencesAppSynchronize(sharedDomain);
	//CFRelease(inputDict);
}
+ (void)setString:(NSString *)inputString forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFStringRef)inputString, sharedDomain);
	CFPreferencesAppSynchronize(sharedDomain);
	//CFRelease(inputString);
}

+ (void)setInteger:(int)theInt forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithInt:theInt], sharedDomain);
	CFPreferencesAppSynchronize(sharedDomain);
}
+(NSDate *)dateForKey:(NSString *)theKey
{
	//CFPreferencesAppSynchronize(sharedDomain);
	NSDate * myString = [(NSDate *)CFPreferencesCopyAppValue((CFStringRef)theKey, sharedDomain) autorelease];
	return (NSDate *)myString;
}
+ (int)integerForKey:(NSString *)theKey
{
	Boolean temp;
	
	int outInt = CFPreferencesGetAppIntegerValue((CFStringRef)theKey, sharedDomain, &temp);
	return outInt;
	
}
+(BOOL)boolForKey:(NSString *)theKey
{
	Boolean temp;
	Boolean outBool = CFPreferencesGetAppBooleanValue((CFStringRef)theKey, sharedDomain, &temp);
	return outBool;
}


+ (NSString *)stringForKey:(NSString *)theKey
{
	CFPreferencesAppSynchronize(sharedDomain);
	NSString * myString = (NSString *)CFPreferencesCopyAppValue((CFStringRef)theKey, sharedDomain);
	return (NSString *)myString;
}
-(void)setUpdatesAvailable:(BOOL)arg1
{
    [SMFPreferences setBool:arg1 forKey:UPDATES_AVAILABLE];
}
-(BOOL)updatesAvailable
{
    return [SMFPreferences boolForKey:UPDATES_AVAILABLE];
}
+(NSString *)ImagesPath
{
    return [IMAGES_FOLDER stringByExpandingTildeInPath];
}
+(NSString *)trustedPlistURL
{
    return TRUSTED_URL;
}
+(NSString *)stringForBool:(BOOL)arg
{
    return arg ? @"YES" : @"NO";
}
+(NSDictionary *)dictionaryForBundlePath:(NSString *)path
{
    return [NSDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:@"Contents/Info.plist"]];
}
+(void)terminateFinder
{
    AGProcess *finder = [AGProcess processForCommand:@"Finder"];
    [finder terminate];
}
@end
