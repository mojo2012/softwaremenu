//
//  SoftwareMenu.h
//  QuDownloader
//
//  Created by Thomas on 10/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
////#import <BackRow/BackRow.h>
//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
////#import <BackRow/BRController.h>
#import <CoreData/CoreData.h>
#import <SMDownloaderSTD.h>

@class BRHeaderControl, BRTextControl,BRScrollingTextControl, BRImageControl, SMProgressBarControl;

@interface SMInstallMenu : BRMediaMenuController 
{
	int padding[16];
	NSString *	identifier;
	BOOL		EXISTS;
	//NSString *	current_vers;
	//NSString *	bak_vers;
	BOOL		UPTODATE;
	BOOL		BAK_EXISTS;
	
	NSMutableArray *		_items;
	NSMutableArray *		_options;
	NSFileHandle   *		log;
	NSMutableDictionary *	_theInformation;
	NSFileManager  *		_man;
	
}

-(void)writeToLog:(NSString *)strLog;
-(id)initCustom;
-(void)setInformationDictionary:(NSDictionary *)information;

// Data source methods:
-(float)heightForRow:(long)row;
-(BOOL)rowSelectable:(long)row;
-(long)itemCount;
-(id)itemForRow:(long)row;
-(long)rowForTitle:(id)title;
-(id)titleForRow:(long)row;
-(void)checkVarious;


@end
@interface SMDownloaderInstaller : SMDownloaderSTD 
{
	
}
-(void)processdownload;

@end

