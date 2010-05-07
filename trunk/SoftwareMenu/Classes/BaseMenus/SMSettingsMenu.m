//
//  SoftwareSettings.m
//  SoftwareMenu
//
//  Created by Thomas on 11/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

typedef enum _kSMSettingType{
	kSMSetSMInfo = -1,
	kSMSetInfo = 0,
	kSMSetToggle = 1,
	kSMSetYNToggle = 2,
	kSMSetSPos = 3,
	kSMSetBlocker = 4,
	kSMSetUpdater = 5,
	kSMSetUntrusted = 6,
	
} SMSettingType;

//#typedef enum {       FILE_CLASS_UTILITY= -2} FileClass;
#define META_TITLE_KEY                                  @"Title"
#define FILE_CLASS_KEY                                  @"File Class"
#define META_DESCRIPTION_KEY                    @"Show Description"

@implementation SMSettingsMenu
- (id) previewControlForItem: (long) item
{
	if(item >= [_items count])
		return nil;
	else
	{
		SMFBaseAsset	*meta = [[SMFBaseAsset alloc] init];
		[meta setCoverArt:[[SMThemeInfo sharedTheme] softwareMenuImage]];
		[meta setTitle:[[_items objectAtIndex:item] title]];
		[meta setSummary:[[_options objectAtIndex:item] valueForKey:LAYER_DISPLAY]];
		SMFMediaPreview *preview =[[SMFMediaPreview alloc] init];
		[preview setShowsMetadataImmediately:YES];
		[preview setAsset:meta];
        [meta release];
		return preview;
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
//						   [NSNumber numberWithInt:kSMSetToggle],
//						   [NSNumber numberWithInt:kSMSetToggle],
//						   [NSNumber numberWithInt:kSMSetToggle],
//						   [NSNumber numberWithInt:kSMSetToggle],
//						   [NSNumber numberWithInt:kSMSetToggle],
                                   //						   [NSNumber numberWithInt:kSMSetToggle],
                                   //						   [NSNumber numberWithInt:kSMSetToggle],
                                   //						   [NSNumber numberWithInt:kSMSetToggle],

                                   [NSNumber numberWithInt:35],
                                   [NSNumber numberWithInt:kSMSetToggle],
                                   [NSNumber numberWithInt:kSMSetToggle],
                                   [NSNumber numberWithInt:kSMSetToggle],
                                   //						   [NSNumber numberWithInt:kSMSetToggle],
						   [NSNumber numberWithInt:kSMSetYNToggle],
                        
						   [NSNumber numberWithInt:kSMSetYNToggle],
                                   [NSNumber numberWithInt:kSMSetYNToggle],
						   [NSNumber numberWithInt:kSMSetSPos],
						   [NSNumber numberWithInt:kSMSetBlocker],
						   [NSNumber numberWithInt:kSMSetUpdater],
						   [NSNumber numberWithInt:kSMSetUntrusted],
                              //     [NSNumber numberWithInt:35],
						   nil];
	NSArray *settingsDisplays = [NSArray arrayWithObjects:
						 BRLocalizedString(@"TV Version",@"TV Version"),
						 BRLocalizedString(@"SoftwareMenu Version",@"Software Menu Version"),
						// BRLocalizedString(@"3rd Party Plugins",@"3rd Party Plugins"),
						// BRLocalizedString(@"Manage Built-in",@"Manage Built-in"),
						// BRLocalizedString(@"Scripts",@"Scripts"),
						// BRLocalizedString(@"Restart Finder",@"Restart Finder"),
						// BRLocalizedString(@"FrapMover",@"FrapMover"),
						// BRLocalizedString(@"Console",@"Console"),
						// BRLocalizedString(@"Tweaks",@"Tweaks"),
						// BRLocalizedString(@"Photos",@"Photos"),
                                 BRLocalizedString(@"Menu Toggles",@"Menu Toggles"),
                                 BRLocalizedString(@"Collections on Shelf",@"Collections on Shelf"),
                                 BRLocalizedString(@"Favorites on Main Menu",@"Favorites on Main Menu"),
                                 BRLocalizedString(@"Updates on Shelf",@"Updates on Shelf"),
                                 BRLocalizedString(@"Parade on Shelf",@"Parade on Shelf"),
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
						 // @"Hide and Show this option from main menu",
						  //@"Hide and Show this option from main menu",
						 // @"Hide and Show this option from main menu",
						 // @"Hide and Show this option from main menu",
						 // @"Hide and Show this option from main menu",
						//  @"Hide and Show this option from main menu",
						//  @"Hide and Show this option from main menu",
						//  @"Hide and Show this option from main menu",
                                      @"Shows and Hides menus under SoftwareMenu", 
                                      @"Shows Photo Collections on Main Menu",
                                      @"Also Show favorites on Main Menu, show collections must be active",
                                      @"Shows available Updates on Main Menu",
                                      @"Display a Media Parade on main menu. gets Photos from SMPhoto Directory",
						  @"Auto Restart the Finder after any action requirering a restart : (anytime you install or remove a plugin, etc)",
						  @"Show selected scripts on the main menu",
						  @"Position of said scripts",
						  @"Blocks Updates from Apple ",
						  @"Manual updates (quickpwn for appleTV...)",
						  @"Untrusted sources ... WIP",
                                //      @"nil",
						  nil];
	//[_settingsPrefNames release];
	NSArray *settingsPrefNames = [NSArray arrayWithObjects:
							 @"nil",
							 @"nil",
//							 @"SMdownloadable",
//							 @"SMbuiltin",
//							 @"SMscripts",
//							 @"SMreboot",
//							 @"SMmover",
//							 @"SMconsole",
//							 @"SMtweaks",
//							 @"SMPhotos",
                                  @"nil",
                                  MAINMENU_SHOW_COLLECTIONS_BOOL,
                                  MAINMENU_SHOW_FAVORIES_BOOL,
                                  MAINMENU_SHOW_UPDATES_BOOL,
                                  MAINMENU_PARADE_BOOL,
							 @"ARF",
							 @"SMM",
							 @"ScriptsPosition",
							 @"nil",
							 @"nil",
							 @"nil",
                              //    @"nil",
							 nil];
	//[_settingsPrefNames retain];
	NSArray *dividerPositions = [NSArray arrayWithObjects:
						 [NSNumber numberWithInt:0],
						 [NSNumber numberWithInt:3],
						 [NSNumber numberWithInt:3],
						 [NSNumber numberWithInt:10],
						 [NSNumber numberWithInt:11],
						 nil];
	//NSArray * settingNames = [SMGeneralMethods menuItemOptions];
	//NSArray * settingDisplays = [SMGeneralMethods menuItemNames];
	
	
	/********************
	 * General Info     *
	 ********************/
	
	
	int ii,counter;
	
	ii=[settingsNumberType count];
	
	NSLog(@"%i, %i, %i, %i",[settingsDisplays count], [settingsNumberType count], [settingsPrefNames count],[settingsDescriptions count]);
	for( counter=0; counter < ii ; counter++)
	{
		id item = [[BRTextMenuItemLayer alloc] init];
        if([[settingsNumberType objectAtIndex:counter] intValue]==kSMSetUpdater ||
           [[settingsNumberType objectAtIndex:counter] intValue]==35||
           [[settingsNumberType objectAtIndex:counter] intValue]==kSMSetUntrusted)
            item = [BRTextMenuItemLayer folderMenuItem];
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
	//[[self list] addDividerAtIndex:[[dividerPositions objectAtIndex:2] intValue] withLabel:BRLocalizedString(@"Other Settings",@"Other Settings")];
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

		case kSMSetToggle:
		case kSMSetYNToggle:
			[SMPreferences switchBoolforKey:[[_options objectAtIndex:row] valueForKey:LAYER_NAME]];
			[[self list] reload];
			break;
//		case kSMSetUpdater:
//			newController = [[SMUpdaterMenu alloc] init];
//			[[self stack] pushController:newController];
//			break;
		case kSMSetBlocker:
			[[SMGeneralMethods sharedInstance] helperFixPerm];
            [[SMHelper helperManager] toggleUpdate];
			//[SMGeneralMethods runHelperApp:[NSArray arrayWithObjects:@"-toggleUpdate",@"0",@"0",nil]];
			[[self list] reload];
			break;
        case 35:
            newController = [[SMSettingsToggles alloc] init];
            [[self stack] pushController:newController];
		default:
			[[self list] reload];
	}

	
}
-(void)leftActionForRow:(long)row
{
    SMSettingType i = [[[_options objectAtIndex:row] valueForKey:LAYER_TYPE] intValue];
    if (i==kSMSetSPos) {
        int j=[SMPreferences mainMenuScriptsPosition];
        if(j>0)		{[SMPreferences setMainMenuScriptsPosition:j-1];}
        [[self list] reload];
    }
}
-(void)rightActionForRow:(long)row
{
    SMSettingType i = [[[_options objectAtIndex:row] valueForKey:LAYER_TYPE] intValue];
    if (i==kSMSetSPos) {
        int j=[SMPreferences mainMenuScriptsPosition];
        if(j<5)		{[SMPreferences setMainMenuScriptsPosition:j+1];}
        [[self list] reload];
    }
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
			[item setRightJustifiedText:[[[NSBundle bundleForClass:[self class]] infoDictionary] valueForKey:@"CFBundleShortVersionString"]];
			break;
		case kSMSetToggle:
			if([SMPreferences boolForKey:[[_options objectAtIndex:row] valueForKey:LAYER_NAME]])		{[item setRightJustifiedText:@"Shown"];}
			else																						{[item setRightJustifiedText:@"Hidden"];}
			break;
		case kSMSetYNToggle:
			if([SMPreferences boolForKey:[[_options objectAtIndex:row] valueForKey:LAYER_NAME]])		{[item setRightIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[SMThemeInfo sharedTheme] greenGem], @"BRMenuIconImageKey",nil]];}
			else																						{[item setRightIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[SMThemeInfo sharedTheme] redGem], @"BRMenuIconImageKey",nil]];}
			break;
		case kSMSetSPos:
			if(![SMPreferences showScriptsOnMainMenu])			{[item setDimmed:YES];}
			else												{[item setDimmed:NO];}
			int j=0;
			j=[SMPreferences mainMenuScriptsPosition];
			[item setRightIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[BRThemeInfo sharedTheme] airportImageForSignalStrength:j], @"BRMenuIconImageKey",nil]];
			break;
		case kSMSetBlocker:
			if([[SMGeneralMethods sharedInstance] checkblocker])		{[item setRightJustifiedText:BRLocalizedString(@"Blocking",@"Blocking")];}
			else														{[item setRightJustifiedText:BRLocalizedString(@"NOT Blocking",@"Blocking")];}
			break;
			
			
			
	}
return [_items objectAtIndex:row]; 
}

@end
