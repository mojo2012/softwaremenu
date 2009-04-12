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
#import "SMMedia.h"
#import "SMGeneralMethods.h"
//static NSString  * trustedURL = @"http://web.me.com/tomcool420/Trusted.plist";



@implementation SMThirdPartyMenu


- (id) previewControlForItem: (long) row
{
	if(row>=[_items count])
		return nil;
	//NSString *resourcePath = nil;
	NSString *appPng = nil;
	NSLog(@"%@",[_options objectAtIndex:row]);
	SMMedia *meta = [[SMMedia alloc] init];
	switch([[[_options objectAtIndex:row] valueForKey:@"Type"] intValue])
	{
		case kSMTpCheck:
			appPng = [[NSBundle bundleForClass:[self class]] pathForResource:@"web" ofType:@"png"];
			[meta setDescription:@"Check online for new updates"];
			[meta setTitle:@"Check For Updates"];
			break;
		case kSMTpRestart:
			appPng = [[NSBundle bundleForClass:[self class]] pathForResource:@"standby" ofType:@"png"];
			[meta setTitle:@"Restart Finder"];
			[meta setDescription:@"Restart Finder"];
			break;
		case kSMTpRefresh:
			appPng = [[NSBundle bundleForClass:[self class]] pathForResource:@"refresh" ofType:@"png"];
			[meta setTitle:@"Refresh Menu"];
			[meta setDescription:@"Refresh in case Info4.plist and/or Info3.plist was modified and change doesn't appear"];
			break;
		case kSMTpSm:
		case KSMTpTrusted:
		case kSMTpUntrusted:
			appPng = [[NSBundle bundleForClass:[self class]] pathForResource:[[_options objectAtIndex:row] valueForKey:@"Name"] ofType:@"png"];
			NSLog(@"appPng: %@, displayName: %@, name: %@, developer: %@",appPng,[[_options objectAtIndex:row] valueForKey:@"DisplayName"],[[_options objectAtIndex:row] valueForKey:@"Name"],[[_options objectAtIndex:row] valueForKey:@"Developer"]);
			[meta setTitle:[[_options objectAtIndex:row] valueForKey:@"DisplayName"]];
			[meta setDescription:[[_options objectAtIndex:row] valueForKey:@"ShortDescription"]];
			[meta setDev:[[_options objectAtIndex:row] valueForKey:@"Developer"]];
			break;
		
	}
	if(![_man fileExistsAtPath:appPng])
		appPng = [[NSBundle bundleForClass:[self class]] pathForResource:@"package" ofType:@"png"];
	
	[meta setImagePath:appPng];
	switch([[[_options objectAtIndex:row] valueForKey:@"Type"] intValue])
	{
		case kSMTpSm:
			[meta setDefaultImage];
			break;
	}
	
	BRMetadataPreviewControl *preview = [[BRMetadataPreviewControl alloc] init];
	[preview setAsset:meta];
	[preview setShowsMetadataImmediately:YES];
	//BRImageAndSyncingPreviewController *obj = [[BRImageAndSyncingPreviewController alloc] init];
	
	
	//id sp = [BRImage imageWithPath:appPng];
	
	//[obj setImage:sp];
	return (preview);
}

-(id)init{
	self = [super init];
	NSString *scriptPNG = [[NSBundle bundleForClass:[self class]] pathForResource:@"internet" ofType:@"png"];
	id folderImage = [BRImage imageWithPath:scriptPNG];
	[self setListIcon:folderImage horizontalOffset:0.5f kerningFactor:0.2f];
	[_options release];
	_man = [NSFileManager defaultManager];
	return self;
}

- (void)dealloc
{
	[_man release];
	[_options release];
	[_items release];
	[super dealloc];  
}

-(id)initWithIdentifier:(NSString *)initId
{
	NSMutableDictionary *file =[[NSMutableDictionary alloc] initWithDictionary:nil];
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
	
	
	int sep1 = [_items count];

	
	NSDictionary *loginItemDict = [NSDictionary dictionaryWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Info4.plist"]];
	
	NSDictionary *SoftwareMenuInfo = [loginItemDict valueForKey:@"SoftwareMenu"];
	NSString *SoftVers = [SoftwareMenuInfo valueForKey:@"Version"];
	
	NSString *frapSoftPath= [[NSString alloc] initWithString:[FRAP_PATH stringByAppendingString: @"SoftwareMenu.frappliance/"]];
	NSString * infoSoftPath = [frapSoftPath stringByAppendingString:@"Contents/Info.plist"];
	
	NSDictionary * Softinfo =[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:infoSoftPath]];
	
	NSString * current_soft_version =[[NSString alloc]initWithString:[Softinfo objectForKey:@"CFBundleVersion"]];
	
	int versLength = [SoftVers length];
	
	id item90 = [BRTextMenuItemLayer folderMenuItem];
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithInt:4],@"Type",
						 @"Thomas C. Cool",@"Developer",
						 @"Extension to Settings Menu. allows you to install plugins, run scripts, upgrade and downgrade TV",@"ShortDescription",
						 @"None",@"ReleaseDate",
						 @"softwaremenu",@"Name",
						 @"SoftwareMenu",@"DisplayName",
						 nil]];

	[item90 setTitle:@"SoftwareMenu"];
	
	if([current_soft_version compare:SoftVers]==NSOrderedAscending)
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
	NSLog(@"C");
	
	
	NSEnumerator *enumerator = [sortedArrays objectEnumerator];
	id obj;
	while((obj = [enumerator nextObject]) != nil) 
	{
		
		NSString *thename = [obj valueForKey:@"name"];
		if (thename == nil)
			thename = [obj valueForKey:@"Name"];
		NSString *displayName = [obj valueForKey:@"DisplayName"];
		if (displayName == nil)
			displayName = thename;
		
		NSString *onlineVersion = [obj valueForKey:@"Version"];
		NSString *frapPath= [NSString stringWithFormat:@"%@%@.frappliance/",FRAP_PATH,thename,nil];
		NSFileManager *manager = [NSFileManager defaultManager];
		id item = [BRTextMenuItemLayer folderMenuItem];
		NSString * current_version = nil;
		if(![thename isEqualToString:@"SoftwareMenu"])
		{
			if ([manager fileExistsAtPath:frapPath])
			{
				//NSString * infoPath = [frapPath stringByAppendingString:@"Contents/Info.plist"];
				NSDictionary * info =[NSDictionary dictionaryWithContentsOfFile:[frapPath stringByAppendingString:@"Contents/Info.plist"]];
				current_version =[NSString stringWithString:[info objectForKey:@"CFBundleVersion"]];
				
				if([[frapPath lastPathComponent] isEqualToString:@"nitoTV.frappliance"])
				{
					current_version = [info objectForKey:@"CFBundleShortVersionString"];
					onlineVersion = [obj valueForKey:@"shortVersion"];
				}
				
				if([current_version compare:onlineVersion]==NSOrderedSame)				{[item setRightJustifiedText:@"Up to Date"];}
				else if ([current_version compare:onlineVersion]==NSOrderedAscending)	{[item setRightJustifiedText:@"New Version available"];}
				else																	{[item setRightJustifiedText:@"Ahead of the curve"];}
			}
			else
			{
				[item setRightJustifiedText:@"Not Installed"];
			}
			
			
			//Adding option for Info
			NSString *dev = [obj valueForKey:@"Developer"];
			if(dev==nil)
				dev = @"nil";
			NSString *desc = [obj valueForKey:@"ShortDescription"];
			if(desc == nil)
				desc = @"nil";
			
			[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithInt:5],@"Type",
								 thename,@"Name",
								 displayName,@"DisplayName",
								 onlineVersion,@"OnlineVersion",
								 dev,@"Developer",
								 desc,@"ShortDescription",
								 [obj valueForKey:@"ReleaseDate"],@"ReleaseDate",
								 nil]];
			[item setTitle:displayName];
			[_items addObject: item];
		}
	}
	
	int sep3 = [_items count];
	NSLog(@"D");
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
	
	NSLog(@"D.1");
	//NSSortDescriptor *nameDescriptors2 = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray *ArraySortDescriptor2 = [NSArray arrayWithObjects:nameDescriptors, nil];
	 NSArray *sortedArrays2 = [_locationDictss2 sortedArrayUsingDescriptors:ArraySortDescriptor2];	
	NSLog(@"E");
	NSEnumerator *enumerator2 = [sortedArrays2 objectEnumerator];
	//id obj2;
	while((obj = [enumerator2 nextObject]) != nil) 
	{
		
		NSString *thename = [obj valueForKey:@"name"];
		if (thename == nil)
			thename = [obj valueForKey:@"Name"];
		NSString *displayName = [obj valueForKey:@"DisplayName"];
		if (displayName == nil)
			displayName = thename;
		NSString *onlineVersion = [obj valueForKey:@"Version"];
		NSString *frapPath= [[NSString alloc] initWithFormat:@"%@%@.frappliance/",FRAP_PATH,thename];
		NSFileManager *manager = [NSFileManager defaultManager];
		id item = [[BRTextMenuItemLayer alloc] init];		
		if(![thename isEqualToString:@"SoftwareMenu"])
		{
			if ([manager fileExistsAtPath:frapPath])
			{
				NSString * infoPath = [frapPath stringByAppendingString:@"Contents/Info.plist"];
				NSDictionary * info =[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:infoPath]];
				NSString * current_version =[[NSString alloc]initWithString:[info objectForKey:@"CFBundleVersion"]];
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
			[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithInt:6],@"Type",
								 thename,@"Name",
								 displayName,@"DisplayName",
								 dev,@"Developer",
								 desc,@"ShortDescription",
								 onlineVersion,@"OnlineVersion",
								 [obj valueForKey:@"ReleaseDate"],@"ReleaseDate",
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
	NSLog(@"itemselected");
	NSArray * thenames = [_options objectAtIndex:fp8];
	NSLog(@"A");
	//NSString *thename = [thenames objectAtIndex:1];
	NSMutableDictionary *loginItemDict=[[NSMutableDictionary alloc] initWithDictionary:nil];
	NSLog(@"B");
	switch([[[_options objectAtIndex:fp8] valueForKey:@"Type"] intValue])
	{
		case kSMTpCheck:
			NSLog(@"doing Update");
			NSString *thelog = [[NSString alloc] initWithString:@"thelog"];
			[thelog writeToFile:[@"~/Library/Application Support/SoftwareMenu/updater.log" stringByExpandingTildeInPath] atomically:YES];
			[self writeToLog:@"Initializing Update"];
			[self startUpdate];
			
			break;
		case kSMTpRefresh:
			[self initWithIdentifier:@"101"];
			break;
		case kSMTpRestart:
			[NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments:[NSArray arrayWithObjects:@"/System/Library/CoreServices/Finder.app/Contents/Plugins/SoftwareMenu.frappliance/Contents/Resources/reset.sh",nil]];
			break;
		case kSMTpSm:
		case KSMTpTrusted:
			NSLog(@"Going to a Trusted Menu");
			NSDictionary *Info4Dict = [NSDictionary dictionaryWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Info4.plist"]];
			[loginItemDict addEntriesFromDictionary:Info4Dict];
			break;
		case kSMTpUntrusted:
			NSLog(@"Going to an Untrusted Menu");
			NSDictionary *Info3Dict = [NSDictionary dictionaryWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/Library/Application Support/SoftwareMenu/Info3.plist"]];
			[loginItemDict addEntriesFromDictionary:Info3Dict];
			break;
	}
	switch([[[_options objectAtIndex:fp8] valueForKey:@"Type"] intValue])
	{
		case kSMTpSm:
			NSLog(@"SoftwareMenu:");
		case kSMTpUntrusted:
		case KSMTpTrusted:
			NSLog(@"doing something");
			NSString *thename = [[_options objectAtIndex:fp8] valueForKey:@"Name"];
			if([thename isEqualToString:@"softwaremenu"]) {thename = @"SoftwareMenu";}
				
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
					
					NSString *thelicense = [obj valueForKey:@"thelicense"];
					if(thelicense == nil)
					{
						thelicense = [obj valueForKey:@"license"];
						if(thelicense == nil)
						{
							thelicense = @"No License added";
						}
					}
					id newController = [[SMInstallMenu alloc] init];
					NSMutableDictionary *theInformation = [NSMutableDictionary dictionaryWithObjectsAndKeys:thename,@"name",theversion,@"version",thedescription,@"description",thelicense,@"license",theURL,@"url",nil];
					[newController setInformationDictionary:theInformation];
					[newController initCustom];
					[[self stack] pushController: newController];
			}
		}
	}
}
-(void)startUpdate
{

	if([_man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/Info3.plist" stringByExpandingTildeInPath]])
		[_man removeFileAtPath:[@"~/Library/Application Support/SoftwareMenu/Info3.plist" stringByExpandingTildeInPath] handler:nil];
	if([_man fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/Info4.plist" stringByExpandingTildeInPath]])
		[_man removeFileAtPath:[@"~/Library/Application Support/SoftwareMenu/Info4.plist" stringByExpandingTildeInPath] handler:nil];
	
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
		[self writeToLog:@"\n"];
		
		NSDictionary *trustedSource =[NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:theTrustedURL]];
		
		if([theTrustedURL isEqualToString:@"http://nitosoft.com/version.plist"])
		{
			NSMutableDictionary *nitoDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
			[nitoDict setObject:@"nitoTV" forKey:@"name"];
			[nitoDict setObject:[trustedSource valueForKey:@"displayVersionTwo"] forKey:@"Version"];
			[nitoDict setObject:[trustedSource valueForKey:@"versionTwo"] forKey:@"shortVersion"];
			[nitoDict setObject:@"http://nitosoft.com/nitoTVTwo.tar.gz" forKey:@"theURL"];
			[nitoDict setObject:[trustedSource valueForKey:@"ShortDescription"] forKey:@"ShortDescription"];
			[nitoDict setObject:[trustedSource valueForKey:@"developer"] forKey:@"Developer"];
			[nitoDict setObject:[trustedSource valueForKey:@"ReleaseDate"] forKey:@"ReleaseDate"];
			[TrustedDict setObject:nitoDict forKey:@"NitoTV"];
			[self writeToLog:@"nitoTV special loop"];
			
		}
		else if([theTrustedURL isEqualToString:@"http://nitosoft.com/updates.plist"])
		{
			NSMutableDictionary *couchDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:nil];
			[couchDict setObject:@"CouchSurfer" forKey:@"name"];
			[couchDict setObject:[trustedSource valueForKey:@"displayVersionTwo"] forKey:@"Version"];
			[couchDict setObject:[trustedSource valueForKey:@"twoUrl"] forKey:@"theURL"];
			[TrustedDict setObject:couchDict forKey:@"CouchSurfer"];
			[self writeToLog:@"CouchSurfer Special loop (Thanks to nito for plist up to date)"];
		}
		else
		{
			[TrustedDict addEntriesFromDictionary:trustedSource];
			[self writeToLog:@"Normal Loop"];
		}
	}
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
	[self writeToLog:@"========= Done ========="];
	BRScrollingTextControl *textControls = [[BRScrollingTextControl alloc] init];
	[textControls setTitle:@"Check For Updates"];
	[textControls setDocumentPath:@"/Users/frontrow/Library/Application Support/SoftwareMenu/updater.log" encoding:NSUTF8StringEncoding];
	BRController *theController =  [BRController controllerWithContentControl:textControls];
	[[self stack] pushController:theController];

}



-(long)defaultIndex
{
	return 0;
}
-(void)willBeBuried
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:[[self list] datasource]];
	[super willBeBuried];
}



-(void)willBePopped
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:[[self list] datasource]];
	[super willBePopped];
}
- (void)writeToLog:(NSString *)str
{
	NSString * thelog2 = [[[[NSString alloc] initWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/updater.log" stringByExpandingTildeInPath]] stringByAppendingString:@"\n"] stringByAppendingString:str];
	[thelog2 writeToFile:[@"~/Library/Application Support/SoftwareMenu/updater.log" stringByExpandingTildeInPath] atomically:YES];
}

- (void)wasExhumedByPoppingController:(id)fp8
{
	[self initWithIdentifier:@"101"];	
}
- (void)wasExhumed
{
	[self initWithIdentifier:@"101"];	
}

//	Data source methods:

- (float)heightForRow:(long)row				{ return 0.0f; }
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}
- (id)itemForRow:(long)row					{ return [_items objectAtIndex:row]; }
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title]; }
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title]; }



@end
