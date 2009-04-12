//
//  SMGeneralMethods.h
//  SoftwareMenu
//
//  Created by Thomas on 3/1/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
////#import <BackRow/BRController.h>
#import <BackRowUtilstwo.h>
#define BASE_URL					@"http://web.me.com/tomcool420/SoftwareMenu/"
#define FRAP_PATH					@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/"
#define BAK_PATH					@"/Users/frontrow/Documents/Backups/"
#define SCRIPTS_FOLDER				@"/Users/frontrow/Documents/scripts/"
#define NAME_KEY					@"name_key_image"
#define TYPE_KEY					@"type_key_image"
#define SCRIPT_KEY					@"script_key_image"
#define MISC_KEY					@"misc_key_image"
#define FRAP_KEY					@"frap_key_image"
#define SM_KEY						@"software_menu_key_image"
#define LAYER_TYPE					@"layer_type"
#define LAYER_NAME					@"layer_name"
#define LAYER_DISPLAY				@"layer_display"
#define LAYER_INT					@"layer_integer"
#define UPDATE_URL					@"http://web.me.com/tomcool420/SoftwareMenu/updates.plist"
#define TRUSTED_URL					@"http://web.me.com/tomcool420/Trusted2.plist"
#define PLUGINS						@"plugins"

@interface SMGeneralMethods : NSObject {
	
}
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
+ (NSArray *)arrayForKey:(NSString *)theKey;
+ (NSArray *)getPrefKeys;
+ (NSArray *)menuItemOptions;
+ (NSArray *)menuItemNames;
+ (NSArray *)builtinfrapsWithSettings:(BOOL)settings;
+ (int)convertDMG:(NSString *)initLocation toFormat:(NSString *)dmgFormat withOutputLocation:(NSString *)outputLocation;
+ (int)runHelperApp:(NSArray *)options;
+ (SMGeneralMethods *)sharedInstance;
+ (BOOL)helperFixPerm;
- (BOOL)helperCheckPerm;
- (BOOL)checkblocker;
- (BOOL)usingTakeTwoDotThree;
- (void)helperFixPerm;
- (void)toggleUpdate;
- (void)blockUpdate;
- (NSString *)getImagePathforDict:(NSDictionary *)infoDict;

@end
