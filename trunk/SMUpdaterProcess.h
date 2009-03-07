//
//  QuDownloadController.h
//  QuDownloader
//
//  Created by Alan Quatermain on 19/04/07.
//  Copyright 2007 AwkwwardTV. All rights reserved.
//
// Updated by nito 08-20-08 - works in 2.x

#import <Foundation/Foundation.h>
#import <BackRow/BRController.h>
#import <CoreData/CoreData.h>


@class BRHeaderControl, BRTextControl,BRScrollingTextControl, BRImageControl, SMProgressBarControl;

@interface SMUpdaterProcess : BRController
{
	int		padding[16];
    BRHeaderControl *       _header;
    BRScrollingTextControl *         _sourceText;
	BRImageControl *		_sourceImage;
    SMProgressBarControl *  _progressBar;
	
    NSURLDownload *         _downloader;
    NSString *              _outputPath;
    long long               _totalLength;
    long long               _gotLength;
	NSMutableString *				_theSourceText;
	NSString *				_downloadURL;
	NSString *				_downloadTitle;
	NSString *				_downloadText;
	NSDictionary *			_updateData;
	int m_screen_saver_timeout;
}
-(NSRect)frame;
-(void)processFiles;


- (id) init;

- (int)makeASRscan:(NSString *)drivepath;

// stack callbacks
- (void) wasPushed;
- (void) willBePopped;
- (BOOL) isNetworkDependent;
-(void)initCustom;
- (void)moveFiles2;
- (void)setUpdateData:(NSDictionary *)updatedata;
- (void) setFileURL:(NSString *)downloadURL;

- (void) setFileText:(NSString *)downloadText;

- (void) setdownloadTitle:(NSString *)downloadName;

- (void) setTitle: (NSString *) title;
- (NSString *) title;
- (void) setSourceImage:(NSString *)name;
- (id) sourceImage;
- (void) setSourceText: (NSMutableString *) text;
- (NSString *) sourceText;
-(void) processdownload;
- (float) percentDownloaded;

- (void) storeResumeData;
- (void) appendSourceText:(NSString *)srcText;

// NSURLDownload delegate methods

@end
