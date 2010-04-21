//
//  SMApplianceInstaller (downloaderDelegate).h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/21/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//



@interface SMApplianceInstallerController (downloaderDelegate)

+ (void) clearAllDownloadCaches;
+ (NSString *) downloadCachePath;
+ (NSString *) outputPathForURLString: (NSString *) urlstr;
- (void) setStatusText:(NSString *)text;
- (BOOL) beginDownload;
- (BOOL) resumeDownload;
- (void) cancelDownload;
- (void) deleteDownload;
- (void) download: (NSURLDownload *) download
decideDestinationWithSuggestedFilename: (NSString *) filename;
- (void) download: (NSURLDownload *) download didFailWithError: (NSError *) error;
- (void) download: (NSURLDownload *) download didReceiveDataOfLength: (unsigned) length;
- (void) download: (NSURLDownload *) download didReceiveResponse: (NSURLResponse *) response;
- (BOOL) download: (NSURLDownload *) download shouldDecodeSourceDataOfMIMEType: (NSString *) encodingType;
- (void) download: (NSURLDownload *) download willResumeWithResponse: (NSURLResponse *) response fromByte: (long long) startingByte;
- (void) downloadDidFinish: (NSURLDownload *) download;
+ (NSString *) outputPathForURLString: (NSString *) urlstr;
-(void) processdownload;
@end
