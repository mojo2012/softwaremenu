//
//  QuDownloadController.m
//  QuDownloader
//
//  Created by Alan Quatermain on 19/04/07.
//  Copyright 2007 AwkwardTV. All rights reserved.
//
// Updated by nito 08-20-08 - works in 2.x

#import "SMUpdaterDownloader.h"
#import "SMProgressBarControl.h"
#import "BRLocalizedString.h"
#import <BackRow/BackRow.h>


#define myDomain			(CFStringRef)@"org.quatermain.downloader"
static NSString * finalName = nil;
static NSString  const * kDefaultURLString = @"http://www.google.com";

@implementation SMUpdaterDownloader
/*- (void) disableScreenSaver{
 //store screen saver state and disable it
 //!!BRSettingsFacade setScreenSaverEnabled does change the plist, but does _not_ seem to work
 m_screen_saver_timeout = [[BRSettingsFacade singleton] screenSaverTimeout];
 [[BRSettingsFacade singleton] setScreenSaverTimeout:-1];
 [[BRSettingsFacade singleton] flushDiskChanges];
 }
 - (void) enableScreenSaver{
 //reset screen saver to user settings
 [[BRSettingsFacade singleton] setScreenSaverTimeout: m_screen_saver_timeout];
 [[BRSettingsFacade singleton] flushDiskChanges];
 }*/
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
		
        __cachePath = [[__cachePath stringByAppendingPathComponent: @"SoftDownloads"] retain];
		
        // ensure this exists
        [[NSFileManager defaultManager] createDirectoryAtPath: __cachePath
                                                   attributes: nil];
    }
	
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
	NSLog(@"output path: %@",[NSString pathWithComponents: [NSArray arrayWithObjects: cache,
															folder, name, nil]]);
    return ( [NSString pathWithComponents: [NSArray arrayWithObjects: cache,
											folder, name, nil]] );
}

- (void) drawSelf

{
	NSString *urlstr;
	urlstr = (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"urlstr", kCFPreferencesCurrentApplication));
	//	 forDomain: @"org.quatermain.downloader"];
	
	
	if ( urlstr == nil )
		urlstr = kDefaultURLString;
	
	_theSourceText = [[NSMutableString alloc] initWithString:_updatename];
	_header = [[BRHeaderControl alloc] init];
	_sourceText = [[BRScrollingTextControl alloc] init];
	_progressBar = [[SMProgressBarControl alloc] init];
	_sourceImage = [[BRImageControl alloc] init];
	[self addControl: _sourceImage];
	//_outputPath = [[SMUpdaterDownloader outputPathForURLString: urlstr] retain];
	
	// lay out our UI
	NSRect masterFrame = [[self parent] frame];
	NSRect frame = masterFrame;
	
	// header goes in a specific location
	frame.origin.y = frame.size.height * 0.82f;
	frame.size.height = [[BRThemeInfo sharedTheme] listIconHeight];
	[_header setFrame: frame];
	
	// progress bar goes in a specific place too (one-eighth of the way
	// up the screen)
	frame.size.width = masterFrame.size.width * 0.45f;
	frame.size.height = ceilf( frame.size.width * 0.068f );
	frame.origin.x = (masterFrame.size.width - frame.size.width) * 0.5f;
	frame.origin.y = masterFrame.origin.y + (masterFrame.size.height * (1.0f / 8.0f));
	[_progressBar setFrame: frame];

	//NSLog(@"name : %@",name);
	NSString *name =@"ATVFiles";
	[self setTitle: name];
	[self setSourceImage: name];
	
	[self setSourceText: @"Downloading Files required"];   // this lays itself out
	//[self appendSourceText: urlstr];
	[_progressBar setCurrentValue: [_progressBar minValue]];
	
	// add the controls
	[self addControl: _header];
	[self addControl: _sourceText];
	[self addControl: _progressBar];
	
	
	
}


- (id) init {
    if ( [super init] == nil )
        return ( nil );
	finalName =  (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"name", kCFPreferencesCurrentApplication));
    return ( self );
}

-(NSString *)getURLstr:(int)value
{
	NSString *theURL;
	switch (value) {
		case 1:
			theURL = [[_xmldata valueForKey:@"OS"]valueForKey:@"UpdateURL"];
			break;
		case 2:
			theURL = [[_xmldata valueForKey:@"EFI"]valueForKey:@"UpdateURL"];
			break;
		case 3:
			theURL = [[_xmldata valueForKey:@"EFI"]valueForKey:@"InstallerURL"];
			break;
		case 4:
			theURL = [[_xmldata valueForKey:@"IR"]valueForKey:@"UpdateURL"];
			break;
		case 5:
			theURL = [[_xmldata valueForKey:@"IR"]valueForKey:@"InstallerURL"];
			break;
		case 6:
			theURL = [[_xmldata valueForKey:@"SI"]valueForKey:@"InstallerURL"];
			break;
		case 7:
			theURL = [[_xmldata valueForKey:@"SI"]valueForKey:@"UpdateURL"];
			break;
		default:
			break;
			
	}
	downloadnumber++;
	return theURL;
}
- (void) dealloc
{
    [self cancelDownload];
	
    [_header release];
    [_sourceText release];
    [_progressBar release];
    [_downloader release];
    [_outputPath release];
	[_sourceImage release];
	
    [super dealloc];
}

- (BOOL) beginDownload
{
    if ( _downloader != nil )
        return ( NO );
	
    // see if we can resume from the current data
    /*if ( [self resumeDownload] == YES )
        return ( YES );*/
	
    // didn't work, delete & try again
    [self deleteDownload];
	NSString *urlstr = [self getURLstr:downloadnumber];
	_outputPath = [[SMUpdaterDownloader outputPathForURLString: urlstr] retain];
	//NSString *urlstr;
	//urlstr =  (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"urlstr", kCFPreferencesCurrentApplication));
	
    if ( urlstr == nil )
		urlstr = kDefaultURLString;
	//[self disableScreenSaver];
	
	//NSLog(@"urlstr in beginDownload: %@",urlstr);
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
}

- (BOOL) resumeDownload
{
    if ( _outputPath == nil )
        return ( NO );
	
    NSString * resumeDataPath = [[_outputPath stringByDeletingLastPathComponent]
                                 stringByAppendingPathComponent: @"ResumeData"];
    if ( [[NSFileManager defaultManager] fileExistsAtPath: resumeDataPath] == NO )
        return ( NO );
	
    NSData * resumeData = [NSData dataWithContentsOfFile: resumeDataPath];
    if ( (resumeData == nil) || ([resumeData length] == 0) )
        return ( NO );
	
    // try to initialize using the saved data...
    _downloader = [[NSURLDownload alloc] initWithResumeData: resumeData
                                                   delegate: self
                                                       path: _outputPath];
    if ( _downloader == nil )
        return ( NO );
	
    [_downloader setDeletesFileUponFailure: NO];
	
    return ( YES );
}

- (void) cancelDownload
{
    [_downloader cancel];
    [self storeResumeData];
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
/*- (void)controlWillActivate
 {
 [self wasPushed];
 }
 -(void)wasPushed
 {
 [self controlWasActivated];
 }*/
- (void)initCustom:(NSDictionary *)xmldata withname:(NSString *)initname
{
	_xmldata=[xmldata mutableCopy];
	_updatename=initname;
	
}


- (void)controlWasActivated
{	
	downloadnumber =1;
	[self drawSelf];
	if ( [self beginDownload] == NO )
    {
        [self setTitle: @"Download Failed"];
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
    [_header setTitle: title];
}

- (NSString *) title
{
    return ( [_header title] );
}
- (void) setSourceImage: (NSString *)name
{
	NSString *appPng = nil;
	
	appPng = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"png"];
	if(![[NSFileManager defaultManager] fileExistsAtPath:appPng])
		appPng = [[NSBundle bundleForClass:[self class]] pathForResource:@"package" ofType:@"png"];
	NSLog(@"appPng: %@",appPng);
	id sp= [BRImage imageWithPath:appPng];
	[_sourceImage setImage:sp];
	[_sourceImage setAutomaticDownsample:YES];
	NSRect masterFrame = [[self parent] frame];
	CGRect frame;
	frame.origin.x = masterFrame.size.width *0.7f;
	frame.origin.y = masterFrame.size.height *0.3f;
	frame.size.width = masterFrame.size.height*0.4f; 
	frame.size.height= masterFrame.size.height*0.4f;
	[_sourceImage setFrame: frame];
	
}
- (void) appendSourceText: (NSString *)srcText
{
	//NSLog(@"appending: %@",srcText);
	[_theSourceText appendString:[NSString stringWithFormat:@"\n%@",srcText]];
	//_theSourceText=[_theSourceText stringByAppendingString:[NSString stringWithFormat:@"\n%@",srcText]];
	[self setSourceText:_theSourceText];
}

- (void) setSourceText: (NSMutableString *) srcText
{
	//   [_sourceText setTextAttributes: [[BRThemeInfo sharedTheme] paragraphTextAttributes]];
    //[_sourceText setText: srcText withAttributes:[[BRThemeInfo sharedTheme] paragraphTextAttributes]];
	
	//NSAttributedString *srcsText =[[NSAttributedString alloc]initWithString:srcText attributes:[[BRThemeInfo sharedTheme] paragraphTextAttributes]];
	[_sourceText setText:srcText];
    // layout this item
    NSRect masterFrame = [[self parent] frame];
	
	// [_sourceText setMaximumSize: NSMakeSize(masterFrame.size.width * 0.66f,
	//                                       masterFrame.size.height)];
	
	// CGSize txtSize = [_sourceText renderedSize];
	
    CGRect frame;
    frame.origin.x = masterFrame.size.width  * 0.1f;
    frame.origin.y = (masterFrame.size.height * 0.2);// - txtSize.height;
    //frame.size = txtSize;
    frame.size.width = masterFrame.size.width*0.6f;
	frame.size.height = masterFrame.size.height*0.65f;
	//struct CGSize shrinksize;
	//shrinksize.width=
	//[_sourceText shrinkTextToFitInBounds:{masterFrame.size.width*0.4f;masterFrame.size.height*0.45f;};]
	[_sourceText setFrame: frame];
}
-(id)sourceImage
{
	return ([_sourceImage image]);
}

- (NSString *) sourceText
{
    return ( [_sourceText text] );
}

- (float) percentDownloaded
{
    return ( [_progressBar percentage] );
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
    // we'll ignore the given filename and use our own
    // they'll likely be the same, anyway
	
    // ensure that all new path components exist
    [[NSFileManager defaultManager] createDirectoryAtPath: [_outputPath stringByDeletingLastPathComponent]
                                               attributes: nil];
	
    //NSLog( @"Starting download to file '%@'", _outputPath );
	
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
	
    ////NSLog( @"Got %u bytes, %lld total", length, _gotLength );
	
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
	
    //NSLog( @"Got response for new download, length = %lld", [response expectedContentLength] );
	
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
    //NSLog( @"Asked to decode data of MIME type '%@'", encodingType );
	
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
	
	//[self enableScreenSaver];
	[self appendSourceText:@"download done"];
    // completed the download: set progress full (just in case) and
    // go do something with the data
    [_progressBar setPercentage: 100.0f];
	//NSLog( @"===== Download finished ===== " );
	[self processdownload];
	
	
	
	
	
    // we'll swap ourselves off the stack here, so let's remove our
    // reference to the downloader, just in case calling -cancel now
    // might cause a problem
    [_downloader autorelease];
    _downloader = nil;
	
    // By default I'm downloading a music file, so let's use a music
    // player for it, eh?
	// NSError * error = nil;
    //NSURL * url = [NSURL fileURLWithPath: _outputPath];
	
	
	/* this code below is from the original example and no longer works on 2.0 appletvs 
	 
	 BRBaseMediaAsset * asset = [[[BRSimpleMediaAsset alloc] initWithMediaURL: url] autorelease];
	 
	 BRMediaPlayer * player = [[[BRQTKitVideoPlayer alloc] init] autorelease];
	 [player setMedia: asset error: &error];
	 
	 id controller = [[BRVideoPlayerController alloc] init];
	 [controller setVideoPlayer: player];
	 
	 [[self stack] swapController: controller];
	 [controller release];
	 */
	
}
-(void) processdownload
{
	if (downloadnumber<8)
	{
		[self beginDownload];
	}
}
- (BOOL)helperCheckPerm
{
	NSString *helperPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
	NSFileManager *man = [NSFileManager defaultManager];
	NSDictionary *attrs = [man fileAttributesAtPath:helperPath traverseLink:YES];
	NSNumber *curPerms = [attrs objectForKey:NSFilePosixPermissions];
	////NSLog(@"curPerms: %@", curPerms);
	if ([curPerms intValue] < 2541)
	{
		//NSLog(@"installHelper permissions: %@ are not sufficient, dying", curPerms);
		return (NO);
	}
	
	return (YES);
	
}
- (BOOL)recreateOnReselect
{
	return (YES);
	
}

@end
