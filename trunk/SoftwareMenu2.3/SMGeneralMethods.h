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

@interface SMGeneralMethods : NSObject {

}
+ (int)integerForKey:(NSString *)theKey;
+ (BOOL)boolForKey:(NSString *)theKey;
+ (NSString *)stringForKey:(NSString *)theKey;
+ (NSArray *)arrayForKey:(NSString *)theKey;
+ (void)setArray:(NSArray *)inputArray forKey:(NSString *)theKey;
+ (void)setBool:(BOOL)inputBOOL forKey:(NSString *)theKey;
+ (void)setString:(NSString *)inputString forKey:(NSString *)theKey;
+ (void)setInteger:(int)theInt forKey:(NSString *)theKey;
+ (void)switchBoolforKey:(NSString *)theKey;
+ (void)restartFinder;
+ (NSArray *)getPrefKeys;
+ (NSArray *)menuItemOptions;
+ (NSArray *)menuItemNames;


+(SMGeneralMethods *)sharedInstance;
-(BOOL)helperCheckPerm;
-(void)helperFixPerm;
-(void)toggleUpdate;
-(BOOL)usingTakeTwoDotThree;
-(NSString *)getImagePathforDict:(NSDictionary *)infoDict;
-(BOOL)checkblocker;

@end
