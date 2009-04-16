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
#define ROWMOTE_DOMAIN_KEY		@"com.apple.frontrow.appliance.RowmoteHelperATV"	
typedef enum {
	
	kSMTwDownload= 9,
	kSMTwRestart=0,
	kSMTwFix = 1,
	kSMTwToggle= 2,
	kSMTwInstall = 3,
	kSMTwDownloadPerian = 4,
	kSMTwDownloadRowmote = 5,

} TweakType;
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
	NSMutableArray *	settingNumberType;
	//NSWorkspace *workspace;
	NSFileManager *		_man;
	NSMutableArray *	_items;
	NSMutableArray *	_options;
	
	NSString	   *	_keypress;
	NSMutableDictionary *	_rowmoteDict;
	NSMutableDictionary *	_infoDict;// = [NSMutableDictionary alloc] ;
	NSMutableDictionary *	_show_hide;
	NSFileHandle   *	log;
	
}
-(BOOL)sshStatus;
-(BOOL)VNCIsRunning;
-(BOOL)AFPIsRunning;
-(BOOL)AFPIsInstalled;
//-(BOOL)dropbearIsRunning;
-(BOOL)dropbearIsInstalled;
-(BOOL)getToggleDimmed:(NSString *)title;
-(BOOL)getToggleRightText:(NSString *)title;

-(int)VNCFix;
-(NSString *)getRowmoteVersion;
-(NSString *)getPerianVersion;

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



