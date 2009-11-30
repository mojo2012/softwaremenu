//
//  DownloadableMenu.m
//  QuDownloader
//
//  Created by Thomas on 10/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//
// in previewControlForItem: add support for downloadable icons
// add untrusted function...

#define DEBUG_MODE false
#import "SMThirdPartyMenu.h"

//static NSString  * trustedURL = @"http://web.me.com/tomcool420/Trusted.plist";



@implementation SMThirdPartyMenu


- (id) previewControlForItem: (long) row
{
	if(row>=[_items count])
		return nil;
	//NSString *resourcePath = nil;
	NSString *appPng = nil;
	//NSLog(@"%@",[_options objectAtIndex:row]);
	SMMedia *meta = [[SMMedia alloc] init];
	switch([[[_options objectAtIndex:row] valueForKey:@"Type"] intValue])
	{
		case kSMTpCheck:
			[meta setBRImage:[[SMThemeInfo sharedTheme] webImage]];
			[meta setDescription:@"Check online for new updates"];
			[meta setTitle:@"Check For Updates"];
			break;
		case kSMTpRestart:
			[meta setBRImage:[[SMThemeInfo sharedTheme] standbyImage]];
			[meta setTitle:@"Restart Finder"];
			[meta setDescription:@"Restart Finder"];
			break;
		case kSMTpRefresh:
			[meta setBRImage:[[SMThemeInfo sharedTheme] refreshImage]];
			[meta setTitle:@"Refresh Menu"];
			[meta setDescription:@"Refresh in case Info4.plist and/or Info3.plist was modified and change doesn't appear"];
			break;
		
		case kSMTpUntrusted:
			
			
			appPng = [SMGeneralMethods getImagePath:[[_options objectAtIndex:row] valueForKey:@"Name"]];
			NSString *releaseDate= [[_options objectAtIndex:row] valueForKey:@"ReleaseDate"];
			if(![releaseDate isEqualToString:@"nil"])
			{
				[meta setTitle:[NSString stringWithFormat:@"Released: %@",releaseDate]];
			}
			else
			{
				[meta setTitle:[[_options objectAtIndex:row] valueForKey:@"DisplayName"]];
			}
			//[SMGeneralMethods getImagePath:[[[_options objectAtIndex:row] valueForKey:@"Name"]]];
			//appPng = [IMAGES_FOLDER stringByAppendingPathComponent:[[[_options objectAtIndex:row] valueForKey:@"Name"] stringByAppendingPathExtension:@"png"]];
			//appPng = [[NSBundle bundleForClass:[self class]] pathForResource:[[_options objectAtIndex:row] valueForKey:@"Name"] ofType:@"png"];
			
			//NSLog(@"appPng: %@, displayName: %@, name: %@, developer: %@",appPng,[[_options objectAtIndex:row] valueForKey:@"DisplayName"],[[_options objectAtIndex:row] valueForKey:@"Name"],[[_options objectAtIndex:row] valueForKey:@"Developer"]);
			if([[[_options objectAtIndex:row] valueForKey:@"UpToDate"] boolValue])
			{
				[meta setDescription:[[_options objectAtIndex:row] valueForKey:@"ShortDescription"]];
			}
			else
			{
				//NSLog(@"UpdateText: %@", [[_options objectAtIndex:row] valueForKey:@"UpdateText"]);
				[meta setDescription:[[_options objectAtIndex:row] valueForKey:@"UpdateText"]];
			}
			[meta setDev:[[_options objectAtIndex:row] valueForKey:@"Developer"]];
			[meta setImagePath:appPng];
			break;
        case kSMTpSm:
        case KSMTpTrusted:
        {
            SMApplianceDictionary *info = [[_options objectAtIndex:row] objectForKey:@"object"];
            if (![info isInstalled] || ![info installedIsUpToDate])
                [meta setOnlineVersion:[info displayVersion]];
            if ([info isInstalled])
                [meta setInstalledVersion:[info installedVersion]];
            if ([info formatedReleaseDate]==nil)
                [meta setTitle:[info displayName]];
            else
                [meta setTitle:[info formatedReleaseDate]];
            [meta setDescription:[info shortDescription]];
            if([info developer]!=nil)
                [meta setDev:[info developer]];
            [meta setImagePath:[SMGeneralMethods getImagePath:[info name]]];
        }
		
	}

	
	switch([[[_options objectAtIndex:row] valueForKey:@"Type"] intValue])
	{
		case kSMTpSm:
			[meta setDefaultImage];
			break;
	}
	
	SMMediaPreview *preview = [[SMMediaPreview alloc] init];
	[preview setAsset:meta];
	[preview setShowsMetadataImmediately:YES];
	//BRImageAndSyncingPreviewController *obj = [[BRImageAndSyncingPreviewController alloc] init];
	
	
	//id sp = [BRImage imageWithPath:appPng];
	
	//[obj setImage:sp];
	return (preview);
}

-(id)init{
	self = [super init];
    [[NSFileManager defaultManager] constructPath:[[SMPreferences trustedPlistPath] stringByDeletingLastPathComponent]];
	[self setListIcon:[[SMThemeInfo sharedTheme] webImage] horizontalOffset:0.5f kerningFactor:0.2f];
	[_options release];
	_man = [NSFileManager defaultManager];
	return self;
}

- (void)dealloc
{
	[_man release];
	[tempFrapsInfo release];
	[tempFrapsInfo2 release];
	[istrusted release];
	[super dealloc];  
}

-(id)initWithIdentifier:(NSString *)initId
{
	return [self initCustom];
}
-(id)initCustom
{
	[SMGeneralMethods setDate:[NSDate date] forKey:@"LastCheck"];
	//NSLog(@"%@",[SMGeneralMethods dateForKey:@"LastCheck"]);
	[SMGeneralMethods checkFolders];
	[[self list] removeDividers];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: @"3rd Party Plugins"];
	

	
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	
	id item99 = [BRTextMenuItemLayer networkMenuItem];
	[item99 setTitle:@"Check For Updates"];
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithInt:1],@"Type",
						 nil]];
	[_items addObject:item99];
	
	id item2 = [[BRTextMenuItemLayer alloc] init];
	 [_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						  [NSNumber numberWithInt:2],@"Type",
						  nil]];
	[item2 setTitle:@"Refresh"];
	[_items addObject: item2];
	
	//Adding reset Finder option
	id item3 = [[BRTextMenuItemLayer alloc] init];
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithInt:3],@"Type",
						 nil]];
	[item3 setTitle:@"Restart Finder"];
	[_items addObject: item3];
	
	//NSLog(@"1");
	int sep1 = [_items count];

	
	NSDictionary *loginItemDict = [NSDictionary dictionaryWithContentsOfFile:[SMPreferences trustedPlistPath]];
	BRTextMenuItemLayer *SMItem = [BRTextMenuItemLayer folderMenuItem];
	NSDictionary *SoftwareMenuInfo = [loginItemDict valueForKey:@"SoftwareMenu"];
    SMApplianceDictionary *SMDict = [[SMApplianceDictionary alloc] initWithDictionary:SoftwareMenuInfo];
    [SMDict setIsTrusted:YES];
    [_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithInt:4],@"Type",
                         SMDict,@"object",
						 nil]];
    
	[SMItem setTitle:@"SoftwareMenu"];
	if(![SMDict installedIsUpToDate])
	{
			[SMItem setRightJustifiedText:@"Update Me"];
			[SMItem setIndentedLeftIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[BRThemeInfo sharedTheme] errorIcon], @"BRMenuIconImageKey",nil] largestOrdinal:4 iconAlignmentFactor:7];
	}
    [_items addObject: SMItem];

	int sep2 = [_items count];	
	
	int feedCounts=[[loginItemDict allKeys] count];
	
	int ii;
	
	NSString *currentNames = nil;
	id currentItems = nil;
	NSString *currentKeys = nil;
	NSArray *sortedArrays;
	NSSortDescriptor *nameDescriptors = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray *ArraySortDescriptor = [NSArray arrayWithObjects:nameDescriptors, nil];
	NSMutableArray *unsortedArray = [NSMutableArray arrayWithObjects:nil];
	
	for (ii = 0; ii < feedCounts; ii++)
	{

		currentKeys = [[loginItemDict allKeys] objectAtIndex:ii];
		currentItems = [loginItemDict valueForKey:currentKeys];
		[unsortedArray addObject:currentItems];
		
		
	}
	
	
	sortedArrays = [unsortedArray sortedArrayUsingDescriptors:ArraySortDescriptor];
	
	
	NSEnumerator *enumerator = [sortedArrays objectEnumerator];
	id obj;
	while((obj = [enumerator nextObject]) != nil) 
	{
        SMApplianceDictionary *objm = [[SMApplianceDictionary alloc] initWithDictionary:obj];
        [objm setIsTrusted:YES];
        if([objm isValid])
        {
            //NSString *onlineVersion = [objm valueForKey:@"Version"];
            

            id item = [BRTextMenuItemLayer folderMenuItem];
            
            if(![[objm name] isEqualToString:@"SoftwareMenu"] && [objm installOnCurrentOS])
            {
                if([objm isInstalled])
                {
                    if([objm installedIsUpToDate])
                        [item setRightJustifiedText:@"Up to Date"];
                    else
                        [item setRightJustifiedText:@"New Version available"];
                }
                else
                    [item setRightJustifiedText:@"Not Installed"];



                //Adding option for Info
				
                [_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithInt:5],@"Type",
                                     objm,@"object",
                                     nil]];
                [item setTitle:[objm displayName]];
                [_items addObject: item];
            }
            // NSLog(@"C.3"); 
        }
        
	}
	
	int sep3 = [_items count];
	//NSLog(@"D");
	///////////////////UNTRUSTED//////////////////////
	NSDictionary *loginItemDict2 = [NSDictionary dictionaryWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Info3.plist"]];
	feedCounts=[[loginItemDict2 allKeys] count];
	currentNames = nil;
	currentKeys = nil;
	NSMutableArray *_locationDictss2 = [NSMutableArray arrayWithObjects:nil];
	
	for (ii = 0; ii < feedCounts; ii++)
	{
		currentKeys = [[loginItemDict2 allKeys] objectAtIndex:ii];
		currentItems = [loginItemDict2 valueForKey:currentKeys];
		[_locationDictss2 addObject:currentItems];
	}
	
	//NSLog(@"D.1");
	//NSSortDescriptor *nameDescriptors2 = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray *ArraySortDescriptor2 = [NSArray arrayWithObjects:nameDescriptors, nil];
	 NSArray *sortedArrays2 = [_locationDictss2 sortedArrayUsingDescriptors:ArraySortDescriptor2];	
	//NSLog(@"E");
	NSEnumerator *enumerator2 = [sortedArrays2 objectEnumerator];
	//id obj2;
	while((obj = [enumerator2 nextObject]) != nil) 
	{
        NSMutableDictionary *objm=[obj mutableCopy];
		NSArray *keys = [obj allKeys];
        NSString *frapName;
        
        if([keys containsObject:@"name"])
            frapName = [objm objectForKey:@"name"];
        else
            frapName = [objm objectForKey:@"Name"];
        
		NSString *thename = [objm valueForKey:@"name"];
		if (thename == nil)
			thename = [objm valueForKey:@"Name"];
        
        NSString *frapDisplayName;
        if ([keys containsObject:@"DisplayName"])
            frapDisplayName=[objm objectForKey:@"DisplayName"];
        else {
            frapDisplayName=frapName;
            [objm setObject:frapName forKey:@"DisplayName"];
        }
        NSString *osMax;
        if([keys containsObject:@"osMax"])
            osMax=[objm objectForKey:@"osMax"];
        else
            osMax=@"20.0";
        NSString *osMin;
        if([keys containsObject:@"osMin"])
            osMin=[objm objectForKey:@"osMin"];
        else
            osMin=@"2.0";
        
        NSString *frapRealName;
        if ([keys containsObject:@"applianceName"])
            frapRealName = [obj objectForKey:@"applianceName"];
        else
            frapRealName = frapName;
        frapRealName = [[frapRealName stringByDeletingPathExtension] stringByAppendingPathExtension:@"frappliance"];
        
		//NSString *displayName = frapDisplayName;//[obj valueForKey:@"DisplayName"];
//		if (displayName == nil)
//			displayName = thename;
		NSString *onlineVersion = [obj valueForKey:@"Version"];
        
        NSString *frapPath = [FRAP_PATH stringByAppendingPathComponent:frapRealName];
        
		//NSString *frapPath= [[NSString alloc] initWithFormat:@"%@%@.frappliance/",FRAP_PATH,thename];
		
        NSFileManager *manager = [NSFileManager defaultManager];
		id item = [[BRTextMenuItemLayer alloc] init];
		NSString * current_version =nil;
		if(![thename isEqualToString:@"SoftwareMenu"] && [SMGeneralMethods isWithinRangeWithMin:osMin withMax:osMax])
		{
			if ([manager fileExistsAtPath:frapPath])
			{
				NSString * infoPath = [frapPath stringByAppendingString:@"Contents/Info.plist"];
				NSDictionary * info =[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:infoPath]];
				current_version = [[NSString alloc]initWithString:[info objectForKey:@"CFBundleVersion"]];

				if ([current_version isEqualToString:onlineVersion])
				{
					[item setRightJustifiedText:@"Up to Date"];
				}
				else
				{
					
					[item setRightJustifiedText:@"New Version available"];
				}
			}
			else
			{
				[item setRightJustifiedText:@"Not Installed"];
			}
			
			//[_options addObject:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:6],thename,nil]];
			NSString *dev = [obj valueForKey:@"Developer"];
			if(dev==nil)
				dev = @"nil";
			NSString *desc = [obj valueForKey:@"ShortDescription"];
			if(desc == nil)
				desc = @"nil";
			NSDate *date = [obj valueForKey:@"date"];
			NSString *dateFormat = nil;
			if(date == nil)
			{
				dateFormat = @"nil";
			}
			else
			{
				dateFormat = [date descriptionWithCalendarFormat:@"%Y-%m-%d" timeZone:nil locale:nil];
			}
			BOOL uptodates = YES;
			if ([current_version compare:onlineVersion]==NSOrderedAscending)
				uptodates = NO;
			NSString *updateText = [obj valueForKey:@"ShortChangeLog"];
			if(updateText == nil)
				updateText = desc;

			[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithInt:5],@"Type",
								 frapRealName,@"Name",
								 frapDisplayName,@"DisplayName",
								 onlineVersion,@"OnlineVersion",
								 dev,@"Developer",
								 updateText,@"UpdateText",
								 [NSNumber numberWithBool:uptodates],@"UpToDate",
								 desc,@"ShortDescription",
								 dateFormat,@"ReleaseDate",
								 nil]];
			[item setTitle:thename];
			[_items addObject: item];
		}

	}
	id list = [self list];
	[list setDatasource: self];
	[_options writeToFile:@"/Users/frontrow/options.plist" atomically:YES];
	[[self list] addDividerAtIndex:sep1 withLabel:@"SoftwareMenu"];
	[[self list] addDividerAtIndex:sep2 withLabel:BRLocalizedString(@"Trusted",@"Trusted")];
	[[self list] addDividerAtIndex:sep3 withLabel:BRLocalizedString(@"Untrusted",@"Untrusted")];
	return self;
	
}

-(void)itemSelected:(long)fp8
{
	//NSLog(@"itemselected");
	//NSArray * thenames = [_options objectAtIndex:fp8];
	//NSLog(@"A");
	BOOL hellos;
	//NSString *thename = [thenames objectAtIndex:1];
	NSMutableDictionary *loginItemDict=[[NSMutableDictionary alloc] initWithDictionary:nil];
	//NSLog(@"B");
	switch([[[_options objectAtIndex:fp8] valueForKey:@"Type"] intValue])
	{
		case kSMTpCheck:
			hellos =NO;
			//NSLog(@"doing Update");
			NSString *thelog = [[NSString alloc] initWithString:@"thelog"];
			[thelog writeToFile:[@"~/Library/Application Support/SoftwareMenu/updater.log" stringByExpandingTildeInPath] atomically:YES];
			[self writeToLog:@"Initializing Update"];
			[self startUpdate];
			
			break;
		case kSMTpRefresh:
			[self initCustom];
			break;
		case kSMTpRestart:
			[NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments:[NSArray arrayWithObjects:@"/System/Library/CoreServices/Finder.app/Contents/Plugins/SoftwareMenu.frappliance/Contents/Resources/reset.sh",nil]];
			break;
		case kSMTpSm:
		case KSMTpTrusted:
			hellos = NO;
			//NSLog(@"Going to a Trusted Menu");
			NSDictionary *Info4Dict = [NSDictionary dictionaryWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Info4.plist"]];
			[loginItemDict addEntriesFromDictionary:Info4Dict];
			break;
		case kSMTpUntrusted:
			hellos = NO;
			//NSLog(@"Going to an Untrusted Menu");
			NSDictionary *Info3Dict = [NSDictionary dictionaryWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Info3.plist"]];
			[loginItemDict addEntriesFromDictionary:Info3Dict];
			break;
	}
	switch([[[_options objectAtIndex:fp8] valueForKey:@"Type"] intValue])
	{
		case kSMTpSm:
			//NSLog(@"SoftwareMenu:");
		case kSMTpUntrusted:
		case KSMTpTrusted:
			hellos = NO;
			//NSLog(@"doing something");
			NSString *thename = [[_options objectAtIndex:fp8] valueForKey:@"Name"];
			if([thename isEqualToString:@"softwaremenu"]) {thename = @"SoftwareMenu";}
            if ([[[_options objectAtIndex:fp8]allKeys]containsObject:@"object"]) {
                NSDictionary *obj = [[_options objectAtIndex:fp8] objectForKey:@"object"];
                //NSLog(@"obj: %@",obj);
//                NSMutableDictionary *theInformation = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                                       [obj objectForKey:@"Name"],@"name",
//                                                       [obj valueForKey:@"Version"],@"version",
//                                                       [obj valueForKey:@"displayName"],@"displayName",
//                                                       [obj valueForKey:@"shortVersion"],@"shortVersion", 
//                                                       [obj valueForKey:@"displayVersion"],@"displayVersion", 
//                                                       [obj objectForKey:@"description"],@"description",
//                                                       [obj objectForKey:@"license"],@"license",
//                                                       [obj objectForKey:@"URL"],@"url",
//                                                        nil];
                                                       
                //id newController = [[SMInstallMenu alloc] initWithDictionary:obj];
                id newController =[[SMApplianceInstallerController alloc] initWithDictionary:obj];
                //[newController setInformationDictionary:theInformation];
                [[self stack] pushController: newController];

            }
            else {
                NSEnumerator *enumerator = [loginItemDict objectEnumerator];
                id obj;
                while((obj = [enumerator nextObject]) != nil) 
                {
                    if ([thename isEqualToString:[obj valueForKey:@"name"]])
                    {
                        NSString * theURL = [obj valueForKey:@"theURL"];
                        if (theURL == nil)
                        {
                            theURL=[obj valueForKey:@"URL"];
                        }
                        
                        NSString * theversion = [obj valueForKey:@"Version"];
                        NSString *thedescription = [obj valueForKey:@"theDesc"];
                        if(thedescription == nil)
                        {
                            thedescription = [obj valueForKey:@"Desc"];
                            if(thedescription == nil)
                            {
                                thedescription = [obj valueForKey:@"desc"];
                                if(thedescription == nil)
                                {
                                    thedescription = @"No description added";
                                }
                            }
                        }
                        NSString *displayName = [obj valueForKey:@"DisplayName"];
                        if (displayName == nil)
                            displayName = thename;
                        NSString *displayVersion = [obj valueForKey:@"displayVersion"];
                        if (displayVersion == nil)
                            displayVersion = theversion;
                        
                        NSString *thelicense = [obj valueForKey:@"thelicense"];
                        if(thelicense == nil)
                        {
                            thelicense = [obj valueForKey:@"license"];
                            if(thelicense == nil)
                            {
                                thelicense = @"No License added";
                            }
                        }
                        NSString *shortVersion = @"empty";
                        if([thename isEqualToString:@"nitoTV"])
                            shortVersion = [obj valueForKey:@"shortVersion"];
                        NSMutableDictionary *theInformation = [NSMutableDictionary dictionaryWithObjectsAndKeys:thename,@"Name",theversion,@"Version",displayName,@"displayName",shortVersion,@"shortVersion", displayVersion,@"displayVersion", thedescription,@"description",thelicense,@"license",theURL,@"URL",nil];
                        
                        id newController = [[SMInstallMenu alloc] initWithDictionary:theInformation];
                        //[newController setInformationDictionary:theInformation];
                        [[self stack] pushController: newController];
                        
            }

						}
		}
	}
}
-(void)startUpdate
{

	if([_man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/Info3.plist" stringByExpandingTildeInPath]])
		[_man removeFileAtPath:[@"~/Library/Application Support/SoftwareMenu/Info3.plist" stringByExpandingTildeInPath] handler:nil];
	
	
	tempFrapsInfo = [[NSMutableDictionary alloc] initWithDictionary:nil];
	tempFrapsInfo2= [[NSMutableDictionary alloc] initWithDictionary:nil];
	
	istrusted = [[NSMutableArray alloc] initWithObjects:nil];
	
	NSMutableDictionary *TrustedDict=[[NSMutableDictionary alloc] init];
	NSMutableDictionary *UnTrustedDict=[[NSMutableDictionary alloc] init];
	
	NSArray *trustedSources =[NSArray arrayWithContentsOfURL:[[NSURL alloc] initWithString:TRUSTED_URL]];
	NSEnumerator *enumerator = [trustedSources objectEnumerator];
	[self writeToLog:@"==== startUpdate ===="];
	[self writeToLog:@"========= Adding Trusted ========="];
	[self writeToLog:[NSString stringWithFormat:@"Downloading trusted file from: %@",TRUSTED_URL,nil]];
	id obj;
	
	while((obj = [enumerator nextObject]) != nil) 
	{
		NSString *theTrustedURL = [obj valueForKey:@"theURL"];
		NSString *theTrustedName = [obj valueForKey:@"name"];

		[self writeToLog:[NSString stringWithFormat:@"Adding From List: %@",theTrustedName,nil]];
		[self writeToLog:[NSString stringWithFormat:@"With URL: %@",theTrustedURL,nil]];
		
		NSDictionary *trustedSource =[NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:theTrustedURL]];
		
		if([theTrustedURL isEqualToString:@"http://nitosoft.com/version.plist"])
		{
			NSMutableDictionary *nitoDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
            [nitoDict setValuesForKeysWithDictionary:trustedSource];
			[nitoDict setObject:@"nitoTV" forKey:@"name"];
			[nitoDict setObject:[nitoDict valueForKey:@"displayVersionTwo"] forKey:@"Version"];
			[nitoDict setObject:[nitoDict valueForKey:@"displayVersionTwo"] forKey:@"displayVersion"];
			[nitoDict setObject:[nitoDict valueForKey:@"versionTwo"] forKey:@"shortVersion"];
			[nitoDict setObject:@"http://nitosoft.com/nitoTVTwo.tar.gz" forKey:@"theURL"];
//			[nitoDict setObject:[trustedSource valueForKey:@"ShortDescription"] forKey:@"ShortDescription"];
//			[nitoDict setObject:[trustedSource valueForKey:@"developer"] forKey:@"Developer"];
//			[nitoDict setObject:[trustedSource valueForKey:@"ReleaseDate"] forKey:@"ReleaseDate"];
//			[nitoDict setObject:[trustedSource valueForKey:@"ImageURL"] forKey:@"ImageURL"];
//            [nitoDict setObject:[trustedSource valueForKey:@"osMin"] forKey:@"osMin"];
//			[nitoDict setObject:[trustedSource valueForKey:@"osMax"] forKey:@"osMax"];
//            [nitoDict setObject:[trustedSource valueForKey:@"license"] forKey:@"license"];
//            [nitoDict setObject:[trustedSource valueForKey:@"desc"] forKey:@"desc"];
            //NSLog(@"imageURL: %@",[nitoDict valueForKey:@"ImageURL"]);
			[TrustedDict setObject:nitoDict forKey:@"NitoTV"];
			[self writeToLog:@"nitoTV special loop"];
			
		}
		else if([theTrustedURL isEqualToString:@"http://nitosoft.com/updates.plist"])
		{
			NSMutableDictionary *couchDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
			[couchDict setObject:@"CouchSurfer" forKey:@"name"];
			[couchDict setObject:[trustedSource valueForKey:@"displayVersionTwo"] forKey:@"Version"];
			[couchDict setObject:[trustedSource valueForKey:@"displayVersionTwo"] forKey:@"displayVersion"];
			[couchDict setObject:[trustedSource valueForKey:@"twoUrl"] forKey:@"theURL"];
			[TrustedDict setObject:couchDict forKey:@"CouchSurfer"];
			[self writeToLog:@"CouchSurfer Special loop (Thanks to nito for plist up to date)"];
		}
		else
		{
			[TrustedDict addEntriesFromDictionary:trustedSource];
		}
		[self writeToLog:@"\n"];
	}
    if([_man fileExistsAtPath:[SMPreferences trustedPlistPath]])
		[_man removeFileAtPath:[SMPreferences trustedPlistPath] handler:nil];
	[TrustedDict writeToFile:[SMPreferences trustedPlistPath] atomically:YES];
	[self getImages:TrustedDict];
	
	NSDictionary *hellofour = [NSDictionary dictionaryWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/unTrusted/untrusted.plist"]];
	NSEnumerator *enumerator2 = [hellofour objectEnumerator];
	[self writeToLog:@"========= Adding Untrusted ========="];
	while((obj = [enumerator2 nextObject]) != nil) 
	{
		
		NSString *theUnTrustedName = [obj valueForKey:@"name"];
		NSString *theUnTrustedURL = [obj valueForKey:@"theURL"];
		[self writeToLog:[[NSString alloc] initWithFormat:@"Adding From List: %@",theUnTrustedName]];
		[self writeToLog:theUnTrustedURL];
		[self writeToLog:@"\n"];
		NSDictionary *hellofive = [[NSDictionary alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:theUnTrustedURL]];
		[UnTrustedDict addEntriesFromDictionary:hellofive];
	}
	[UnTrustedDict writeToFile:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Info3.plist" atomically:YES];
	[self writeToLog:@"========= Done ========="];
	BRScrollingTextControl *textControls = [[BRScrollingTextControl alloc] init];
	[textControls setTitle:@"Check For Updates"];
	[textControls setDocumentPath:@"/Users/frontrow/Library/Application Support/SoftwareMenu/updater.log" encoding:NSUTF8StringEncoding];
	BRController *theController =  [BRController controllerWithContentControl:textControls];
	[[self stack] pushController:theController];

}
-(void)getImages:TrustedDict
{
	[self writeToLog:@"getting Images"];
	NSEnumerator *keyEnum = [TrustedDict keyEnumerator];
	id obj2;
	NSString *ImageURL=nil;
	NSString *name=nil;
	id obj;
	while((obj2 = [keyEnum nextObject]) != nil) 
	{
		obj = [TrustedDict objectForKey:obj2];
		ImageURL = nil;
		//NSLog(@"1");
		name = [obj objectForKey:@"name"];
		if (name == nil)
			name = [obj objectForKey:@"Name"];
		ImageURL = [obj objectForKey:@"ImageURL"];
		//NSLog(@"name:%@, ImageURl:%@",name,ImageURL);
		if([ImageURL length] !=0)
		{
			//NSLog(@"non zero");
		}
		if([ImageURL length] == 0)
		{
			if([name isEqualToString:@"ATVFiles"])
			{
				ImageURL=@"http://softwaremenu.googlecode.com/svn/trunk/SoftwareMenu2.3/ATVFiles.png";
				NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
				[imageData writeToFile:[[SMPreferences ImagesPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] atomically:YES];
				
			}
			else if([name isEqualToString:@"CouchSurfer"])
			{
				ImageURL=@"http://softwaremenu.googlecode.com/svn/trunk/SoftwareMenu2.3/CouchSurfer.png";
				NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
				[imageData writeToFile:[[SMPreferences ImagesPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] atomically:YES];
			}
			else if([name isEqualToString:@"nitoTV"])
			{
				ImageURL=@"http://softwaremenu.googlecode.com/svn/trunk/SoftwareMenu2.3/nitoTV.png";
				NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
				[imageData writeToFile:[[SMPreferences ImagesPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] atomically:YES];
			}
			
		}
		if([ImageURL length]!=0)
		{
			//NSLog(@"2");
			//NSLog(@"Image URL: %@",ImageURL);
			[self writeToLog:ImageURL];
			NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
			//NSLog(@"3");
			
			//NSLog(@"4");
			//NSLog(@"image path: %@",[IMAGES_FOLDER stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]]);
			if([_man fileExistsAtPath:[[SMPreferences ImagesPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]]])
			{
				[_man removeFileAtPath:[[SMPreferences ImagesPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] handler:nil];
			}
			[imageData writeToFile:[[SMPreferences ImagesPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:[ImageURL pathExtension]]] atomically:YES];
			
		}
	}
		
	
}


- (void)writeToLog:(NSString *)str
{
	NSString * thelog2 = [[[[NSString alloc] initWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/updater.log" stringByExpandingTildeInPath]] stringByAppendingString:@"\n"] stringByAppendingString:str];
	[thelog2 writeToFile:[@"~/Library/Application Support/SoftwareMenu/updater.log" stringByExpandingTildeInPath] atomically:YES];
}

- (void)wasExhumed
{
	[self initCustom];	
}

//	Data source methods:
-(NSMutableDictionary *)formatDict:(NSDictionary*)dict
{
    NSMutableDictionary *objm = [dict mutableCopy];
    NSArray *keys = [objm allKeys];
    
    //Checking Name
    if (![keys containsObject:@"Name"] && [keys containsObject:@"name"])
    {
        [objm setObject:[objm objectForKey:@"name"] forKey:@"Name"];
    }
    else if(![keys containsObject:@"Name"] && ![keys containsObject:@"name"])
    {
        return nil;
    }
    
    //Checking Version
    if(![keys containsObject:@"Version"])
    {
        return nil;
    }
    
    //Checking description
    NSString *thedescription = [objm valueForKey:@"theDesc"];
    if(thedescription == nil)
    {
        thedescription = [objm valueForKey:@"Desc"];
        if(thedescription == nil)
        {
            thedescription = [objm valueForKey:@"desc"];
            if(thedescription == nil)
            {
                thedescription = @"No description added";
            }
        }
    }
    [objm setObject:thedescription forKey:@"description"];
    
    //displayVersion
    if (![keys containsObject:@"displayVersion"] && [keys containsObject:@"DisplayVersion"])
        [objm setObject:[objm objectForKey:@"DisplayVersion"] forKey:@"displayVersion"];
    else if (![keys containsObject:@"displayVersion"] && ![keys containsObject:@"DisplayVersion"])
        [objm setObject:[objm objectForKey:@"Version"] forKey:@"DisplayVersion"];
    
    //displayName
    if(![keys containsObject:@"displayName"])
        [objm setObject:[objm objectForKey:@"Name"] forKey:@"displayName"];
    
    //license
    NSString *thelicense = [objm valueForKey:@"thelicense"];
    if(thelicense == nil)
    {
        thelicense = [objm valueForKey:@"license"];
        if(thelicense == nil)
        {
            thelicense = @"No License added";
        }
    }
    [objm setObject:thelicense forKey:@"license"];
    
    //URL
    if(![keys containsObject:@"theURL"] && ![keys containsObject:@"URL"])
    {
        return nil;
    }
    else if(![keys containsObject:@"URL"])
    {
        [objm setObject:[objm objectForKey:@"theURL"] forKey:@"URL"];
    }
    
    //osMin
    if(![keys containsObject:@"osMin"])
    {
        [objm setObject:@"nil" forKey:@"osMin"];
    }
    //osMax
    if(![keys containsObject:@"osMax"])
    {
        [objm setObject:@"nil" forKey:@"osMax"];
    }
    return objm;
    
}

@end
