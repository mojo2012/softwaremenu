//
//  SoftwareMenu.h
//  QuDownloader
//
//  Created by Thomas on 10/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import "SMMediaMenuController.h"
#import <Foundation/Foundation.h>
////#import <BackRow/BackRow.h>
//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
////#import <BackRow/BRController.h>
#import <CoreData/CoreData.h>
#import <SMDownloaderSTD.h>

typedef enum {
	kSMInInfo = 1,
	kSMInLicense = 2,
	kSMInInstall = 4,
	kSMInUpdate = 5,
	kSMInBackup = 6,
	kSMInRemove = 7,
	kSMInRemoveB = 8,
	kSMInRestore = 9,
	kSMInManage = 10,
} InType;
@class BRHeaderControl, BRTextControl,BRScrollingTextControl, BRImageControl, SMProgressBarControl;

@interface SMInstallMenu : SMMediaMenuController 
{
	NSString *	identifier;
	BOOL		EXISTS;
	//NSString *	current_vers;
	//NSString *	bak_vers;
	BOOL		UPTODATE;
	BOOL		BAK_EXISTS;
	

	NSMutableDictionary *	_theInformation;
	NSFileManager		*	_man;

	
}

-(NSString *)installedVersion;
-(NSString *)bakVersion;
-(BOOL) frapExists;
-(BOOL) bakExists;
-(BOOL) frapUpToDate;


@end
@interface SMDownloaderInstaller : SMDownloaderSTD 
{
	
}
-(void)processdownload;

@end

