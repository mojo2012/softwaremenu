//
//  QuDownloadController.m
//  QuDownloader
//
//  Created by Alan Quatermain on 19/04/07.
//  Copyright 2007 AwkwardTV. All rights reserved.
//
// Updated by nito 08-20-08 - works in 2.x

#import "SMDownloaderSTD.h"
#import "SMUpdaterProcess.h"
#import "BRLocalizedString.h"
#import <BackRow/BackRow.h>
#import	"SMGeneralMethods.h"
#define	DOCUMENTS_FOLDER	@"/Users/frontrow/Documents/"

#define myDomain			(CFStringRef)@"org.quatermain.downloader"
static NSString * finalName = nil;
static NSString  const * kDefaultURLString = @"http://www.google.com";

@implementation SMUpdaterProcess
- (void) disableScreenSaver{
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
}
-(void)setUpdateData:(NSDictionary *)updatedata
{
	NSLog(@"updatedata");
	_updateData=updatedata;
	[_updateData retain];
}


- (void) drawSelf

{
	NSLog(@"drawSelf");
	[self disableScreenSaver];
	//NSString *urlstr=_downloadURL;
	_theSourceText = [[NSMutableString alloc] initWithString:BRLocalizedString(@"Starting Update Processing",@"Starting Update Processing")];
	//_theSourceText = @"starting Download:";
	_header = [[BRHeaderControl alloc] init];
	_sourceText = [[BRScrollingTextControl alloc] init];
	//_progressBar = [[SMProgressBarControl alloc] init];
	_sourceImage = [[BRImageControl alloc] init];
	[self addControl: _sourceImage];
	// work out our desired output path	
	// lay out our UI
	NSLog(@"hello");
	NSRect masterFrame = [[self parent] frame];
	NSLog(@"hello2");
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
	//[_progressBar setFrame: frame];
	NSString *name =  _downloadTitle;
	if (name == nil)
	{
		name = BRLocalizedString(@"Updating",@"Updating");
	}
	//NSLog(@"name : %@",name);
	
	[self setTitle: name];
	[self setSourceImage: name];
	
	[self setSourceText: [NSString stringWithFormat:BRLocalizedString(@"Processing Updates for ATV%@",@"Processing Updates for ATV%@"),[_updateData valueForKey:@"displays"]]];   // this lays itself out
	//[self appendSourceText: @"hello"];
	//[_progressBar setCurrentValue: [_progressBar minValue]];
	
	// add the controls
	[self addControl: _header];
	[self addControl: _sourceText];
	//[self addControl: _progressBar];
	
	
	
}


- (id) init {
    if ( [super init] == nil )
        return ( nil );
	//finalName =  (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"name", kCFPreferencesCurrentApplication));
    return ( self );
}

- (void) dealloc
{
    //[self cancelDownload];
	
    [_header release];
    [_sourceText release];
    [_progressBar release];
    [_downloader release];
    [_outputPath release];
	[_sourceImage release];
	[_updateData release];
	
    [super dealloc];
}

- (void)controlWasActivated
{
	NSLog(@"was Activated");
	[self drawSelf];
	
	

	
    [self processFiles];
	[super controlWasActivated];

	
}
-(void)initCustom
{
	
}

- (void)controlWillDeactivate;
{
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
/*-(void)wasPushed;
{
	NSLog(@"was Pushed");
	[self processFiles];
	[super wasPushed];

}*/

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
    frame.origin.y = (masterFrame.size.height * 0.01f);// - txtSize.height;
    //frame.size = txtSize;
    frame.size.width = masterFrame.size.width*0.6f;
	frame.size.height = masterFrame.size.height*0.84f;
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



// NSURLDownload delegate methods
-(void) processFiles
{
	NSFileManager *man =[NSFileManager defaultManager];
	NSString *helperLaunchPath= [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
	NSString *thestatus = [[NSString alloc] initWithString:@"OK"];
	[self appendSourceText:BRLocalizedString(@"*Step 1/9: Checking Permissions on Helper",@"*Step 1/9: Checking Permissions on Helper")];
	
	/*if(![self helperCheckPerm])
	{
		NSString *launchPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"FixPerm" ofType:@"sh"];
		NSTask *task = [[NSTask alloc] init];
		NSArray *args = [NSArray arrayWithObjects:launchPath,nil];
		[task setArguments:args];
		[task setLaunchPath:@"/bin/bash"];
		[task launch];
		[task waitUntilExit];
		[self appendSourceText:@"	Fixed Permissions"];
	}*/
	[[SMGeneralMethods sharedInstance] helperFixPerm];
	if([man fileExistsAtPath:@"/Volumes/OSBoot 1/"] && [[SMGeneralMethods sharedInstance] helperCheckPerm])
	{
		NSTask *task8 = [[NSTask alloc] init];
		[self appendSourceText:@"*Step -/- Unmounting volume at /Volumes/OSBBoot\ 1/"];
		NSArray *args8 = [NSArray arrayWithObjects:@"-unmount",@"0",@"0",nil];
		[task8 setArguments:args8];
		[task8 setLaunchPath:helperLaunchPath];
		[task8 launch];
		[task8 waitUntilExit];
		
	}
	
	if([[SMGeneralMethods sharedInstance] helperCheckPerm] && ![man fileExistsAtPath:@"/Volumes/OSBoot /1"]){
		[self appendSourceText:BRLocalizedString(@"*Step 1.5/9 Blocking mesu.apple.com",@"*Step 1.5/9 Blocking mesu.apple.com")];
		SMGeneralMethods *ihc = [[SMGeneralMethods alloc] init];
		[ihc toggleUpdate];
	}
	else
	{
		[self appendSourceText:@"either /Volumes/OSBoot 1/ was not unmounted properly or Permissions are still wrong -- Popping"];
		NSLog(@"either /Volumes/OSBoot 1/ was not unmounted properly or Permissions are still wrong -- Popping");
		thestatus = @"BAD";
	}
	
	if([[SMGeneralMethods sharedInstance] helperCheckPerm] && [thestatus isEqualToString:@"OK"])
	{
		[self appendSourceText:BRLocalizedString(@"	Permissions OK",@"	Permissions OK")];
		[self appendSourceText:BRLocalizedString(@"*Step 2/9: Make the .dmg writable",@"*Step 2/9: Make the .dmg writable")];
		/*NSTask *task2 = [[NSTask alloc] init];
		NSArray *args2 = [NSArray arrayWithObjects:@"-makewritable",[_updateData valueForKey:@"displays"],@"0",nil];
		[task2 setArguments:args2];
		[task2 setLaunchPath:helperLaunchPath];
		[task2 launch];
		[task2 waitUntilExit];*/
		NSLog(@"converted");
		[self makeDMGRW:[NSString stringWithFormat:BRLocalizedString(@"/Users/frontrow/Documents/ATV%@/OS.dmg",@"/Users/frontrow/Documents/ATV%@/OS.dmg"),[_updateData valueForKey:@"displays"],nil]];
	}
	else
	{
		[self appendSourceText:@"Permissions are wrong if this is first error Message"];
		NSLog(@"Permissions are wrong");
		thestatus = @"BAD";
		
	}
	
	
	if([man fileExistsAtPath:[NSString stringWithFormat:[DOCUMENTS_FOLDER stringByAppendingPathComponent:[NSString stringWithFormat:@"ATV%@/converted.dmg",[_updateData valueForKey:@"displays"],nil]]]]&&[thestatus isEqualToString:@"OK"])
	{
		[self appendSourceText:BRLocalizedString(@"	Conversion Done",@"	Conversion Done")];
		[self appendSourceText:BRLocalizedString(@"*Step 3/9: Mount the .dmg",@"*Step 3/9: Mount the .dmg")];
		NSTask *task3 = [[NSTask alloc] init];
		NSArray *args3 = [NSArray arrayWithObjects:@"-mountconverted",[_updateData valueForKey:@"displays"],@"0",nil];
		[task3 setArguments:args3];
		[task3 setLaunchPath:helperLaunchPath];
		[task3 launch];
		[task3 waitUntilExit];
		NSLog(@"mounted");
	}
	else
	{
		thestatus = @"BAD";
		NSLog(@"3");
		[self appendSourceText:@"Stopped"];
		NSLog(@"Stopped after converted");
	}
	if([man fileExistsAtPath:@"/Volumes/OSBoot 1/"] && [thestatus isEqualToString:@"OK"])
	{
		[self appendSourceText:BRLocalizedString(@"	Mounted",@"	Mounted")];
		[self appendSourceText:BRLocalizedString(@"*Step 4/9: add the SSH and SoftwareMenu",@"*Step 4/9: add the SSH and SoftwareMenu")];
		NSTask *task4 = [[NSTask alloc] init];
		NSArray *args4 = [NSArray arrayWithObjects:@"-addFiles",[_updateData valueForKey:@"displays"],@"0",nil];
		[task4 setArguments:args4];
		[task4 setLaunchPath:helperLaunchPath];
		[task4 launch];
		[task4 waitUntilExit];
		NSLog(@"sshed");
	}
	else
	{
		thestatus = @"BAD";
		NSLog(@"4");
		[self appendSourceText:@"Stopped"];
		NSLog(@"Stopped after mounting");
		
	}
	if([man fileExistsAtPath:@"/Volumes/OSBoot 1/usr/bin/dbclient"] && [thestatus isEqualToString:@"OK"])
	{
		[self appendSourceText:BRLocalizedString(@"	copied",@"	copied")];
		[self appendSourceText:BRLocalizedString(@"*Step 5/9 Unmounting",@"*Step 5/9 Unmounting")];
		NSTask *task5 = [[NSTask alloc] init];
		NSLog(@"unmounting");
		NSArray *args5 = [NSArray arrayWithObjects:@"-unmount",@"0",@"0",nil];
		[task5 setArguments:args5];
		[task5 setLaunchPath:helperLaunchPath];
		[task5 launch];
		[task5 waitUntilExit];
		NSLog(@"unmounted");
	}
	else
	{
		NSLog(@"5");
		[self appendSourceText:@"Stopped"];
		NSLog(@"adding SSH");
		thestatus =@"BAD";
	}
	if(![man fileExistsAtPath:@"/Volumes/OSBoot 1/"])
	{
		[self appendSourceText:BRLocalizedString(@"	unmounted",@"	unmounted")];
		[self appendSourceText:BRLocalizedString(@"*Step 6/9 makeRO",@"*Step 6/9 makeRO")];
		/*NSTask *task7 = [[NSTask alloc] init];
		NSArray *args7 = [NSArray arrayWithObjects:@"-makeRO",[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/converted.dmg",[_updateData valueForKey:@"displays"],nil],@"0",nil];
		[task7 setArguments:args7];
		[task7 setLaunchPath:helperLaunchPath];
		[task7 launch];
		[task7 waitUntilExit];*/
		[self makeDMGRO:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/converted.dmg",[_updateData valueForKey:@"displays"],nil]];
		NSLog(@"ro");
	}
	else
	{
		NSLog(@"6");
		[self appendSourceText:@"error"];
		NSLog(@"error");
		thestatus = @"BAD";	
	}
	
	/*if([man fileExistsAtPath:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/final.dmg",[_updateData valueForKey:@"displays"],nil]])
	{
		[self appendSourceText:@"	was converted"];
		[self appendSourceText:@"*Step 7/9 ASR scanning... cannot check for that"];
		NSTask *task6 = [[NSTask alloc] init];
		NSArray *args6 = [NSArray arrayWithObjects:@"-asrscan",[_updateData valueForKey:@"displays"],@"0",nil];
		[task6 setArguments:args6];
		[task6 setLaunchPath:helperLaunchPath];
		[task6 launch];
		[task6 waitUntilExit];
		
	}
	else
	{
		NSLog(@"7");
		[self errorMessage:@"was not make RO"];
	}*/
	//[self appendSourceText:@"	scanned"];
	if([thestatus isEqualToString:@"OK"])
	{
		[self appendSourceText:BRLocalizedString(@"*Step 7/9 Moving Files to ~/Updates",@"*Step 7/9 Moving Files to ~/Updates")];
		[self appendSourceText:[NSString stringWithFormat:BRLocalizedString(@"	You have chosen to %@",@"	You have chosen to %@"),[_updateData valueForKey:@"preserve"],nil]];
		[self moveFiles2];
		//[self appendSourceText:@"	"];
	}
	
	[self cleanstuff];
	
	
	
	
	
	
	if([man fileExistsAtPath:[NSString stringWithFormat:@"/Users/frontrow/Updates/final.dmg",nil]] && [thestatus isEqualToString:@"OK"])
	{
		int i;
		NSLog(@"making scan");
		[self appendSourceText:BRLocalizedString(@"*Step 8/9 Doing ASR scan",@"*Step 8/9 Doing ASR scan")];
		i=[self makeASRscan:@"/Users/frontrow/Updates/final.dmg"];
		NSLog(@"term status:%d",i);
		if (i != 0)
		{
			
			
			[self appendSourceText:@"error"];
			NSLog(@"error");
			thestatus = @"BAD";	
		}
		else
		{
			[self appendSourceText:@"	done"];
		}
		
	}
	else
	{
		NSLog(@"7");
		[self appendSourceText:@"was not make RO"];
		[self appendSourceText:@"error"];
		NSLog(@"error");
		thestatus = @"BAD";
	}
	NSLog(@"thestatus: %@",thestatus);
	NSLog(@"hello");
	[self appendSourceText:BRLocalizedString(@"*Press Menu and launch the Update from the menu item",@"*Press Menu and launch the Update from the menu item")];

	/*if([thestatus isEqualToString:@"OK"])
	{
		NSLog(@"%@",[_updateData valueForKey:@"now"]);
		if([[_updateData valueForKey:@"now"] isEqualToString:@"NO"])
		{
			[self appendSourceText:@"*Press Menu and launch the Update from the menu item"];

			
		}
		else
		{
			
			NSLog(@"in Loop");
			[self appendSourceText:@"*Step 9/9 Launching OSUpdate, Please wait"];
			NSTask *task7 = [[NSTask alloc] init];
			NSArray *args7 = [NSArray arrayWithObjects:@"-osupdate",@"0",@"0",nil];
			[task7 setArguments:args7];
			[task7 setLaunchPath:helperLaunchPath];
			[task7 launch];
			[task7 waitUntilExit];
		}
	}
	
	else if([thestatus isEqualToString:@"BAD"])
	{
		[self appendSourceText:@"Bad show old boy, there's a problem"];
	}*/
	[[self stack] popController];
	
}

-(void)errorMessage:(NSString *)theerrormessage
{

	NSLog(@"theerrormessage:%@",theerrormessage);
	BRAlertController *alert = [BRAlertController alertOfType:0
													   titled:[NSString stringWithFormat:@"ATV%@",[_updateData valueForKey:@"displays"]]
																			 primaryText:theerrormessage
												secondaryText:@"contact me"/*\nPressing the Left arrow key enables the script to show in the main softwareMenu categories\n (for scripts you run a lot)"*/];
	[[self stack] swapController:alert];
}
- (BOOL)helperCheckPerm
{
	return [[SMGeneralMethods sharedInstance] helperCheckPerm];
	
}
- (BOOL)recreateOnReselect
{
	return (YES);
	
}
- (int)makeASRscan:(NSString *)drivepath
{
	 NSLog(@"starting ASR");
	 NSTask *mdTask2 = [[NSTask alloc] init];
	 NSPipe *mdip2 = [[NSPipe alloc] init];
	 NSFileHandle *hdih = [mdip2 fileHandleForReading];
	 [mdTask2 setLaunchPath:@"/usr/sbin/asr"];
	 [mdTask2 setArguments:[NSArray arrayWithObjects:@"-imagescan", drivepath, nil]];
	 [mdTask2 setStandardOutput:mdip2];
	 [mdTask2 setStandardError:mdip2];
	 [mdTask2 launch];
	 [mdTask2 waitUntilExit];
	 int termStatus = [mdTask2 terminationStatus];
	 NSData *outData;
	 outData = [hdih readDataToEndOfFile];
	 NSString *string = [[NSString alloc] initWithData: outData encoding: NSUTF8StringEncoding];
	 NSLog(@"%@ status: %i",string, termStatus);
	 return termStatus;
}
-(void)cleanstuff
{
	NSFileManager *man =[NSFileManager defaultManager];
	if([[_updateData valueForKey:@"preserve"]isEqualToString:@"delete"])
	{
		[man removeFileAtPath:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",[_updateData valueForKey:@"displays"],nil] handler:nil];
		
	}
	else
	{
		[man removeFileAtPath:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/converted.dmg",[_updateData valueForKey:@"displays"],nil] handler:nil];
		[man removeFileAtPath:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/final.dmg",[_updateData valueForKey:@"displays"],nil] handler:nil];
	}
	if([man fileExistsAtPath:@"/Users/frontrow/dropbear/"])
	{
		[man removeFileAtPath:@"/Users/frontrow/dropbear/" handler:nil];
	}
		
}
-(void)moveFiles2
{
	NSLog(@"MoveFiles");
	NSFileManager *man =[NSFileManager defaultManager];
	if([man fileExistsAtPath:@"/Users/frontrow/Updates"])
	{
		[man removeFileAtPath:@"/Users/frontrow/Updates" handler:nil];
	}
	[man createDirectoryAtPath:@"/Users/frontrow/Updates" attributes:nil];
	
	
	NSArray *dlinks=[_updateData valueForKey:@"dlinks"];
	NSString *original=[_updateData valueForKey:@"original"];
	NSEnumerator *enum2 = [dlinks objectEnumerator];
	id obje;
	while((obje = [enum2 nextObject]) != nil)
	{
		
		NSString *thefilename=[obje lastPathComponent];
		NSString *basename= [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",[_updateData valueForKey:@"displays"],nil];
		NSString *updatename= @"/Users/frontrow/Updates";
		if(![[obje pathExtension] isEqualToString:@"dmg"])
		{
			NSString *obje2=[obje lastPathComponent];
			if([[_updateData valueForKey:@"preserve"] isEqualToString:@"preserve"])
			{
				NSLog(@"copying %@ to %@",[basename stringByAppendingPathComponent:obje2],[updatename stringByAppendingPathComponent:obje2]);
				[man copyPath:[basename stringByAppendingPathComponent:obje2] toPath:[updatename stringByAppendingPathComponent:obje2] handler:nil];
				
			}
			else
			{
				[man movePath:[basename stringByAppendingPathComponent:obje2] toPath:[updatename stringByAppendingPathComponent:obje2] handler:nil];
			}
		}
		else
		{
			if([[_updateData valueForKey:@"original"] isEqualToString:@"NO"])
			{
			
					[man movePath:[basename stringByAppendingPathComponent:@"final.dmg"] toPath:[updatename stringByAppendingPathComponent:@"final.dmg"] handler:nil];
			
			}
			else
			{
				if([[_updateData valueForKey:@"preserve"] isEqualToString:@"preserve"])
				{
					[man copyPath:[basename stringByAppendingPathComponent:@"OS.dmg"] toPath:[updatename stringByAppendingPathComponent:@"OS.dmg"] handler:nil];
				}
				else
				{
					[man movePath:[basename stringByAppendingPathComponent:@"OS.dmg"] toPath:[updatename stringByAppendingPathComponent:@"OS.dmg"] handler:nil];
				}
			}
		}
		
	}
}

- (void) makeDMGRO:(NSString *)drivepath
{
	
	NSTask *mdTask = [[NSTask alloc] init];
	NSPipe *mdip = [[NSPipe alloc] init];
	[mdTask setLaunchPath:@"/usr/bin/hdiutil"];
	[mdTask setArguments:[NSArray arrayWithObjects:@"convert", drivepath, @"-format", @"UDZO", @"-o", [[drivepath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"final.dmg"], nil]];
	[mdTask setStandardOutput:mdip];
	[mdTask setStandardError:mdip];
	[mdTask launch];
	[mdTask waitUntilExit];
	//return (TRUE);
	
}
- (void) makeDMGRW:(NSString *)drivepath
{
	NSLog(@"converting");
	NSTask *mdTask = [[NSTask alloc] init];
	NSPipe *mdip = [[NSPipe alloc] init];
	[mdTask setLaunchPath:@"/usr/bin/hdiutil"];
	[mdTask setArguments:[NSArray arrayWithObjects:@"convert", drivepath, @"-format", @"UDRW", @"-o",[[drivepath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"converted.dmg"], nil]];
	[mdTask setStandardOutput:mdip];
	[mdTask setStandardError:mdip];
	[mdTask launch];
	[mdTask waitUntilExit];
	//return (TRUE);
	
}

-(void)wasPushed
{
	NSLog(@"wasPushed");
	[super wasPushed];
}

@end
