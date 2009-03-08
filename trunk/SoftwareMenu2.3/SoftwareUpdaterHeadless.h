//
//  SoftwareUpdaterHeadless.h
//  SoftwareMenu
//
//  Created by Thomas on 10/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <BackRow/BackRow.h>



@interface SoftwareUpdaterHeadless : NSObject {
	NSString *				_DownloadFileNames;
	NSMutableDictionary *	tempFrapsInfo;
	NSURLDownload *         _downloader;
	NSString *              _outputPath;
	long long               _totalLength;
	long long               _gotLength;
	BOOL					STARTING;
	NSString	*			thelog;
}
- (void)writeToLog:(NSString *)str;
- (id) init;
- (BOOL) beginDownload;
- (BOOL) resumeDownload;
- (void) startUpdate;
- (void) parsetrusted;
- (void) cancelDownload;
- (void) deleteDownload;
- (float) percentDownloaded;

- (void) storeResumeData;
- (void) download: (NSURLDownload *) download decideDestinationWithSuggestedFilename: (NSString *) filename;
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
