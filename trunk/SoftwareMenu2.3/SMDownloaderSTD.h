//
//  QuDownloadController.h
//  QuDownloader
//
//  Created by Alan Quatermain on 19/04/07.
//  Copyright 2007 AwkwwardTV. All rights reserved.
//
// Updated by nito 08-20-08 - works in 2.x

#import <Foundation/Foundation.h>
////#import <BackRow/BRController.h>
#import <CoreData/CoreData.h>


@class BRHeaderControl, BRTextControl,BRScrollingTextControl, BRImageControl, SMProgressBarControl;

@interface SMDownloaderSTD : BRController
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
	NSMutableDictionary *	_theInformation;
	int m_screen_saver_timeout;
}

+ (void) clearAllDownloadCaches;
+ (NSString *) downloadCachePath;
+ (NSString *) outputPathForURLString: (NSString *) urlstr;

- (id) init;
- (BOOL) beginDownload;
- (BOOL) resumeDownload;
- (void) cancelDownload;
- (void) deleteDownload;

// stack callbacks
- (BOOL) isNetworkDependent;
-(id)initCustom;
-(void)setInformationDict:(NSMutableDictionary *)infoDict;
- (void) setFileURL:(NSString *)downloadURL;

- (void) setFileText:(NSString *)downloadText;

- (void) setdownloadTitle:(NSString *)downloadName;

- (void) setTitle: (NSString *) title;
- (NSString *) title;
- (void) setSourceImage:(NSString *)name;
- (id) sourceImage;
- (void) setSourceText: (NSMutableString *) text;
- (NSString *) sourceText;
- (void) processdownload;
- (float) percentDownloaded;

- (void) storeResumeData;
- (void) appendSourceText:(NSString *)srcText;

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
