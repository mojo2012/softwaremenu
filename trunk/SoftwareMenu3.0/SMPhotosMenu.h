//
//  SMTweaks.h
//  SoftwareMenu
//
//  Created by Thomas on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//



typedef enum {
	
	kSMSSAbout=0,
	kSMSSStart=1,
	kSMSSSettings=2,
	kSMSSCustomSettings=3,
} SMSSType;
@interface SMPhotosMenu : SMMediaMenuController {
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
-(id)initCustom;


// Data source methods:
/*-(float)heightForRow:(long)row;
-(BOOL)rowSelectable:(long)row;
-(long)itemCount;
-(id)itemForRow:(long)row;
-(long)rowForTitle:(id)title;
-(id)titleForRow:(long)row;
-(id)initCustom;*/



@end

/*@interface BRPhotoCollectionDataStore : BRDataStore

+ (id)dataStoreWithCollection:(id)arg1;
- (id)initWithPhotoCollection:(id)arg1;
- (void)dealloc;
- (id)collection;
- (BOOL)storeAppliesToObject:(id)arg1;
- (id)data;

@end*/


//@interface SMScreenSaverDefaultSettings	: BRSlideshowSettingsController
//@end






