//
//  SoftwareSettings.h
//  SoftwareMenu
//
//  Created by Thomas on 11/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMMediaMenuController.h"
////#import <BackRow/BackRow.h>
#define SHOW_HIDE_KEY			@"Show_Hide"


typedef enum {
	
	kSMSetInfo = 0,
	kSMSetToggle = 1,
	kSMSetYNToggle = 2,
	kSMSetSPos = 3,
	kSMSetBlocker = 4,
	kSMSetUpdater = 5,
	kSMSetUntrusted = 6,
	
} SettingType;
@interface SoftwareSettings : SMMediaMenuController 
{
}
- (NSSize)sizeFor1080i;
@end