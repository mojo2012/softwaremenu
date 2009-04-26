//
//  SoftwareScriptsMenu.h
//  QuDownloader
//
//  Created by Thomas on 10/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
////#import <BackRow/BackRow.h>
#import "SMMediaMenuController.h"
#define SCRIPTS_PREFS		@"/Users/frontrow/Library/Application Support/SoftwareMenu/scriptsprefs.plist"
@interface SMScriptsMenu : SMMediaMenuController 
{
	NSMutableDictionary *	_runoption;
}

-(id)initCustom;
// Data source methods:
@end