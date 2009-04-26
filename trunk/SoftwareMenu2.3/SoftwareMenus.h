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

#import <Foundation/Foundation.h>


#import <CoreData/CoreData.h>


@interface SoftwareMenus : BRBaseAppliance
{
	NSString *theversion;
	NSString *theURL;
	NSString *thename;
	NSMutableDictionary *scripts;
}

- (id) init;
- (void) dealloc;

+ (NSString *) className;
- (id)controllerForIdentifier:(id)fp8;
- (id)applianceCategories;


//- (BRLayerController *) applianceControllerWithScene: (BRRenderScene *) scene;
- (void) appStopping: (NSNotification *) note;

@end
