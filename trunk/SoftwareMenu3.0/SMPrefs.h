//
//  SMPrefs.h
//  SoftwareMenu
//
//  Created by Thomas on 5/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#define myDomain			(CFStringRef)@"com.apple.frontrow.appliance.SoftwareMenu"


@interface SMPreferences : NSObject {

}
+ (BOOL)threePointZeroOrGreater;
+ (NSString *)appleTVVersion;
+ (void)setDate:(NSDate *)inputDict forKey:(NSString *)theKey;
+ (NSDate *)dateForKey:(NSString *)theKey;
+ (int)integerForKey:(NSString *)theKey;
+ (BOOL)boolForKey:(NSString *)theKey;
+ (NSString *)stringForKey:(NSString *)theKey;
+ (NSDictionary *)dictForKey:(NSString *)theKey;
+ (void)setArray:(NSArray *)inputArray forKey:(NSString *)theKey;
+ (void)setDict:(NSDictionary *)inputDict forKey:(NSString *)theKey;
+ (void)setBool:(BOOL)inputBOOL forKey:(NSString *)theKey;
+ (void)setBool:(BOOL)inputBOOL	forKey:(NSString *)theKey forDomain:(NSString *)theDomain;
+ (void)setString:(NSString *)inputString forKey:(NSString *)theKey;
+ (void)setInteger:(int)theInt forKey:(NSString *)theKey;
+ (void)switchBoolforKey:(NSString *)theKey;
+(void)setPlaysMusicInSlideShow:(BOOL)arg;
+(BOOL)playsMusicInSlideShow;
+(NSString *)scriptsPlistPath;
+(NSString *)trustedPlistPath;
+(NSString *)trustedPlistURL;
+(NSString *)ImagesPath;
+(void)setPhotoFavorites:(NSArray *)favorites;
+(NSMutableArray *)photoFavorites;
//+(BOOL)slideshowSS;
+(void)setSlideshowSS:(BOOL)arg1;
+(NSString *)photoFolderPath;
+(void)setPhotoFolderPath:(NSString *)path;
+(NSString *)screensaverFolder;
+(void)setScreensaverFolder:(NSString *)screensaverFolder;
+(long)screensaverSpinFrequency;
+(long)screensaverSecondsPerSlide;
+(void)setScreensaverSecondsPerSlide:(int)arg;
+(BOOL)screensaverPanAndZoom;
+(void)setScreensaverPanAndZoom:(BOOL)arg;
+(BOOL)screensaverShufflePhotos;
+(void)setScreensaverShufflePhotos:(BOOL)arg;
+(BOOL)screensaverRepeat;
+(void)setScreensaverRepeat:(BOOL)arg;
+(NSString *)screensaverSelectedTransitionName;
+(void)setScreensaverSelectedTransitionName:(NSString *)arg;
+(NSString *)slideshowType;
+(BOOL)screensaverUseAppleProvider;
+(void)setScreensaverUseAppleProvider:(BOOL)arg;
+(void)setScreensaverSpinFrequency:(int)freq;
+(BOOL)strictApplianceInstallLimits;
+(NSString *)stringForBool:(BOOL)arg;
+(NSDictionary *)screensaverSlideshowPlaybackOptions;

@end
