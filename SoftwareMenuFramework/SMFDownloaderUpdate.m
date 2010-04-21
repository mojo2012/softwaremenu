//
//  SMFDownloaderUpdate.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/30/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

@interface BRControl (SMFCompat)
-(CGRect)frame;
@end

@interface SMFDownloaderUpdate (LayoutMethods)
-(void)layoutImage;
-(void)layoutHeader;
-(void)layoutBox;
-(void)layoutCurrentText;
-(void)layoutProgressBar;
-(void)layoutTimeControl;

@end
@interface SMFDownloaderUpdate (DownloaderMethods)
+ (NSString *) outputPathForURLString: (NSString *) urlstr;
+ (void) clearAllDownloadCaches;
+ (NSString *) downloadCachePath;
- (void)process;
-(void)cancelDownload;
-(void)deleteDownload;
-(BOOL)beginDownload;
@end

@implementation SMFDownloaderUpdate
-(id)initWithFiles:(NSArray *)links withImage:(BRImage *)image withTitle:(NSString *)title
{
    if ( [super init] == nil )
        return ( nil );
    _forceDestination = FALSE;
    _files = [links mutableCopy];
    [_files retain];
    _image = image;
    [_image retain];
    _title = title;
    [_title retain];
    _boxText=nil;
    _current = 0;
    _textControls=[[NSMutableArray alloc]init];
    [_textControls retain];
    _arrowControl = [[BRImageControl alloc] init];
    BRImage *arrow = [[BRThemeInfo sharedTheme]menuArrowImage];
    [_arrowControl setImage:arrow];
    [_arrowControl setAutomaticDownsample:YES];
    _completeObject=nil;
    _completeFunction=nil;
    
    return self;
    
}
-(void)drawSelf;
{
    [self _removeAllControls];
    [self disableScreenSaver];
    //_boxText = [[NSMutableString alloc] initWithString:@"Starting Download"];
    _headerControl = [[BRHeaderControl alloc] init];
    _textBox = [[BRScrollingTextControl alloc] init];
    _progressBar = [[SMFProgressBarControl alloc] init];
    _imageControl = [[BRImageControl alloc] init];
    _outputPaths = [[NSMutableArray alloc] init];
    _textControl=[[BRTextControl alloc] init];
    _timeControl=[[BRTextControl alloc] init];
//    _outputPath = [[NSString alloc]init];
//    [_outputPath retain];

    [self layoutImage];
    [self layoutHeader];
    [self layoutProgressBar];
    //[self layoutBox];
    [self layoutCurrentText];
    [self layoutTimeControl];
    if([_files count]==0)
        [self preProcess];
    else
        [self beginDownload];
}
-(void)addText:(NSString *)text
{
//    NSLog(@"text: %@",text);
//    NSLog(@"textcontrols: %@",_textControls);
    CGRect masterFrame = [self getMasterFrame];
    CGRect frame;
    BRTextControl *textC = [[BRTextControl alloc] init];
    [textC setText:text withAttributes:[[BRThemeInfo sharedTheme] metadataTitleAttributes]];
    frame.size = [textC preferredFrameSize];
    frame.origin.x=masterFrame.origin.x+masterFrame.size.width*0.13f;
    if(frame.size.width>masterFrame.size.width*0.65f)
        frame.size.width=masterFrame.size.width*0.65f;
    if([_textControls count]==0)
        frame.origin.y=masterFrame.size.height*0.7f;
    else
    {
        NSRect oldframe=[[_textControls lastObject] frame];
        frame.origin.y=oldframe.origin.y-frame.size.height*1.1f;
    }
    [textC setFrame:frame];
    //[textC retain];
    [self addControl:textC];
    [_textControls addObject:textC];
    [self setArrowForRect:frame];
}
-(void)setArrowForRect:(CGRect)frame
{
    [_arrowControl removeFromParent];
    BRImage *arrow=[[BRThemeInfo sharedTheme] folderIcon];
    CGRect newFrame;
    newFrame.size.height=frame.size.height;
    newFrame.size.width = frame.size.height*[arrow aspectRatio];
    newFrame.origin.x=frame.origin.x-newFrame.size.width*1.5f;
    newFrame.origin.y=frame.origin.y;
    [_arrowControl setFrame:newFrame];
    [self addControl:_arrowControl];
    
}
-(void)controlWasActivated
{
    [self drawSelf];
    [super controlWasActivated];
}
-(void)setmd5Array:(NSArray *)md5Array
{
    [_md5Array release];
    _md5Array = md5Array;
    [_md5Array retain];
    if([_md5Array count]==[_files count])
        [self setCheckMD5:YES];
}
-(BOOL)checkMD5
{
    return _checkMD5;
}
-(void)setCheckMD5:(BOOL)checkMD5
{
    if([_md5Array count]==[_files count])
        _checkMD5=checkMD5;
    else
        _checkMD5=NO;
}
-(NSArray *)links
{
    return _files;
}
-(void)setLinks:(NSArray *)links
{
    [_files release];
    _files = [links mutableCopy];
    [_files retain];
}
-(BRImage *)image
{
    return _image;
}
-(void)setImage:(BRImage *)image
{
    [_image release];
    _image=image;
    [_image retain];
}
-(NSString *)title
{
    return _title;
}
-(void)setTitle:(NSString *)title
{
    [_title release];
    _title=title;
    [_title retain];
    [self layoutHeader];
}
-(BOOL)forceDestination
{
    return _forceDestination;
}
-(void)setForceDestination:(BOOL)force
{
    _forceDestination=force;
}
-(void)setBoxText:(NSString *)text
{
    if (_textBox !=nil)
        [_textBox setText:text];
    _boxText=[text mutableCopy];
}
-(void)appendBoxText:(NSString *)append
{
    if(_boxText==nil)
        [self setBoxText:append];
    else {
        NSString *text = [NSString stringWithFormat:@"%@\n%@",_boxText,append,nil];
        [self setBoxText:text];
    }
}
-(void)setText:(NSString *)text
{
    [_textControl removeFromParent];
    CGRect masterFrame=[self getMasterFrame];
    [_textControl setText:text withAttributes:[[BRThemeInfo sharedTheme] metadataTitleAttributes]];
    CGRect frame=[_textControl frame];
    frame.size=[_textControl preferredFrameSize];
    frame.origin.x=masterFrame.size.width*0.5f-frame.size.width*0.5f+masterFrame.origin.x;   
    [_textControl setFrame:frame];
    [self addControl:_textControl];
}
-(NSArray *)paths
{
    return _outputPaths;
}
-(void)dealloc
{
    [_title release];
    [_boxText release];
    
    [_md5Array release];
    [_files release];
    [_headerControl release];
    [_textControl release];
    [_imageControl release];
    
    [_progressBar release];
    [_outputPath release];
    [_outputPaths release];
    [_image release];
    
//    if(_downloader !=nil)
//    {
//        [self cancelDownload];
//        [_downloader release];
//        _downloader = nil;
//    }
//    [_timeControl release];
//    [_textControl release];
    [super dealloc];
}
- (void)setCompleteFunction:(NSString *)function forObject:(id)object
{
    [_completeObject release];
    [_completeFunction release];
    _completeObject = [object retain];
    _completeFunction = [function retain];
}
@end
@implementation SMFDownloaderUpdate (LayoutMethods)
-(void)layoutImage
{
    [_imageControl removeFromParent];
    //[_imageControl release];
    //_imageControl = [[BRImageControl alloc] init];
    if (_image==nil)
        _image = [[BRThemeInfo sharedTheme] appleTVIcon];
    [_imageControl setImage:_image];
    [_imageControl setAutomaticDownsample:YES];
	CGRect masterFrame = [self getMasterFrame];
    float aspectRatio = [_image aspectRatio];
	CGRect frame;
	frame.origin.x = masterFrame.size.width *0.7f;
	frame.origin.y = masterFrame.size.height *0.3f;
	frame.size.width = masterFrame.size.height*0.4f; 
	frame.size.height= frame.size.width/aspectRatio;
    [_imageControl setFrame:frame];
    [self addControl:_imageControl];
}
-(void)layoutHeader
{
    [_headerControl removeFromParent];
    if(_title == nil)
        _title = @"";
    [_headerControl setTitle:_title];
    CGRect masterFrame = [self getMasterFrame];
    CGRect frame=masterFrame;
    frame.origin.y = frame.size.height * 0.82f;
    frame.size.height = [[BRThemeInfo sharedTheme] listIconHeight];
    [_headerControl setFrame:frame];
    [self addControl:_headerControl];
}
-(void)layoutBox
{
    [_textBox removeFromParent];
    CGRect masterFrame = [self getMasterFrame];
    CGRect frame;
    frame.origin.x = masterFrame.size.width  * 0.025f;
    frame.origin.y = (masterFrame.size.height * 0.2f);
    frame.size.width = masterFrame.size.width*0.6f;
	frame.size.height = masterFrame.size.height*0.65f;
	[_textBox setFrame: frame];
    [self addControl:_textBox];
    
}
-(void)layoutProgressBar
{
    [_progressBar removeFromParent];
    CGRect masterFrame = [self getMasterFrame];
    CGRect frame;
    frame.size.width = masterFrame.size.width * 0.45f;
    frame.size.height = ceilf( frame.size.width * 0.068f );
    frame.origin.x = (masterFrame.size.width - frame.size.width) * 0.5f;
    frame.origin.y = masterFrame.origin.y + (masterFrame.size.height * (0.05f));
    [_progressBar setFrame: frame];
    [_progressBar setCurrentValue:[_progressBar minValue]];
    [self addControl:_progressBar];
}
-(void)layoutCurrentText
{
    NSString *text=@"";
    //[_textControl removeFromParent];
    CGRect masterFrame= [self getMasterFrame];
    [_textControl setText:text withAttributes:[[BRThemeInfo sharedTheme] metadataTitleAttributes]];
    CGRect frame;
    CGRect pbframe=[_progressBar frame];
    frame.origin.y=masterFrame.size.height*0.11f;
//    frame.size.width=masterFrame.size.width*0.2f;
//    frame.size.height=masterFrame.size.height*0.05f;
    frame.size=[_textControl preferredFrameSize];
    frame.origin.x=masterFrame.size.width*0.5f-frame.size.width*0.5f+masterFrame.origin.x;
    [_textControl setFrame:frame];
    [self addControl:_textControl];
}
-(void)layoutTimeControl
{
    CGRect masterFrame= [self getMasterFrame];
    CGRect pbframe=[_progressBar frame];
    [_timeControl setText:@"        " withAttributes:[[SMFThemeInfo sharedTheme]centerJustifiedRedText]];
    CGRect frame;
    frame.size=[_timeControl preferredFrameSize];
    frame.origin.x=pbframe.origin.x;//masterFrame.origin.x+masterFrame.size.width*0.5f-frame.size.width;
    frame.size.width=pbframe.size.width;
    frame.origin.y=pbframe.origin.y+pbframe.size.height*0.7f-frame.size.height*0.5f;//+masterFrame.size.height*0.05f;
    [_timeControl setFrame:frame];
    [self addControl:_timeControl];
}
@end
@implementation SMFDownloaderUpdate (DownloaderMethods)
+ (NSString *) outputPathForURLString: (NSString *) urlstr
{
    NSString * cache = [self downloadCachePath];
    NSString * name = [urlstr lastPathComponent];
	
    NSRange range = [name rangeOfString: @"?"];
    if ( range.location != NSNotFound )
        name = [name substringToIndex: range.location];
	
    NSString * folder = [[name stringByDeletingPathExtension]
                         stringByAppendingPathExtension: @"download"];
    return ( [NSString pathWithComponents: [NSArray arrayWithObjects: cache,
											folder, name, nil]] );
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
- (BOOL) beginDownload
{
    if ( _downloader != nil )
        return ( NO );
    [_startTime release];
    _startTime = [NSDate date];
    [_startTime retain];
    [_lastUpdate release];
    _lastUpdate=[NSDate date];
    [_lastUpdate retain];

    // see if we can resume from the current data

	
    // didn't work, delete & try again
	
	NSString *urlstr;
    if([_files count]<=_current)
        return NO;
	urlstr=[_files objectAtIndex:_current];
    if ( urlstr == nil )
		return NO;
	[self disableScreenSaver];
	
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
	
    [_downloader setDeletesFileUponFailure: YES];
	
    return ( YES );
}

- (BOOL) resumeDownload
{
    return ( NO );
}

- (void) cancelDownload
{
    [_downloader cancel];
    [self deleteDownload];
    //[self storeResumeData];
}

- (void) deleteDownload
{

    [[NSFileManager defaultManager] removeFileAtPath:[_outputPath stringByDeletingLastPathComponent]
                                             handler: nil];
}
- (void) download: (NSURLDownload *) download
decideDestinationWithSuggestedFilename: (NSString *) filename
{
    NSLog(@"1");
    [_outputPath release];
    _outputPath = [SMFDownloaderUpdate outputPathForURLString:[_files objectAtIndex:_current]];
    [_outputPath retain];
    NSLog(@"outputPath: %@",_outputPath);
    [[NSFileManager defaultManager] createDirectoryAtPath: [_outputPath stringByDeletingLastPathComponent]
                                               attributes: nil];
    if (!_forceDestination) {
        //[_outputPath release];
        _outputPath = [[_outputPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:filename];
        //[_outputPath retain];
    }
    //[self setText:[_outputPath lastPathComponent]];
    [self addText:[_outputPath lastPathComponent]];
    [download setDestination: _outputPath allowOverwrite: YES];
    
}

- (void) download: (NSURLDownload *) download didFailWithError: (NSError *) error
{
    //[self storeResumeData];
	
    NSLog( @"Download encountered error '%d'", [error code]);//,
    // [error localizedDescription] );
	
    // show an alert for the returned error (hopefully it has nice
    // localized reasons & such...)
    BRAlertController * obj = [BRAlertController alertForError: error];
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
    else if((double)[[NSDate date] timeIntervalSinceDate:_lastUpdate]>(double)2)
    {
        //NSLog(@"startime: %@",_startTime);
        double x= (double)_gotLength/(double)_totalLength;
        double a = ((double)1.0f -x)/x*[[NSDate date] timeIntervalSinceDate:_startTime];///x;
        NSLog(@"time left: %lf",a);
        [_timeControl setText:[NSString stringWithFormat:@"%i seconds left",(int)a,nil] withAttributes:[[SMFThemeInfo sharedTheme] centerJustifiedRedText]];
       // _lastUpdate=[NSDate date];
        [_lastUpdate release];
        _lastUpdate=[NSDate date];
        [_lastUpdate retain];
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
    // resuming now, so pretty much as above, except we have a starting
    // value to set on the progress bar
    _totalLength = 0;
    _gotLength = (long long) startingByte;
	
    // the total here seems to be the amount *remaining*, not the
    // complete total
	
    //NSLog( @"Resumed download at byte %lld, remaining is %lld",
    // _gotLength, [response expectedContentLength] );
	
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
	[_outputPaths addObject:_outputPath];
	//[self appendBoxText:@"download done"];
	[_downloader autorelease];
    _downloader = nil;
	[self enableScreenSaver];
    [_progressBar setPercentage: 100.0f];
    if(_current+1<[_files count])
    {
        _current++;
        [self beginDownload];
    }
    else if([self checkMD5])
        [self startCheckMD5];
    else
        [self preProcess];

}
-(void)startCheckMD5
{
    [self addText:@"Checking MD5"];
    if ([_outputPaths count]==[_md5Array count] && [_outputPaths count]==[_files count]) {
        int i;
        for(i=0;i<[_outputPaths count];i++)
            if(![self checkmd5ForFile:[_outputPaths objectAtIndex:i] withExpectedmd5:[_md5Array objectAtIndex:i]])
                 [[self stack] swapController:[BRAlertController alertOfType:0 titled:@"Wrong MD5" primaryText:nil secondaryText:nil]];
                 
    }
    [self addText:@"Process"];
    [self preProcess];
                 
}
-(BOOL)checkmd5ForFile:(NSString *)path withExpectedmd5:(NSString *)md5
{
    
    //NSLog(@"%@ %s", self, _cmd);
    NSTask *mdTask = [[NSTask alloc] init];
    NSPipe *mdip = [[NSPipe alloc] init];
    NSString *fullPath = path;
    NSFileHandle *mdih = [mdip fileHandleForReading];
    [mdTask setLaunchPath:@"/sbin/md5"];
    
    [mdTask setArguments:[NSArray arrayWithObjects:@"-q", fullPath, nil]];
    [mdTask setStandardOutput:mdip];
    [mdTask setStandardError:mdip];
    [mdTask launch];
    [mdTask waitUntilExit];
    NSData *outData;
    outData = [mdih readDataToEndOfFile];
    NSString *temp = [[NSString alloc] initWithData:outData encoding:NSASCIIStringEncoding];
    temp = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //int theTerm = [mdTask terminationStatus];
    //NSLog(@"md5: %@", temp);
    NSLog(@"file: %@",path);
    NSLog(@"expected md5: %@",md5);
    NSLog(@"returned md5: %@",temp);
    if ([temp isEqualToString:md5])
    {
        //NSLog(@"file at %@ is OK", path);
        return YES;
        
    }
    
    return NO;
}
-(void)preProcess
{
    NSLog(@"preprocess");
    id a;
    if (_completeObject!=nil && _completeFunction!=nil) {
        a=[SMFSharedFunctions invocationsForObject:_completeObject withSelectorVal:_completeFunction withArguments:[self paths]];
        NSLog(@"a:%@",a);
        if([a respondsToSelector:@selector(invoke)])
        {
            NSLog(@"invoking");
            [a invoke];
        }
        else
            [self process];
    }
    [self process];

}
-(void)process
{
    [self addText:@"All Files are Downloaded"];
    [_progressBar removeFromParent];
}


@end


