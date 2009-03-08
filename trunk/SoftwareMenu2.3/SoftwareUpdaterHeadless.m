//
//  SoftwareUpdaterHeadless.m
//  SoftwareMenu
//
//  Created by Thomas on 10/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SoftwareUpdaterHeadless.h"
#import "QuProgressBarControl.h"
#import "BRLocalizedString.h"
#import <BackRow/BackRow.h>
#define myDomain			(CFStringRef)@"org.quatermain.downloader"
static NSString  * trustedURL = @"http://web.me.com/tomcool420/Trusted.plist";


@implementation SoftwareUpdaterHeadless
- (id) init {
	thelog = [[NSString alloc] initWithString:@"thelog"];
	[thelog writeToFile:[@"~/updater.log" stringByExpandingTildeInPath] atomically:YES];
	[self writeToLog:@"init"];
    if ( [super init] == nil )
        return ( nil );
    return ( self );
	
}

-(void)startUpdate
{
	tempFrapsInfo = [[NSMutableDictionary alloc] initWithDictionary:nil];
	[self writeToLog:@"==== startUpdate ===="];
	[self writeToLog:@"Downloading trusted file"];
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:trustedURL]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	NSURLDownload  *theDownload=[[NSURLDownload alloc] initWithRequest:theRequest delegate:self];
	STARTING = true;
	if (!theDownload) {
		NSLog(@"shit");
    }
	else{
		//[self parsetrusted];
		NSLog(@" ==== hello ====");
	}
}

-(void)parsetrusted
{
	/*NSDate *future = [NSDate dateWithTimeIntervalSinceNow: 0.5];
	 [NSThread sleepUntilDate:future];*/
	NSLog(@"===== parsetrusted =====");
	
	[self writeToLog:@"parsing trusted Sources"];
	
	NSArray *loginItemDict = [NSArray arrayWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Trusted/Trusted.plist.xml"]];
	NSEnumerator *enumerator = [loginItemDict objectEnumerator];
	NSString *theURL;
	id obj;
	while((obj = [enumerator nextObject]) != nil) 
	{
		theURL = [obj valueForKey:@"theURL"];
		NSLog(@"theURL: %@", theURL);
		NSString * thelogstring = [[NSString stringWithFormat:@"source: %@  ; ",[obj valueForKey:@"thename"]] stringByAppendingString:[NSString stringWithFormat:@"URL: %@",theURL]];
		[self writeToLog:thelogstring];
		
		NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:theURL]
												  cachePolicy:NSURLRequestUseProtocolCachePolicy
											  timeoutInterval:60.0];
		NSURLDownload  *theDownload=[[NSURLDownload alloc] initWithRequest:theRequest delegate:self];
		
		if (!theDownload) {
			NSLog(@"shit");
		}
	}
	[self writeToLog:@"done"];
}
- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename
{
	NSLog(@" ===== download =====");
    NSString *destinationFilename;
    NSString *homeDirectory=NSHomeDirectory();
	
    destinationFilename=[[homeDirectory stringByAppendingPathComponent:@"Library/Application Support/SoftwareMenu/Trusted"]
						 stringByAppendingPathComponent:filename];
	_DownloadFileNames = destinationFilename;
	CFPreferencesSetAppValue(CFSTR("theURL"), (CFStringRef)[NSString stringWithString:destinationFilename],kCFPreferencesCurrentApplication);
	NSLog(@" destionationFilename: %@",destinationFilename);
	//[[NSFileManager defaultManager]  createDirectoryAtPath: withIntermediateDirectories:YES attributes:nil error:nil];
	//[[NSFileManager defaultManager]  createDirectoryAtPath:[homeDirectory stringByAppendingString:@"/Library/Application Support/SoftwareMenu/Trusted"] withIntermediateDirectories:YES attributes:nil error:nil];
	[download setDestination:destinationFilename allowOverwrite:YES];
}
- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{
    // release the connection
    [download release];
	NSString *theURL= (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"theURL", kCFPreferencesCurrentApplication));
	[self writeToLog:[theURL stringByAppendingString:@" has failed"]];
	if(STARTING)
	{
		[self writeToLog:@"please send me a mail and yell at me"];
	}
    // inform the user
    NSLog(@"Download failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
}
- (void)downloadDidFinish:(NSURLDownload *)download
{
    // release the connection
    [download release];
	
    // do something with the data
    NSLog(@"%@",@"downloadDidFinish");
	[self writeToLog:@"==== Download Finished === "];
	if (STARTING)
	{
		STARTING = false;
		[self parsetrusted];
	}
	else
	{
		NSString *theURL= (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"theURL", kCFPreferencesCurrentApplication));
		NSLog(@"destination filename:%@",theURL);
		[self writeToLog:[NSString stringWithFormat:@"adding links from : %@", theURL]];
		NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:theURL];
		[tempFrapsInfo addEntriesFromDictionary:tempdict];
		/*theURL = _DownloadFileNames;
		 NSLog(@"destionation filenames:%@",theURL);*/
		[tempFrapsInfo writeToFile:@"Users/frontrow/Library/Application Support/SoftwareMenu/info2.plist" atomically:YES];
	}
}
- (void) cancelDownload
{
    [_downloader cancel];
    //[self storeResumeData];
}

- (void) deleteDownload
{
    if ( _outputPath == nil )
        return;
	
    [[NSFileManager defaultManager] removeFileAtPath:
	 [_outputPath stringByDeletingLastPathComponent]
                                             handler: nil];
}
- (void)writeToLog:(NSString *)str
{
	NSString * thelog2 = [[[[NSString alloc] initWithContentsOfFile:[@"~/updater.log" stringByExpandingTildeInPath]] stringByAppendingString:@"\n"] stringByAppendingString:str];
	[thelog2 writeToFile:[@"~/updater.log" stringByExpandingTildeInPath] atomically:YES];
	/*//if (DEBUG_MODE)
	 //{
	 log = [NSFileHandle fileHandleForWritingAtPath:[@"~/updater.log" stringByExpandingTildeInPath]];
	 [log seekToEndOfFile];
	 str = [str stringByAppendingString:@"\n"];
	 NSData *data = [str dataUsingEncoding:NSASCIIStringEncoding];
	 [log writeData:data];
	 [log closeFile];
	 //}*/
}

- (void) dealloc
{
    [self cancelDownload];
	[self writeToLog:@"dealloc"];
	/*if (DEBUG_MODE)
	 {
	 [log closeFile];
	 [log release];
	 }*/
	
	
	[_downloader release];
    [_outputPath release];
	
    [super dealloc];
}

@end
