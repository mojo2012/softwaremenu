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


@class BRHeaderControl, BRTextControl,BRScrollingTextControl, BRImageControl;

@interface SMInfo : BRController
{
	int							padding[16];
    BRHeaderControl *			_header;
    BRScrollingTextControl *    _sourceText;
	BRTextControl *				_currentvers;
	BRTextControl *				_onlinevers;
	BRTextControl *				_bakvers;
	BRImageControl *			_sourceImage;
	
	NSString *					_theSourceText;
	NSString *					_theDescriptionURL;
	NSString *					_theName;
	NSString *					_theDescription;
	NSMutableArray *			_theVersions;
}
-(NSRect)frame;

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
