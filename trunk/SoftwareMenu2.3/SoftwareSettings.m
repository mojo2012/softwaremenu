//
//  SoftwareSettings.m
//  SoftwareMenu
//
//  Created by Thomas on 11/3/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SoftwareSettings.h"
//#import "SoftwareUntrusted.h"
#import "SoftwareManual.h"
#import "SMUpdater.h"
#import "SMGeneralMethods.h"
#import "SMMedia.h"
#import "SMMediaPreview.h"
//#import "BackRow/BRMetadataPreviewControl.h"
#import "BackRowUtilstwo.h"
//#typedef enum {       FILE_CLASS_UTILITY= -2} FileClass;
#define META_TITLE_KEY                                  @"Title"
#define FILE_CLASS_KEY                                  @"File Class"
#define META_DESCRIPTION_KEY                    @"Show Description"



@implementation SoftwareSettings
static NSDate *lastFilterChangeDate = nil;
- (BOOL)_assetHasMetadata
	{
		return YES;
	}

/*- (id) previewControlForItem: (long) item
{
	id asset =[[BRBaseMediaAsset alloc] init];

	NSString *appPng = nil;
	NSString * theoption = [[_options objectAtIndex:item] valueForKey:NAME_KEY];
	
	appPng = [[SMGeneralMethods sharedInstance] getImagePathforDict:[NSDictionary dictionaryWithObjectsAndKeys:SM_KEY,TYPE_KEY,theoption,NAME_KEY,nil]];
	BRImageAndSyncingPreviewController *obj = [[BRImageAndSyncingPreviewController alloc] init];
	id sp = [BRImage imageWithPath:appPng];
	
	[obj setImage:sp];
	return (obj);
}*/
- (id) previewControlForItem: (long) item
{
    // If subclassing BRMediaMenuController, this function is called when the selection cursor
    // passes over an item.
	if(item >= [_items count])
		return nil;
	else
	{
		//NSLog(@"in preview loop");
		//NSArray *names = [[NSArray alloc] initWithObjects:       BRLocalizedString(@"  Populate File Data", @"Populate File Data menu item"),BRLocalizedString(@"  Fetch TV Show Data", @"Fetch TV Show Data menu item"),nil];
		/* Get setting name & kill the gem cushion  */
		NSString *settingName = @"hello";
		//NSArray *settingDescriptions=[[NSArray alloc] initWithObjects: BRLocalizedString(@"Tells Sapphire that for every TV episode, gather more information about this episode from the internet.", @"Fetch TV Show Data description"),nil];
		NSString *settingDescription=@"Bye";
		/* Construct a gerneric metadata asset for display */
		/*NSMutableDictionary *settingMeta=[[NSMutableDictionary alloc] init];
		 [settingMeta setObject:settingName forKey:META_TITLE_KEY];
		 [settingMeta setObject:[NSNumber numberWithInt:-2] forKey:FILE_CLASS_KEY];
		 [settingMeta setObject:settingDescription forKey:META_DESCRIPTION_KEY];
		 SMMediaPreview *preview = [[SMMediaPreview alloc] init];
		 [preview setUtilityData:settingMeta];
		 [preview setShowsMetadataImmediately:YES];*/
		//[preview _populateMetadata];
		/*SMMedia *media = [[SMMedia alloc] init];
		[media setImagePath:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/SoftwareMenu.png"];
		[media setObject:@"hello" forKey:@"title"];
		BRMetadataControl *meta=[[BRMetadataControl alloc] init];
		 [meta setTitle:BRLocalizedString(@"Hello",@"Hello")];
		 [meta setSummary:BRLocalizedString(@"hello",@"Hello")];
		 [meta setStarRating:nil];
		 [meta setRating:nil];
		 [meta setCopyright:nil];*/
		SMMedia	*meta = [[SMMedia alloc] init];
		/*[meta setObject:@"hello" forKey:@"title"];
		[meta setObject:@"hello" forKey:@"description"];
		[meta setObject:@"Bye" forKey:@"mediaSummary"];
		[meta setObject:@"SoftwareMenu.png" forKey:@"id"];
		[meta setObject:[BRMediaType movie] forKey:@"mediaType"];*/
		[meta setImagePath:@"hello"];
		//NSURL *hello = [[NSURL alloc] initFileURLWithPath:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/Contents/Resources/SoftwareMenu.png"];
		//[meta setObject:[hello absoluteString] forKey:@"previewURL"];
		//
		//[meta setObject:[hello absoluteString] forKey:@"mediaURL"];
		

		BRMetadataPreviewControl *previewtoo =[[BRMetadataPreviewControl alloc] init];
		[previewtoo setAsset:meta];

		[previewtoo setShowsMetadataImmediately:YES];
		[previewtoo setDeletterboxAssetArtwork:NO];
		[previewtoo _updateMetadataLayer];

		return [previewtoo autorelease];
		
		//BRMediaAssetItemProvider *assetProvider =[[BRMediaAssetItemProvider alloc] init];
		//[assetProvider setMediaAssets:[NSArray arrayWithObjects:meta,nil]];
		//[media setObject:@"hello" forKey:META_DESCRIPTION_KEY];
		//[previewtoo setMetadataProvider:hellotoo];
		//[previewtoo setMetadataProvider:assetProvider];*/
		/*And go*/
		//[preview doPopulation];
		
	}
    return ( nil );
}







- (void)dealloc
{
	[_options release];
	[_items release];
	[super dealloc];  
}

-(id)initWithIdentifier:(NSString *)initId
{
	[[self list] removeDividers];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: NSLocalizedString(@"Settings",@"Settings")
	];
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	NSArray * settingNames = [SMGeneralMethods menuItemOptions];
	NSArray * settingDisplays = [SMGeneralMethods menuItemNames];
	_show_hide = [[NSMutableDictionary alloc] initWithDictionary:nil];
	
	if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/settings.plist" stringByExpandingTildeInPath]])
	{
		NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/settings.plist" stringByExpandingTildeInPath]];
		[_show_hide addEntriesFromDictionary:tempdict];
		//NSLog(@"adding from temp dict");
	}
	/********************
	 * General Info     *
	 ********************/
	id item1 =[[BRTextMenuItemLayer alloc] init];
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",LAYER_TYPE,@"atv_info",LAYER_NAME,SM_KEY,TYPE_KEY,@"SoftwareMenu",NAME_KEY,nil]];
	[item1 setTitle:@"ATV Version:"];
	NSDictionary *atv_framework_plist = [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/version.plist"];
	//NSLog(@"ATV_plist:%@",atv_framework_plist);
	NSString *atv_version = [atv_framework_plist valueForKey:@"CFBundleVersion"];
	[item1 setRightJustifiedText:atv_version];
	[_items addObject:item1];
	
	id item2 =[[BRTextMenuItemLayer alloc] init];
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"0",LAYER_TYPE,@"SM_info",LAYER_NAME,SM_KEY,TYPE_KEY,@"SoftwareMenu",NAME_KEY,nil]];
	[item2 setTitle:@"Software Menu Version:"];
	NSDictionary *sm_info_plist = [[NSBundle bundleForClass:[self class]] infoDictionary];
	//NSLog(@"Software Menu Version:",sm_info_plist);
	NSString *sm_version = [sm_info_plist valueForKey:@"CFBundleVersion"];
	[item2 setRightJustifiedText:sm_version];
	[_items addObject:item2];

	int iii=[_items count];
	int ii;//
	ii=[settingNames count];
	int counter;
	
	for( counter=0; counter < ii ; counter++)
	{
		id item = [[BRTextMenuItemLayer alloc] init];
		
		NSString *settingName = (NSString *)[settingNames objectAtIndex:counter];
		NSString *settingDisplay =(NSString *)[settingDisplays objectAtIndex:counter];
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"1",LAYER_TYPE,settingName,LAYER_NAME,SM_KEY,TYPE_KEY,@"SoftwareMenu",NAME_KEY,nil]];
		//NSLog(@"%@",settingName);
		[item setTitle:settingDisplay];
			if([SMGeneralMethods boolForKey:settingName])
			{
				[item setRightJustifiedText:BRLocalizedString(@"Shown",@"Shown")];
			}
			else
			{
				[item setRightJustifiedText:BRLocalizedString(@"Hidden",@"Hidden")];
				[SMGeneralMethods setBool:NO forKey:settingName];
			}
		
		[_items addObject:item];
		
		
		//UNtrusted
		
	}
	int othersec = [_items count];
	/*************
	 * ARF (Auto Restart Finder)
	 *************/
	NSMutableArray * settingDisplaysOne=[[NSMutableArray alloc] initWithObjects:BRLocalizedString(@"Auto Restart Finder",@"Auto Restart Finder"),BRLocalizedString(@"Scripts Main Menu",@"Scripts Main Menu"),nil];
	NSMutableArray * settingNamesOne=[[NSMutableArray alloc] initWithObjects:@"ARF",@"SMM",nil];
	ii=[settingNamesOne count];
	for( counter=0; counter < ii ; counter++)
	{
		id item2 = [[BRTextMenuItemLayer alloc] init];
		
		NSString *settingName = (NSString *)[settingNamesOne objectAtIndex:counter];
		NSString *settingDisplay =(NSString *)[settingDisplaysOne objectAtIndex:counter];
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2",LAYER_TYPE,settingName,LAYER_NAME,SM_KEY,TYPE_KEY,@"SoftwareMenu",NAME_KEY,nil]];
		//NSLog(@"%@",settingName);
		[item2 setTitle:settingDisplay];
		if([SMGeneralMethods boolForKey:settingName])
		{
			[item2 setRightJustifiedText:BRLocalizedString(@"YES",@"YES")];
		}
		else
		{
			[item2 setRightJustifiedText:BRLocalizedString(@"NO",@"NO")];
			[SMGeneralMethods setBool:NO forKey:settingName];
		}
		
		[_items addObject:item2];
		
		
		//UNtrusted
		
	}
	/*[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2",LAYER_TYPE,@"ARF",LAYER_NAME,SM_KEY,TYPE_KEY,@"SoftwareMenu",NAME_KEY,nil]];
	id item2 = [[BRTextMenuItemLayer alloc] init];
	[item2 setTitle:@"Auto Restart Finder"];
	if([SMGeneralMethods boolForKey:@"ARF"])
	{
		[item2 setRightJustifiedText:@"YES"];
	}
	else
	{
		[item2 setRightJustifiedText:@"NO"];
		[SMGeneralMethods setBool:NO forKey:@"ARF"];
	}
	[_items addObject:item2];*/
	
	/*************
	 * Scripts on Main Menu
	 *************/
	/*[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2",LAYER_TYPE,@"SMM",LAYER_NAME,SM_KEY,TYPE_KEY,@"SoftwareMenu",NAME_KEY,nil]];
	id item4 = [[BRTextMenuItemLayer alloc] init];
	[item4 setTitle:@"Scripts on Main Menu"];
	if([[_show_hide valueForKey:@"SMM"]isEqualToString:@"YES"])
	{
		[item4 setRightJustifiedText:@"YES"];
	}
	else if([[_show_hide valueForKey:@"SMM"]isEqualToString:@"NO"])
	{
		[item4 setRightJustifiedText:@"NO"];
	}
	else
	{
		[_show_hide setObject:@"YES" forKey:@"SMM"];
		[item4 setRightJustifiedText:@"YES"];
	}
	[_items addObject:item4];*/
	
	/*************
	 * Scripts Position
	 *************/
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2.1",LAYER_TYPE,@"ScriptsPosition",LAYER_NAME,SM_KEY,TYPE_KEY,@"SoftwareMenu",NAME_KEY,nil]];
	id item3 = [[BRTextMenuItemLayer alloc] init];
	[item3 setTitle:@"Scripts Location"];
	int j=0;
	j=[SMGeneralMethods integerForKey:@"ScriptsPosition"];
	[item3 setRightIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[BRThemeInfo sharedTheme] airportImageForSignalStrength:j], @"BRMenuIconImageKey",nil]];
	
	if(![SMGeneralMethods boolForKey:@"SMM"])
	{
		[item3 setDimmed:YES];
	}
	[_items addObject:item3];
	
	int upgradeIndex=[_items count];
	
	id item7 = [[BRTextMenuItemLayer alloc] init];
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2.5",LAYER_TYPE,@"toggleUpdateBlocker",LAYER_NAME,SM_KEY,TYPE_KEY,@"SoftwareMenu",NAME_KEY,nil]];
	[item7 setTitle:BRLocalizedString(@"UpdateBlocker",@"UpdateBlocker")];
	BOOL toggleUp = NO;
	toggleUp=[[SMGeneralMethods sharedInstance] checkblocker];
	if(toggleUp)
	{
		[item7 setRightJustifiedText:BRLocalizedString(@"Blocking",@"Blocking")];
	}
	else
	{
		[item7 setRightJustifiedText:BRLocalizedString(@"NOT Blocking",@"Blocking")];
	}
	[_items addObject:item7];
	
	id item5 = [[BRTextMenuItemLayer alloc] init];
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"2.5",LAYER_TYPE,@"Updater",LAYER_NAME,SM_KEY,TYPE_KEY,@"Upgrader",NAME_KEY,nil]];
	[item5 setTitle:NSLocalizedString(@"Updater",@"Updater")];
	[_items addObject:item5];
	
	int untrustedsec = [_items count];
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"3",LAYER_TYPE,@"Manage",LAYER_NAME,SM_KEY,TYPE_KEY,@"Upgrader",NAME_KEY,nil]];
	id item6 = [BRTextMenuItemLayer folderMenuItem];
	[item6 setTitle:NSLocalizedString(@"Manage Untrusted Sources",@"Manage Untrusted Sources")];
	[item6 axSelectedItemText];
	[_items addObject:item6];

	
	[_show_hide writeToFile:@"Users/frontrow/Library/Application Support/SoftwareMenu/settings.plist" atomically:YES];
	id list = [self list];
	[list setDatasource: self];
	[[self list] addDividerAtIndex:0 withLabel:BRLocalizedString(@"System Info",@"System Info")];
	[[self list] addDividerAtIndex:iii withLabel:BRLocalizedString(@"Main Menu Settings",@"Main Menu Settings")];
	[[self list] addDividerAtIndex:upgradeIndex withLabel:BRLocalizedString(@"Upgrader",@"Upgrader")];
	[[self list] addDividerAtIndex:othersec withLabel:BRLocalizedString(@"Other Settings",@"Other Settings")];
	[[self list] addDividerAtIndex:untrustedsec withLabel:BRLocalizedString(@"Manage Untrusted Sources",@"Manage Untrusted Sources")];
	return self;
	
}



-(void)itemSelected:(long)fp8
{
	//NSLog(@"settingsChanged: %@",[[_options objectAtIndex:fp8] valueForKey:LAYER_NAME]);
	if([[[_options objectAtIndex:fp8] valueForKey:LAYER_TYPE] isEqualToString:@"1"] || [[[_options objectAtIndex:fp8] valueForKey:LAYER_TYPE] isEqualToString:@"2"])
	{
		//NSMutableDictionary *hello=[NSMutableDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/settings.plist" stringByExpandingTildeInPath]];
		NSString *settingsChanged=[[_options objectAtIndex:fp8] valueForKey:LAYER_NAME];
		//NSLog(@"settingsChanged: %@", settingsChanged);
		//NSString *settingIs= [hello valueForKey:settingsChanged];
		[SMGeneralMethods switchBoolforKey:settingsChanged];
		[self initWithIdentifier:@"101"];
	}
	/*else if([[[_options objectAtIndex:fp8] valueForKey:LAYER_TYPE] isEqualToString:@"2"])
	{
		NSMutableDictionary *hello=[NSMutableDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/settings.plist" stringByExpandingTildeInPath]];
		NSString *settingsChanged=[[_options objectAtIndex:fp8] valueForKey:LAYER_NAME];
		NSString *settingIs= [hello valueForKey:settingsChanged];
		if([settingIs isEqualToString:@"YES"])
		{
			[hello setValue:@"NO" forKey:settingsChanged];
			
			
		}
		else
		{
			[hello setValue:@"YES" forKey:settingsChanged];
		}
		//NSLog(@"new value is %@", [hello valueForKey:@"settingsChanged"]);
		[hello writeToFile:@"Users/frontrow/Library/Application Support/SoftwareMenu/settings.plist" atomically:YES];
		[self initWithIdentifier:@"101"];
		
	}*/
	else if([[[_options objectAtIndex:fp8] valueForKey:LAYER_TYPE] isEqualToString:@"2.5"])
	{
		if([[[_options objectAtIndex:fp8] valueForKey:LAYER_NAME] isEqualToString:@"Updater"])
		{
			//NSLog(@"Going to Software Updater");
			id newController = nil;
			newController = [[SMUpdater alloc] init];
			[newController initCustom];
			[[self stack] pushController:newController];
		}
		else if([[[_options objectAtIndex:fp8] valueForKey:LAYER_NAME] isEqualToString:@"toggleUpdateBlocker"])
		{
			
			SMGeneralMethods *ihc = [[SMGeneralMethods alloc] init];
			[ihc helperFixPerm];
			NSString *helperLaunchPath= [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
			NSTask *task6 = [[NSTask alloc] init];
			NSArray *args6 = [NSArray arrayWithObjects:@"-toggleUpdate",@"0",@"0",nil];
			[task6 setArguments:args6];
			[task6 setLaunchPath:helperLaunchPath];
			[task6 launch];
			[task6 waitUntilExit];
			[self initWithIdentifier:@"101"];
		}
		
	}
	if([[[_options objectAtIndex:fp8] valueForKey:LAYER_NAME] isEqualToString:@"Manage"])
	{
		id newController = nil;
		newController = [[SoftwareManual alloc] init];
		[newController initWithIdentifier:nil];
		[[self stack] pushController:newController];
		// Call for Menu to manage untrusted
		/*CFPreferencesSetAppValue(CFSTR("status"), (CFStringRef)[NSString stringWithString:@"name"],kCFPreferencesCurrentApplication);

		BRTextEntryController *textinput = [[BRTextEntryController alloc] init];
		 [textinput setTitle:@"add Untrusted: Name"];
		 [textinput setTextEntryCompleteDelegate:self];
		 [[self stack] pushController:textinput];*/
	}
	if([[[_options objectAtIndex:fp8] valueForKey:LAYER_NAME] isEqualToString:@"AddUntrusted"])
	{
		/*id newController = nil;
		newController = [[SoftwareManual alloc] init];
		[newController initWithIdentifier:nil];
		[[self stack] pushController:newController];*/
		// Call for Menu to manage untrusted
		CFPreferencesSetAppValue(CFSTR("status"), (CFStringRef)[NSString stringWithString:@"name"],kCFPreferencesCurrentApplication);
		 
		 BRTextEntryController *textinput = [[BRTextEntryController alloc] init];
		 [textinput setTitle:@"add Untrusted: Name"];
		 [textinput setTextEntryCompleteDelegate:self];
		 [[self stack] pushController:textinput];
	}
	
}
- (BOOL)brEventAction:(BREvent *)event
{
	long selitem;
	unsigned int hashVal = (uint32_t)((int)[event page] << 16 | (int)[event usage]);
	if ([(BRControllerStack *)[self stack] peekController] != self)
		hashVal = 0;
	
	//int itemCount = [[(BRListControl *)[self list] datasource] itemCount];
	
	//NSLog(@"hashval =%i",hashVal);
	selitem = 0;
	
	selitem = [self getSelection];
	NSMutableArray *theoptions = [_options objectAtIndex:selitem];
	
	switch (hashVal)
	{
		case 65676:  // tap up
			//NSLog(@"type up");
			break;
		case 65677:  // tap down
			//NSLog(@"type down");
			break;
		case 65675:  // tap left
			//NSLog(@"type left");

			
			//NSLog(@"selection :%d",selitem);
			//NSLog(@"theoptions objectAtIndex:1 :%@", [theoptions objectAtIndex:1]);
			if(![[SMGeneralMethods sharedInstance] usingTakeTwoDotThree] || lastFilterChangeDate == nil || [lastFilterChangeDate timeIntervalSinceNow] < -0.4f)
			{
				[lastFilterChangeDate release];
				lastFilterChangeDate = [[NSDate date] retain];
				if([[theoptions valueForKey:LAYER_NAME] isEqualToString:@"ScriptsPosition"])
				{
					//NSLog(@"going to decrease");
					int i;
					i=[SMGeneralMethods integerForKey:@"ScriptsPosition"];
					if(i>0)
					{
						[SMGeneralMethods setInteger:i-1 forKey:@"ScriptsPosition"];
					}
					//[self modifyJ:@"decrease"];
					[self initWithIdentifier:@"101"];
				}
			}
			break;
		case 65674:
			//NSLog(@"type right");
			//NSLog(@"selection :%d",selitem);
			//NSLog(@"theoptions: %@",theoptions);
			if(![[SMGeneralMethods sharedInstance] usingTakeTwoDotThree] || lastFilterChangeDate == nil || [lastFilterChangeDate timeIntervalSinceNow] < -0.4f)
			{
				[lastFilterChangeDate release];
				lastFilterChangeDate = [[NSDate date] retain];
			if([[theoptions valueForKey:LAYER_NAME] isEqualToString:@"ScriptsPosition"])
			{
				int i;
				i=[SMGeneralMethods integerForKey:@"ScriptsPosition"];
				if(i<5)
				{
					[SMGeneralMethods setInteger:i+1 forKey:@"ScriptsPosition"];
				}
				[self initWithIdentifier:@"101"];
			}
			}
			break;
		case 65673:  // tap play
			/*selitem = [self selectedItem];
			 [[_items objectAtIndex:selitem] setWaitSpinnerActive:YES];*/
			//NSLog(@"type play");
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

-(long)defaultIndex
{
	return 0;
}
-(void)willBeBuried
{
	//NSLog(@"willBuried");
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:[[self list] datasource]];
	[super willBeBuried];
}

-(void)willBePushed
{
	//NSLog(@"willBePushed");
	[super willBePushed];
}

-(void)willBePopped
{
	//NSLog(@"willBePopped");
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:[[self list] datasource]];
	[super willBePopped];
}


//	Data source methods:
-(long)getLongValue:(NSString *)jtwo
{
	if([jtwo isEqualToString:@"1"])
	{
		//NSLog(@"j = 1");
		return 1;
	}
	else if([jtwo isEqualToString:@"2"])
	{
		//NSLog(@"j = 2");
		return 2;
	}
	else if([jtwo isEqualToString:@"3"])
	{
		//NSLog(@"j = 3");
		return 3;
	}
	else if([jtwo isEqualToString:@"4"])
	{
		//NSLog(@"j = 4");
		return 4;
	}
	else if([jtwo isEqualToString:@"5"])
	{
		//NSLog(@"j = 5");
		return 5;
	}
	else if([jtwo isEqualToString:@"0"])
	{
		//NSLog(@"j = 6");
		return 0;
	}
	//NSLog(@"j = 100");
	return 100;
}
-(void)modifyJ:(NSString *)changeValue
{
	NSString *jtwo=[_show_hide valueForKey:@"scriptsPos"];
	long j= [self getLongValue:jtwo];
	if([changeValue isEqualToString:@"decrease"])
	{
		if(j>0)
		{
			j=j-1;
		}
	}
	else if([changeValue isEqualToString:@"increase"])
	{
		
		if(j<5)
		{
			//NSLog(@"increasing");
			j=j+1;
			
		}
	}
	[_show_hide setObject:[NSString stringWithFormat:@"%d", j]	forKey:@"scriptsPos"];
	//NSLog(@"writing to file");
	[_show_hide writeToFile:@"Users/frontrow/Library/Application Support/SoftwareMenu/settings.plist" atomically:YES];
}

- (float)heightForRow:(long)row				{ return 0.0f; }
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}
- (id)itemForRow:(long)row					{ return [_items objectAtIndex:row]; }
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title]; }
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title]; }



@end
