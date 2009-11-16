//
//  SoftwareUpdater.m
//  QuDownloader
//
//  Created by Thomas on 10/19/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

//#import "QuProgressBarControl.h"
#import "BRLocalizedString.h"
////#import <BackRow/BackRow.h>
#import "SoftwareUpdater.h"
#define myDomain			(CFStringRef)@"org.quatermain.downloader"
static NSString  * trustedURL = @"http://web.me.com/tomcool420/Trusted.plist";
#define DEBUG_MODE true


@implementation SoftwareUpdater


- (void) drawSelf

{
	//NSLog(@"=== DrawSelf ====");
	//ditto above comment where urlstr is commented out.
	NSString *urlstr;
	urlstr = trustedURL;
	//NSLog(@"afterURL");
	_header = [[BRHeaderControl alloc] init];
	_sourceText = [[BRTextControl alloc] init];	
	NSRect masterFrame = [self frame];
	NSRect frame = masterFrame;
	//NSLog(@"after frame shit");
	
	// header goes in a specific location
	frame.origin.y = frame.size.height * 0.82f;
	frame.size.height = [[BRThemeInfo sharedTheme] listIconHeight];
	[_header setFrame: frame];
	//NSLog(@"after setting up header");
	NSString *name = NSLocalizedString(@"Download Test",@"Download Test");
	[self setTitle: name];
	[self setSourceText: urlstr];   // this lays itself out	
	// add the controls
	//NSLog(@"after setting up everything");
	[self addControl: _header];
	[self addControl: _sourceText];	
	//NSLog(@"after adding controls");
	
}

- (id) init {
	/*if (DEBUG_MODE)
	{
		log = [NSFileHandle fileHandleForWritingAtPath:@"/Users/frontrow/Updater.log"];
		[log retain];
		[log seekToEndOfFile];
	}*/
	thelog = [[NSString alloc] initWithString:@"thelog"];
	[thelog writeToFile:[@"~/updater.log" stringByExpandingTildeInPath] atomically:YES];
	[self writeToLog:@"init"];
    if ( [super init] == nil )
        return ( nil );
    return ( self );
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
	
	
    [_header release];
    [_sourceText release];
	[_downloader release];
    [_outputPath release];
	
    [super dealloc];
}

/*- (BOOL) beginDownload
{
    if ( _downloader != nil )
        return ( NO );
	
    // see if we can resume from the current data

		urlstr = kDefaultURLString;
    NSURL * url = [NSURL URLWithString: urlstr];
    if ( url == nil )
        return ( NO );
	
    NSURLRequest * req = [NSURLRequest requestWithURL: url
                                          cachePolicy: NSURLRequestUseProtocolCachePolicy
                                      timeoutInterval: 20.0];
	
    // create the dowloader
    _downloader = [[NSURLDownload alloc] initWithRequest: req delegate: self];
    if ( _downloader == nil )
        return ( NO );
	
    [_downloader setDeletesFileUponFailure: NO];
	
    return ( YES );
}*/

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

// stack callbacks
- (void)controlWasActivated;
{
	[self drawSelf];
	[self startUpdate];
	
	
    [super controlWasActivated];
}
-(void)startUpdate
{
	NSFileManager *man = [NSFileManager defaultManager];
	if(![man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/Trusted" stringByExpandingTildeInPath]])
		[man createDirectoryAtPath:[@"~/Library/Application Support/SoftwareMenu/Trusted" stringByExpandingTildeInPath] attributes:nil];
	tempFrapsInfo = [[NSMutableDictionary alloc] initWithDictionary:nil];
	//NSLog(@" ===== startUpdate =====");
	[self writeToLog:@"==== startUpdate ===="];
	[self writeToLog:@"Downloading trusted file"];
	i =0;
	urls=[[NSMutableArray alloc] initWithArray:nil];
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:trustedURL]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	NSURLDownload  *theDownload=[[NSURLDownload alloc] initWithRequest:theRequest delegate:self];
	STARTING = true;
	if (!theDownload) {
	//NSLog(@"shit");
    }
	else{
		//[self parsetrusted];
		//NSLog(@" ==== hello ====");
	}
}
-(void)parsetrusted
{
	/*NSDate *future = [NSDate dateWithTimeIntervalSinceNow: 0.5];
	[NSThread sleepUntilDate:future];*/
	//NSLog(@"===== parsetrusted =====");
	
	[self writeToLog:@"parsing trusted Sources"];
	
	NSArray *loginItemDict = [NSArray arrayWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Trusted/Trusted.plist.xml"]];
	NSEnumerator *enumerator = [loginItemDict objectEnumerator];
	NSString *theURL;
	total = [loginItemDict count];
	total = total +1;
	[self writeToLog:[NSString stringWithFormat:@"total: %d",total]];
	id obj;
	while((obj = [enumerator nextObject]) != nil) 
	{
		theURL = [obj valueForKey:@"theURL"];
		//NSLog(@"theURL: %@", theURL);
		NSString * thelogstring = [[NSString stringWithFormat:@"source: %@  ; ",[obj valueForKey:@"thename"]] stringByAppendingString:[NSString stringWithFormat:@"URL: %@",theURL]];
		[self writeToLog:thelogstring];
		
		NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:theURL]
												  cachePolicy:NSURLRequestUseProtocolCachePolicy
											  timeoutInterval:60.0];
		NSURLDownload  *theDownload=[[NSURLDownload alloc] initWithRequest:theRequest delegate:self];
		
		if (!theDownload) {
			//NSLog(@"shit");
		}
	}
	/*NSString * path = @"/Users/frontrow/Library/Application Support/SoftwareMenu/Trusted/";
	NSFileManager *fileManager = [NSFileManager defaultManager];
	long i, count = [[fileManager directoryContentsAtPath:path] count];	
	NSMutableDictionary *frapsTempDict = [[NSMutableDictionary alloc] initWithDictionary:nil];
	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [[fileManager directoryContentsAtPath:path] objectAtIndex:i];
		//NSLog(@"idStr: %@",idStr);
	}*/
	[self setSourceText:@"done"];
	
}


- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename
{
	//NSLog(@" ===== download =====");
    NSString *destinationFilename;
    NSString *homeDirectory=NSHomeDirectory();
	
    destinationFilename=[[homeDirectory stringByAppendingPathComponent:@"Library/Application Support/SoftwareMenu/Trusted"]
						 stringByAppendingPathComponent:filename];
	_DownloadFileNames = destinationFilename;
	CFPreferencesSetAppValue(CFSTR("theURL"), (CFStringRef)[NSString stringWithString:destinationFilename],kCFPreferencesCurrentApplication);
	//NSLog(@" destionationFilename: %@",destinationFilename);
	[urls addObject:destinationFilename];
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
    //NSLog(@"%@",@"downloadDidFinish");
	[self writeToLog:@"==== Download Finished === "];
	if (STARTING)
	{
		STARTING = false;
		[self parsetrusted];
	}
	else
	{
		//NSLog(@"%d",i);
		NSString *theURL= [urls objectAtIndex:i];
		//NSLog(@"destination filename:%@",theURL);
		[self writeToLog:[NSString stringWithFormat:@"adding links from : %@", theURL]];
		NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:theURL];
		[tempFrapsInfo addEntriesFromDictionary:tempdict];
		
		/*theURL = _DownloadFileNames;
		//NSLog(@"destionation filenames:%@",theURL);*/
		[tempFrapsInfo writeToFile:@"Users/frontrow/Library/Application Support/SoftwareMenu/info2.plist" atomically:YES];
		//[self setsourceText:[[self sourceText] stringByAppendingString:[NSString stringWithFormat:@"\n%@ has been parsed",theURL]]]; 
	}
	i=i+1;
	[self writeToLog:[NSString stringWithFormat:@"i: %d",i]];
	if(i==total)
	{
		[self writeToLog:@"done"];
	}
}


- (void)controlWillDeactivate;
{
    [self cancelDownload];
    [super controlWillDeactivate];
}

- (BOOL) isNetworkDependent
{
    return ( YES );
}

- (void) setTitle: (NSString *) title
{
    [_header setTitle: title];
}

- (NSString *) title
{
    return ( [_header title] );
}
- (void) setSourceText: (NSString *) srcText
{
	//   [_sourceText setTextAttributes: [[BRThemeInfo sharedTheme] paragraphTextAttributes]];
    [_sourceText setText: srcText withAttributes:[[BRThemeInfo sharedTheme] paragraphTextAttributes]];
	
    // layout this item
    NSRect masterFrame = [self frame];
	
	// [_sourceText setMaximumSize: NSMakeSize(masterFrame.size.width * 0.66f,
	//                                       masterFrame.size.height)];
	
    NSSize txtSize = [_sourceText renderedSize];
	
    NSRect frame;
    frame.origin.x = (masterFrame.size.width - txtSize.width) * 0.5f;
    frame.origin.y = (masterFrame.size.height * 0.75f) - txtSize.height;
    frame.size = txtSize;
    
	[_sourceText setFrame: frame];
}

- (NSString *) sourceText
{
    return ( [_sourceText text] );
}


@end
