//
//  SMScreensaverSettingsMenu.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/18/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//



@interface SMScreensaverSettingsMenu : SMMediaMenuController {
	NSMutableArray *	settingNames;
	NSMutableArray *	settingDisplays;
	NSMutableArray *	settingType;
	NSMutableArray *	settingDescriptions;
	NSMutableArray *	settingNumberType;
	NSMutableDictionary *	_dividers;
	
	
}
@end