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
#import "SMInstallMenu.h"
//static NSString  * trustedURL = @"http://web.me.com/tomcool420/Trusted.plist";



@implementation SMThirdPartyMenu


- (id) previewControlForItem: (long) item
{
	//NSString *resourcePath = nil;
	NSString *appPng = nil;
	NSString * theoption = [[_options objectAtIndex:item] objectAtIndex:1];
	
	appPng = [[NSBundle bundleForClass:[self class]] pathForResource:theoption ofType:@"png"];
	
	
	if(![[NSFileManager defaultManager] fileExistsAtPath:appPng])
		appPng = [[NSBundle bundleForClass:[self class]] pathForResource:@"package" ofType:@"png"];
	if([theoption isEqualToString:@"Reset"])
		appPng = [[NSBundle bundleForClass:[self class]] pathForResource:@"softwareupdate" ofType:@"png"];
	

	BRImageAndSyncingPreviewController *obj = [[BRImageAndSyncingPreviewController alloc] init];
	
	
	id sp = [BRImage imageWithPath:appPng];
	
	[obj setImage:sp];
	return (obj);
}

-(id)init{
	return [super init];
}

- (void)dealloc
{
	[super dealloc];  
}

-(id)initWithIdentifier:(NSString *)initId
{
	NSFileManager *man =[NSFileManager defaultManager];
	if(![man fileExistsAtPath:[@"~/Documents" stringByExpandingTildeInPath]])
	{
		[man createDirectoryAtPath:[@"~/Documents" stringByExpandingTildeInPath] attributes:nil];
	}
	if(![man fileExistsAtPath:[@"~/Documents/Backups" stringByExpandingTildeInPath]])
	{
		[man createDirectoryAtPath:[@"~/Documents/Backups" stringByExpandingTildeInPath] attributes:nil];
	}
	
	NSMutableDictionary *file =[[NSMutableDictionary alloc] initWithDictionary:nil];
	[[self list] removeDividers];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: @"3rd Party Plugins"];
	NSString *scriptPNG = [[NSBundle bundleForClass:[self class]] pathForResource:@"internet" ofType:@"png"];
	id folderImage = [BRImage imageWithPath:scriptPNG];
	[self setListIcon:folderImage horizontalOffset:0.5f kerningFactor:0.2f];
	
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	

	
	//Setting up the default parts
	
	id item99 = [BRTextMenuItemLayer networkMenuItem];
	[item99 setTitle:@"Check For Updates"];
	[_options addObject:[[NSArray alloc] initWithObjects:@"1",@"Check",nil]];
	[_items addObject:item99];
	//Adding Refresh again
	id item2 = [[BRTextMenuItemLayer alloc] init];
	[_options addObject:[[NSArray alloc] initWithObjects:@"1",@"refresh",nil]];
	[item2 setTitle:@"Refresh"];
	[_items addObject: item2];
	//Adding reset Finder option
	id item3 = [[BRTextMenuItemLayer alloc] init];
	[_options addObject:[[NSArray alloc] initWithObjects:@"1",@"Reset",nil]];
	[item3 setTitle:@"Restart Finder"];
	[_items addObject: item3];
	int sep1 = [_items count];
	
	
	/*id item98 = [[BRTextMenuItemLayer alloc] init];
	[item98 setTitle:@"Manage Untrusted"];
	[_options addObject:@"Untrusted"];
	[_items addObject:item98];*/
	/*NSSortDescriptor *nameDescriptor =[[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray *descriptors = [NSArray arrayWithObjects:nameDescriptor, nil];*/
	
	NSDictionary *loginItemDict = [NSDictionary dictionaryWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Info4.plist"]];
	NSDictionary *SoftwareMenuInfo = [loginItemDict valueForKey:@"SoftwareMenu"];
	NSString *SoftVers = [SoftwareMenuInfo valueForKey:@"Version"];
	NSString *frapSoftPath= [[NSString alloc] initWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/SoftwareMenu.frappliance/"];
	NSString * infoSoftPath = [frapSoftPath stringByAppendingString:@"Contents/Info.plist"];
	NSDictionary * Softinfo =[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:infoSoftPath]];
	NSString * current_soft_version =[[NSString alloc]initWithString:[Softinfo objectForKey:@"CFBundleVersion"]];
	//NSLog(@"SoftVers: %@, current_soft_version: %@", SoftVers, current_soft_version);
	int versLength = [SoftVers length];
	//NSLog(@"versLength: %d",versLength);
	
	id item90 = [BRTextMenuItemLayer folderMenuItem];
	[_options addObject:[[NSArray alloc] initWithObjects:@"2",@"SoftwareMenu",nil]];
	[item90 setTitle:@"Software Menu"];
	
	if (![current_soft_version isEqualToString:SoftVers])	
	{
		if(versLength != 0)
		{
			[item90 setRightJustifiedText:@"Update Me"];
			[item90 setLeftIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[BRThemeInfo sharedTheme] errorIcon], @"BRMenuIconImageKey",nil]];

		}
	}
			
		[_items addObject: item90];

	
	
	
	int sep2 = [_items count];
	int feedCounts=[[loginItemDict allKeys] count];
	int ii;
	NSString *currentNames = nil;
	id currentItems = nil;
	NSString *currentKeys = nil;
	/*NSString *currentmd5 = nil;
	NSString *currentVersion =nil;
	NSString *currentURL = nil;*/
	NSArray *sortedArrays;
	NSSortDescriptor *nameDescriptors = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray *descriptorss = [NSArray arrayWithObjects:nameDescriptors, nil];
	NSMutableArray *_locationDictss = [[NSMutableArray alloc] init];
	
	for (ii = 0; ii < feedCounts; ii++)
	{
		//NSDictionary *dicts;
		////NSLog(@"ii: %d",ii);
		currentKeys = [[loginItemDict allKeys] objectAtIndex:ii];
		currentItems = [loginItemDict valueForKey:currentKeys];
		////NSLog(@"current items: %@",currentItems);
		[_locationDictss addObject:currentItems];
		
		
	}
	
	
	sortedArrays = [_locationDictss sortedArrayUsingDescriptors:descriptorss];
	
	
	
	NSEnumerator *enumerator = [sortedArrays objectEnumerator];
	id obj;
	while((obj = [enumerator nextObject]) != nil) 
	{
		
		
		NSString *thename = [obj valueForKey:@"name"];
		NSString *onlineVersion = [obj valueForKey:@"Version"];
		NSString *frapPath= [[NSString alloc] initWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",thename];
		NSFileManager *manager = [NSFileManager defaultManager];
		id item = [BRTextMenuItemLayer folderMenuItem];		
		if(![thename isEqualToString:@"SoftwareMenu"])
		{
			if ([manager fileExistsAtPath:frapPath])
			{
				[file setValue:@"YES" forKey:thename];
				//NSLog(@"%@.frappliance exists",thename);
				NSString * infoPath = [frapPath stringByAppendingString:@"Contents/Info.plist"];
				NSDictionary * info =[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:infoPath]];
				NSString * current_version =[[NSString alloc]initWithString:[info objectForKey:@"CFBundleVersion"]];
				//NSLog(@"%@ %@", current_version,onlineVersion);
				if ([current_version isEqualToString:onlineVersion])
				{
					[item setRightJustifiedText:@"Up to Date"];
					//NSLog(@"Up to Date");
				}
				else
				{
					[item setRightJustifiedText:@"New Version available"];
					//NSLog(@"Not up to date, current is %@",onlineVersion);
				}
			}
			else
			{
				[file setValue:@"NO" forKey:thename];
				[item setRightJustifiedText:@"Not Installed"];
				//NSLog(@"Not Installed");
			}
			
			
			//Adding option for Info
			[_options addObject:[[NSArray alloc] initWithObjects:@"2",thename,nil]];
			[item setTitle:thename];
			[_items addObject: item];
		}
	else
	{
		/*NSString * infoPath = [frapPath stringByAppendingString:@"Contents/Info.plist"];
		NSDictionary * info =[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:infoPath]];
		NSString * current_version =[[NSString alloc]initWithString:[info objectForKey:@"CFBundleVersion"]];
		//NSLog(@"Software Menu: %@ %@", current_version,onlineVersion);
		if (![current_version isEqualToString:onlineVersion])	
		{
			[_options addObject:thename];
			[item setTitle:thename];
			[item setRightJustifiedText:@"Update ME"];
			[_items addObject: item];
			
			
		}*/
	}
	}
	
	int sep3 = [_items count];
	
	///////////////////UNTRUSTED//////////////////////
	NSDictionary *loginItemDict2 = [NSDictionary dictionaryWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Info3.plist"]];
	feedCounts=[[loginItemDict2 allKeys] count];
	currentNames = nil;
	//id currentItems2 = nil;
	currentKeys = nil;
	NSArray *sortedArrays2;
	/*NSSortDescriptor *nameDescriptors2 = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray *descriptorss = [NSArray arrayWithObjects:nameDescriptors, nil];*/
	NSMutableArray *_locationDictss2 = [[NSMutableArray alloc] init];
	
	for (ii = 0; ii < feedCounts; ii++)
	{
		//NSDictionary *dicts;
		//NSLog(@"ii: %d",ii);
		currentKeys = [[loginItemDict2 allKeys] objectAtIndex:ii];
		currentItems = [loginItemDict2 valueForKey:currentKeys];
		//NSLog(@"current items: %@",currentItems);
		[_locationDictss2 addObject:currentItems];
		
		
	}
	
	
	sortedArrays2 = [_locationDictss2 sortedArrayUsingDescriptors:descriptorss];
	//NSLog(@"sortedArrays2: %@",sortedArrays2);
	
	
	NSEnumerator *enumerator2 = [sortedArrays2 objectEnumerator];
	id obj2;
	while((obj2 = [enumerator2 nextObject]) != nil) 
	{
		
		
		NSString *thename = [obj2 valueForKey:@"name"];
		NSString *onlineVersion = [obj2 valueForKey:@"Version"];
		NSString *frapPath= [[NSString alloc] initWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",thename];
		NSFileManager *manager = [NSFileManager defaultManager];
		id item = [[BRTextMenuItemLayer alloc] init];		
		if(![thename isEqualToString:@"SoftwareMenu"])
		{
			if ([manager fileExistsAtPath:frapPath])
			{
				[file setValue:@"YES" forKey:thename];
				//NSLog(@"%@.frappliance exists",thename);
				NSString * infoPath = [frapPath stringByAppendingString:@"Contents/Info.plist"];
				NSDictionary * info =[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:infoPath]];
				NSString * current_version =[[NSString alloc]initWithString:[info objectForKey:@"CFBundleVersion"]];
				//NSLog(@"%@ %@", current_version,onlineVersion);
				if ([current_version isEqualToString:onlineVersion])
				{
					[item setRightJustifiedText:@"Up to Date"];
					//NSLog(@"Up to Date");
				}
				else
				{
					
					[item setRightJustifiedText:@"New Version available"];
					//NSLog(@"Not up to date, current is %@",onlineVersion);
				}
			}
			else
			{
				[file setValue:@"NO" forKey:thename];
				[item setRightJustifiedText:@"Not Installed"];
				//NSLog(@"Not Installed");
			}
			
			
			//Adding option for Info
			[_options addObject:[[NSArray alloc] initWithObjects:@"3",thename,nil]];
			[item setTitle:thename];
			[_items addObject: item];
		}
		else
		{
			/*NSString * infoPath = [frapPath stringByAppendingString:@"Contents/Info.plist"];
			 NSDictionary * info =[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:infoPath]];
			 NSString * current_version =[[NSString alloc]initWithString:[info objectForKey:@"CFBundleVersion"]];
			 //NSLog(@"Software Menu: %@ %@", current_version,onlineVersion);
			 if (![current_version isEqualToString:onlineVersion])	
			 {
			 [_options addObject:thename];
			 [item setTitle:thename];
			 [item setRightJustifiedText:@"Update ME"];
			 [_items addObject: item];
			 
			 
			 }*/
		}
	}
		id list = [self list];
		[list setDatasource: self];
	[file setValue:@"NO" forKey:@"Update"];
	[file writeToFile:[@"~/Library/Application Support/SoftwareMenu/log2.plist" stringByExpandingTildeInPath] atomically:YES];
	if (![current_soft_version isEqualToString:SoftVers])
	{
		[[self list] addDividerAtIndex:sep1 withLabel:@"Important - SoftwareMenu"];

	}
	else
	{
		[[self list] addDividerAtIndex:sep1 withLabel:@"SoftwareMenu"];

	}
	[[self list] addDividerAtIndex:sep2 withLabel:@"Trusted"];
	[[self list] addDividerAtIndex:sep3 withLabel:@"Self Added"];
		return self;
	
}

-(void)itemSelected:(long)fp8
{
	id newController = nil;
	NSArray * thenames = [_options objectAtIndex:fp8];
	NSString *thetype = [thenames objectAtIndex:0];
	NSString *thename = [thenames objectAtIndex:1];
	if([thetype isEqualToString:@"1"])
	{
		if ([thename isEqualToString:@"refresh"])
		{
			[self initWithIdentifier:@"101"];
		}
		else if([thename isEqualToString:@"Untrusted"])
		{
			// Call for Menu to manage untrusted
			
			/*BRTextEntryController *textinput = [[BRTextEntryController alloc] init];
			 [textinput setTitle:@"add Untrusted"];
			 [textinput setTextEntryCompleteDelegate:self];
			 [[self stack] pushController:textinput];*/
			
		}
		else if([thename isEqualToString:@"Reset"]){
			[NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments:[NSArray arrayWithObjects:@"/System/Library/CoreServices/Finder.app/Contents/Plugins/SoftwareMenu.frappliance/Contents/Resources/reset.sh",nil]];
		}
		else if ([thename isEqualToString:@"Check"])
		{
			NSString *thelog = [[NSString alloc] initWithString:@"thelog"];
			[thelog writeToFile:[@"~/Library/Application Support/SoftwareMenu/updater.log" stringByExpandingTildeInPath] atomically:YES];
			[self writeToLog:@"init"];
			[self writeToLog:@"update"];
			[self startUpdate];
			
		}
	}
	else 
	{
		//NSLog(@"%@",thename);
		//NSLog(@"selected something");
		NSMutableDictionary *loginItemDict=[[NSMutableDictionary alloc] initWithDictionary:nil];
		if([thetype isEqualToString:@"2"])
		   {
		NSDictionary *loginItemsDict = [NSDictionary dictionaryWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Info4.plist"]];
			   [loginItemDict addEntriesFromDictionary:loginItemsDict];
		}
		else if([thetype isEqualToString:@"3"])
		{
			NSDictionary *loginItemsDict = [NSDictionary dictionaryWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Info3.plist"]];
			[loginItemDict addEntriesFromDictionary:loginItemsDict];
		}
		NSEnumerator *enumerator = [loginItemDict objectEnumerator];
		id obj;
		while((obj = [enumerator nextObject]) != nil) 
		{
			if ([thename isEqualToString:[obj valueForKey:@"name"]])
			{
				//NSLog(@"right name: %@", thename);
				NSString * theURL = [obj valueForKey:@"theURL"];
				if (theURL == nil)
				{
					theURL=[obj valueForKey:@"URL"];
				}
				NSString * theversion = [obj valueForKey:@"Version"];
				NSString *thescript =[obj valueForKey:@"thescript"];
				//NSLog(@"%@",thescript);
				if(thescript == nil)
				{
					thescript = @"none";
				}
				
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
				NSString *thelicense = [obj valueForKey:@"thelicense"];
				if(thelicense == nil)
				{
					thelicense = [obj valueForKey:@"license"];
					if(thelicense == nil)
					{
						thelicense = @"No License added";
					}
				}
				NSLog(@"before starting");
				NSMutableDictionary *theInformation = [[NSMutableDictionary alloc] initWithObjectsAndKeys:thename,@"name",theversion,@"version",thescript,@"script",thedescription,@"description",thelicense,@"license",theURL,@"url",nil];
				newController = [[SMInstallMenu alloc] init];
				NSLog(@"gonna send");
				[newController setInformationDictionary:theInformation];
				[newController initCustom];
				[[self stack] pushController: newController];
			}
		}
	}
}
-(void)startUpdate
{
	NSFileManager *man = [NSFileManager defaultManager];
	if(![man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/Trusted" stringByExpandingTildeInPath]])
		[man createDirectoryAtPath:[@"~/Library/Application Support/SoftwareMenu/Trusted" stringByExpandingTildeInPath] attributes:nil];
	if(![man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/unTrusted" stringByExpandingTildeInPath]])
		[man createDirectoryAtPath:[@"~/Library/Application Support/SoftwareMenu/unTrusted" stringByExpandingTildeInPath] attributes:nil];
	if([man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/Info3.plist" stringByExpandingTildeInPath]])
		[man removeFileAtPath:[@"~/Library/Application Support/SoftwareMenu/Info3.plist" stringByExpandingTildeInPath] handler:nil];
	if([man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/Info4.plist" stringByExpandingTildeInPath]])
		[man removeFileAtPath:[@"~/Library/Application Support/SoftwareMenu/Info4.plist" stringByExpandingTildeInPath] handler:nil];
	
	tempFrapsInfo = [[NSMutableDictionary alloc] initWithDictionary:nil];
	tempFrapsInfo2= [[NSMutableDictionary alloc] initWithDictionary:nil];
	istrusted = [[NSMutableArray alloc] initWithObjects:nil];
	NSMutableDictionary *TrustedDict=[[NSMutableDictionary alloc] init];
	NSMutableDictionary *UnTrustedDict=[[NSMutableDictionary alloc] init];
	NSArray *hellotwo =[[NSArray alloc] initWithContentsOfURL:[[NSURL alloc]initWithString:@"http://web.me.com/tomcool420/Trusted2.plist"]];
	NSEnumerator *enumerator = [hellotwo objectEnumerator];
	[self writeToLog:@"==== startUpdate ===="];
	[self writeToLog:@"========= Adding Trusted ========="];
	[self writeToLog:@"Downloading trusted file from: http://web.me.com/tomcool420/Trusted2.plist"];
	id obj;
	while((obj = [enumerator nextObject]) != nil) 
	{
		NSString *theTrustedURL = [obj valueForKey:@"theURL"];
		NSString *theTrustedName = [obj valueForKey:@"name"];

		[self writeToLog:[[NSString alloc] initWithFormat:@"Adding From List: %@",theTrustedName]];
		[self writeToLog:theTrustedURL];
		[self writeToLog:@"\n"];
		NSDictionary *hellothree =[[NSDictionary alloc] initWithContentsOfURL:[[NSURL alloc]initWithString:theTrustedURL]];
		if([theTrustedURL isEqualToString:@"http://nitosoft.com/version.plist"])
		{
			NSMutableDictionary *hellofive = [[NSMutableDictionary alloc] init];
			[hellofive setObject:@"nitoTV" forKey:@"name"];
			[hellofive setObject:[hellothree valueForKey:@"displayVersionTwo"] forKey:@"Version"];
			[hellofive setObject:@"http://nitosoft.com/nitoTVInstaller_tt.zip" forKey:@"theURL"];
			[TrustedDict setObject:hellofive forKey:@"NitoTV"];
			[self writeToLog:@"nitoTV special loop"];
			
		}
		else if([theTrustedURL isEqualToString:@"http://nitosoft.com/updates.plist"])
		{
			NSMutableDictionary *hellofive = [[NSMutableDictionary alloc] init];
			[hellofive setObject:@"CouchSurfer" forKey:@"name"];
			[hellofive setObject:[hellothree valueForKey:@"displayVersionTwo"] forKey:@"Version"];
			[hellofive setObject:[hellothree valueForKey:@"twoUrl"] forKey:@"theURL"];
			[TrustedDict setObject:hellofive forKey:@"CouchSurfer"];
			[self writeToLog:@"CouchSurfer"];
		}
		else
		{
			[TrustedDict addEntriesFromDictionary:hellothree];
			[self writeToLog:@"Normal Loop"];
		}
		//NSLog(@"hellothree: %@",hellothree);
	}
	//NSLog(@"TrustedDict: %@",TrustedDict);
	[TrustedDict writeToFile:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Info4.plist" atomically:YES];
	
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
	//NSLog(@" ===== startUpdate =====");
	[self writeToLog:@"========= Done ========="];
	BRScrollingTextControl *textControls = [[BRScrollingTextControl alloc] init];
	[textControls setTitle:@"Check For Updates"];
	[textControls setDocumentPath:@"/Users/frontrow/Library/Application Support/SoftwareMenu/updater.log" encoding:NSUTF8StringEncoding];
	BRController *theController =  [BRController controllerWithContentControl:textControls];
	[[self stack] pushController:theController];
	/*i =0;
	urls=[[NSMutableArray alloc] initWithArray:nil];
	NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:trustedURL]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:60.0];
	NSURLDownload  *theDownload=[[NSURLDownload alloc] initWithRequest:theRequest delegate:self];
	STARTING = true;
	if (!theDownload) {
		//NSLog(@"shit");
    }
	else{
		//[self parsetrusted];
		//NSLog(@" ==== hello ====");
	}*/
}
-(void)parsetrusted
{
	total = 0 ;
	/*NSDate *future = [NSDate dateWithTimeIntervalSinceNow: 0.5];
	 [NSThread sleepUntilDate:future];*/
	//NSLog(@"===== parsetrusted =====");
	
	[self writeToLog:@"parsing trusted Sources"];
	
	NSArray *loginItemDict = [NSArray arrayWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Trusted/Trusted.plist.xml"]];
	NSEnumerator *enumerator = [loginItemDict objectEnumerator];
	NSString *theURL;
	total = [loginItemDict count];
	total = total +1;
	[self writeToLog:[NSString stringWithFormat:@"total: %d",total]];
	id obj;
	[istrusted addObject:@"yes"];
	while((obj = [enumerator nextObject]) != nil) 
	{
		[istrusted addObject:@"yes"];
		theURL = [obj valueForKey:@"theURL"];
		//NSLog(@"theURL: %@", theURL);
		NSString * thelogstring = [[NSString stringWithFormat:@"source: %@  ; ",[obj valueForKey:@"thename"]] stringByAppendingString:[NSString stringWithFormat:@"URL: %@",theURL]];
		[self writeToLog:thelogstring];
		
		NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:theURL]
												  cachePolicy:NSURLRequestUseProtocolCachePolicy
											  timeoutInterval:60.0];
		NSURLDownload  *theDownload=[[NSURLDownload alloc] initWithRequest:theRequest delegate:self];
		
		if (!theDownload) {
			//NSLog(@"shit");
		}
	}
	
	NSDictionary *loginItemDict2 = [NSDictionary dictionaryWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/unTrusted/untrusted.plist"]];
	NSEnumerator *enumerator2 = [loginItemDict2 objectEnumerator];
	int total2 = [loginItemDict2 count];
	total = total + total2 ;
	while((obj = [enumerator2 nextObject]) != nil) 
	{
		[istrusted addObject:@"no"];
		theURL = [obj valueForKey:@"theURL"];
		//NSLog(@"theURL: %@", theURL);
		NSString * thelogstring = [[NSString stringWithFormat:@"source: %@  ; ",[obj valueForKey:@"thename"]] stringByAppendingString:[NSString stringWithFormat:@"URL: %@",theURL]];
		[self writeToLog:thelogstring];
		
		NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:theURL]
												  cachePolicy:NSURLRequestUseProtocolCachePolicy
											  timeoutInterval:60.0];
		NSURLDownload  *theDownload=[[NSURLDownload alloc] initWithRequest:theRequest delegate:self];
		
		if (!theDownload) {
			//NSLog(@"shit");
		}
	}

}


- (void)download:(NSURLDownload *)download decideDestinationWithSuggestedFilename:(NSString *)filename
{
	//NSLog(@" ===== download =====");
    NSString *destinationFilename;
    NSString *homeDirectory=NSHomeDirectory();
	if(STARTING)
	{
		destinationFilename=[[homeDirectory stringByAppendingPathComponent:@"Library/Application Support/SoftwareMenu/Trusted"]
							 stringByAppendingPathComponent:filename];
	}
	else
	{
		if([[istrusted objectAtIndex:i] isEqualToString:@"yes"])
		{
			destinationFilename=[[homeDirectory stringByAppendingPathComponent:@"Library/Application Support/SoftwareMenu/Trusted"]
								 stringByAppendingPathComponent:filename];
		}
		else
		{
			destinationFilename=[[homeDirectory stringByAppendingPathComponent:@"Library/Application Support/SoftwareMenu/unTrusted"]
								 stringByAppendingPathComponent:filename];
		}
	}
	_DownloadFileNames = destinationFilename;
	CFPreferencesSetAppValue(CFSTR("theURL"), (CFStringRef)[NSString stringWithString:destinationFilename],kCFPreferencesCurrentApplication);
	//NSLog(@" destionationFilename: %@",destinationFilename);
	[urls addObject:destinationFilename];
	[download setDestination:destinationFilename allowOverwrite:YES];
}
- (void)download:(NSURLDownload *)download didFailWithError:(NSError *)error
{
    // release the connection
    [download release];
	NSString *theURL= (NSString *)(CFPreferencesCopyAppValue((CFStringRef)@"theURL", kCFPreferencesCurrentApplication));
	[self writeToLog:[theURL stringByAppendingString:@" has failed"]];
	if(STARTING)
	{
		[self writeToLog:@"please send me a mail and yell at me"];
	}
    // inform the user
	i=i+1;
	[self writeToLog:@"error"];
    NSLog(@"Download failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
}
- (void)downloadDidFinish:(NSURLDownload *)download
{
    // release the connection
    [download release];
	
    // do something with the data
    //NSLog(@"%@",@"downloadDidFinish");
	[self writeToLog:@"==== Download Finished === "];
	if (STARTING)
	{
		STARTING = false;
		[self parsetrusted];
	}
	else
	{
		
		NSString *theURL= [urls objectAtIndex:i];
		//NSLog(@"destination filename:%@",theURL);
		[self writeToLog:[NSString stringWithFormat:@"adding links from : %@", theURL]];
		NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:theURL];
		
		
		/*theURL = _DownloadFileNames;
		 //NSLog(@"destionation filenames:%@",theURL);*/
		if([[istrusted objectAtIndex:i]isEqualToString:@"yes"])
		{
			[tempFrapsInfo addEntriesFromDictionary:tempdict];
			[tempFrapsInfo writeToFile:@"Users/frontrow/Library/Application Support/SoftwareMenu/Info4.plist" atomically:YES];

		}
		else if([[istrusted objectAtIndex:i]isEqualToString:@"no"])
		{
			[tempFrapsInfo2 addEntriesFromDictionary:tempdict];
			[tempFrapsInfo2 writeToFile:@"Users/frontrow/Library/Application Support/SoftwareMenu/Info3.plist" atomically:YES];
		}
		//[self setsourceText:[[self sourceText] stringByAppendingString:[NSString stringWithFormat:@"\n%@ has been parsed",theURL]]]; 
	}
	i=i+1;
	[self writeToLog:[NSString stringWithFormat:@"i: %d",i]];
	[self writeToLog:[NSString stringWithFormat:@"total: %d",total]];
	//NSLog(@"%d",i);
	//NSLog(@"total: %d",total);
	if(i==total)
	{
		[self writeToLog:@"done"];
		
		BRScrollingTextControl *textControls = [[BRScrollingTextControl alloc] init];
		[textControls setTitle:@"Check For Updates"];
		[textControls setDocumentPath:@"/Users/frontrow/Library/Application Support/SoftwareMenu/updater.log" encoding:NSUTF8StringEncoding];
		BRController *theController =  [BRController controllerWithContentControl:textControls];
		[[self stack] pushController:theController];
	}
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
- (void)writeToLog:(NSString *)str
{
	NSString * thelog2 = [[[[NSString alloc] initWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/updater.log" stringByExpandingTildeInPath]] stringByAppendingString:@"\n"] stringByAppendingString:str];
	[thelog2 writeToFile:[@"~/Library/Application Support/SoftwareMenu/updater.log" stringByExpandingTildeInPath] atomically:YES];
}
- (void) textDidEndEditing: (id) sender
{
	[[self stack] popController];
	NSString *thetext = [sender stringValue];
	//NSLog(@"thetext");
	[self writeToLog:thetext];
}
- (void)wasExhumedByPoppingController:(id)fp8
{
	[self initWithIdentifier:@"101"];	
}
- (void)wasExhumed
{
	[self initWithIdentifier:@"101"];	
}
- (BOOL)brEventAction:(BREvent *)event
{
	long selitem;
	unsigned int hashVal = (uint32_t)((int)[event page] << 16 | (int)[event usage]);
	if ([(BRControllerStack *)[self stack] peekController] != self)
		hashVal = 0;
	
	//int itemCount = [[(BRListControl *)[self list] datasource] itemCount];
	
	//NSLog(@"hashval =%i",hashVal);
	switch (hashVal)
	{
		case 65676:  // tap up
			break;
		case 65677:  // tap down
			break;
		case 65675:  // tap left
			break;
		case 65674:  // tap right

			break;
		
		case 65673:  // tap play
			/*selitem = [self selectedItem];*/
			selitem = 0;
			
			selitem = [self selectedItem];
			 if(selitem<(long)1);
				[[_items objectAtIndex:selitem] setWaitSpinnerActive:YES];
			//NSLog(@"type play");
			break;
	}
	return [super brEventAction:event];
}
//	Data source methods:

- (float)heightForRow:(long)row				{ return 0.0f; }
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}
- (id)itemForRow:(long)row					{ return [_items objectAtIndex:row]; }
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title]; }
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title]; }



@end
