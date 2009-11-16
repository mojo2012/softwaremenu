//
//  SMGeneralMethods.h
//  SoftwareMenu
//
//  Created by Thomas on 3/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
////#import <BackRow/BRController.h>
//#import <BackRowUtilstwo.h>
#import <syslog.h>
#import <Foundation/Foundation.h>
//#import <BackRow/BRLocalizedStringManager.h>
#import "External/AGProcess.h"
#import "BackRowUtilstwo.h"

// plugin-based NSLocalizedString macros
// use genstrings -s BRLocalizedString -o <Language>.lproj to generate Localized.strings

@interface SMGeneralMethods : NSObject {
	
}
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
+ (void)restartFinder;
+ (void)checkFolders;
+ (void)checkScreensaver;
+ (void)terminateFinder;
+ (NSArray *)arrayForKey:(NSString *)theKey;
+ (NSArray *)getPrefKeys;
+ (NSArray *)menuItemOptions;
+ (NSArray *)menuItemNames;
+ (NSArray *)builtinfrapsWithSettings:(BOOL)settings;
+ (int)convertDMG:(NSString *)initLocation toFormat:(NSString *)dmgFormat withOutputLocation:(NSString *)outputLocation;
+ (int)runHelperApp:(NSArray *)options;
+ (SMGeneralMethods *)sharedInstance;
+ (void)helperFixPerm;
- (void)helperFixPerm;
- (BOOL)helperCheckPerm;
+ (BOOL)helperCheckPerm;
- (BOOL)checkblocker;
- (BOOL)usingTakeTwoDotThree;
- (void)helperFixPerm;
- (void)toggleUpdate;
- (void)blockUpdate;
- (NSString *)getImagePathforDict:(NSDictionary *)infoDict;
+ (NSString *)getImagePath:(NSString *)Name;

@end
