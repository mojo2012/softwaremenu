//
//  SMNewUpdaterProcess.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 22/11/09.
//  Copyright 2009 Thomas Cool. All rights reserved.


#import "SMNewUpdaterProcess.h"
#import "BRLocalizedString.h"
#import	"SMGeneralMethods.h"
//#import "SMPseudoCompat.h"
#define	DOCUMENTS_FOLDER	@"/Users/frontrow/Documents/"




@implementation SMNewUpdaterProcess


-(id)initForFolder:(NSString *)folder withVersion:(NSString *)Version
{
    if ( [super init] == nil )
        return ( nil );
    self = [super init];
    _folder=folder;
    [_folder retain];
    _version=Version;
    [_version retain];
    _image = [BRImage imageWithPath:@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/appleTVImage.png"];
    [_image retain];
    _title = BRLocalizedString(@"Patching",@"Patching");
    [_title retain];
    _spinner = [[BRWaitSpinnerControl alloc]init];

    _headerControl = [[BRHeaderControl alloc] init];
    _textControls=[[NSMutableArray alloc]init];
    [_textControls retain];
    _imageControl = [[BRImageControl alloc] init];
    _arrowControl = [[BRImageControl alloc] init];
    BRImage *arrow = [[BRThemeInfo sharedTheme]menuArrowImage];
    [_arrowControl setImage:arrow];
    [_arrowControl setAutomaticDownsample:YES];
    [self disableScreenSaver];
    return self;
    
}
-(void)drawSelf;
{
    [self _removeAllControls];
    //[self addText:@"haha"];
    [self layoutImage];
    [self layoutHeader];
    CGRect masterFrame=[self getMasterFrame];
    CGRect frame2 = masterFrame;
	frame2.origin.x = masterFrame.size.width  * 0.39f;
    frame2.origin.y = (masterFrame.size.height * 0.05f);// - txtSize.height;
	
    frame2.size.width = masterFrame.size.width*0.22f;
	frame2.size.height = masterFrame.size.height*0.22f;
	[_spinner setFrame:frame2];
	[_spinner setSpins:YES];
    [self addControl:_spinner];
}
//-(void)controlWasActivated
//{
//    [self layoutSubcontrols];
//    [super controlWasActivated];
//}
-(void)addText:(NSString *)text
{
    NSLog(@"text: %@",text);
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
        CGRect oldframe=[[_textControls lastObject] frame];
        frame.origin.y=oldframe.origin.y-frame.size.height*1.1f;
    }
    [textC setFrame:frame];
    //[textC retain];
    [self addControl:textC];
    [_textControls addObject:textC];
    [self setArrowForRect:frame];
}
-(void)addTextSpace:(NSString *)text
{
    
    if([_textControls count]==0)
        return;
    BRTextControl *textC=[_textControls lastObject];
    NSString *string = [[textC attributedString] string];
    string = [string stringByAppendingFormat:@"     %@",text,nil];
    return;
    [textC setText:string withAttributes:[[BRThemeInfo sharedTheme] metadataTitleAttributes]];
    CGRect frame = [textC frame];
    frame.size.width=[textC preferredFrameSize].width;
    [textC setFrame:frame];
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
-(NSMutableDictionary *)getOptions
{
	NSMutableDictionary *theoptions = [[SMGeneralMethods dictForKey:@"Updater_Options"] mutableCopy];
	return theoptions;
}
-(void)controlWasActivated
{
    NSLog(@"before");
    [self drawSelf];
    [super controlWasActivated];
    NSLog(@"run");
    [self startDownloadingURL];
}
-(void) run
{
    NSLog(@"1");
	NSFileManager *man =[NSFileManager defaultManager];
	NSMutableDictionary *tempoptions=[self getOptions];
	BOOL original_status=[[tempoptions valueForKey:@"original"] boolValue];	
	
	NSString *helperLaunchPath= [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
	[self addText:BRLocalizedString(@"Checking Permissions on Helper",@"Checking Permissions on Helper")];
	////step//step;
	//[self setNumber:step withSteps:numberOfSteps];
	BOOL update_status=YES;
	
	
	[SMGeneralMethods helperFixPerm];
	if(![SMGeneralMethods helperCheckPerm])
	{
		update_status=NO;
		[self addText:@"	Error with Permissions"];
	}
	else
	{
		[self addTextSpace:BRLocalizedString(@"OK",@"OK")];
		
	}
	NSLog(@"2");
	if([man fileExistsAtPath:@"/Volumes/OSBoot 1/"] && update_status && !original_status)
	{
		NSTask *task8 = [[NSTask alloc] init];
		[self addText:@"Unmounting volume at /Volumes/OSBBoot 1/"];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
        [[SMHelper helperManager]unmountPath:@"/Volumes/OSBoot 1/"];
		//NSArray *args8 = [NSArray arrayWithObjects:@"-unmount",@"0",@"0",nil];
//		[task8 setArguments:args8];
//		[task8 setLaunchPath:helperLaunchPath];
//		[task8 launch];
//		[task8 waitUntilExit];
		if([man fileExistsAtPath:@"/Volumes/OSBoot 1/"])
		{
			update_status=NO;
			[self addText:@"	Volume \"/Volumes/OSBoot 1/\" could not umount"];
		}
		else
		{
			[self addTextSpace:@"Done"];
		}
		
	}
	
	NSLog(@"3");
	if(update_status){
		[self addText:BRLocalizedString(@"Blocking mesu.apple.com",@"Blocking mesu.apple.com")];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		[[SMGeneralMethods sharedInstance] blockUpdate];
		[self addTextSpace:@"Done"];
	}
	
	
	if(update_status && !original_status)
	{
		[self addText:BRLocalizedString(@"Convert .dmg to UDRW",@"Convert .dmg to UDRW")];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		//[self makeDMGRW:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/OS.dmg",_version,nil]];
        NSLog(@"/Users/frontrow/Documents/ATV%@/OS.dmg",_version);
        [[SMHelper helperManager] makeImageReadWrite:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/OS.dmg",_version,nil] withNewName:@"converted.dmg"];
		//[SMGeneralMethods convertDMG:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/OS.dmg",_version,nil] toFormat:@"UDRW" withOutputLocation:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/converted.dmg",_version,nil]];
		if(![man fileExistsAtPath:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/converted.dmg",_version,nil]])
		{
			[self addText:@"Conversion to RW has failed"];
			update_status=NO;
		}
		else
		{
			[self addTextSpace:BRLocalizedString(@"Converted",@"Converted")];
		}
	}
	
	
	
	if(update_status && !original_status)
	{
		[self addText:BRLocalizedString(@"Mount the .dmg",@"Mount the .dmg")];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
//		NSTask *task3 = [[NSTask alloc] init];
//		NSArray *args3 = [NSArray arrayWithObjects:@"-mountconverted",_version,@"0",nil];
//		[task3 setArguments:args3];
//		[task3 setLaunchPath:helperLaunchPath];
//		[task3 launch];
//		[task3 waitUntilExit];
        [[SMHelper helperManager]mountImage:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/converted.dmg",_version,nil]];
        
		//NSLog(@"mounted");
		if(![man fileExistsAtPath:@"/Volumes/OSBoot 1/"])
		{
			[self addText:@"Was Not Mounted"];
			update_status=NO;
		}
		else
		{
			[self addTextSpace:BRLocalizedString(@"Mounted",@"Mounted")];
			
		}
	}
	
	if(update_status && !original_status)
	{
		
		[self addText:BRLocalizedString(@"Adding Dropbear SSH and SoftwareMenu",@"Add Dropbear SSH and SoftwareMenu")];
//		//step;
//		//[self setNumber:step withSteps:numberOfSteps];
//		NSTask *task4 = [[NSTask alloc] init];
//		NSArray *args4 = [NSArray arrayWithObjects:@"-addFiles",_version,@"0",nil];
//		[task4 setArguments:args4];
//		[task4 setLaunchPath:helperLaunchPath];
//		[task4 launch];
//		[task4 waitUntilExit];
        [[SMHelper helperManager]addDropbearToDrive:@"/Volumes/OSBoot 1"];
		if(![man fileExistsAtPath:@"/Volumes/OSBoot 1/usr/bin/dbclient"])
		{
			update_status=NO;
			[self addText:@"Files were not copied properly"];
		}
		else
		{
			[self addTextSpace:BRLocalizedString(@"Done",@"Done")];
		}
	}
	if(update_status && !original_status &&[SMGeneralMethods boolForKey:@"retain_installed"])
	{
		[self addText:BRLocalizedString (@"Moving Fraps",@"Moving Fraps")];
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
		[self addTextSpace:@"Done"];
		
	}
	if(update_status && !original_status && [SMGeneralMethods boolForKey:@"retain_builtin"] && [[NSFileManager defaultManager] fileExistsAtPath:@"/System/Library/CoreServices/Finder.app/Contents/Plugins (Disabled)/"])
	{
		[self addText:@"Copying Builtin stuff"];
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
		[self addTextSpace:@"Done"];
	}
	if(update_status && !original_status && NO)// [[tempoptions valueForKey:@"install_perian"] boolValue])
	{
		[self addText:BRLocalizedString(@"Installing Perian",@"Installing Perian")];
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
			[self addTextSpace:@"Installed"];
		}
		else
		{
			[self addText:@"	Perian Install Failed"];
			update_status = NO;
		}
	}
	
	if(update_status && !original_status)
	{
		[self addText:BRLocalizedString(@"Unmounting",@"Unmounting")];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
//		NSTask *task5 = [[NSTask alloc] init];
//		//NSLog(@"unmounting");
//		NSArray *args5 = [NSArray arrayWithObjects:@"-unmount",@"0",@"0",nil];
//		[task5 setArguments:args5];
//		[task5 setLaunchPath:helperLaunchPath];
//		[task5 launch];
//		[task5 waitUntilExit];
        [[SMHelper helperManager] unmountPath:@"/Volumes/OSBoot 1/"];
		//NSLog(@"unmounted");
		if([man fileExistsAtPath:@"/Volumes/OSBoot 1/"])
		{
			[self addText:@"Was not Unmounted"];
			update_status=NO;
		}
		else
		{
			[self addTextSpace:BRLocalizedString(@"Unmounted",@"Unmounted")];
		}
	}
	
	if(update_status && !original_status)
	{
		
		[self addText:BRLocalizedString(@"Converting to UDZO (read-only)",@"Converting to UDZO (read-only)")];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		//[self makeDMGRO:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/converted.dmg",_version,nil]];
		NSString *atvpath=[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",_version,nil];
		[SMGeneralMethods convertDMG:[atvpath stringByAppendingPathComponent:@"converted.dmg"] toFormat:@"UDZO" withOutputLocation:[atvpath stringByAppendingPathComponent:@"final.dmg"]];
		if(![man fileExistsAtPath:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/final.dmg",_version,nil]])
		{
			update_status=NO;
			[self addText:@"Conversion to RO failed"];
		}
		else
		{
			[self addTextSpace:@"Done"];
		}
	}
	
	if(update_status)
	{
		if(!original_status)
		{
			[self addText:BRLocalizedString(@"Moving Files to ~/Updates",@"Moving Files to ~/Updates")];
		}
		else
		{
			[self addText:BRLocalizedString(@"Moving Files to ~/Updates",@"Moving Files to ~/Updates")];
		}
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		
		//[self addText:[NSString stringWithFormat:BRLocalizedString(@"	Preserve: %@",@"	Preserve: %@"),[_updateData valueForKey:@"preserve"],nil]];
		[self moveFiles2:original_status];
		//[self addText:@"	"];
		if(![man fileExistsAtPath:[@"~/Updates/final.dmg" stringByExpandingTildeInPath]])
		{
			[self addText:@"Moving Failed"];
			update_status=NO;
		}
        
		else
		{
			[self addTextSpace:@"Done"];
		}
	}
	//[self cleanstuff];
	[self addText:@"Cleaned files"];
	if(update_status)
	{
		//[self addDropbearBanner];
	}
	
	
	
	
	
	
	if(update_status)
	{
		int i;
		//NSLog(@"making scan");
		[self addText:BRLocalizedString(@"Doing ASR scan",@"Doing ASR scan")];
		//step;
		//[self setNumber:step withSteps:numberOfSteps];
		i=[self makeASRscan:@"/Users/frontrow/Updates/final.dmg"];
		//NSLog(@"term status:%d",i);
		if (i != 0)
		{
			
			
			[self addText:@"error"];
			//NSLog(@"error");
			update_status=NO;	
		}
		else
		{
			[self addTextSpace:@"Done"];
		}
		
	}
	
//	if(update_status && [[tempoptions valueForKey:@"updatenow"]boolValue])
//	{
//		[self addText:@"Launching OSUpdate, Please wait"];
//		//step;
//		//[self setNumber:step withSteps:numberOfSteps];
//		NSTask *task7 = [[NSTask alloc] init];
//		NSArray *args7 = [NSArray arrayWithObjects:@"-osupdate",@"0",@"0",nil];
//		[task7 setArguments:args7];
//		[task7 setLaunchPath:helperLaunchPath];
//		[task7 launch];
//		[task7 waitUntilExit]; 
//		
//	}
	/*else*/ if(update_status)
	{
		[self addText:BRLocalizedString(@"*Press Menu and launch the Update from the menu item",@"*Press Menu and launch the Update from the menu item")];
		{
			[_spinner setSpins:NO];
            [_spinner removeFromParent];
		}
		
	}
	else if(!update_status)
	{
		[self addText:@"there was an error"];
		[_spinner setSpins:NO];
        [_spinner removeFromParent];
	}
    //[_arrowControl setAffineTransform:CGAffineTransformMakeTranslation(30.0f,30.0f)];
	
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
		[man removeFileAtPath:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",_version,nil] handler:nil];
		
	}
	else
	{
		[man removeFileAtPath:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/converted.dmg",_version,nil] handler:nil];
		[man removeFileAtPath:[NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/final.dmg",_version,nil] handler:nil];
	}
	if([man fileExistsAtPath:@"/Users/frontrow/dropbear/"])
	{
		[man removeFileAtPath:@"/Users/frontrow/dropbear/" handler:nil];
	}
	
}
- (void)startDownloadingURL;
{
    NSLog(@"Starting download :( needs to be changed");
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
	
	[self run];
}

- (void)downloadDidFinish:(NSURLDownload *)download
{
    // release the connection
    [download release];
	[self run];
	
    // do something with the data
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
	
	
	//NSArray *dlinks=[_updateData valueForKey:@"dlinks"];
	//NSLog(@"dlinks: %@",dlinks);
	//NSString *original=[_updateData valueForKey:@"original"];
	id obje;
    NSString *folder = [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",_version,nil];
    NSArray *files = [man directoryContentsAtPath:folder];
    NSEnumerator *enum2 = [files objectEnumerator];
	while((obje = [enum2 nextObject]) != nil)
	{
		
		NSString *basename= [NSString stringWithFormat:@"/Users/frontrow/Documents/ATV%@/",_version,nil];
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
		else if([obje isEqualToString:@"final.dmg"])
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

@end
