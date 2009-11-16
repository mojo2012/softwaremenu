//
//  SMPreferences.m
//  SoftwareMenu
//
//  Created by Thomas on 5/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMPrefs.h"
#import "SMDefines.h"

@implementation SMPreferences

+ (NSString *)appleTVVersion
{
	NSDictionary *finderDict = [[NSBundle mainBundle] infoDictionary];
	NSString *theVersion = [finderDict objectForKey: @"CFBundleVersion"];
	return theVersion;
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
	//CFPreferencesSetAppValue((CFStringRef)theKey, (CFStringRef)inputString, myDomain);
	CFPreferencesAppSynchronize(myDomain);
	CFRelease(inputString);
}

+ (void)setInteger:(int)theInt forKey:(NSString *)theKey
{
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFNumberRef)[NSNumber numberWithInt:theInt], myDomain);
	CFPreferencesAppSynchronize(myDomain);
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
	CFPreferencesAppSynchronize(myDomain);
	NSString * myString = (NSString *)CFPreferencesCopyAppValue((CFStringRef)theKey, myDomain);
	return (NSString *)myString;
}
-(void)setUpdatesAvailable:(BOOL)arg1
{
    [SMPreferences setBool:arg1 forKey:UPDATES_AVAILABLE];
}
-(BOOL)updatesAvailable
{
    return [SMPreferences boolForKey:UPDATES_AVAILABLE];
}
-(void)setShowsCollectionsOnMainMenu:(BOOL)arg1
{
    [SMPreferences setBool:arg1 forKey:MAINMENU_SHOW_COLLECTIONS_BOOL];
}
-(BOOL)showsCollectionsOnMainMenu
{
    return [SMPreferences boolForKey:MAINMENU_SHOW_COLLECTIONS_BOOL];
}
+(NSArray *)photoFavorites
{
    return [SMPreferences arrayForKey:PHOTO_FAVORITES];
}
+(void)setPhotoFavorites:(NSArray *)favorites
{
    [SMPreferences setArray:favorites forKey:PHOTO_FAVORITES];
}
+(NSString *)scriptsPlistPath
{
    return [[@"~/Library/Preferences/SoftwareMenu" stringByAppendingPathComponent:SCRIPTS_PLIST] stringByExpandingTildeInPath];
}
+(NSString *)trustedPlistPath
{
    return [[@"~/Library/Preferences/SoftwareMenu" stringByAppendingPathComponent:TRUSTED_PLIST] stringByExpandingTildeInPath];
}
+(NSString *)ImagesPath
{
    return [IMAGES_FOLDER stringByExpandingTildeInPath];
}
+(NSString *)trustedPlistURL
{
    return TRUSTED_URL;
}
+(NSString *)photoFolderPath
{
    NSString * path = [SMPreferences stringForKey:PHOTO_DIRECTORY_KEY];
    
    if (path == nil)
    {
    path = DEFAULT_IMAGES_PATH;
    [SMPreferences setString:path forKey:PHOTO_DIRECTORY_KEY];
    }
    return [path autorelease];
}
+(void)setPhotoFolderPath:(NSString *)path
{
    [SMPreferences setString:path forKey:PHOTO_DIRECTORY_KEY];
}
+(BOOL)slideshowSS
{
    return [SMPreferences boolForKey:SCREEN_SAVER_SLIDESHOW];
}
+(void)setSlideshowSS:(BOOL)arg1
{
    [SMPreferences setBool:arg1 forKey:SCREEN_SAVER_SLIDESHOW];
}
+(long)screensaverSpinFrequency
{
    long a = [SMPreferences integerForKey:SCREEN_SAVER_SPIN_FREQ];
    if (a == 0)
    {
        a=60;//[[ATVSettingsFacade singleton]screenSaverPhotoSpinFrequency]
    }
    NSLog(@"spin freq: %i",a);
    return a;
}
+(void)setScreensaverSpinFrequency:(int)freq
{
    [SMPreferences setInteger:freq forKey:SCREEN_SAVER_SPIN_FREQ];
}
+(NSString *)slideshowType
{
    NSArray *array = [NSArray arrayWithObjects:SCREEN_SAVER_FLOATING,SCREEN_SAVER_SLIDESHOW,SCREEN_SAVER_PARADE,nil];
    NSString *a = [SMPreferences stringForKey:SCREEN_SAVER_TYPE];
    if(a==nil)
        a=SCREEN_SAVER_FLOATING;
    return [a autorelease];
}
@end