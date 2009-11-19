//
//  QuDownloadController.m
//  QuDownloader
//
//  Created by Alan Quatermain on 19/04/07.
//  Copyright 2007 AwkwardTV. All rights reserved.
//
// Updated by nito 08-20-08 - works in 2.x

//#import "SMDownloaderSTD.h"
#import "SMUpdaterProcess.h"
#import "BRLocalizedString.h"
////#import <BackRow/BackRow.h>
#import	"SMGeneralMethods.h"
#import "SMPseudoCompat.h"
#define	DOCUMENTS_FOLDER	@"/Users/frontrow/Documents/"

//#define myDomain			(CFStringRef)@"org.quatermain.downloader"
//static NSString * finalName = nil;
//static NSString  const * kDefaultURLString = @"http://www.google.com";




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
	//NSLog(@"updatedata");
	_updateData=updatedata;
	[_updateData retain];
}


- (void) drawSelf

{
	_previousText =	[[NSMutableString alloc] init];
	[self disableScreenSaver];
	_theSourceText =[[NSMutableString alloc] initWithString:BRLocalizedString(@"Starting Update Processing",@"Starting Update Processing")];
	_header =		[[BRHeaderControl alloc] init];
	_sourceText =	[[BRScrollingTextControl alloc] init];
	_sourceImage =	[[BRImageControl alloc] init];
	_spinner =		[[BRWaitSpinnerControl alloc] init];
	//_step =			[[BRTextControl alloc] init];
	[self addControl: _sourceImage];
	// work out our desired output path	
	// lay out our UI
	//NSLog(@"hello");
	CGRect masterFrame = [[self parent] frame];
	//NSLog(@"hello2");
	CGRect frame = masterFrame;
	
	// header goes in a specific location
	frame.origin.y = frame.size.height * 0.9f;
	frame.size.height = [[BRThemeInfo sharedTheme] listIconHeight];
	[_header setFrame: frame];

	
	frame.size.width = masterFrame.size.width * 0.45f;
	frame.size.height = ceilf( frame.size.width * 0.068f );
	frame.origin.x = (masterFrame.size.width - frame.size.width) * 0.5f;
	frame.origin.y = masterFrame.origin.y + (masterFrame.size.height * (1.0f / 8.0f));
	NSString *name =  _downloadTitle;
	if (name == nil)
	{
		name = BRLocalizedString(@"Updating",@"Updating");
	}
	//NSLog(@"name : %@",name);
	CGRect frame2 = masterFrame;
	frame2.origin.x = masterFrame.size.width  * 0.71f;
    frame2.origin.y = (masterFrame.size.height * 0.13);// - txtSize.height;
	
    frame2.size.width = masterFrame.size.width*0.22f;
	frame2.size.height = masterFrame.size.height*0.22f;
	[_spinner setFrame:frame2];
	[_spinner setSpins:YES];
	[self setTitle: name];
	[self setSourceImage: name];
	//[self setNumber:0 withSteps:0];
	//[self setTheText:@"ATV"];
	[self setSourceText: [NSString stringWithFormat:BRLocalizedString(@"Processing Updates for ATV%@",@"Processing Updates for ATV%@"),[_updateData valueForKey:@"displays"]]];   // this lays itself out
	
	//[self appendSourceText: @"hello"];
	//[_progressBar setCurrentValue: [_progressBar minValue]];
	
	// add the controls
	[self addControl: _header];
	[self addControl: _sourceText];
	[self addControl:_spinner];
	//[self addControl:_step];
	//[self addControl: _progressBar];
	NSLog(@"1");
	
	
}


- (id) init {
    if ( [super init] == nil )
        return ( nil );
	//finalName =  (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"name", kCFPreferencesCurrentApplication));
	self = [super init];
	//[self drawSelf];
    return ( self );
}
- (void)setNumber:(int)step withSteps:(int)numberOfSteps
{
    [_step setText:[[NSString alloc]initWithFormat:@"Step: %@/%@",step,numberOfSteps,nil] withAttributes:[[SMThemeInfo sharedTheme] leftJustifiedParagraphTextAttributes]];
	
    CGRect masterFrame = [[self parent] frame];
	
	
    CGRect frame;
    frame.origin.x = masterFrame.size.width  * 0.7f;
    frame.origin.y = (masterFrame.size.height * 0.1);// - txtSize.height;
	
    frame.size.width = masterFrame.size.width*0.25f;
	frame.size.height = masterFrame.size.height*0.07f;
	
	[_step setFrame: frame];
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
	//[_sourceTheText release];
	
    [super dealloc];
}

- (void)controlWasActivated
{
	//NSLog(@"was Activated");
	[self drawSelf];
	[super controlWasActivated];
	[self startDownloadingURL];
	//[self processFiles];
	
	
}
-(id)initCustom
{
	return self;
}

/*- (void)controlWillDeactivate;
{
    [super controlWillDeactivate];
}*/

- (BOOL) isNetworkDependent
{
    return ( NO );
}


- (void) setTitle: (NSString *) title
{
    [_header setTitle: title];
}
/*-(void)wasPushed;
 {
 //NSLog(@"was Pushed");
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
	
	appPng = @"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/appleTVImage.png";
	if(![[NSFileManager defaultManager] fileExistsAtPath:appPng])
		appPng = [[NSBundle bundleForClass:[self class]] pathForResource:@"package" ofType:@"png"];
	//NSLog(@"appPng: %@",appPng);
	id sp= [BRImage imageWithPath:appPng];
	[_sourceImage setImage:sp];
	[_sourceImage setAutomaticDownsample:YES];
	CGRect masterFrame = [[self parent] frame];
	CGRect frame;
	frame.origin.x = masterFrame.size.width *0.7f;
	frame.origin.y = masterFrame.size.height *0.3f;
	frame.size.width = masterFrame.size.height*0.4f; 
	frame.size.height= masterFrame.size.height*0.3f;
	[_sourceImage setFrame: frame];
	
}
- (void) appendSourceText: (NSString *)srcText
{
	//NSLog(@"appending: %@",srcText);
	[_theSourceText appendString:[NSString stringWithFormat:@"\n%@",srcText]];
	_previousText = srcText;
	//_theSourceText=[_theSourceText stringByAppendingString:[NSString stringWithFormat:@"\n%@",srcText]];
	[self setSourceText:_theSourceText];
	//[self setTheText:[srcText mutableCopy]];
}
-(void) appendSourceTextSpace:(NSString *)srcText
{
	[_theSourceText appendString:[NSString stringWithFormat:@"    ...  %@",srcText]];
	[self setSourceText:_theSourceText];
}
-(void) setTheText:(NSMutableString *) srcText
{
	//[_sourceTheText setText:srcText];
	CGRect masterFrame = [[self parent] frame];
	CGRect frame;
    frame.origin.x = masterFrame.size.width  * 0.1f;
    frame.origin.y = (masterFrame.size.height * 0.2f);// - txtSize.height;
    //frame.size = txtSize;
    frame.size.width = masterFrame.size.width*0.6f;
	frame.size.height = masterFrame.size.height*0.2f;
		//[_sourceTheText setFrame: frame];

}
- (void) setSourceText: (NSMutableString *) srcText
{
	//   [_sourceText setTextAttributes: [[BRThemeInfo sharedTheme] paragraphTextAttributes]];
    //[_sourceText setText: srcText withAttributes:[[BRThemeInfo sharedTheme] paragraphTextAttributes]];
	
	//NSAttributedString *srcsText =[[NSAttributedString alloc]initWithString:srcText attributes:[[BRThemeInfo sharedTheme] paragraphTextAttributes]];
	[_sourceText setText:srcText];
    // layout this item
    CGRect masterFrame = [[self parent] frame];
	
	// [_sourceText setMaximumSize: NSMakeSize(masterFrame.size.width * 0.66f,
	//                                       masterFrame.size.height)];
	
	// CGSize txtSize = [_sourceText renderedSize];
	
    CGRect frame;
    frame.origin.x = 0.0f;//masterFrame.size.width  * 0.1f;
    frame.origin.y = (masterFrame.size.height * 0.0f);// - txtSize.height;
    //frame.size = txtSize;
    frame.size.width = masterFrame.size.width*0.6f;
	frame.size.height = masterFrame.size.height*0.9f;
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





// NSURLDownload delegate methods
-(void) addDropbearBanner
{
	NSFileManager *man2 = [NSFileManager defaultManager];
	if([man2 fileExistsAtPath:[@"~/.dropbear_banner" stringByExpandingTildeInPath]])
	{
		[man2 removeFileAtPath:[@"~/.dropbear_banner" stringByExpandingTildeInPath] handler:nil];
	}
	NSTask *task8 = [[NSTask alloc] init];
	//[self appendSourceText:@"*Step -/- Unmounting volume at /Volumes/OSBBoot 1/"];
	NSArray *args8 = [NSArray arrayWithObjects:@"Welcome to the AppleTV (via SoftwareMenu)",@">>",@"~/.dropbear_banner",nil];
	[task8 setArguments:args8];
	[task8 setLaunchPath:@"/bin/echo"];
	[task8 launch];
	[task8 waitUntilExit];
}
-(void) processFiles
{
	NSLog(@"1");
	//int numberOfSteps,step;
	//step=0;
	NSFileManager *man =[NSFileManager defaultManager];
	NSMutableDictionary *tempoptions=[self getOptions];
	BOOL original_status=[[tempoptions valueForKey:@"original"] boolValue];	
	/*if(original_status)
	{
		numberOfSteps=2;
	}
	else
	{
		numberOfSteps=10;
		if([man fileExistsAtPath:@"/Volumes/OSBoot 1/"])
		{
			numberOfSteps+=1;
		}
		if([SMGeneralMethods boolForKey:@"retain_installed"])
		{
			numberOfSteps+=1;
		}
		if([SMGeneralMethods boolForKey:@"retain_builtin"] && [[NSFileManager defaultManager] fileExistsAtPath:@"/System/Library/CoreServices/Finder.app/Contents/Plugins (Disabled)/"])
		{
			numberOfSteps+=1;
		}
		if([[_updateData valueForKey:@"install_perian"] boolValue])
		{
			numberOfSteps+=1;
		}
		if([[_updateData valueForKey:@"now"]boolValue])
		{
			numberOfSteps+=1;
		}
	}*/
	
	NSString *helperLaunchPath= [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
	[self appendSourceText:BRLocalizedString(@"Checking Permissions on Helper",@"Checking Permissions on Helper")];
	////step//step;
	//[self setNumber:step withSteps:numberOfSteps];
	BOOL update_status=YES;
	
	
	[SMGeneralMethods helperFixPerm];
	if(![SMGeneralMethods helperCheckPerm])
	{
		update_status=NO;
		[self appendSourceText:@"	Error with Permissions"];
	}
	else
	{
		[self appendSourceTextSpace:BRLocalizedString(@"OK",@"OK")];
		
	}
	
	if([man fileExistsAtPath:@"/Volumes/OSBoot 1/"] && update_status && !original_status)
	{
		NSTask *task8 = [[NSTask alloc] init];
		[self appendSourceText:@"Unmounting volume at /Volumes/OSBBoot 1/"];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		NSArray *args8 = [NSArray arrayWithObjects:@"-unmount",@"0",@"0",nil];
		[task8 setArguments:args8];
		[task8 setLaunchPath:helperLaunchPath];
		[task8 launch];
		[task8 waitUntilExit];
		if([man fileExistsAtPath:@"/Volumes/OSBoot 1/"])
		{
			update_status=NO;
			[self appendSourceText:@"	Volume \"/Volumes/OSBoot 1/\" could not umount"];
		}
		else
		{
			[self appendSourceTextSpace:@"Done"];
		}
		
	}
	
	
	if(update_status){
		[self appendSourceText:BRLocalizedString(@"Blocking mesu.apple.com",@"Blocking mesu.apple.com")];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		[[SMGeneralMethods sharedInstance] blockUpdate];
		[self appendSourceTextSpace:@"Done"];
	}
	
	
	if(update_status && !original_status)
	{
		[self appendSourceText:BRLocalizedString(@"Convert .dmg to UDRW",@"Convert .dmg to UDRW")];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		//[self makeDMGRW:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/OS.dmg",[_updateData valueForKey:@"displays"],nil]];
		[SMGeneralMethods convertDMG:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/OS.dmg",[_updateData valueForKey:@"displays"],nil] toFormat:@"UDRW" withOutputLocation:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/converted.dmg",[_updateData valueForKey:@"displays"],nil]];
		if(![man fileExistsAtPath:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/converted.dmg",[_updateData valueForKey:@"displays"],nil]])
		{
			[self appendSourceText:@"Conversion to RW has failed"];
			update_status=NO;
		}
		else
		{
			[self appendSourceTextSpace:BRLocalizedString(@"Converted",@"Converted")];
		}
	}
	
	
	
	if(update_status && !original_status)
	{
		[self appendSourceText:BRLocalizedString(@"Mount the .dmg",@"Mount the .dmg")];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		NSTask *task3 = [[NSTask alloc] init];
		NSArray *args3 = [NSArray arrayWithObjects:@"-mountconverted",[_updateData valueForKey:@"displays"],@"0",nil];
		[task3 setArguments:args3];
		[task3 setLaunchPath:helperLaunchPath];
		[task3 launch];
		[task3 waitUntilExit];
		//NSLog(@"mounted");
		if(![man fileExistsAtPath:@"/Volumes/OSBoot 1/"])
		{
			[self appendSourceText:@"Was Not Mounted"];
			update_status=NO;
		}
		else
		{
			[self appendSourceTextSpace:BRLocalizedString(@"Mounted",@"Mounted")];
			
		}
	}
	
	if(update_status && !original_status)
	{
		
		[self appendSourceText:BRLocalizedString(@"Adding Dropbear SSH and SoftwareMenu",@"Add Dropbear SSH and SoftwareMenu")];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		NSTask *task4 = [[NSTask alloc] init];
		NSArray *args4 = [NSArray arrayWithObjects:@"-addFiles",[_updateData valueForKey:@"displays"],@"0",nil];
		[task4 setArguments:args4];
		[task4 setLaunchPath:helperLaunchPath];
		[task4 launch];
		[task4 waitUntilExit];
		if(![man fileExistsAtPath:@"/Volumes/OSBoot 1/usr/bin/dbclient"])
		{
			update_status=NO;
			[self appendSourceText:@"Files were not copied properly"];
		}
		else
		{
			[self appendSourceTextSpace:BRLocalizedString(@"Done",@"Done")];
		}
	}
	if(update_status && !original_status &&[SMGeneralMethods boolForKey:@"retain_installed"])
	{
		[self appendSourceText:BRLocalizedString (@"Moving Fraps",@"Moving Fraps")];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		NSArray * builtinfraps = [[NSArray alloc] initWithObjects:@"Movies.frappliance",@"Music.frappliance",@"Photos.frappliance",@"Podcasts.frappliance",@"YT.frappliance",@"TV.frappliance",@"Settings.frappliance",@"SoftwareMenu.frappliance",nil];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *thepath =@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/";
		NSString *newbase = @"/Volumes/OSBoot 1/System/Library/CoreServices/Finder.app/Contents/PlugIns/";
		long i, count = [[fileManager directoryContentsAtPath:thepath] count];
		for ( i = 0; i < count; i++ )
		{
			NSString *idStr = [[fileManager directoryContentsAtPath:thepath] objectAtIndex:i];
			if(![builtinfraps containsObject:idStr])
			{

				if([SMGeneralMethods boolForKey:[@"copy_" stringByAppendingString:[idStr stringByDeletingPathExtension]]])
				{
				[man copyPath:[thepath stringByAppendingPathComponent:idStr] toPath:[newbase stringByAppendingPathComponent:idStr] handler:nil];
				}
			}
			
		}		
		[self appendSourceTextSpace:@"Done"];
		
	}
	if(update_status && !original_status && [SMGeneralMethods boolForKey:@"retain_builtin"] && [[NSFileManager defaultManager] fileExistsAtPath:@"/System/Library/CoreServices/Finder.app/Contents/Plugins (Disabled)/"])
	{
		[self appendSourceText:@"Copying Builtin stuff"];
		NSLog(@"retaining builtin");
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *thepath =@"/Volumes/OSBoot 1/System/Library/CoreServices/Finder.app/Contents/Plugins (Disabled)/";
		NSString *newbase = @"/Volumes/OSBoot 1/System/Library/CoreServices/Finder.app/Contents/PlugIns/";
		long i, count = [[fileManager directoryContentsAtPath:@"/System/Library/CoreServices/Finder.app/Contents/Plugins (Disabled)/"] count];
		[man createDirectoryAtPath:thepath attributes:nil];
		for ( i = 0; i < count; i++ )
		{
			NSString *idStr = [[fileManager directoryContentsAtPath:@"/System/Library/CoreServices/Finder.app/Contents/Plugins (Disabled)/"] objectAtIndex:i];
			NSLog(@"%@ %@ %@",idStr,[newbase stringByAppendingPathComponent:idStr],[thepath stringByAppendingPathComponent:idStr]);
			//[man movePath:[newbase stringByAppendingPathComponent:idStr] toPath:[thepath stringByAppendingPathComponent:idStr] handler:nil];
			NSTask *task41 = [[NSTask alloc] init];
			NSArray *args41 = [NSArray arrayWithObjects:[newbase stringByAppendingPathComponent:idStr],[thepath stringByAppendingPathComponent:idStr],nil];
			[task41 setArguments:args41];
			[task41 setLaunchPath:@"/bin/mv"];
			[task41 launch];
			[task41 waitUntilExit];
			
			
		}
		[self appendSourceTextSpace:@"Done"];
	}
	if(update_status && !original_status && [[tempoptions valueForKey:@"install_perian"] boolValue])
	{
		[self appendSourceText:BRLocalizedString(@"Installing Perian",@"Installing Perian")];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		NSTask *task41 = [[NSTask alloc] init];
		//NSLog(@"unmounting");
		NSArray *args41 = [NSArray arrayWithObjects:@"-install_perian",@"/Users/frontrow/Documents/Perian_1.1.3.dmg",@"/Volumes/OSBoot 1/",nil];
		[task41 setArguments:args41];
		[task41 setLaunchPath:helperLaunchPath];
		[task41 launch];
		[task41 waitUntilExit];
		int perianTerm=[task41 terminationStatus];
		if(perianTerm == 0)
		{
			[self appendSourceTextSpace:@"Installed"];
		}
		else
		{
			[self appendSourceText:@"	Perian Install Failed"];
			update_status = NO;
		}
	}
	
	if(update_status && !original_status)
	{
		[self appendSourceText:BRLocalizedString(@"Unmounting",@"Unmounting")];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		NSTask *task5 = [[NSTask alloc] init];
		//NSLog(@"unmounting");
		NSArray *args5 = [NSArray arrayWithObjects:@"-unmount",@"0",@"0",nil];
		[task5 setArguments:args5];
		[task5 setLaunchPath:helperLaunchPath];
		[task5 launch];
		[task5 waitUntilExit];
		//NSLog(@"unmounted");
		if([man fileExistsAtPath:@"/Volumes/OSBoot 1/"])
		{
			[self appendSourceText:@"Was not Unmounted"];
			update_status=NO;
		}
		else
		{
			[self appendSourceTextSpace:BRLocalizedString(@"Unmounted",@"Unmounted")];
		}
	}
	
	if(update_status && !original_status)
	{
		
		[self appendSourceText:BRLocalizedString(@"Converting to UDZO (read-only)",@"Converting to UDZO (read-only)")];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		//[self makeDMGRO:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/converted.dmg",[_updateData valueForKey:@"displays"],nil]];
		NSString *atvpath=[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",[_updateData valueForKey:@"displays"],nil];
		[SMGeneralMethods convertDMG:[atvpath stringByAppendingPathComponent:@"converted.dmg"] toFormat:@"UDZO" withOutputLocation:[atvpath stringByAppendingPathComponent:@"final.dmg"]];
		if(![man fileExistsAtPath:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/final.dmg",[_updateData valueForKey:@"displays"],nil]])
		{
			update_status=NO;
			[self appendSourceText:@"Conversion to RO failed"];
		}
		else
		{
			[self appendSourceTextSpace:@"Done"];
		}
	}
	
	if(update_status)
	{
		if(!original_status)
		{
			[self appendSourceText:BRLocalizedString(@"Moving Files to ~/Updates",@"Moving Files to ~/Updates")];
		}
		else
		{
			[self appendSourceText:BRLocalizedString(@"Moving Files to ~/Updates",@"Moving Files to ~/Updates")];
		}
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		
		//[self appendSourceText:[NSString stringWithFormat:BRLocalizedString(@"	Preserve: %@",@"	Preserve: %@"),[_updateData valueForKey:@"preserve"],nil]];
		[self moveFiles2:original_status];
		//[self appendSourceText:@"	"];
		if(![man fileExistsAtPath:[@"~/Updates/final.dmg" stringByExpandingTildeInPath]])
		{
			[self appendSourceText:@"Moving Failed"];
			update_status=NO;
		}

		else
		{
			[self appendSourceTextSpace:@"Done"];
		}
	}
	[self cleanstuff];
	[self appendSourceText:@"Cleaned files"];
	if(update_status)
	{
		//[self addDropbearBanner];
	}
	
	
	
	
	
	
	if(update_status)
	{
		int i;
		//NSLog(@"making scan");
		[self appendSourceText:BRLocalizedString(@"Doing ASR scan",@"Doing ASR scan")];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		i=[self makeASRscan:@"/Users/frontrow/Updates/final.dmg"];
		//NSLog(@"term status:%d",i);
		if (i != 0)
		{
			
			
			[self appendSourceText:@"error"];
			//NSLog(@"error");
			update_status=NO;	
		}
		else
		{
			[self appendSourceTextSpace:@"Done"];
		}
		
	}
	
	if(update_status && [[tempoptions valueForKey:@"updatenow"]boolValue])
	{
		[self appendSourceText:@"Launching OSUpdate, Please wait"];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		NSTask *task7 = [[NSTask alloc] init];
		NSArray *args7 = [NSArray arrayWithObjects:@"-osupdate",@"0",@"0",nil];
		[task7 setArguments:args7];
		[task7 setLaunchPath:helperLaunchPath];
		[task7 launch];
		[task7 waitUntilExit]; 
		
	}
	else if(update_status)
	{
		[self appendSourceText:BRLocalizedString(@"*Press Menu and launch the Update from the menu item",@"*Press Menu and launch the Update from the menu item")];
		{
			[_spinner setSpins:NO];
		}
		
	}
	else if(!update_status)
	{
		[self appendSourceText:@"there was an error"];
		[_spinner setSpins:NO];
	}
	
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
	//NSLog(@"starting ASR");
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
	//NSLog(@"%@ status: %i",string, termStatus);
	return termStatus;
}
-(void)cleanstuff
{
	NSMutableDictionary *tempoptions = [self getOptions];
	NSFileManager *man =[NSFileManager defaultManager];
	//NSLog(@"preserve: %d",[[_updateData valueForKey:@"preserve"]boolValue]);
	if(![[tempoptions valueForKey:@"preserve"] boolValue])
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
-(void)moveFiles2:(BOOL)original_status
{
	NSMutableDictionary *tempoptions = [self getOptions];
	//NSLog(@"MoveFiles");
	NSFileManager *man =[NSFileManager defaultManager];
	if([man fileExistsAtPath:@"/Users/frontrow/Updates"])
	{
		[man removeFileAtPath:@"/Users/frontrow/Updates" handler:nil];
	}
	[man createDirectoryAtPath:@"/Users/frontrow/Updates" attributes:nil];
	
	
	NSArray *dlinks=[_updateData valueForKey:@"dlinks"];
	//NSLog(@"dlinks: %@",dlinks);
	//NSString *original=[_updateData valueForKey:@"original"];
	NSEnumerator *enum2 = [dlinks objectEnumerator];
	id obje;
	while((obje = [enum2 nextObject]) != nil)
	{
		
		NSString *basename= [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",[_updateData valueForKey:@"displays"],nil];
		NSString *updatename= @"/Users/frontrow/Updates";
		if(![[obje pathExtension] isEqualToString:@"dmg"])
		{
			NSString *obje2=[obje lastPathComponent];
			//NSLog(@"preserve: %d",[[_updateData valueForKey:@"preserve"] boolValue]);
			if([[tempoptions valueForKey:@"preserve"] boolValue])
			{
				//NSLog(@"copying %@ to %@",[basename stringByAppendingPathComponent:obje2],[updatename stringByAppendingPathComponent:obje2]);
				[man copyPath:[basename stringByAppendingPathComponent:obje2] toPath:[updatename stringByAppendingPathComponent:obje2] handler:nil];
				
			}
			else
			{
				[man movePath:[basename stringByAppendingPathComponent:obje2] toPath:[updatename stringByAppendingPathComponent:obje2] handler:nil];
			}
		}
		else
		{
			if(!original_status)
			{
				
				[man movePath:[basename stringByAppendingPathComponent:@"final.dmg"] toPath:[updatename stringByAppendingPathComponent:@"final.dmg"] handler:nil];
				
			}
			else
			{
				if([[tempoptions valueForKey:@"preserve"] boolValue])
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
	//NSLog(@"converting");
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
	//NSLog(@"wasPushed");
	[super wasPushed];
}
-(BOOL)returnBoolValue:(NSString *)thevalue
{
	if([thevalue isEqualToString:@"YES"])
	{
		return YES;
	}
	else if([thevalue isEqualToString:@"1"])
	{
		return YES;
	}
	else
		return NO;
}
- (void)startDownloadingURL;
{
    // create the request
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"selsettings" ofType:@"png"]]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
	NSURLDownload  *theDownload=[[NSURLDownload alloc] initWithRequest:theRequest delegate:self];
    if (!theDownload) {
        // inform the user that the download could not be made
    }
}

- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename
{
    NSString *destinationFilename;
    NSString *homeDirectory=NSHomeDirectory();
	
    destinationFilename=[[homeDirectory stringByAppendingPathComponent:@"Library/Caches/Softdownloads/"]
						 stringByAppendingPathComponent:filename];
    [download setDestination:destinationFilename allowOverwrite:YES];
}


- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{
    // release the connection
    [download release];
	
    // inform the user
    //NSLog(@"Download failed! Error - %@ %@",
        //  [error localizedDescription],
        //  [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
	[self processFiles];
}

- (void)downloadDidFinish:(NSURLDownload *)download
{
    // release the connection
    [download release];
	[self processFiles];
	
    // do something with the data
}
-(NSMutableDictionary *)getOptions
{
	NSMutableDictionary *theoptions = [[SMGeneralMethods dictForKey:@"Updater_Options"] mutableCopy];
	return theoptions;
}

@end
