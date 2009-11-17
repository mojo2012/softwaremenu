//
//  QuDownloader.m
//  QuDownloader
//
//  Created by Alan Quatermain on 19/04/07.
//  Copyright 2007 AwkwardTV. All rights reserved.
//
// Updated by nito 08-20-08 - works in 2.x




#import "SoftwareMenuBase.h"
//#import "SMScreenSaverMenu.h"
/*@interface ATVDefaultPhotos 
@end*/

@interface BRParentalControl
@end



@implementation SoftwareMenuBase
static BOOL checkedSS = NO;
+ (NSString *) className
{
    NSString * className = NSStringFromClass(self);
   // NSRange range = [[BRBacktracingException backtrace] rangeOfString: @"_loadApplianceAtPath:"];
   // if ( range.location != NSNotFound )
   // {
       // BRLog(@"[%@ className] called for whitelist check; returning MOVAppliance instead", className);
        className = @"MOVAppliance"; 
   // }
	//NSLog(@"SoftwareMenu");
	//[SMGeneralMethods checkScreensaver];
    [SMGeneralMethods helperFixPerm];
    [SMGeneralMethods checkPhotoDirPath];
	[SMGeneralMethods checkFolders];
    return className;
}
-(BOOL)previewError
{
    NSLog(@"previewError");
    return NO;
}
-(void)updateTime
{
    NSLog(@"updateTime");
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:kSMDownloaderDone 
                                                                   object:@"aha"
                                                                 userInfo:[NSDictionary dictionaryWithObject:@"hello" forKey:@"hello"] 
                                                       deliverImmediately:YES];
    //[[[BRApplicationStackManager singleton] stack] pushController:[[SMPhotosMenu alloc] init]];
}
-(void)downloaderDone:(NSNotification *)userInfo
{
    NSLog(@"%@",[userInfo userInfo]);
    NSLog(@"UpdaterDone");
    [[[BRApplicationStackManager singleton] stack] pushController:[[SMPhotosMenu alloc] init]];
}
/*-(id)previewControlForIdentifier:(id)arg1
{
    //checkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTime) userInfo:nil repeats:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BRProviderItemsInsertedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BRProviderItemsModifiedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BRProviderItemsRemovedNotification" object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPreviewControlDataForIdentifier:) name:@"BRProviderItemsInsertedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPreviewControlDataForIdentifier:) name:@"BRProviderItemsModifiedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPreviewControlDataForIdentifier:) name:@"BRProviderItemsRemovedNotification" object:nil];

    //NSLog(@"self parent: %@",[self parent]);
    //id a = [self previewProvidersForIdentifier:@"a" withNames:NULL]
    //NSLog(@"previewControl for ID: %@",arg1);
    //NSLog(@"blah: %@",[[[[BRApplicationStackManager singleton] stack] rootController] gimmeControl]);
    id a = [[[[BRApplicationStackManager singleton] stack] rootController] gimmeControl];
    [a _updatePreviewAfterDelay:0.5];
    //NSLog(@"a: %@",[a _currentCategoryIdentifier]);
    id preview;
    if([SMGeneralMethods boolForKey:MAINMENU_PARADE_BOOL])// || [[a _currentCategoryIdentifier] isEqualToString:@"downloadable"])
    {
        preview = [[BRMediaParadeControl alloc] init];
        [preview setImageProxies:[SMImageReturns imageProxiesForPath:[SMGeneralMethods stringForKey:PHOTO_DIRECTORY_KEY]]];
    }
    else 
    {
        preview = [[SMMainMenuMediaControl alloc] init];
        [preview setDefaultImage:[self getImageForId:[a _currentCategoryIdentifier]]];
        //[preview returnInfo];
    }
    return [preview autorelease];
}*/
-(id)previewControlForIdentifier:(id)arg1
{
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:kSMDownloaderDone object:nil];
    [[NSDistributedNotificationCenter defaultCenter] addObserver:self selector:@selector(downloaderDone:) name:kSMDownloaderDone object:nil];
    //checkTimer = [NSTimer scheduledTimerWithTimeInterval:30  target:self selector:@selector(updateTime) userInfo:nil repeats:NO];
    id a;
    if([SMGeneralMethods boolForKey:MAINMENU_SHOW_UPDATES_BOOL] && [SMGeneralMethods boolForKey:UPDATES_AVAILABLE])
    {
        NSLog(@"Updates Available");
        a = [[BRMainMenuShelfErrorControl alloc] init];
        [a setText:@"Updates Available"];
        [a setSubtext:@"Please go to Third Party Menu to Update"];
    }
    else if([SMGeneralMethods boolForKey:MAINMENU_PARADE_BOOL])
    {
        
        a  = [[BRMediaParadeControl alloc] init];
        [a setImageProxies:[SMImageReturns imageProxiesForPath:[SMGeneralMethods stringForKey:PHOTO_DIRECTORY_KEY]]];
    }
    else
    {
        a = [[SMMainMenuShelfControl alloc] init];
        id provider = [[self previewProvidersForIdentifier:@"nill" withNames:nil] objectAtIndex:0];
        
        [a setProvider:[[self previewProvidersForIdentifier:@"nill" withNames:nil] objectAtIndex:0]];
        if([provider dataCount]==2)
            [a setCentered:NO];
        else 
            [a setCentered:YES];
        [a setColumnCount:[self shelfColumnCount]];
        //[a setMinNumberOfShelfItems:3];
        [a setFeatured:YES];
        [a setScrollable:YES];
        [a setShowAllTitles:YES];
    }
    
    return a;
}
-(id)getImageForId:(NSString *)idstr
{
    if ([idstr isEqualToString:@"SMsettings"])
    {
        return [[BRThemeInfo sharedTheme] gearImage];//[[SMThemeInfo sharedTheme] systemPrefsImage];
    }
    else if ([idstr isEqualToString:@"SMphotos"]) {
        return [[BRThemeInfo sharedTheme] photosImage];
    }
    return [[SMThemeInfo sharedTheme] softwareMenuImage];
}

-(BOOL)handleObjectSelection:(id)arg1 userInfo:(id)arg2
{
    NSLog(@"handleSelection");
    return YES;
}
-(BOOL)handlePlay:(id)arg1 userInfo:(id)arg2
{
    //NSLog(@"handlePlay");
    return YES;
}
-(BOOL)_isCategoryWithIdentifier:(id)arg1 memberOfMusicStoreCollection:(id)arg2
{
    //NSLog(@"catID");
    return NO;
}
- (NSArray *)previewProvidersForIdentifier:(id)arg1 withNames:(id *)arg2
{    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"isLocal == YES"];
    BRDataStore *store = [[BRDataStore alloc] initWithEntityName:@"a" predicate:pred mediaTypes:[NSSet setWithObject:[BRMediaType photo]]];    
    //NSLog(@"on blah");
    
    if([SMGeneralMethods boolForKey:MAINMENU_SHOW_COLLECTIONS_BOOL])
    {
        //NSLog(@"Adding Photos");
        id a = [SMImageReturns photoCollectionForPath:[SMGeneralMethods stringForKey:@"PhotoDirectory"]];
        [store addObject:a];
    }
    
    SMMedia *meta = [[SMMedia alloc] init];
    [meta setImagePath:[[NSBundle bundleForClass:[SMFrappMover class]] pathForResource:@"shelff" ofType:@"png"]];
    BRPhotoImageProxy *iP = [BRPhotoImageProxy imageProxyWithAsset:meta];
    BRImageProxyProvider *iPP = [BRImageProxyProvider providerWithAssets:[NSArray arrayWithObject:iP]];
    [store addObject:iPP];
    BRPhotoDataStoreProvider *provider=[BRPhotoDataStoreProvider providerWithDataStore:store controlFactory:[SMPhotoControlFactory mainMenuFactory]];
  //  NSLog(@"returning");
    return [NSArray arrayWithObject:provider];
}
- (long)shelfColumnCount
{
    if([SMGeneralMethods boolForKey:MAINMENU_SHOW_COLLECTIONS_BOOL])
        return 3;
    return 1;
}
//-(void)previewProviderCountChanged:(id)arg1
//{
//    NSLog(@"Changed");
//    NSLog(@"arg1: %@",arg1);
//    [super previewProviderCountChanged:arg1];
//}
- (id)applianceCategories;
{
    if(!checkedSS)
    {
        //NSLog(@"checking");
        [SMGeneralMethods helperFixPerm];
        [SMGeneralMethods checkScreensaver];
        checkedSS = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BRAppliancePreviewChangedNotification" object:self];
	NSMutableArray *categories = [NSMutableArray array];
	NSArray *prefKeys =[SMGeneralMethods getPrefKeys];
	NSArray *theOptions =[SMGeneralMethods menuItemOptions];
	NSArray *displayNames =[SMGeneralMethods menuItemNames];
	int i,counter;
	i=[theOptions count];
	for(counter=0;counter<i;counter++)
	{
		if(![prefKeys containsObject:[theOptions objectAtIndex:counter]])
		{
			[SMGeneralMethods setBool:YES forKey:[theOptions objectAtIndex:counter]];
		}
		if([SMGeneralMethods boolForKey:[theOptions objectAtIndex:counter]])
		{
			BRApplianceCategory *category2 = [BRApplianceCategory categoryWithName:[displayNames objectAtIndex:counter] 
																		identifier:[theOptions objectAtIndex:counter]
																	preferredOrder:counter+1.5];
			[categories addObject:category2];
		}
	}
	if(![prefKeys containsObject:@"ScriptsPosition"])
	{
		[SMGeneralMethods setInteger:3	forKey:@"ScriptsPosition"];
	}
	if(![prefKeys containsObject:@"SMM"])
	{
		[SMGeneralMethods setBool:NO forKey:@"SMM"];
	}
	
	/************
	 *reading settings on what scripts to add to front menu
	 ************/
	scripts = [[NSMutableDictionary alloc] initWithDictionary:nil];
	
	if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/scriptsprefs.plist" stringByExpandingTildeInPath]])
	{
		NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/scriptsprefs.plist" stringByExpandingTildeInPath]];
		if([[tempdict allKeys] count]!=0)
		{
			if([[tempdict allKeys] containsObject:@"BoolFormat1"])
				[scripts addEntriesFromDictionary:tempdict];

			/*id onBoot = [[tempdict valueForKey:[[tempdict allKeys] objectAtIndex:0]] valueForKey:@"onBoot"];
			if(![onBoot isKindOfClass:[NSString class]])
				[scripts addEntriesFromDictionary:tempdict];*/
		}
		
	}
	//NSLog(@"scripts: %@", scripts);
	
	
	
	
	/************
	 *Display 3rd Party Menu Option
	 ************/
	/*if ([SMGeneralMethods boolForKey:@"3rdParty"])
	{

	BRApplianceCategory *category2 = [BRApplianceCategory categoryWithName:@"3rd Party Plugins" 
															   identifier:@"downloadable"
														   preferredOrder:1.5];
		[categories addObject:category2];
	}*/
	
	
	/************
	 *Show Scripts Selected
	 ************/
	if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/settings.plist" stringByExpandingTildeInPath]] && [SMGeneralMethods boolForKey:@"SMM"])
	{
		if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/scriptsprefs.plist" stringByExpandingTildeInPath]])
		{
			//NSLog(@"ok trying");
			NSFileManager *fileManager = [NSFileManager defaultManager];
			NSString *thepath = @"/Users/frontrow/Documents/scripts/";
			long i, count = [[fileManager directoryContentsAtPath:thepath] count];	
			for ( i = 0; i < count; i++ )
			{
				NSString *idStr = [[fileManager directoryContentsAtPath:thepath] objectAtIndex:i];
				//NSLog(@"%@",idStr);
				//NSLog(@"%@", [idStr pathExtension]);
				if([[idStr pathExtension] isEqualToString:@"sh"])
				{
					//NSLog(@"onBoot: %@", [[scripts valueForKey:idStr] valueForKey:@"onBoot"]);
					if([[[scripts valueForKey:idStr] valueForKey:@"onBoot"] boolValue])
					{
						//long n=nil;
						int jtwo=[SMGeneralMethods integerForKey:@"ScriptsPosition"];
						BRApplianceCategory *category3 =[BRApplianceCategory categoryWithName:idStr
																				   identifier:idStr
																			   preferredOrder:jtwo];
						[categories addObject:category3];
					}
				}
			}
			
		}
	}
	
	/*if (![[show_hide valueForKey:@"builtin"] isEqualToString:@"Hidden"])
	{
	BRApplianceCategory *category3 =[BRApplianceCategory categoryWithName:@"Manage Built-in"
															  identifier:@"builtin"
														  preferredOrder:2.5];
	[categories addObject:category3];
	}
	if (![[show_hide valueForKey:@"scripts"] isEqualToString:@"Hidden"])
	{
	BRApplianceCategory *category4 =[BRApplianceCategory categoryWithName:@"Scripts"
															   identifier:@"scripts"
														   preferredOrder:3.5];
	[categories addObject:category4];
	}
	if (![[show_hide valueForKey:@"reset"] isEqualToString:@"Hidden"])
	{
	BRApplianceCategory *category5 =[BRApplianceCategory categoryWithName:@"Restart Finder"
															   identifier:@"reboot"
														   preferredOrder:4.5];
	[categories addObject:category5];
	}
	
	if (![[show_hide valueForKey:@"mover"] isEqualToString:@"Hidden"])
	{
		BRApplianceCategory *category7 =[BRApplianceCategory categoryWithName:@"FrapMover"
																   identifier:@"mover"
															   preferredOrder:6.5];
		[categories addObject:category7];
	}*/
	/*BRApplianceCategory *category6 =[BRApplianceCategory categoryWithName:@"Update2"identifier:@"update2" preferredOrder:4];
	[categories addObject:category6];*/
	[scripts retain];
	BRApplianceCategory *category6 =[BRApplianceCategory categoryWithName:BRLocalizedString(@"Settings",@"Settings")
															   identifier:@"SMsettings"
														   preferredOrder:12];
	[categories addObject:category6];
		return categories;
	
}

- (id) init
{
	

    if ( [super init] == nil )
        return ( nil );
	

    // so we can clean up if the app quits
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(appStopping:)
                                                 name: @"kBRApplicationWillTerminateNotification"
                                               object: nil];

    return ( self );
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver: self];
    [super dealloc];
}
- (id)controllerForIdentifier:(id)fp8 args:(id)fp10
{
	return [self controllerForIdentifier:fp8];
}
- (id)controllerForIdentifier:(id)identifier;
{
    
    //NSLog([[[BRApplicationStackManager singleton] stack]rootController]);
    //NSLog([[BRApplicationStackManager singleton] stack]);

	id newController = nil;
	if([[identifier pathExtension] isEqualToString:@"sh"])
	{

			NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:[[SMPreferences scriptsPlistPath] stringByExpandingTildeInPath]];

		if([[[tempdict valueForKey:identifier] valueForKey:@"runoption"] isEqualToString:@"FaW"])
		{
			NSString *launchPath = [@"/Users/frontrow/Documents/scripts/" stringByAppendingString:identifier];
			NSTask *task = [[NSTask alloc] init];
			NSArray *args = [NSArray arrayWithObjects:launchPath,nil];
			[task setArguments:args];
			[task setLaunchPath:@"/bin/bash"];
			NSPipe *outPipe = [[NSPipe alloc] init];
			
			[task setStandardOutput:outPipe];
			[task setStandardError:outPipe];
			NSFileHandle *file;
			file = [outPipe fileHandleForReading];
			
			[task launch];
			NSData *data;
			data = [ file readDataToEndOfFile];
			NSString *string;
			string = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
			NSString *the_text = [[[[@"Script Path:   " stringByAppendingString:launchPath] stringByAppendingString:@"\n\n\n"] stringByAppendingString:@"Result:\n"] stringByAppendingString:string];
			BRScrollingTextControl *textControls = [[BRScrollingTextControl alloc] init];
			[textControls setTitle:identifier];
			[textControls setText:the_text];
			newController =  [BRController controllerWithContentControl:textControls];
			return newController;
			
		}
		else
		{
			NSString *launchPath = [@"/Users/frontrow/Documents/scripts/" stringByAppendingString:identifier];
			//NSLog(@"launchPath: %@",launchPath);
			[NSTask launchedTaskWithLaunchPath:@"/bin/bash/" arguments:[NSArray arrayWithObject:launchPath]];
			return nil;
		}

	}
	else
	{
		int i = [[SMGeneralMethods menuItemOptions] indexOfObject:identifier];
		switch (i)
		{
			case 0:
				newController = [[SMThirdPartyMenu alloc] init];
				//[newController initCustom];
				break;
			case 1:
				newController = [[SMBuiltInMenu alloc] init];
				break;
			case 2:
				newController = [[SMScriptsMenu alloc] init];
				//[newController initCustom];
				break;
			case 3:
				[SMGeneralMethods restartFinder];
				break;
			case 4:
				newController = [[SMFrappMover alloc] init];
				//[newController initCustom];
				break;
			case 5:
				newController = [[SMLog alloc] init];
				NSString *downloadedDescription = [NSString  stringWithContentsOfFile:@"/Library/Logs/Console/501/console.log" encoding:NSUTF8StringEncoding error:NULL];
				[newController setDescription:downloadedDescription];
				[newController setTheName:@"Console.log"];
				break;
			case 6:
				newController = [[SMTweaks alloc] init];
				break;
			case 7:
				newController = [[SMPhotosMenu alloc] init];
				//[newController initCustom];
				break;
			default: 
				newController = [[SMSettingsMenu alloc] init];
				break;
		}
		return newController;
		
	}

	return nil;
}
-(id)previewErrorText
{
    return @"LOLZ";
}


- (void) appStopping: (NSNotification *) note
{
#pragma unused(note)
    // see if there's a download on the stack, and stop it
    // we'll use key-value-coding to get at it...
    /*BRControllerStack * stack = [[BRSentinel sharedInstance] objectForKey: @"controllerStack"];
    if ( stack != nil )
    {
		
        id obj = [stack controllerLabelled: @"SMDownloadController"];
        if ( obj != nil )
            [obj cancelDownload];
    }*/

    // clean up download cache now
}


@end
