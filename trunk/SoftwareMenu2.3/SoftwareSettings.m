//
//  SoftwareSettings.m
//  SoftwareMenu
//
//  Created by Thomas on 11/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
#import <Cocoa/Cocoa.h>
#import "SMUpdaterOptionss.h"
#import "SoftwareSettings.h"
#import "SMUOptions.h"
#import "SMTweaks.h"
//#import "SoftwareUntrusted.h"
#import "SoftwareManual.h"
#import "SMUpdater.h"
#import "SMGeneralMethods.h"
#import "SMMedia.h"
#import "SMDefaultPhotos.h"
#import "SMMediaPreview.h"
#import "SMScreenSaverMenu.h"
#import "SMInfo.h"
#import "SMScreenSaverSettingsMenu.h"
#import "SoftwarePasscodeController.h"
//#import "SMMediaPreview.h"
//#import "BackRow/BRMetadataPreviewControl.h"
#import "BackRowUtilstwo.h"
//#import "ATVScreenSaverManager.h"
//#typedef enum {       FILE_CLASS_UTILITY= -2} FileClass;
#define META_TITLE_KEY                                  @"Title"
#define FILE_CLASS_KEY                                  @"File Class"
#define META_DESCRIPTION_KEY                    @"Show Description"
@interface ATVSettingsFacade : BRSettingsFacade
- (void)setScreenSaverSelectedPath:(id)fp8;
- (id)screenSaverSelectedPath;
- (id)screenSaverPaths;
- (id)screenSaverCollectionForScreenSaver:(id)fp8;
- (id)versionOS;

@end
@implementation SoftwareSettings
- (id) previewControlForItem: (long) item
{
	if(item >= [_items count])
		return nil;
	else
	{
		SMMedia	*meta = [[SMMedia alloc] init];
		[meta setDefaultImage];
		[meta setTitle:[[_items objectAtIndex:item] title]];
		[meta setDescription:[[_options objectAtIndex:item] valueForKey:LAYER_DISPLAY]];
		SMMediaPreview *preview =[[SMMediaPreview alloc] init];
		[preview setShowsMetadataImmediately:YES];
		[preview setAsset:meta];
		return [preview autorelease];
	}
    return ( nil );
}



-(id)init
{
	self = [super init];
	[self setListIcon:[[BRThemeInfo sharedTheme] gearImage] horizontalOffset:0.5f kerningFactor:0.2f];
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: NSLocalizedString(@"Settings",@"Settings")];
	[[self list] removeDividers];
	NSArray *settingsNumberType = [NSArray arrayWithObjects:
						   [NSNumber numberWithInt:kSMSetInfo],
						   [NSNumber numberWithInt:kSMSetSMInfo],
						   [NSNumber numberWithInt:kSMSetToggle],
						   [NSNumber numberWithInt:kSMSetToggle],
						   [NSNumber numberWithInt:kSMSetToggle],
						   [NSNumber numberWithInt:kSMSetToggle],
						   [NSNumber numberWithInt:kSMSetToggle],
						   [NSNumber numberWithInt:kSMSetToggle],
						   [NSNumber numberWithInt:kSMSetToggle],
						   [NSNumber numberWithInt:kSMSetToggle],
						   [NSNumber numberWithInt:kSMSetYNToggle],
						   [NSNumber numberWithInt:kSMSetYNToggle],
						   [NSNumber numberWithInt:kSMSetSPos],
						   [NSNumber numberWithInt:kSMSetBlocker],
						   [NSNumber numberWithInt:kSMSetUpdater],
						   [NSNumber numberWithInt:kSMSetUntrusted],
						   nil];
	NSArray *settingsDisplays = [NSArray arrayWithObjects:
						 BRLocalizedString(@"TV Version",@"TV Version"),
						 BRLocalizedString(@"SoftwareMenu Version",@"Software Menu Version"),
						 BRLocalizedString(@"3rd Party Plugins",@"3rd Party Plugins"),
						 BRLocalizedString(@"Manage Built-in",@"Manage Built-in"),
						 BRLocalizedString(@"Scripts",@"Scripts"),
						 BRLocalizedString(@"Restart Finder",@"Restart Finder"),
						 BRLocalizedString(@"FrapMover",@"FrapMover"),
						 BRLocalizedString(@"Console",@"Console"),
						 BRLocalizedString(@"Tweaks",@"Tweaks"),
						 BRLocalizedString(@"Photos",@"Photos"),
						 BRLocalizedString(@"Auto Restart Finder",@"Auto Restart Finder"),
						 BRLocalizedString(@"Scripts Main Menu",@"Scripts Main Menu"),
						 BRLocalizedString(@"Scripts Position",@"Scripts Position"),
						 BRLocalizedString(@"UpdateBlocker",@"UpdateBlocker"),
						 BRLocalizedString(@"Updater",@"Updater"),
						 BRLocalizedString(@"Manage Untrusted Sources",@"Manage Untrusted Sources"),
						 nil];
	
	 NSArray *settingsDescriptions = [NSArray arrayWithObjects:
						  @"nil",
						  @"nil",
						  @"Hide and Show this option from main menu",
						  @"Hide and Show this option from main menu",
						  @"Hide and Show this option from main menu",
						  @"Hide and Show this option from main menu",
						  @"Hide and Show this option from main menu",
						  @"Hide and Show this option from main menu",
						  @"Hide and Show this option from main menu",
						  @"Hide and Show this option from main menu",
						  @"Auto Restart the Finder after any action requirering a restart : (anytime you install or remove a plugin, etc)",
						  @"Show selected scripts on the main menu",
						  @"Position of said scripts",
						  @"Blocks Updates from Apple ",
						  @"Manual updates (quickpwn for appleTV...)",
						  @"Untrusted sources ... WIP",
						  nil];
	//[_settingsPrefNames release];
	NSArray *settingsPrefNames = [NSArray arrayWithObjects:
							 @"nil",
							 @"nil",
							 @"downloadable",
							 @"builtin",
							 @"scripts",
							 @"reboot",
							 @"mover",
							 @"console",
							 @"tweaks",
							 @"Photos",
							 @"ARF",
							 @"SMM",
							 @"ScriptsPosition",
							 @"nil",
							 @"nil",
							 @"nil",
							 nil];
	//[_settingsPrefNames retain];
	NSArray *dividerPositions = [NSArray arrayWithObjects:
						 [NSNumber numberWithInt:0],
						 [NSNumber numberWithInt:2],
						 [NSNumber numberWithInt:10],
						 [NSNumber numberWithInt:13],
						 [NSNumber numberWithInt:15],
						 nil];
	//NSArray * settingNames = [SMGeneralMethods menuItemOptions];
	//NSArray * settingDisplays = [SMGeneralMethods menuItemNames];
	
	
	/********************
	 * General Info     *
	 ********************/
	
	
	int ii,counter;
	
	ii=[settingsNumberType count];
	
	
	for( counter=0; counter < ii ; counter++)
	{
		id item = [[BRTextMenuItemLayer alloc] init];
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							 [settingsNumberType objectAtIndex:counter],LAYER_TYPE,
							 [settingsPrefNames objectAtIndex:counter],LAYER_NAME,
							 [settingsDescriptions objectAtIndex:counter],LAYER_DISPLAY,
							 nil]];
		[item setTitle:[settingsDisplays objectAtIndex:counter]];
		[_items addObject:item];
		
	}
	id list = [self list];
	[list setDatasource: self];
	
	[[self list] addDividerAtIndex:[[dividerPositions objectAtIndex:0] intValue] withLabel:BRLocalizedString(@"System Info",@"System Info")];
	[[self list] addDividerAtIndex:[[dividerPositions objectAtIndex:1] intValue] withLabel:BRLocalizedString(@"Main Menu Settings",@"Main Menu Settings")];
	[[self list] addDividerAtIndex:[[dividerPositions objectAtIndex:2] intValue] withLabel:BRLocalizedString(@"Other Settings",@"Other Settings")];
	[[self list] addDividerAtIndex:[[dividerPositions objectAtIndex:3] intValue] withLabel:BRLocalizedString(@"Upgrader",@"Upgrader")];
	[[self list] addDividerAtIndex:[[dividerPositions objectAtIndex:4] intValue] withLabel:BRLocalizedString(@"Manage Untrusted Sources",@"Manage Untrusted Sources")];
	
	

	return self;

}

- (void)dealloc
{
	//[_settingsNumberType release];
	[_options release];
	[_items release];
	[super dealloc];  
}



-(void)itemSelected:(long)row
{
	id newController = nil;
	//BOOL isDir;
	switch([[[_options objectAtIndex:row] valueForKey:LAYER_TYPE] intValue])
	{
		case kSMSetInfo:
			//Used as new menu test bed
			/*newController = [[SoftwarePasscodeController alloc] init];
			NSLog(@"afterinit");
			[newController setTitle:@"hello"];
			NSLog(@"afterTitle");
			[newController setDescription:@"hello"];
			NSLog(@"afterdesc");
			[newController setNumberOfBoxes:5];
			//[newController drawSelf];
			NSLog(@"afterboxes");
			[[self stack] pushController:newController];*/
			newController = [[SoftwarePasscodeController alloc] initWithTitle:@"hello"
															  withDescription:@"to you too" 
																	withBoxes:4
																	  withKey:@"weird"];	
			//[self setCustomRotationTime];
			/*newController = [[SMScreenSaverMenu alloc] init];
			[newController initCustom];*/
			[[self stack] pushController:newController];
			break;
		case kSMSetToggle:
		case kSMSetYNToggle:
			[SMGeneralMethods switchBoolforKey:[[_options objectAtIndex:row] valueForKey:LAYER_NAME]];
			[[self list] reload];
			break;
			break;
		case kSMSetUpdater:
			newController = [[SMUpdater alloc] init];
			[newController initCustom];
			[[self stack] pushController:newController];
			break;
		case kSMSetBlocker:
			[[SMGeneralMethods sharedInstance] helperFixPerm];
			[SMGeneralMethods runHelperApp:[NSArray arrayWithObjects:@"-toggleUpdate",@"0",@"0",nil]];
			[[self list] reload];
			break;
		case kSMSetUntrusted:
			newController = [[SoftwareManual alloc] init];
			[newController initWithIdentifier:nil];
			[[self stack] pushController:newController];
		default:
			[[self list] reload];
	}

	
}
- (BOOL)brEventAction:(BREvent *)event
{

	int remoteAction =[event remoteAction];
	
	if ([(BRControllerStack *)[self stack] peekController] != self)
		return [super brEventAction:event];
	
	if([event value] ==0)
		return [super brEventAction:event];
	
	if(![[SMGeneralMethods sharedInstance] usingTakeTwoDotThree] && remoteAction>1)
		remoteAction ++;
	int i;
	long row = [self getSelection];

	//NSMutableArray *theoptions = [_options objectAtIndex:selitem];
	
	switch (remoteAction)
	{
		case kSMRemoteUp:
		case 65676:  // tap up
			//NSLog(@"up");
			break;
		case kSMRemoteDown:
		case 65677:  // tap down
			//NSLog(@"down");
			break;
		case 65675:  // tap left
		case kSMRemoteLeft:
			//NSLog(@"left");
			//if(![[SMGeneralMethods sharedInstance] usingTakeTwoDotThree] || lastFilterChangeDate == nil || [lastFilterChangeDate timeIntervalSinceNow] < -0.4f)
			//{
			//[lastFilterChangeDate release];
			//lastFilterChangeDate = [[NSDate date] retain];
			switch ([[[_options objectAtIndex:row] valueForKey:LAYER_TYPE] intValue])
			{
				case kSMSetSPos:
					i=[SMGeneralMethods integerForKey:@"ScriptsPosition"];
					if(i>0)		{[SMGeneralMethods setInteger:i-1 forKey:@"ScriptsPosition"];}
					[[self list] reload];
					break;
			}
			//}
			break;
		case 65674: //tap right
		case kSMRemoteRight:
			switch ([[[_options objectAtIndex:row] valueForKey:LAYER_TYPE] intValue])
			{
				case kSMSetSPos:
					i=[SMGeneralMethods integerForKey:@"ScriptsPosition"];
					if(i<5)		{[SMGeneralMethods setInteger:i+1 forKey:@"ScriptsPosition"];}
					[[self list] reload];
					break;
			}
			
			break;
		case kSMRemotePlay:
		case 65673:  // tap play
			NSLog(@"play");
			break;
			
	}
	
	
	return [super brEventAction:event];
}


- (int)getSelection
{
	BRListControl *list = [self list];
	int row;
	NSMethodSignature *signature = [list methodSignatureForSelector:@selector(selection)];
	NSInvocation *selInv = [NSInvocation invocationWithMethodSignature:signature];
	[selInv setSelector:@selector(selection)];
	[selInv invokeWithTarget:list];
	if([signature methodReturnLength] == 8)
	{
		double retDoub = 0;
		[selInv getReturnValue:&retDoub];
		row = retDoub;
	}
	else
		[selInv getReturnValue:&row];
	return row;
}






- (id)itemForRow:(long)row	
{ 
	BRTextMenuItemLayer *item = [_items objectAtIndex:row];
	switch([[[_options objectAtIndex:row]valueForKey:LAYER_TYPE]intValue])
	{
		case kSMSetInfo:
			[item setRightJustifiedText:[[NSDictionary dictionaryWithContentsOfFile:@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/version.plist"] 
										 valueForKey:@"CFBundleVersion"]];
			break;
		case kSMSetSMInfo:
			[item setRightJustifiedText:[[[NSBundle bundleForClass:[self class]] infoDictionary] valueForKey:@"CFBundleVersion"]];
			break;
		case kSMSetToggle:
			if([SMGeneralMethods boolForKey:[[_options objectAtIndex:row] valueForKey:LAYER_NAME]])		{[item setRightJustifiedText:@"Shown"];}
			else																						{[item setRightJustifiedText:@"Hidden"];}
			break;
		case kSMSetYNToggle:
			if([SMGeneralMethods boolForKey:[[_options objectAtIndex:row] valueForKey:LAYER_NAME]])		{[item setRightIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[SMThemeInfo sharedTheme] greenGem], @"BRMenuIconImageKey",nil]];}
			else																						{[item setRightIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[SMThemeInfo sharedTheme] redGem], @"BRMenuIconImageKey",nil]];}
			break;
		case kSMSetSPos:
			if(![SMGeneralMethods boolForKey:@"SMM"])			{[item setDimmed:YES];}
			else												{[item setDimmed:NO];}
			int j=0;
			j=[SMGeneralMethods integerForKey:@"ScriptsPosition"];
			[item setRightIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[BRThemeInfo sharedTheme] airportImageForSignalStrength:j], @"BRMenuIconImageKey",nil]];
			break;
		case kSMSetBlocker:
			if([[SMGeneralMethods sharedInstance] checkblocker])		{[item setRightJustifiedText:BRLocalizedString(@"Blocking",@"Blocking")];}
			else														{[item setRightJustifiedText:BRLocalizedString(@"NOT Blocking",@"Blocking")];}
			break;
			
			
			
	}
return [_items objectAtIndex:row]; 
}
- (void)wasExhumed	{[[self list] reload];}
/*- (void)setCustomRotationTime
{
	//NSString *timeScale = [slideShowEditor currentTimeUnits];
	BRController *timeController = [[BRController alloc] init];
	id theTheme = [BRThemeInfo sharedTheme];
	BRHeaderControl *theHeader = [[BRHeaderControl alloc] init];
	[timeController addControl:theHeader];
	[theHeader setTitle:@"Rotation Duration"];
	BRTextControl *firstTextControl = [[BRTextControl alloc] init];
	[timeController addControl:firstTextControl];
	[firstTextControl setText:[NSString stringWithFormat:BRLocalizedString(@"Enter a number in seconds", @"enter duration"),nil] withAttributes:[[BRThemeInfo sharedTheme] promptTextAttributes]];
	[theHeader setIcon:[[BRThemeInfo sharedTheme] photoSettingsImage] horizontalOffset:0.5f kerningFactor:0.2f];
	
	//NSString *atvVersion = [nitoTVAppliance appleTVVersion];
	NSRect master ;
	//NSLog(@"atvVersion: %@", atvVersion);
	if ([[SMGeneralMethods sharedInstance] usingTakeTwoDotThree]){
		//NSLog(@"2.3");
		master  = [[self parent] frame];
	} else {
		master = [self frame];
	}
    
	NSRect frame = master;
	
	frame.origin.y = frame.size.height * 0.60;
	
	
	// position it near the top of the screen (remember, origin is
    // lower-left)
    frame.origin.y = frame.size.height * 0.82f;
    frame.size.height = [theTheme listIconHeight];
    [theHeader setFrame: frame];
	id timeControls = nil;
		timeControls = [[BRPasscodeEntryControl alloc] initWithNumDigits:4 userEditable:YES hideDigits:NO];
	
	
	[timeController addControl:timeControls];
	CGDirectDisplayID display = [[BRDisplayManager sharedInstance] display];
	NSRect testFrame;
	NSRect firstFrame;
	
	firstFrame.size = [firstTextControl renderedSize];
    firstFrame.origin.y = master.origin.y + (master.size.height * 0.72f);
    firstFrame.origin.x = NSMinX(master) + (NSMaxX(master) * 1.0f/ 2.42f);
	[firstTextControl setFrame: firstFrame];
	
	NSSize frameSize;
	
	frameSize.width = CGDisplayPixelsWide( display );
    frameSize.height = CGDisplayPixelsHigh( display );

	
	if (![self is1080i])
	{
		testFrame.size = [timeControls preferredSizeFromScreenSize:frameSize];
	} else {
		//NSLog(@"is 1080i, should do 1080 by 720");
		testFrame.size = [timeControls preferredSizeFromScreenSize:[self sizeFor1080i]];
	}
	
	
    testFrame.origin.y = master.origin.y + (master.size.height * 0.40f);
    testFrame.origin.x = NSMinX(master) + (NSMaxX(master) * 1.0f/ 3.62f);
	//[firstTextControl setFrame: testFrame];
	[timeControls setFrame:testFrame];
	//[timeControls setInitialPasscode:[slideShowEditor convertedTime]];
	
	//id timeControls = [timeController editor];
	//NSLog(@"timeControls: %@ delegate: %@", timeControls, [timeControls delegate]);
	
	
	//id timeController = [BRController controllerWithContentControl:timeControls];
	[timeControls setDelegate:self];
	//[timeControls _layoutUI];
	[[self stack] pushController:timeController];
	//NSLog(@"timeControls: %@ delegate: %@", timeControls, [timeControls delegate]);
}
- (BOOL)is1080i
{
	NSString *displayUIString = [BRDisplayManager currentDisplayModeUIString];
	//NSLog(@"displayUIString: %@", displayUIString);
	NSArray *displayCom = [displayUIString componentsSeparatedByString:@" "];
	NSString *shortString = [displayCom objectAtIndex:0];
	if ([shortString isEqualToString:@"1080i"])
		return YES;
	else
		return NO;
}

- (NSSize)sizeFor1080i
{
	
	NSSize currentSize;
	currentSize.width = 1280.0f;
	currentSize.height = 720.0f;
	
	
	return currentSize;
}
- (void) textDidChange: (id<BRTextContainer>) sender
{
	 NSLog(@"text did change");
}

- (void) textDidEndEditing: (id) sender
{
	/*int timeUnits = [nitoTVAppliance integerForKey:@"timeUnits"];
	int unitConverter = 1;
	
	switch (timeUnits) {
			
		case 1: //seconds
			
			unitConverter = 1;
			
			break;
			
	    case 2: //minutes
			
			unitConverter = 60;
			
			break;
			
		case 3: //hours
			
			unitConverter = 3600;
			break;
			
	}
	int newDuration = ([[sender stringValue] intValue] * unitConverter);
	
	//NSLog(@"newDuration: %i", newDuration);
	[[BRSettingsFacade singleton] setSlideshowSecondsPerSlide:newDuration];
	[[self list] reload];
	[[self stack] popController];
	[[self list] reload];
	//NSLog(@"check it: %i", [[BRSettingsFacade singleton] slideshowSecondsPerSlide]);
	[[self stack] popController];
	[SMGeneralMethods setInteger:[[sender stringValue] intValue] forKey:PHOTO_SPIN_FREQUENCY];
	NSLog(@"here is what was entered: %@",[sender stringValue]);
	
}*/
@end
