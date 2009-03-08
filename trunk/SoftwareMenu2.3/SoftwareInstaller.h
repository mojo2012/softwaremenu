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
#import <SoftwareMenus.h>

@class BRHeaderControl, BRTextControl, QuProgressBarControl;

@interface SoftwareInstaller : BRController
{
	int		padding[16];
    BRHeaderControl *       _header;
    BRTextControl *         _sourceText;
    QuProgressBarControl *  _progressBar;
	NSString *				_urlstr;
	
    NSURLDownload *         _downloader;
    NSString *              _outputPath;
    long long               _totalLength;
    long long               _gotLength;
}
-(NSRect)frame;

+ (void) clearAllDownloadCaches;
+ (NSString *) downloadCachePath;
+ (NSString *) outputPathForURLString: (NSString *) urlstr;
- (BOOL) resumeDownload;
- (void) storeResumeData;
- (id) init;
- (BOOL) beginDownload;
- (void) cancelDownload;
- (void) deleteDownload;

// stack callbacks
- (void) wasPushed;
- (void) willBePopped;
- (BOOL) isNetworkDependent;

- (void) setTitle: (NSString *) title;
- (NSString *) title;

- (void) setSourceText: (NSString *) text;
- (NSString *) sourceText;

- (float) percentDownloaded;


// NSURLDownload delegate methods
- (void) download: (NSURLDownload *) download
decideDestinationWithSuggestedFilename: (NSString *) filename;
- (void) download: (NSURLDownload *) download didFailWithError: (NSError *) error;
- (void) download: (NSURLDownload *) download didReceiveDataOfLength: (unsigned) length;
- (void) download: (NSURLDownload *) download didReceiveResponse: (NSURLResponse *) response;
- (BOOL) download: (NSURLDownload *) download
shouldDecodeSourceDataOfMIMEType: (NSString *) encodingType;
- (void) download: (NSURLDownload *) download
willResumeWithResponse: (NSURLResponse *) response
		 fromByte: (long long) startingByte;
- (void) downloadDidFinish: (NSURLDownload *) download;

@end
