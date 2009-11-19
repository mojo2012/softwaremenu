//
//  SMTweaks.h
//  SoftwareMenu
//
//  Created by Thomas on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>



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
		kSMSSSTimeOut = 5,
        kSMSSSEffect = 6,
        kSMSSSTransition = 7,
        kSMSSSPlaylist = 8,
        kSMSSSPlayMusic = 9,
        kSMSSSShuffleMusic = 10,
        kSMSSSPAZ = 11,
        kSMSSSShufflePhotos=12,
        kSMSSSRepeat = 13,
        kSMSSSUSEA=14,
	}kSMSSSMenu;
@interface SMPhotosSettingsMenu : SMMediaMenuController {
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
@interface SMPlaylistSelection : BRSlideshowSettingsMusicController 
{
    int padding[32];
}
@end






