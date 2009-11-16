//
//  QuDownloader.h
//  QuDownloader
//
//  Created by Alan Quatermain on 19/04/07.
//  Copyright 2007 AwkwardTV. All rights reserved.
//
// Updated by nito 08-20-08 - works in 2.x
//#import <Cocoa/Cocoa.h>

////#import <BackRow/BackRow.h>



#import <CoreData/CoreData.h>
/*@interface ATVSettingsFacade : BRSettingsFacade
- (void)setScreenSaverSelectedPath:(id)fp8;
- (id)screenSaverSelectedPath;
- (id)screenSaverPaths;
- (id)screenSaverCollectionForScreenSaver:(id)fp8;

@end*/

@interface SoftwareMenuBase : BRBaseAppliance
{
    int padding[32];
    NSString *_controlStr;
	NSString *theversion;
	NSString *theURL;
	NSString *thename;
	NSMutableDictionary *scripts;
    NSTimer *checkTimer;
}
- (id) init;
- (void) dealloc;
-(id)getImageForId:(NSString *)idstr;
+ (NSString *) className;
- (id)controllerForIdentifier:(id)fp8;
- (id)applianceCategories;


//- (BRLayerController *) applianceControllerWithScene: (BRRenderScene *) scene;
- (void) appStopping: (NSNotification *) note;

@end
