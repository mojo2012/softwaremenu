//
//  SoftwareScriptsMenu.h
//  QuDownloader
//
//  Created by Thomas on 10/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

#define SCRIPTS_PREFS		@"/Users/frontrow/Library/Application Support/SoftwareMenu/scriptsprefs.plist"
@interface SMScriptsMenu : SMFMediaMenuController 
{
	NSMutableDictionary *	_runoption;
    NSMutableArray      *   _scripts;
    NSMutableArray      *   _optionScripts;
}

-(id)initCustom;
+(NSArray *)scripts;
+(void)runScript:(NSString *)path displayResult:(BOOL)display;
+(void)runScript:(NSString *)path displayResult:(BOOL)display asRoot:(BOOL)root;
@end