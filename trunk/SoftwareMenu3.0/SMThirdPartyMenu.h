//
//  SoftwareMenu.h
//  QuDownloader
//
//  Created by Thomas on 10/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//


typedef enum 
	{
		kSMTpCheck = 1,
		kSMTpRefresh = 2,
		kSMTpRestart = 3,
		kSMTpSm =4,
		KSMTpTrusted =5,
		kSMTpUntrusted =6,
	} TPMenuTypes;

@interface SMThirdPartyMenu : SMMediaMenuController 
{
	NSMutableDictionary *	tempFrapsInfo;
	NSMutableDictionary *	tempFrapsInfo2;
	NSMutableArray * istrusted;
	NSFileManager *		_man;
	
	
}
- (void) startUpdate;
-(void)writeToLog:(NSString *)strLog;
-(id)initWithIdentifier:(NSString *)initId;
-(id)initCustom;
-(void) getImages:(id)dictionary;




@end
