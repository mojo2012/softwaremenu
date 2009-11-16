//
//  SoftwareSettings.h
//  SoftwareMenu
//
//  Created by Thomas on 11/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#define SHOW_HIDE_KEY			@"Show_Hide"


typedef enum {
	kSMSetSMInfo = -1,
	kSMSetInfo = 0,
	kSMSetToggle = 1,
	kSMSetYNToggle = 2,
	kSMSetSPos = 3,
	kSMSetBlocker = 4,
	kSMSetUpdater = 5,
	kSMSetUntrusted = 6,
	
} SettingType;
@interface SMSettingsMenu : SMMediaMenuController 
{
}
@end