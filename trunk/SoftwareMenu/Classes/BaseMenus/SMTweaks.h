//
//  SMTweaks.h
//  SoftwareMenu
//
//  Created by Thomas on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define ROWMOTE_DOMAIN_KEY		@"com.apple.frontrow.appliance.RowmoteHelperATV"

typedef enum {
	
	kSMTwDownload= 9,
	kSMTwRestart=0,
	kSMTwFix = 1,
	kSMTwToggle= 2,
	kSMTwInstall = 3,
	kSMTwDownloadPerian = 4,
	kSMTwDownloadRowmote = 5,
	kSMTwReload	=6,

} TweakType;

@interface SMTweaks : SMFMediaMenuController {
	NSMutableArray *	settingNames;
	NSMutableArray *	settingDisplays;
	NSMutableArray *	settingType;
	NSMutableArray *	settingDescriptions;
	NSMutableArray *	settingNumberType;
	//NSWorkspace *workspace;
	NSFileManager *		_man;
	
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
-(BOOL)getToggleTweak:(SMTweak)tw;
-(BOOL)getToggleDimmed:(SMTweak)tw;

-(int)VNCFix;
-(NSString *)getRowmoteVersion;
-(NSString *)getPerianVersion;

// Data source methods:

//-(id)initCustom;



@end


