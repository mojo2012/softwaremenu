//
//  SMTweaks.h
//  SoftwareMenu
//
//  Created by Thomas on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define ROWMOTE_DOMAIN_KEY		@"com.apple.frontrow.appliance.RowmoteHelperATV"



@interface SMTweaks : SMFMediaMenuController {
	NSMutableArray *	settingNames;
	NSMutableArray *	settingDisplays;
	NSMutableArray *	settingDescriptions;
	NSMutableArray *	settingNumberType;
	NSFileManager *		_man;
	
	
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


