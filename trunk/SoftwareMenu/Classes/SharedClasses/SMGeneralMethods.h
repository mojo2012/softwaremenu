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

#import "BackRowUtilstwo.h"
typedef enum _SMMountTypes{
    SMAFPMount = 0,
    SMNFSMount = 1,
    SMSMBMount = 2,
} SMMountTypes;
// plugin-based NSLocalizedString macros
// use genstrings -s BRLocalizedString -o <Language>.lproj to generate Localized.strings

@interface SMGeneralMethods : NSObject {
	NSData *address;
    NSNetServiceBrowser *browser;
    NSMutableArray *services;
    
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
- (void)checkFolders;
+ (void)checkScreensaver;
+ (void)terminateFinder;
+ (NSArray *)arrayForKey:(NSString *)theKey;
+ (NSArray *)getPrefKeys;

+ (NSArray *)builtinfrapsWithSettings:(BOOL)settings;
+ (int)convertDMG:(NSString *)initLocation toFormat:(NSString *)dmgFormat withOutputLocation:(NSString *)outputLocation;
+ (int)runHelperApp:(NSArray *)options;

+ (SMGeneralMethods *)sharedInstance;

#pragma mark NETWORK_SHIT
- (BOOL)mountManualPointWithDictionary:(NSDictionary *)theDict;
- (BOOL)mountManualPointWithDictionary:(NSDictionary *)theDict returnString:(NSString * *)rstring;
- (BOOL)mountManualPointWithDictionary:(NSDictionary *)theDict softLink:(BOOL)link returnString:(NSString * *)rstring;
- (BOOL)mountPoint:(NSString *)inpoint atPoint:(NSString *)outPoint ofType:(int)theType returnString:(NSString * *)string;

#pragma mark SYSTEM_SHIT
- (BOOL)linkDirectory:(NSString *)theDir toPath:(NSString *)thePath;

#pragma mark Helper Permissions (move to helperManager)
+ (void)helperFixPerm;
- (void)helperFixPerm;
- (BOOL)helperCheckPerm;
+ (BOOL)helperCheckPerm;
- (BOOL)SMHelperCheckPerm;


+ (BOOL)pythonIsInstalled;
+ (NSString *)defaultScriptsDirectory;
- (BOOL)checkblocker;
- (BOOL)usingTakeTwoDotThree;
- (void)helperFixPerm;
- (void)toggleUpdate;
- (void)blockUpdate;
- (NSString *)getImagePathforDict:(NSDictionary *)infoDict;
+ (NSString *)getImagePath:(NSString *)Name;
-(BOOL)isRW;
+(void)checkPhotoDirPath;
+ (BOOL)isWithinRangeForDict:(NSDictionary *)dict;
+ (BOOL)isWithinRangeWithMin:(NSString *)osMin withMax:(NSString *)osMax;
+ (BOOL)OSGreaterThan:(NSString *)value;
+ (BOOL)OSLessThan:(NSString *)value;
+(int)remoteActionForBREvent:(BREvent *)event;
+(NSString *)checkUpdatesPath;
+ (BOOL)isLocalDrive:(NSString *)theDrive;

@end
