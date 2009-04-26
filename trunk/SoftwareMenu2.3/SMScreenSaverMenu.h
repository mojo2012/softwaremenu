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
#define PHOTO_DIRECTORY_KEY		@"PhotoDirectory"
typedef enum {
	
	kSMSSAbout=0,
	kSMSSStart=1,
	kSMSSSettings=2,
	kSMSSCustomSettings=3,
} SMSSType;
@interface SMScreenSaverMenu : SMMediaMenuController {
	NSMutableArray *	settingNames;
	NSMutableArray *	settingDisplays;
	NSMutableArray *	settingType;
	NSMutableArray *	settingDescriptions;
	NSMutableArray *	settingNumberType;
	NSMutableDictionary *	_dividers;
	NSMutableArray *	paths;
	//NSWorkspace *workspace;
	NSFileManager *		_man;
	//NSMutableArray *	_items;
	//NSMutableArray *	_options;
	NSString *			_tempPath;
	
}



// Data source methods:
/*-(float)heightForRow:(long)row;
-(BOOL)rowSelectable:(long)row;
-(long)itemCount;
-(id)itemForRow:(long)row;
-(long)rowForTitle:(id)title;
-(id)titleForRow:(long)row;
-(id)initCustom;*/



@end
@interface SMScreenSaverDefaultSettings	: BRSlideshowSettingsController
@end






