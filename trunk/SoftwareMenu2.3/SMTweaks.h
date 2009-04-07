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
/*typedef enum {
	FILE_CLASS_UTILITY= -2,
	FILE_CLASS_NOT_FILE= -1,
	FILE_CLASS_UNKNOWN = 0,
	FILE_CLASS_TV_SHOW = 1,
	FILE_CLASS_MOVIE = 2,
	FILE_CLASS_AUDIO = 3,
	FILE_CLASS_IMAGE = 4,
	FILE_CLASS_OTHER = 5,
} FileClass;*/
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
	//NSWorkspace *workspace;
	NSFileManager *		_man;
	NSMutableArray *	_items;
	NSMutableArray *	_options;
	
	NSString	   *	_keypress;
	NSMutableDictionary *	_infoDict;// = [NSMutableDictionary alloc] ;
	NSMutableDictionary *	_show_hide;
	NSFileHandle   *	log;
	
}
-(BOOL)sshStatus;
-(BOOL)VNCIsRunning;
-(BOOL)AFPIsRunning;
-(BOOL)AFPIsInstalled;
-(BOOL)dropbearIsRunning;
-(BOOL)dropbearIsInstalled;
-(BOOL)getToggleDimmed:(NSString *)title;
-(BOOL)getToggleRightText:(NSString *)title;


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




