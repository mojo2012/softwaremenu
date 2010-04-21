//
//  SMPrefs.h
//  SoftwareMenuFramework
//
//  Created by Thomas on 5/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


extern const NSString * kSMFBla;
@interface SMFPreferences : NSObject {

}
+ (BOOL)threePointZeroOrGreater;
+ (BOOL)twoPointThreeOrGreater;
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
+ (NSDictionary *)dictionaryForBundlePath:(NSString *)path;
+ (NSString *)ImagesPath;
+ (NSString *)stringForBool:(BOOL)arg;
+ (NSDictionary *)dictionaryForBundlePath:(NSString *)path;
+ (void)terminateFinder;
@end
