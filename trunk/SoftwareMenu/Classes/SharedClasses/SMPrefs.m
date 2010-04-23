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
	CFPreferencesSetAppValue((CFStringRef)theKey, (CFStringRef)inputString, myDomain);
	CFPreferencesAppSynchronize(myDomain);
	//CFRelease(inputString);
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
+(NSMutableArray *)photoFavorites
{
    NSArray *array = [SMPreferences arrayForKey:PHOTO_FAVORITES];
    if (array==nil)
    {
        array = [NSArray array];
    }
    //NSLog(@"array: %@",array);
    return [array mutableCopy];
}
+(void)setPhotoFavorites:(NSArray *)favorites
{
    [SMPreferences setArray:favorites forKey:PHOTO_FAVORITES];
}
+(BOOL)defaultScriptRunAsRoot
{
    return [SMPreferences boolForKey:@"ScriptsDefaultRoot"];
}
+(BOOL)defaultScriptWait
{
    return [SMPreferences boolForKey:@"ScriptDefaultWait"];
}
+(void)setDefaultScriptRunAsRoot:(BOOL)inputBool
{
    [SMPreferences setBool:inputBool forKey:@"ScriptsDefaultRoot"];
}
+(void)setDefaultScriptWait:(BOOL)inputBool
{
    [SMPreferences setBool:inputBool forKey:@"ScriptDefaultWait"];
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
+(void)setPlaysMusicInSlideShow:(BOOL)arg
{
    [SMPreferences setBool:arg forKey:SLIDESHOW_MUSIC_PLAY];
}
+(BOOL)playsMusicInSlideShow
{
    return [SMPreferences boolForKey:SLIDESHOW_MUSIC_PLAY];
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
    return a;
}
+(void)setScreensaverSpinFrequency:(int)freq
{
    [SMPreferences setInteger:freq forKey:SCREEN_SAVER_SPIN_FREQ];
}
+(NSString *)slideshowType
{
    //NSArray *array = [NSArray arrayWithObjects:SCREEN_SAVER_FLOATING,SCREEN_SAVER_SLIDESHOW,SCREEN_SAVER_PARADE,nil];
    NSString *a = [SMPreferences stringForKey:SCREEN_SAVER_TYPE];
    if(a==nil)
        a=SCREEN_SAVER_FLOATING;
    return [a autorelease];
}
+(NSString *)screensaverFolder
{
    NSString *folder = [SMPreferences stringForKey:SCREEN_SAVER_FOLDER];
    if (folder == nil) 
        folder = DEFAULT_IMAGES_PATH;
    return folder;
}
+(void)setScreensaverFolder:(NSString *)screensaverFolder
{
    [SMPreferences setString:screensaverFolder forKey:SCREEN_SAVER_FOLDER];
}
+(long)screensaverSecondsPerSlide
{
    int a = [SMPreferences integerForKey:SCREEN_SAVER_SECONDS_PER_S];
    if(a==nil || a==0)
        a=60;
    return a;
}
+(void)setScreensaverSecondsPerSlide:(int)arg
{
    [SMPreferences setInteger:arg forKey:SCREEN_SAVER_SECONDS_PER_S];
}
+(BOOL)screensaverPanAndZoom
{
    return [SMPreferences boolForKey:SCREEN_SAVER_PAN_AND_ZOOM];
}
+(void)setScreensaverPanAndZoom:(BOOL)arg
{
    [SMPreferences setBool:arg forKey:SCREEN_SAVER_PAN_AND_ZOOM];
}
+(BOOL)screensaverShufflePhotos
{
    return [SMPreferences boolForKey:SCREEN_SAVER_PHOTOS_SHUFFLE];
}
+(void)setScreensaverShufflePhotos:(BOOL)arg
{
    [SMPreferences setBool:arg forKey:SCREEN_SAVER_PHOTOS_SHUFFLE];
}
+(BOOL)screensaverRepeat
{
    return [SMPreferences boolForKey:SCREEN_SAVER_REPEAT];
}
+(void)setScreensaverRepeat:(BOOL)arg
{
    [SMPreferences setBool:arg forKey:SCREEN_SAVER_REPEAT];
}
+(NSString *)screensaverSelectedTransitionName
{
    NSString * a= [SMPreferences stringForKey:SCREEN_SAVER_TRANSITION];
    if (a==nil) 
        a=@"Dissolve";
    return a;
}
+(void)setScreensaverSelectedTransitionName:(NSString *)arg
{
    [SMPreferences setString:arg forKey:SCREEN_SAVER_TRANSITION];
}
+(BOOL)screensaverUseAppleProvider
{
    return [SMPreferences boolForKey:SCREEN_SAVER_USE_APPLE];
}
+(void)setScreensaverUseAppleProvider:(BOOL)arg
{
    [SMPreferences setBool:arg forKey:SCREEN_SAVER_USE_APPLE];
}
+(NSDictionary *)screensaverSlideshowPlaybackOptions
{
    NSMutableDictionary *a = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:NO],@"None",
                              [NSNumber numberWithBool:YES],@"Random",
                              [SMPreferences stringForBool:[SMPreferences screensaverPanAndZoom]],@"PanAndZoom",
                              @"YES",@"RepeatSlideShow",
                              [NSNumber numberWithInt:[SMPreferences screensaverSecondsPerSlide]],@"SecondsPerSlide",
                              [NSNumber numberWithBool:[SMPreferences screensaverShufflePhotos]],@"ShuffleSlides",
                              [SMPreferences screensaverSelectedTransitionName],@"TransitionName",
                              @"NO",@"PlayMusic",
                              nil];
    return a;
                            
}
+(NSString *)stringForBool:(BOOL)arg
{
    return arg ? @"YES" : @"NO";
}
+(BOOL)strictApplianceInstallLimits
{
    return [SMPreferences boolForKey:APPLIANCE_LIMITS_STRICT];
}
+(BOOL)strictApplianceLowerInstallLimit
{
    return [SMPreferences boolForKey:APPLIANCE_LOWER_STRICT];
}
+(BOOL)strictApplianceUpperInstallLimit
{
    return [SMPreferences boolForKey:APPLIANCE_UPPER_STRICT];
}
+(BOOL)keepFrapplianceOrder
{
    return ![SMPreferences boolForKey:LOOSE_FRAP_ORDER];
}
+(void)setKeepFrapplianceOrder:(BOOL)arg
{
    [SMPreferences setBool:!arg forKey:LOOSE_FRAP_ORDER];
}
+(NSDictionary *)frapOrderDict
{
    id a = [SMPreferences dictForKey:FRAP_ORDER_DICT];
    return a==nil ? [NSDictionary dictionaryWithObjectsAndKeys:nil] : a;
}
+(NSDictionary *)dictionaryForBundlePath:(NSString *)path
{
    return [NSDictionary dictionaryWithContentsOfFile:[path stringByAppendingPathComponent:@"Contents/Info.plist"]];
}
+(BOOL)customMainMenu
{
    return [SMPreferences boolForKey:CUSTOM_MAIN_MENU];
}
+(void)setCustomMainMenu:(BOOL)state
{
    [SMPreferences setBool:state forKey:CUSTOM_MAIN_MENU];
}
+(NSString *)selectedExtension
{
    return [SMPreferences stringForKey:MM_PLUGIN_SELECTED];
}
+(void)setSelectedExtension:(NSString *)extensionPath
{
    [SMPreferences setString:extensionPath forKey:MM_PLUGIN_SELECTED];
}
+(BOOL)mainMenuBlockPreview
{
    return [SMPreferences boolForKey:MM_BLOCK_PREVIEW];
}
+(void)setMainMenuBlockPreview:(BOOL)state
{
    [SMPreferences setBool:state forKey:MM_BLOCK_PREVIEW];
}
+(void)setMainMenuEdgeFade:(BOOL)state
{
    [SMPreferences setBool:state forKey:MM_EDGE_FADE];
}
+(BOOL)mainMenuEdgeFade
{
    return [SMPreferences boolForKey:MM_EDGE_FADE];
}
+(void)setMainMenuLoadPlugins:(BOOL)state
{
    [SMPreferences setBool:!state forKey:MM_NOT_LOAD_PLUGINS];
}
+(BOOL)mainMenuLoadPlugins
{
    return ![SMPreferences boolForKey:MM_NOT_LOAD_PLUGINS];
}
@end
