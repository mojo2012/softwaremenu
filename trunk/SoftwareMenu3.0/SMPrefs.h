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

+(NSString *)scriptsPlistPath;
+(NSString *)trustedPlistPath;
+(NSString *)trustedPlistURL;
+(NSString *)ImagesPath;
+(void)setPhotoFavorites:(NSArray *)favorites;
+(NSArray *)photoFavorites;
//+(BOOL)slideshowSS;
+(void)setSlideshowSS:(BOOL)arg1;
+(NSString *)photoFolderPath;
+(void)setPhotoFolderPath:(NSString *)path;
+(long)screensaverSpinFrequency;
+(NSString *)slideshowType;

@end
