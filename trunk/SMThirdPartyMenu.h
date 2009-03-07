//
//  SoftwareMenu.h
//  QuDownloader
//
//  Created by Thomas on 10/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import <BackRow/BackRow.h>


@interface SMThirdPartyMenu : BRMediaMenuController 
{
	int padding[16];
	//NSString *	identifier;
	//NSString *	name;
	//NSString *	path;
	//NSString *	urlstr;
	//NSString *	version;
	BOOL		EXISTS;
	//NSString *	current_vers;
	//NSString *	bak_vers;
	BOOL		UPTODATE;
	BOOL		BAK_EXISTS;
	BOOL					STARTING;
	NSMutableDictionary *	tempFrapsInfo;
	NSMutableDictionary *	tempFrapsInfo2;
	int i;
	NSMutableArray * urls;
	NSMutableArray * istrusted;
	int total;
	NSString *				_DownloadFileNames;


	
	NSMutableArray *	_items;
	NSMutableArray *	_options;
	NSFileHandle   *	log;
	
}
- (void) startUpdate;
- (void) parsetrusted;
-(void)writeToLog:(NSString *)strLog;
-(id)initWithIdentifier:(NSString *)initId;
/*-(void)removeFrap;
 -(void)restoreFrap;
 -(void)downloadAndInstall;
 -(void)updateFrap;
-(void)checkVarious;*/
- (void) download: (NSURLDownload *) download decideDestinationWithSuggestedFilename: (NSString *) filename;
- (void) download: (NSURLDownload *) download didFailWithError: (NSError *) error;

// Data source methods:
-(float)heightForRow:(long)row;
-(BOOL)rowSelectable:(long)row;
-(long)itemCount;
-(id)itemForRow:(long)row;
-(long)rowForTitle:(id)title;
-(id)titleForRow:(long)row;


@end
