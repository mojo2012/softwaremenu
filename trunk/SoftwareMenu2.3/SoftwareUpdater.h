//
//  SoftwareUpdater.h
//  QuDownloader
//
//  Created by Thomas on 10/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <BackRow/BRController.h>
#import <CoreData/CoreData.h>

@class BRHeaderControl, BRTextControl, QuProgressBarControl;

@interface SoftwareUpdater : BRController 
	{
		int		padding[16];
		BRHeaderControl *       _header;
		BRTextControl *         _sourceText;
		NSString *				_DownloadFileNames;
		NSMutableDictionary *	tempFrapsInfo;
		NSURLDownload *         _downloader;
		NSString *              _outputPath;
		long long               _totalLength;
		long long               _gotLength;
		BOOL					STARTING;
		NSString	*			thelog;
		NSFileHandle *log;
		int i;
		NSMutableArray * urls;
		int total;
	}
- (void)writeToLog:(NSString *)str;

	-(NSRect)frame;
	QuProgressBarControl *  _progressBar;
	+ (void) clearAllDownloadCaches;
	+ (NSString *) downloadCachePath;
	+ (NSString *) outputPathForURLString: (NSString *) urlstr;
	
	- (id) init;
	- (BOOL) beginDownload;
	- (BOOL) resumeDownload;
	- (void) startUpdate;
	- (void) parsetrusted;
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
	
	- (void) storeResumeData;
	
	// NSURLDownload delegate methods
	- (void) download: (NSURLDownload *) download decideDestinationWithSuggestedFilename: (NSString *) filename;
	- (void) download: (NSURLDownload *) download didFailWithError: (NSError *) error;
	- (void) download: (NSURLDownload *) download didReceiveDataOfLength: (unsigned) length;
	- (void) download: (NSURLDownload *) download didReceiveResponse: (NSURLResponse *) response;
	- (BOOL) download: (NSURLDownload *) download shouldDecodeSourceDataOfMIMEType: (NSString *) encodingType;
	- (void) download: (NSURLDownload *) download willResumeWithResponse: (NSURLResponse *) response
fromByte: (long long) startingByte;
	- (void) downloadDidFinish: (NSURLDownload *) download;
	
	@end
