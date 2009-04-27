//
//  SMTweaks.h
//  SoftwareMenu
//
//  Created by Thomas on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

//#import <Cocoa/Cocoa.h>
////#import <BackRow/BackRow.h>
#import <SMDownloaderSTD.h>
#import <Cocoa/Cocoa.h>
//#import <Foundation/Foundation.h>
#import <SoftwareSettings.h>
#import "SMMediaMenuController.h"
#define DEFAULT_IMAGES_PATH		@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/DefaultPhotos/"
#define PHOTO_SPIN_FREQUENCY	@"PhotoSpinFrequency"
#define DEFAULT_SPIN_FREQUENCY	1
typedef enum
	{
		kSMSSSType = 0,
		kSMSSSRotation = 1,
		kSMSSSSlideTime = 4,
		kSMSSSFDefaults = 2,
		kSMSSSDefaultImages = 3,
	}kSMSSSMenu;
@interface SMScreenSaverSettingsMenu : SMMediaMenuController {
	NSMutableArray *	settingNames;
	NSMutableArray *	settingDisplays;
	NSMutableArray *	settingType;
	NSMutableArray *	settingDescriptions;
	NSMutableArray *	settingNumberType;
	NSMutableDictionary *	_dividers;
	NSMutableArray *	paths;
	//NSWorkspace *workspace;
	NSFileManager *		_man;
	
	
}



// Data source methods:

-(id)initCustom;



@end





