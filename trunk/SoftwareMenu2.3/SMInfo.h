//
//  QuDownloadController.h
//  QuDownloader
//
//  Created by Alan Quatermain on 19/04/07.
//  Copyright 2007 AwkwwardTV. All rights reserved.
//
// Updated by nito 08-20-08 - works in 2.x

#import <Foundation/Foundation.h>
//#import <BackRow/BRController.h>
#import <CoreData/CoreData.h>
#define DESCRIPTION_KEY			@"description"
#define TITLE_KEY				@"title"
#define NUMBER_BOXES_KEY		@"numberOfBoxes"

@class BRHeaderControl, BRTextControl,BRScrollingTextControl, BRImageControl, BRPasscodeEntryControl, BRDisplayManager, BRImage;

@interface SMInfo : BRController
{
	int							padding[16];
    BRHeaderControl *			_header;
    BRScrollingTextControl *    _sourceText;
	BRTextControl *				_currentvers;
	BRTextControl *				_onlinevers;
	BRTextControl *				_bakvers;
	BRImageControl *			_sourceImage;
	BRImage		*				_theImage;
	
	NSString *					_theSourceText;
	NSString *					_theDescriptionURL;
	NSString *					_theName;
	NSString *					_theDescription;
	NSMutableArray *			_theVersions;
	NSMutableDictionary *		_passData;
}
-(NSRect)frame;
-(NSSize)sizeFor1080i;

-(id) init;
-(BOOL) isNetworkDependent;
-(void) customStuff;
-(void) setTheName:(NSString *)theName;
-(void) setVersions:(NSString *)theOnlineVersion withBak:(NSString *)theBackupVersion withCurrent:(NSString *)theInstalledVersion;
-(void) setDescriptionWithURL:(NSString *)theDescriptionURL;
-(void) setDescriptionWithFile:(NSString *)theDescriptionFile;
-(void) setDescription:(NSString *)theDescription;
-(void) setBakVers: (NSString *) srcText;
-(void) setCurrVers: (NSString *) srcText;
-(void) setOnlineVers: (NSString *) srcText;
-(void)setTheImage:(BRImage *)theImage;
-(void) drawSelf;


-(id) sourceImage: (NSString *)name;
-(void) appendSourceText:(NSString *)srcText;
-(void) setTitle: (NSString *) title;
-(void) setSourceImage:(NSString *)name;
-(void) setSourceText: (NSString *) text;
-(NSString *) sourceText;
-(NSString *) title;
@end
@interface SMLog : SMInfo
{

}
- (void) drawSelf;
- (void) setSourceText;
@end
