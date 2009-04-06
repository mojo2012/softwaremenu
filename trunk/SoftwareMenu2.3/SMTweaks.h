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

@interface SMTweaks : BRMediaMenuController {
	int padding[16];
	NSString *	identifier;
	NSString *	name;
	NSString *	path;
	NSString *	urlstr;
	NSString *	version;
	NSMutableArray *	settingNames;
	NSMutableArray *	settingDisplays;
	NSMutableArray *	settingType;
	NSMutableArray *	settingDescriptions;
	NSWorkspace *workspace;
	
	NSMutableArray *	_items;
	NSMutableArray *	_options;
	
	NSString	   *	_keypress;
	NSMutableDictionary *	_infoDict;// = [NSMutableDictionary alloc] ;
	NSMutableDictionary *	_show_hide;
	NSFileHandle   *	log;
	
}

-(BOOL)VNCIsRunning;
-(BOOL)AFPIsRunning;
-(BOOL)AFPIsInstalled;
-(BOOL)dropbearIsRunning;
-(BOOL)dropbearIsInstalled;
-(BOOL)getToggleDimmed:(NSString *)title;
-(NSString *)getToggleRightText:(NSString *)title;


// Data source methods:
-(float)heightForRow:(long)row;
-(BOOL)rowSelectable:(long)row;
-(long)itemCount;
-(id)itemForRow:(long)row;
-(long)rowForTitle:(id)title;
-(id)titleForRow:(long)row;
-(id)initCustom;

@end
@interface SMDownloaderTweaks : SMDownloaderSTD
{
}

-(void)processdownload;

@end




