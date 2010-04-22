//
//  SMApplianceInstaller (downloaderDelegate).m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/21/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import "SMApplianceInstaller (downloaderDelegate).h"
#define kDefaultURLString @"http://www.google.com"

@implementation SMApplianceInstallerController (downloaderDelegate)
- (void) disableScreenSaver{
    //store screen saver state and disable it
    //!!BRSettingsFacade setScreenSaverEnabled does change the plist, but does _not_ seem to work
    m_screen_saver_timeout = [[BRSettingsFacade singleton] screenSaverTimeout];
    [[BRSettingsFacade singleton] setScreenSaverTimeout:-1];
    [[BRSettingsFacade singleton] flushDiskChanges];
}
- (void) enableScreenSaver{
    //reset screen saver to user settings
    NSLog(@"timeout: %@",[NSNumber numberWithInt:m_screen_saver_timeout]);
    [[BRSettingsFacade singleton] setScreenSaverTimeout: m_screen_saver_timeout];
    [[BRSettingsFacade singleton] flushDiskChanges];
}
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
	//NSLog(@"output path: %@",[NSString pathWithComponents: [NSArray arrayWithObjects: cache,
    //	folder, name, nil]]);
    return ( [NSString pathWithComponents: [NSArray arrayWithObjects: cache,
											folder, name, nil]] );
}
//+ (NSString *) outputPathForURLString: (NSString *) urlstr
//{
//    NSString * cache = [self downloadCachePath];
//    NSString * name = [urlstr lastPathComponent];
//	
//    // trim any parameters from the URL
//    NSRange range = [name rangeOfString: @"?"];
//    if ( range.location != NSNotFound )
//        name = [name substringToIndex: range.location];
//	
//    NSString * folder = [[name stringByDeletingPathExtension]
//                         stringByAppendingPathExtension: @"download"];
//	//NSLog(@"output path: %@",[NSString pathWithComponents: [NSArray arrayWithObjects: cache,
//    //	folder, name, nil]]);
//    return ( [NSString pathWithComponents: [NSArray arrayWithObjects: cache,
//											folder, name, nil]] );
//}
- (void) setStatusText:(NSString *)text
{
    if([_statusText parent]!=nil)
        [_statusText removeFromParent];
    [_statusText setText:text withAttributes:[[SMThemeInfo sharedTheme]leftJustifiedTitleTextAttributess]];
    CGRect framem=[[self parent] frame];
    CGRect frame;
    frame.size=[_statusText preferredFrameSize];
    frame.origin.x=framem.origin.x+framem.size.width*0.15f-0.5f*frame.size.width;
    frame.origin.y=framem.origin.y+framem.size.height*0.32f;
    [_statusText setFrame:frame];
    [self addControl:_statusText];
}
- (BOOL) beginDownload
{
    
    if ( _downloader != nil )
        return ( NO );
	
    // see if we can resume from the current data
    if ( [self resumeDownload] == YES )
        return ( YES );
	
    // didn't work, delete & try again
    [self deleteDownload];
	
	NSString *urlstr;
	//urlstr =  (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"urlstr", kCFPreferencesCurrentApplication));
	urlstr=[_information archiveURL];
    if ( urlstr == nil )
		urlstr = (NSString *)kDefaultURLString;
    _outputPath = [[SMApplianceInstallerController outputPathForURLString: urlstr] retain];
    [_outputPath retain];
	[self disableScreenSaver];
	
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
	//[_author setText:@"DL" withAttributes:[[SMThemeInfo sharedTheme]leftJustifiedTitleTextAttributess]];
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
	
    return ( NO );
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
- (void) download: (NSURLDownload *) download
decideDestinationWithSuggestedFilename: (NSString *) filename
{
    
    [[NSFileManager defaultManager] createDirectoryAtPath: [_outputPath stringByDeletingLastPathComponent]
                                               attributes: nil];
    if (!_forceDestination) {
        [_outputPath release];
        _outputPath = [[_outputPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:filename];
        [_outputPath retain];
    }
    [download setDestination: _outputPath allowOverwrite: YES];
    
}

- (void) download: (NSURLDownload *) download didFailWithError: (NSError *) error
{
   // [self storeResumeData];
	
    NSLog( @"Download encountered error '%d'", [error code]);
    // [error localizedDescription] );
	
    // show an alert for the returned error (hopefully it has nice
    // localized reasons & such...)
//    BRAlertController * obj = [BRAlertController alertForError: error];
//    [[self stack] swapController: obj];
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
    NSLog( @"Asked to decode data of MIME type '%@'", encodingType );
	
    // we'll allow decoding only if it won't interfere with resumption
    if ( [encodingType isEqualToString: @"application/gzip"] )
	{
		return ( NO );
		NSLog(@"gzip encoding");
	}
	if([encodingType isEqualToString:@"application/x-gzip"])
	{
		return(NO);
	}
	
    return ( YES );
}

- (void) download: (NSURLDownload *) download
willResumeWithResponse: (NSURLResponse *) response
		 fromByte: (long long) startingByte
{
    _totalLength = 0;
    _gotLength = (long long) startingByte;

	
    if ( [response expectedContentLength] != NSURLResponseUnknownLength )
    {
        _totalLength = _gotLength + [response expectedContentLength];
        [_progressBar setMaxValue: (float) _totalLength];
    }
    else
    {
        [_progressBar setMaxValue: (float) (_gotLength << 1)];
    }
	
    [_progressBar setCurrentValue: (float) _gotLength];
}

- (void) downloadDidFinish: (NSURLDownload *) download
{

	[_downloader release];
    _downloader = nil;
	[self enableScreenSaver];
    [self processdownload];
    [_progressBar setPercentage: 100.0f];
    NSLog(@"done");
}
-(void) processdownload
{
//    BOOL RO = NO;
    //[_author setText:@"Installing" withAttributes:[[SMThemeInfo sharedTheme]leftJustifiedTitleTextAttributess]];
	[self setStatusText:@"Installing"];
//    NSFileManager *man = [NSFileManager defaultManager];

//    NSNumber *oldOrder=[NSNumber numberWithFloat:-1.f];
//    if ([SMPreferences keepFrapplianceOrder])
//    {
//        NSLog([ATV_PLUGIN_PATH stringByAppendingPathComponent:[[_information name] stringByAppendingPathExtension:@"frappliance"]]);
//
//        if ([man fileExistsAtPath:[ATV_PLUGIN_PATH stringByAppendingPathComponent:[[_information name] stringByAppendingPathExtension:@"frappliance"]]]) {
//            NSLog(@"found it");
//            NSDictionary * infoDict= [SMPreferences dictionaryForBundlePath:
//                                      [ATV_PLUGIN_PATH stringByAppendingPathComponent:[[_information name] stringByAppendingPathExtension:@"frappliance"]]];
//            oldOrder = [infoDict objectForKey:@"FRAppliancePreferedOrderValue"];
//       }
//        else if ([[[SMPreferences frapOrderDict] allKeys] containsObject:[_information name]])
//        {
//            oldOrder = [[SMPreferences frapOrderDict] objectForKey:[_information name]];
//        }
//        NSLog(@"old order: %@",oldOrder);
//    }
    //[self appendSourceText:@"Installing"];
//	NSTask *helperTask = [[NSTask alloc] init];
//	NSString *helperPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
//    
	if (![[SMGeneralMethods sharedInstance] helperCheckPerm])
	{
		[[SMGeneralMethods sharedInstance] helperFixPerm];
		//[self appendSourceText:@"Fixed Permissions"];
        
	}
//    if(![[SMGeneralMethods sharedInstance] isRW])
//    {
//        RO=YES;
//        [SMGeneralMethods runHelperApp:[NSArray arrayWithObjects:@"-toggleTweak",@"RW",@"ON",nil]];
//        
//    }
//	[helperTask setLaunchPath:helperPath];
//	if([man fileExistsAtPath:[@"/System/Library/Finder/Contents/Plugins/" stringByAppendingPathComponent:[[_information name] stringByAppendingPathExtension:@"frappliance"]]])
//	{
//		NSLog(@"update");
//		[helperTask setArguments:[NSArray arrayWithObjects:@"-update", _outputPath,[[_information name] stringByAppendingPathExtension:@"frappliance"], nil]];
//	}
//	else
//	{
//		[helperTask setArguments:[NSArray arrayWithObjects:@"-i", _outputPath,[[_information name] stringByAppendingPathExtension:@"frappliance"], nil]];
//	}
//    
//	[helperTask launch];
//	//int theTerm=[helperTask terminationStatus];
//	[helperTask waitUntilExit];
//	[helperTask release];
//    
    
    [[SMHelper helperManager]installWithFile:_outputPath];
    
    
//    NSDate *future1 = [NSDate dateWithTimeIntervalSinceNow: 5 ];
//    [NSThread sleepUntilDate:future1];
//    if([SMPreferences keepFrapplianceOrder]&& oldOrder!=nil)
//    {
//        NSLog(@"time to write");
//        NSLog(@": %@",[[NSBundle bundleWithPath:[ATV_PLUGIN_PATH stringByAppendingPathComponent:[[_information name] stringByAppendingPathExtension:@"frappliance"]]] infoDictionary]);
//        [SMGeneralMethods runHelperApp:[NSArray arrayWithObjects:@"-changeOrder",[ATV_PLUGIN_PATH stringByAppendingPathComponent:[[_information name] stringByAppendingPathExtension:@"frappliance"]] ,[oldOrder stringValue],nil]];
//
//    }
	//[self appendSourceText:@"Press Menu When you are done"];
	[SMGeneralMethods terminateFinder];
    //[_author setText:@"DoneI" withAttributes:[[SMThemeInfo sharedTheme]leftJustifiedTitleTextAttributess]];
    [self setStatusText:@"Installed"];
    NSDate *future = [NSDate dateWithTimeIntervalSinceNow: 1 ];
    [NSThread sleepUntilDate:future];
    [self setupButtons];
    [self setupButtons];
    NSLog(@"last: %@",[NSDictionary dictionaryWithContentsOfFile:[[ATV_PLUGIN_PATH stringByAppendingPathComponent:
                                                                   [[_information name] stringByAppendingPathExtension:@"frappliance"]] 
                                                                  stringByAppendingPathComponent:@"Contents/Info.plist"]]);
    [_statusText removeFromParent];
    [_progressBar removeFromParent];
    
    
    
}
@end
