//
//  SoftwareInstaller.m
//  QuDownloader
//
//  Created by Thomas on 10/9/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SoftwareInstaller.h"
#import "QuProgressBarControl.h"
#import "BRLocalizedString.h"

@implementation SoftwareInstaller

+ (void) clearAllDownloadCaches
{
    [[NSFileManager defaultManager] removeFileAtPath: [self downloadCachePath]
                                             handler: nil];
}

+ (NSString *) downloadCachePath
{
    static NSString * __cachePath = nil;
	
    if ( __cachePath == nil )
    {
        // find the user's Caches folder
        NSArray * list = NSSearchPathForDirectoriesInDomains( NSCachesDirectory,
															 NSUserDomainMask, YES );
		
        // handle any failures in that API
        if ( (list != nil) && ([list count] != 0) )
            __cachePath = [list objectAtIndex: 0];
        else
            __cachePath = NSTemporaryDirectory( );
		
        __cachePath = [[__cachePath stringByAppendingPathComponent: @"SoftwareMenu"] retain];
		
        // ensure this exists
        [[NSFileManager defaultManager] createDirectoryAtPath: __cachePath
                                                   attributes: nil];
    }
	NSLog(@"cachePath: %@",__cachePath);
    return ( __cachePath );
}

+ (NSString *) outputPathForURLString: (NSString *) urlstr
{
    NSString * cache = [self downloadCachePath];
    NSString * name = [urlstr lastPathComponent];
	
    // trim any parameters from the URL
    NSRange range = [name rangeOfString: @"?"];
    if ( range.location != NSNotFound )
        name = [name substringToIndex: range.location];
	
    NSString * folder = [[name stringByDeletingPathExtension]
                         stringByAppendingPathExtension: @"download"];
	
    return ( [NSString pathWithComponents: [NSArray arrayWithObjects: cache,
											folder, name, nil]] );
}

-(void) drawSelf
{
	
	_header = [[BRHeaderControl alloc] init];
	_sourceText=[[BRTextControl alloc] init];
	_progressBar=[[QuProgressBarControl alloc] init];
	_outputPath=[[SoftwareInstaller outputPathForURLString:urlstr] retain];
	NSLog(@"setting up frame");
	NSRect masterFrame = [self frame];
	NSRect frame = masterFrame;
	frame.origin.y = frame.size.height *0.82f;
	frame.size.height = [[BRThemeInfo sharedTheme] listIconHeight];
	[_header setFrame: frame];
	
	
	frame.size.width = masterFrame.size.width * 0.45f;
	frame.size.height = ceilf( frame.size.width * 0.068f );
	frame.origin.x = (masterFrame.size.width - frame.size.width) * 0.5f;
	frame.origin.y = masterFrame.origin.y + (masterFrame.size.height * (1.0f / 8.0f));
	[_progressBar setFrame: frame];
	
	
	[self setTitle:tHEname];
	NSLog(@"%@",urlstr);
	[self setSourceText:urlstr];
	[_progressBar setCurrentValue:[_progressBar minValue]];
	
	[self addControl:_header];
	[self addControl:_sourceText];
	[self addControl:_progressBar];
}
- (id) init
{
	
    if ( [super init] == nil )
        return ( nil );
	NSLog(@"Download init");
	urlstr = (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"urlstr", kCFPreferencesCurrentApplication));
	[urlstr writeToFile:@"/Users/frontrow/path5.txt" atomically:YES];
	tHEname = (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"name", kCFPreferencesCurrentApplication));
	version	= (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"version", kCFPreferencesCurrentApplication));
	NSLog(@"values imported");
	
	return (self);
}
- (void) dealloc
{
    [self cancelDownload];
	
    [_header release];
    [_sourceText release];
    [_progressBar release];
    [_downloader release];
    [_outputPath release];
	
    [super dealloc];
}
- (BOOL) beginDownload
{
    if ( _downloader != nil )
        return ( NO );
	[self deleteDownload];
	
	NSLog(urlstr);
	
    NSURL * url = [NSURL URLWithString: _urlstr];
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
}
- (void) cancelDownload
{
    [_downloader cancel];
}
- (void) deleteDownload
{
    if ( _outputPath == nil )
        return;
	
    [[NSFileManager defaultManager] removeFileAtPath:
	 [_outputPath stringByDeletingLastPathComponent]
                                             handler: nil];
}

- (void)controlWasActivated;
{
	[self drawSelf];
	
    if ( [self beginDownload] == NO )
    {
        [self setTitle: @"Download Failed"];
		[self setSourceText:@"Is your internet connected ... maybe the plist isn't up to date... send an email"];
        [_progressBar setPercentage: 0.0f];
    }
	
    [super controlWasActivated];
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
	NSLog(@"setting title");
    [_header setTitle: title];
}
- (NSString *) title
{
	NSLog(@"checking title");
    return ( [_header title] );
}

- (void) setSourceText: (NSString *) srcText
{
	NSLog(@"setting source text");
    [_sourceText setText: srcText withAttributes:[[BRThemeInfo sharedTheme] paragraphTextAttributes]];
	
    // layout this item
    NSRect masterFrame = [self frame];
    CGSize txtSize = [_sourceText renderedSize];
	
    CGRect frame;
    frame.origin.x = (masterFrame.size.width - txtSize.width) * 0.5f;
    frame.origin.y = (masterFrame.size.height * 0.75f) - txtSize.height;
    frame.size = txtSize;
    
	[_sourceText setFrame: frame];
}
- (NSString *) sourceText
{
	NSLog(@"checking source text");
    return ( [_sourceText text] );
}
- (void) storeResumeData
{
    NSData * data = [_downloader resumeData];
    if ( data != nil )
    {
		// store this in the .download folder
        NSString * path = [[_outputPath stringByDeletingLastPathComponent]
                           stringByAppendingPathComponent: @"ResumeData"];
        [data writeToFile: path atomically: YES];
    }
}

// NSURLDownload delegate methods
- (void) download: (NSURLDownload *) download

decideDestinationWithSuggestedFilename: (NSString *) filename
{
	NSLog(@"starting download");
    // we'll ignore the given filename and use our own
    // they'll likely be the same, anyway
	
    // ensure that all new path components exist
    [[NSFileManager defaultManager] createDirectoryAtPath: [_outputPath stringByDeletingLastPathComponent]
                                               attributes: nil];
	
    NSLog(
		  @"Starting download to file '%@'", _outputPath );
	
    [download setDestination: _outputPath allowOverwrite: YES];
}

- (void) download: (NSURLDownload *) download didFailWithError: (NSError *) error
{
    [self storeResumeData];
	
    NSLog( @"Download encountered error '%d' (%@)", [error code],
		  [error localizedDescription] );
	
    // show an alert for the returned error (hopefully it has nice
    // localized reasons & such...)
    BRAlertController * obj = [BRAlertController alertForError: error
                                                     withScene: [self scene]];
    [[self stack] swapController: obj];
}

- (void) download: (NSURLDownload *) download didReceiveDataOfLength: (unsigned) length
{
    _gotLength += (long long) length;
    float percentage = 0.0f;
	
    //NSLog( @"Got %u bytes, %lld total", length, _gotLength );
	
    // we'll handle the case where the NSURLResponse didn't include the
    // size of the source file
    if ( _totalLength == 0 )
    {
        // bump up the max value a bit
        percentage = [_progressBar percentage];
        if ( percentage >= 95.0f )
            [_progressBar setMaxValue: [_progressBar maxValue] + (float) (length << 3)];
    }
	
    [_progressBar setCurrentValue: _gotLength];
}

- (void) download: (NSURLDownload *) download didReceiveResponse: (NSURLResponse *) response
{
    // we might receive more than one of these (if we get redirects,
    // for example)
    _totalLength = 0;
    _gotLength = 0;
	
    NSLog( @"Got response for new download, length = %lld", [response expectedContentLength] );
	
    if ( [response expectedContentLength] != NSURLResponseUnknownLength )
    {
        _totalLength = [response expectedContentLength];
        [_progressBar setMaxValue: (float) _totalLength];
    }
    else
    {
        // an arbitrary number -- one megabyte
        [_progressBar setMaxValue: 1024.0f * 1024.0f];
    }
}

- (BOOL) download: (NSURLDownload *) download
shouldDecodeSourceDataOfMIMEType: (NSString *) encodingType
{
    NSLog( @"Asked to decode data of MIME type '%@'", encodingType );
	
    // we'll allow decoding only if it won't interfere with resumption
    if ( [encodingType isEqualToString: @"application/gzip"] )
        return ( NO );
	
    return ( YES );
}

- (void) download: (NSURLDownload *) download
willResumeWithResponse: (NSURLResponse *) response
		 fromByte: (long long) startingByte
{
    // resuming now, so pretty much as above, except we have a starting
    // value to set on the progress bar
    _totalLength = 0;
    _gotLength = (long long) startingByte;
	
    // the total here seems to be the amount *remaining*, not the
    // complete total
	
    NSLog( @"Resumed download at byte %lld, remaining is %lld",
		  _gotLength, [response expectedContentLength] );
	
    if ( [response expectedContentLength] != NSURLResponseUnknownLength )
    {
        _totalLength = _gotLength + [response expectedContentLength];
        [_progressBar setMaxValue: (float) _totalLength];
    }
    else
    {
        // an arbitrary number
        [_progressBar setMaxValue: (float) (_gotLength << 1)];
    }
	
    // reset current value as appropriate
    [_progressBar setCurrentValue: (float) _gotLength];
}

- (void) downloadDidFinish: (NSURLDownload *) download
{
    // completed the download: set progress full (just in case) and
    // go do something with the data
    [_progressBar setPercentage: 100.0f];
	//NSString * donedone =@"download done";
	[self setSourceText: @"download done"];
	NSString * thename= (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"name", kCFPreferencesCurrentApplication));
	NSString * theurlstr= (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"urlstr", kCFPreferencesCurrentApplication));
    NSString * name = [urlstr lastPathComponent];
	NSString * folder = [[name stringByDeletingPathExtension]
                         stringByAppendingPathExtension: @"download"];
	NSString * thearguments =[[NSString alloc] stringWithFormat:@"%@ %@",thename,folder];
	NSLog(@"%@",thearguments);
	[NSTask launchedTaskWithLaunchPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"install" ofType:@"sh"] arguments:[NSArray arrayWithObject:name]];
	
	/*NSTask *theProcess;
	 theProcess = [[NSTask alloc] init];
	 
	 [theProcess setLaunchPath:@"/usr/bin/mv"];
	 // Path of the shell command we'll execute
	 [theProcess setArguments:
	 [NSArray arrayWithObjects:@"/Users/frontrow/Library/Caches/QuDownloads/Sapphire_1.0b6.4.download/Sapphire_1.0b6.4.sh",@"/Users/frontrow/Sapphire_1.0b6.4.sh"]];
	 // Arguments to the command: the name of the
	 // Applications directory
	 
	 [theProcess launch];
	 // Run the command
	 
	 [theProcess release];*/
	
    NSLog( @"Download finished" );
	
    // we'll swap ourselves off the stack here, so let's remove our
    // reference to the downloader, just in case calling -cancel now
    // might cause a problem
    [_downloader autorelease];
    _downloader = nil;


	
}


@end
