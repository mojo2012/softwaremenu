//
//  SMMPrefs.m
//  SoftwareMenu
//
//  Created by Thomas on 5/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMMPrefs.h"
#import "SMDefines.h"

@implementation SMMPrefs

+ (NSString *)appleTVVersion
{
	NSDictionary *finderDict = [[NSBundle mainBundle] infoDictionary];
	NSString *theVersion = [finderDict objectForKey: @"CFBundleVersion"];
	return theVersion;
}

+ (BOOL)threePointZeroOrGreater
{
	
	NSComparisonResult theResult = [@"3.0" compare:[SMMPrefs appleTVVersion] options:NSNumericSearch];
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
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFStringRef)inputString, myDomain);
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
	//CFPreferencesAppSynchronize(myDomain);
	NSString * myString = (NSString *)CFPreferencesCopyAppValue((CFStringRef)theKey, myDomain);
	return (NSString *)myString;
}
-(void)setUpdatesAvailable:(BOOL)arg1
{
    [SMMPrefs setBool:arg1 forKey:UPDATES_AVAILABLE];
}
-(BOOL)updatesAvailable
{
    return [SMMPrefs boolForKey:UPDATES_AVAILABLE];
}
-(void)setShowsCollectionsOnMainMenu:(BOOL)arg1
{
    [SMMPrefs setBool:arg1 forKey:MAINMENU_SHOW_COLLECTIONS_BOOL];
}
-(BOOL)showsCollectionsOnMainMenu
{
    return [SMMPrefs boolForKey:MAINMENU_SHOW_COLLECTIONS_BOOL];
}
+(NSArray *)photoFavorites
{
    return [SMMPrefs arrayForKey:PHOTO_FAVORITES];
}
+(void)setPhotoFavorites:(NSArray *)favorites
{
    [SMMPrefs setArray:favorites forKey:PHOTO_FAVORITES];
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
    NSString * path = [SMMPrefs stringForKey:PHOTO_DIRECTORY_KEY];
    
    if (path == nil)
    {
        path = DEFAULT_IMAGES_PATH;
        [SMMPrefs setString:path forKey:PHOTO_DIRECTORY_KEY];
    }
    return [path autorelease];
}
+(void)setPhotoFolderPath:(NSString *)path
{
    [SMMPrefs setString:path forKey:PHOTO_DIRECTORY_KEY];
}
+(BOOL)slideshowSS
{
    return [SMMPrefs boolForKey:SCREEN_SAVER_SLIDESHOW];
}
+(void)setSlideshowSS:(BOOL)arg1
{
    [SMMPrefs setBool:arg1 forKey:SCREEN_SAVER_SLIDESHOW];
}
+(long)screensaverSpinFrequency
{
    long a = [SMMPrefs integerForKey:SCREEN_SAVER_SPIN_FREQ];
    if (a == 0)
    {
        a=[[ATVSettingsFacade singleton]screenSaverPhotoSpinFrequency];
    }
    NSLog(@"SMM spin freq: %i",a);
    return a;
}
+(NSString *)slideshowType
{
    NSArray *array = [NSArray arrayWithObjects:@"Floating",@"Slideshow",@"Parade",nil];
    NSString *a = [SMMPrefs stringForKey:@"ScreensaverType"];
    NSLog(@"a: %@",a);
    if(a==nil)
        a=@"Floating";
    else if(![array containsObject:a])
        a=@"Floating";
    return a;
}
@end
