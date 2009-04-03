//
//  SMUpdater.m
//  SoftwareMenu
//
//  Created by Thomas on 2/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMUpdater.h"
#import "SMDownloaderSTD.h"
#import "SMUpdaterProcess.h"
#import "SMInfo.h"
#import "SMUOptions.h"



@implementation SMUpdater

-(id)getChoices:(NSString *)URL
{
	
	NSData *outData = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL]];
	NSString *error;
	NSPropertyListFormat format;
	id vDict;
	vDict = [NSPropertyListSerialization propertyListFromData:outData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
	return vDict;
}

-(id)initCustom
{
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: BRLocalizedString(@"Updater",@"Updater")];
	
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	NSArray *values=[[NSArray alloc] initWithArray:[self getChoices:UPDATE_URL]];
	id item1 = [[BRTextMenuItemLayer alloc] init];
	[_options addObject:[[NSArray alloc] initWithObjects:@"readme",nil]];
	[item1 setTitle:[[BRLocalizedString(@"Readme",@"Readme") stringByAppendingString:@"/"]stringByAppendingString:BRLocalizedString(@"Disclaimer",@"Disclaimer")]];
	[_items addObject:item1];
	int optionsSeparator=[_items count];
	
	/*NSArray *optionKeys  = [NSArray arrayWithObjects:@"preserve",@"updatenow",@"originalupdate",@"install_perian",@"do_usb_patch",@"retain_installed",@"retain_builtin",nil];
	NSArray *optionNames = [NSArray arrayWithObjects:BRLocalizedString(@"Preserve Files",@"Preserve Files"),
							BRLocalizedString(@"Update Immediatly",@"Update Immediatly"),
							BRLocalizedString(@"Keep Unpatched",@"Keep Unpatched"),
							BRLocalizedString(@"Install Perian",@"Install Perian"),
							BRLocalizedString(@"USB Patch",@"USB Patch"),
							BRLocalizedString(@"Retain Plugins",@"Retain Plugins"),
							BRLocalizedString(@"Retain Builtin Backup",@"Retain Builtin Backup"), nil];
	int ii, counterr;
	ii=[optionKeys count];
	for(counterr=0;counterr<ii;counterr++)
	{
		id item2 = [[BRTextMenuItemLayer alloc] init];
		NSString *optionKey=[optionKeys objectAtIndex:counterr];
		[_options addObject:[NSArray arrayWithObjects:@"options",optionKey,nil]];
		[item2 setTitle:[optionNames objectAtIndex:counterr]];
		if([SMGeneralMethods boolForKey:optionKey])
		{
			[item2 setRightJustifiedText:BRLocalizedString(@"YES",@"YES")];
		}
		else
		{
			[item2 setRightJustifiedText:BRLocalizedString(@"NO",@"NO")];
			[SMGeneralMethods setBool:NO forKey:optionKey];
		}
		[_items addObject:item2];
		if([optionKey isEqualToString:@"retain_installed"] && ![SMGeneralMethods boolForKey:optionKey])
		{
			id item3 = [[BRTextMenuItemLayer alloc] init];
			[item3 setTitle:BRLocalizedString(@"Retain Nito?",@"Retain Nito?")];
			if([SMGeneralMethods boolForKey:@"retain_nito"])
			{
				[item3 setRightJustifiedText:BRLocalizedString(@"YES",@"YES")];
			}
			else
			{
				[item3 setRightJustifiedText:BRLocalizedString(@"NO",@"NO")];
				[SMGeneralMethods setBool:NO forKey:@"retain_nito"];
			}
			[_options addObject:[NSArray arrayWithObjects:@"options",optionKey,nil]];
			[_items addObject:item3];
		}
		
	}*/
	id item31 =[BRTextMenuItemLayer folderMenuItem];
	[item31 setTitle:@"Options"];
	[_options addObject:[NSArray arrayWithObjects:@"options",@"options",nil]];
	[_items addObject:item31];
	int updateSeperator=[_items count];
	
	NSFileManager *man = [NSFileManager defaultManager];
	if([man fileExistsAtPath:@"/Users/frontrow/Updates/final.dmg"])
	{
		id item3 = [[BRTextMenuItemLayer alloc] init];
		[_options addObject:[[NSArray alloc] initWithObjects:@"osupdate",nil]];
		[item3 setTitle:BRLocalizedString(@"Update now!",@"Update now")];
		[_items addObject:item3];
		
	}
	
	int updateListSeperator=[_items count];
	
	NSDictionary *atv_framework_plist = [NSDictionary dictionaryWithContentsOfFile:@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/version.plist"];
	NSString *atv_version = [atv_framework_plist valueForKey:@"CFBundleVersion"];
	NSEnumerator *enumeratorToo = [values objectEnumerator];
	id obje;
	while((obje = [enumeratorToo nextObject]) != nil) 
		
	{
		NSString *thename=[[NSString alloc] initWithString:[NSString stringWithFormat:@"Upgrade/Downgrade to %@",[obje valueForKey:@"display"],nil]];
		if([atv_version compare:[obje valueForKey:@"display"]]==NSOrderedSame)
		{
			thename=@"RePatch to:";
		}
		else if([atv_version compare:[obje valueForKey:@"display"]]==NSOrderedAscending)
		{
			thename=@"Upgrade to:";
		}
		else
		{
			thename=@"Downgrade to:";
		}
		NSArray *option = [[NSArray alloc] initWithObjects:@"updating",[obje valueForKey:@"atv_version"],[obje valueForKey:@"xml_location"],[obje valueForKey:@"display"],nil];
		[_options addObject:option];
		id item = [[BRTextMenuItemLayer alloc] init];
		[item setTitle:thename];
		[item setRightJustifiedText:[obje valueForKey:@"display"]];

		[_items addObject:item];
	}
	id list = [self list];
	[list setDatasource: self];
	[[self list] addDividerAtIndex:updateListSeperator withLabel:BRLocalizedString(@"Updates",@"Updates")];
	if([man fileExistsAtPath:@"/Users/frontrow/Updates/final.dmg"])
	{
		[[self list] addDividerAtIndex:updateSeperator withLabel:BRLocalizedString(@"Update Now",@"Update Now")];
	}
	[[self list] addDividerAtIndex:optionsSeparator withLabel:BRLocalizedString(@"Options",@"Options")];
	return self;
	
}

-(void)itemSelected:(long)fp8
{
	//NSString *xml_location=[[_options objectAtIndex:fp8]valueForKey:@"xml_location"];
	if([[[_options objectAtIndex:fp8]objectAtIndex:0] isEqualToString:@"osupdate"])
	{
		NSTask *task7 = [[NSTask alloc] init];
		NSArray *args7 = [NSArray arrayWithObjects:@"-osupdate",@"0",@"0",nil];
		[task7 setArguments:args7];
		[task7 setLaunchPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""]];
		[task7 launch];
		[task7 waitUntilExit];
	}
	else if([[[_options objectAtIndex:fp8]objectAtIndex:0] isEqualToString:@"readme"])
	{
		//NSString *readmepath=[[NSBundle bundleForClass:[self class]] pathForResource:@"readmeupd" ofType:@"txt"];
		NSString *downloadedDescription = [NSString  stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"readmeupd" ofType:@"txt"] encoding:NSUTF8StringEncoding error:NULL];
		_downloadnumber=10;
		id newController=[[SMInfo alloc] init];
		[newController setDescription:downloadedDescription];

		//id newController = [[SMLog alloc] init];
		
		//[newController setDescription:downloadedDescription];
		[newController setTheName:@"README"];
		[[self stack] pushController:newController];
		return;
		
	}
	else if([[[_options objectAtIndex:fp8]objectAtIndex:0] isEqualToString:@"options"])
	{
		_downloadnumber=10;
		id newController2 = [[SMUOptions alloc] init];
		[newController2 initCustom];
		[[self stack] pushController:newController2];
		//[SMGeneralMethods switchBoolforKey:[[_options objectAtIndex:fp8] objectAtIndex:1]];
		[self initCustom];
		return;
	}
	else if([[[_options objectAtIndex:fp8]objectAtIndex:0] isEqualToString:@"updating"])
	{
		_displays=[[_options objectAtIndex:fp8] objectAtIndex:3];
		[self start_updating:[[_options objectAtIndex:fp8] objectAtIndex:2]];
	}
	
	
}


-(id)init{
	//NSLog(@"init");
	
	return [super init];
}
- (void)dealloc
{
	[_items release];
	[_options release];
	[_dlinks release];
	[_dlinks2 release];
	[_md5s release];
	[_displays release];
	[_builtinfraps release];
	[super dealloc];  
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


-(void)willBePopped
{
	//NSLog(@"willBePopped");
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:[[self list] datasource]];
	[super willBePopped];
}

-(void)start_updating:(NSString *)xml_location
{
	if ([[SMGeneralMethods sharedInstance] checkblocker])
	{
		[[SMGeneralMethods sharedInstance] toggleUpdate];
	}
	//NSLog(@"start updating");
	NSMutableArray *dLinks = [[NSMutableArray alloc] init];
	NSMutableArray *md5s   = [[NSMutableArray alloc] init];
	NSData *outData = [NSData dataWithContentsOfURL:[NSURL
													 URLWithString:xml_location]];
	NSString *error;
	NSPropertyListFormat format;
	id vDict;
	vDict = [NSPropertyListSerialization propertyListFromData:outData
			 
											 mutabilityOption:NSPropertyListImmutable
			 
													   format:&format
			 
											 errorDescription:&error];
	
	//NSLog(@"vDict: %@", vdict);
	NSString *osURL = [[vDict valueForKey:@"OS"] valueForKey:@"UpdateURL"];
	NSString *efiInstaller = [[vDict valueForKey:@"EFI"] valueForKey:@"InstallerURL"];
	NSString *efiUpdater = [[vDict valueForKey:@"EFI"] valueForKey:@"UpdateURL"];
	NSString *irInstaller = [[vDict valueForKey:@"IR"] valueForKey:@"InstallerURL"];
	NSString *irUpdater = [[vDict valueForKey:@"IR"] valueForKey:@"UpdateURL"];
	NSString *siInstaller = [[vDict valueForKey:@"SI"] valueForKey:@"InstallerURL"];
	NSString *siUpdater = [[vDict valueForKey:@"SI"] valueForKey:@"UpdateURL"];
	[dLinks addObject:osURL];
	[dLinks addObject:efiInstaller];
	[dLinks addObject:efiUpdater];
	[dLinks addObject:irInstaller];
	[dLinks addObject:irUpdater];
	[dLinks addObject:siInstaller];
	[dLinks addObject:siUpdater];
	osURL = [[vDict valueForKey:@"OS"] valueForKey:@"md5OS"];
	efiInstaller = [[vDict valueForKey:@"EFI"] valueForKey:@"md5EFIins"];
	efiUpdater = [[vDict valueForKey:@"EFI"] valueForKey:@"md5EFIupd"];
	irInstaller = [[vDict valueForKey:@"IR"] valueForKey:@"md5IRins"];
	irUpdater = [[vDict valueForKey:@"IR"] valueForKey:@"md5IRupd"];
	siInstaller = [[vDict valueForKey:@"SI"] valueForKey:@"md5SIins"];
	siUpdater = [[vDict valueForKey:@"SI"] valueForKey:@"md5SIupd"];
	[md5s addObject:osURL];
	[md5s addObject:efiInstaller];
	[md5s addObject:efiUpdater];
	[md5s addObject:irInstaller];
	[md5s addObject:irUpdater];
	[md5s addObject:siInstaller];
	[md5s addObject:siUpdater];
	
	_downloadnumber=0;
	//[dLinks autorelease];
	//NSLog(@"%@",_dlinks);
	//NSLog(@"end updating");
	NSMutableArray * builtinfraps = [[NSMutableArray alloc] initWithObjects:@"OS",@"EFI Installer",@"EFI Updater",@"IR Installer",@"IR Updater",@"SI Installer",@"SI Updater",nil];
	
	
	NSString *atvpath=[[NSString alloc] initWithString:@"/Users/frontrow/Documents/"];
	NSString *foldername=[NSString stringWithFormat:@"ATV%@",_displays,nil];
	atvpath=[atvpath stringByAppendingPathComponent:foldername];
	NSFileManager *man = [NSFileManager defaultManager];
	BOOL OSISRIGHT = NO;
	if([man fileExistsAtPath:atvpath])
	{
		[dLinks count];
		int i,counter;
		i=[dLinks count];
		NSMutableArray *md5s2 =[[NSMutableArray alloc] initWithCapacity:7];
		NSMutableArray *builtinfraps2 =[[NSMutableArray alloc] initWithCapacity:7];
		NSMutableArray *dLinks2 =[[NSMutableArray alloc] initWithCapacity:7];
		for( counter=0; counter < i-1 ; counter++)
		{
			NSString *itemName=[[dLinks objectAtIndex:counter] lastPathComponent];
			//NSLog(@"itemName: %@",itemName);
			//NSLog(@"itemPath: %@",[atvpath stringByAppendingPathComponent:itemName]);
			if([[itemName pathExtension]isEqualToString:@"dmg"])
			{
				
				OSISRIGHT=[self checkmd5:[atvpath stringByAppendingPathComponent:@"OS.dmg"] withmd5:[md5s objectAtIndex:0]];
				if(OSISRIGHT)
				{
					//NSLog(@"OS.dmg has correct MD5");
				}
				else
				{
					[man removeFileAtPath:[atvpath stringByAppendingPathComponent:@"OS.dmg"] handler:NULL];
					[md5s2 addObject:[md5s objectAtIndex:counter]];
					[dLinks2 addObject:[dLinks objectAtIndex:counter]];
					[builtinfraps2 addObject:[builtinfraps objectAtIndex:counter]];
				}
			}
			else
			{
				OSISRIGHT=[self checkmd5:[atvpath stringByAppendingPathComponent:itemName] withmd5:[md5s objectAtIndex:counter]];
				if(OSISRIGHT)
				{
					//NSLog(@"%@ has correct MD5",itemName);
				}
				else
				{
					
					[man removeFileAtPath:[atvpath stringByAppendingPathComponent:itemName] handler:NULL];
					[md5s2 addObject:[md5s objectAtIndex:counter]];
					[dLinks2 addObject:[dLinks objectAtIndex:counter]];
					[builtinfraps2 addObject:[builtinfraps objectAtIndex:counter]];
				}
			}
		}
		
		_md5s=md5s2;
		_dlinks=dLinks2;
		_builtinfraps=builtinfraps2;
		_dlinks2=dLinks;	
		
	}
	else
	{
		_md5s=md5s;
		_dlinks=dLinks;
		_dlinks2=dLinks;
		_builtinfraps=builtinfraps;
	}
	[_builtinfraps retain];
	[_md5s retain];
	[_dlinks retain];
	[_dlinks2 retain];
	//[_downloadnumber retain];
	NSMutableDictionary *tempoptions = [self getOptions];
	if([tempoptions valueForKey:@"install_perian"])
	{
		if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Documents/Perian_1.1.3.dmg" stringByExpandingTildeInPath]])
		{
			if(![self checkmd5:[@"~/Documents/Perian_1.1.3.dmg" stringByExpandingTildeInPath] withmd5:@"c0377cb6142f27270b1daf8ab151d1c6"])
			{
				[[NSFileManager defaultManager] removeFileAtPath:[@"~/Documents/Perian_1.1.3.dmg" stringByExpandingTildeInPath] handler:nil];
				[_builtinfraps addObject:@"Perian 1.1.3"];
				[_dlinks addObject:@"http://perian.cachefly.net/Perian_1.1.3.dmg"];
				[_md5s addObject:@"c0377cb6142f27270b1daf8ab151d1c6"];
				NSLog(@"install Perian");
			}

		}
		else
		{
			[_builtinfraps addObject:@"Perian 1.1.3"];
			[_dlinks addObject:@"http://perian.cachefly.net/Perian_1.1.3.dmg"];
			[_md5s addObject:@"c0377cb6142f27270b1daf8ab151d1c6"];
			NSLog(@"install Perian");
		}

	}
	if([tempoptions valueForKey:@"do_usb_patch"])
	{
		if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Documents/MacOSXUpdCombo10.4.9Intel.dmg" stringByExpandingTildeInPath]])
		{
			if(![self checkmd5:[@"~/Documents/MacOSXUpdCombo10.4.9Intel.dmg" stringByExpandingTildeInPath] withmd5:@"2c579f52ad69d12d95ea82ee3d9c4937"])
			{
				[[NSFileManager defaultManager] removeFileAtPath:[@"~/Documents/MacOSXUpdCombo10.4.9Intel.dmg" stringByExpandingTildeInPath] handler:nil];
				[_builtinfraps addObject:@"Combo Update 10.4.9"];
				[_dlinks addObject:@"http://supportdownload.apple.com/download.info.apple.com/Apple_Support_Area/Apple_Software_Updates/Mac_OS_X/downloads/061-3165.20070313.iU8y4/MacOSXUpdCombo10.4.9Intel.dmg"];
				[_md5s addObject:@"2c579f52ad69d12d95ea82ee3d9c4937"];
				NSLog(@"10.4.9");
			}
			
		}
		else
		{
			[_builtinfraps addObject:@"Combo Update 10.4.9"];
			[_dlinks addObject:@"http://supportdownload.apple.com/download.info.apple.com/Apple_Support_Area/Apple_Software_Updates/Mac_OS_X/downloads/061-3165.20070313.iU8y4/MacOSXUpdCombo10.4.9Intel.dmg"];
			[_md5s addObject:@"2c579f52ad69d12d95ea82ee3d9c4937"];
			NSLog(@"10.4.9");
		}
		
	}

	NSLog(@"here");
	if ([_dlinks count]==0)
		   
	{
		_downloadnumber=10;
		[self moveFiles];
	}
	else
	{
		[self downloadthemalready];
		
	}
	
}
-(void)downloadthemalready;
{
	//NSLog(@"downloadthemalready");
	//NSArray *titles=[[NSArray alloc] initWithObjects:@"OS",@"EFI Installer","EFI Updater","IR Installer","IR Updater","SI Installer",@"SI Updater",nil];
	
	//NSArray * thetitles = [[NSArray alloc] initWithObjects:@"OS",@"EFI Installer","EFI Updater","IR Installer","IR Updater","SI Installer",@"SI Updater",nil];
	
	//NSLog(@"%@",_builtinfraps);
	//int thenumber=[_dlinks count];
	//NSLog(@"%i",thenumber);
	//if (_downloadnumber<7)
	//{
	
	//NSLog(@"in if loop");
	id newController2 = nil;
	newController2 =[[SMDownloaderSTD alloc] init];
	//NSString *hello=[_builtinfraps objectAtIndex:_downloadnumber];
	//NSLog(@"%@",[NSString stringWithFormat:BRLocalizedString(@"%@ for ATV%@",@"%@ for ATV%@"),[_builtinfraps objectAtIndex:_downloadnumber],_displays,nil]);
	//[newController2 setdownloadTitle:[NSString stringWithFormat:@"%@ for ATV%@",[_builtinfraps objectAtIndex:_downloadnumber],_displays,nil]];
	//NSLog(@"%@",[_dlinks objectAtIndex:_downloadnumber]);
	//[newController2 setFileURL:[_dlinks objectAtIndex:_downloadnumber]];
	//NSLog(@"%@",[_dlinks objectAtIndex:_downloadnumber]);
	//NSLog(@"%@",[NSString stringWithFormat:@"downloading file %d/%d\n URL: \n %@",_downloadnumber+1,[_dlinks count],[_dlinks objectAtIndex:_downloadnumber],nil]);
	//[newController2 setFileText:[NSString stringWithFormat:@"downloading file %d/7\n URL: \n %@",_downloadnumber+1,[_dlinks objectAtIndex:_downloadnumber],nil]];
	NSMutableDictionary *hellotwo =[[NSMutableDictionary alloc] initWithObjectsAndKeys:[_dlinks objectAtIndex:_downloadnumber],@"url",
									[NSString stringWithFormat:BRLocalizedString(@"%@ for ATV%@",@"%@ for ATV%@"),[_builtinfraps objectAtIndex:_downloadnumber],_displays,nil],@"name",
									[NSString stringWithFormat:BRLocalizedString(@"downloading file %d/%d\n URL: \n %@",@"downloading file %d/%d\n URL: \n %@"),_downloadnumber+1,[_dlinks count],[_dlinks objectAtIndex:_downloadnumber],nil],@"downloadtext",nil];
	//NSLog(@"hellotwo: %@",hellotwo);
	[newController2 setInformationDict:hellotwo];
	
	//[newController initCustom:[self getChoices:@"http://web.me.com/tomcool420/SoftwareMenu/ATV21.xml"] withName:@"2.whatever"];
	[[self stack] pushController: newController2];
	//}
	
	
}
- (void)wasExhumedByPoppingController:(id)fp8
{
	NSLog(@"was Exhumed By Poppping");
	
	//NSLog(@"builtinfrapscount %d",[_builtinfraps count]);
	if(_downloadnumber==10)
	{
		[self initCustom];
	}
	else if (_downloadnumber<[self getValueMinusOne])
	{
		_downloadnumber++;
		[self downloadthemalready];
	}
	else
	{
		[self moveFiles];
	}
}
-(void)wasExhumed
{
	NSLog(@"was Exhumed");
	
	//NSLog(@"builtinfrapscount %d",[_builtinfraps count]);
	if(_downloadnumber==10)
	{
		[self initCustom];
	}
	else if (_downloadnumber<[self getValueMinusOne])
	{
		_downloadnumber++;
		[self downloadthemalready];
	}
	else
	{
		[self moveFiles];
	}
}
-(int)getValueMinusOne
{
	if([_builtinfraps count]==0)
	{
		return 0;
	}
	else
	{
		int i;
		i=[_builtinfraps count] -1;
		return i;
	}
}
-(void)moveFiles
{
	NSLog(@"-1");
	_downloadnumber=10;
	NSString *atvpath=[[NSString alloc] initWithString:@"/Users/frontrow/Documents/"];
	NSString *foldername=[NSString stringWithFormat:BRLocalizedString(@"ATV%@",@"ATV%@"),_displays,nil];
	atvpath=[atvpath stringByAppendingPathComponent:foldername];
	NSFileManager *man = [NSFileManager defaultManager];
	if(![man fileExistsAtPath:atvpath])
	{
		[man createDirectoryAtPath:atvpath attributes:nil];
	}
	/*else
	 {
	 [man removeFileAtPath:atvpath handler:NULL];
	 [man createDirectoryAtPath:atvpath attributes:nil];
	 }*/
	
	int counter,i;
	i=[_dlinks count];
	//NSEnumerator *enumerator =[_dlinks objectEnumerator];
	
	BOOL CONTINUE = YES;
	NSString *hello;
	NSString *themd5;
	for( counter=0; counter < i ; counter++)
	{
		
		NSString *obje = [_dlinks objectAtIndex:counter];
		NSString *md5 =  [_md5s objectAtIndex:counter];
		NSString * path_init = @"/Users/frontrow/Library/Caches/SoftDownloads";
		NSString * thefolder = [[[obje lastPathComponent] stringByDeletingPathExtension] stringByAppendingPathExtension:@"download"];
		path_init = [path_init stringByAppendingPathComponent:thefolder];
		path_init = [path_init stringByAppendingPathComponent:[obje lastPathComponent]];
		NSLog(@"%@",path_init);
		
		[man movePath:path_init toPath:[atvpath stringByAppendingPathComponent:[obje lastPathComponent]] handler:nil];
		if (![self checkmd5:[atvpath stringByAppendingPathComponent:[obje lastPathComponent]]withmd5:md5])
		{
			CONTINUE=NO;
			hello=obje;
			themd5=md5;
		}
		NSLog(@"0");
		if([[obje lastPathComponent] isEqualToString:@"Perian_1.1.3.dmg"])
		{
			[man movePath:[atvpath stringByAppendingPathComponent:@"Perian_1.1.3.dmg"] toPath:[[atvpath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"Perian_1.1.3.dmg"] handler:nil];
		}
		else if([[obje lastPathComponent] isEqualToString:@"MacOSXUpdCombo10.4.9Intel.dmg"])
		{
			[man movePath:[atvpath stringByAppendingPathComponent:@"MacOSXUpdCombo10.4.9Intel.dmg"] toPath:[[atvpath stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"MacOSXUpdCombo10.4.9Intel.dmg"] handler:nil];
		}
		else if([[obje pathExtension] isEqualToString:@"dmg"])
		{
			[man movePath:[atvpath stringByAppendingPathComponent:[obje lastPathComponent]] toPath:[atvpath stringByAppendingPathComponent:@"OS.dmg"] handler:nil];
		}

	}
	if(!CONTINUE)
	{
		BRAlertController *alert = [BRAlertController alertOfType:0
														   titled:[NSString stringWithFormat:BRLocalizedString(@"ATV%@",@"ATV%@"),_displays]
													  primaryText:[NSString stringWithFormat:BRLocalizedString(@"MD5 Problem: %@",@"MD5 Problem: %@"),themd5]
													secondaryText:hello/*\nPressing the Left arrow key enables the script to show in the main softwareMenu categories\n (for scripts you run a lot)"*/];
		[[self stack] pushController:alert];
	}
	if(CONTINUE)
	{
		NSLog(@"3");
		[self patchOSdmg];
	}
	
}

-(BOOL)checkmd5:(NSString *)path withmd5:(NSString *)md5
{
	
	
	//NSLog(@"%@ %s", self, _cmd);
	NSTask *mdTask = [[NSTask alloc] init];
	NSPipe *mdip = [[NSPipe alloc] init];
	NSString *fullPath = path;
	NSFileHandle *mdih = [mdip fileHandleForReading];
	[mdTask setLaunchPath:@"/sbin/md5"];
	
	[mdTask setArguments:[NSArray arrayWithObjects:@"-q", fullPath, nil]];
	[mdTask setStandardOutput:mdip];
	[mdTask setStandardError:mdip];
	[mdTask launch];
	[mdTask waitUntilExit];
	NSData *outData;
	outData = [mdih readDataToEndOfFile];
	NSString *temp = [[NSString alloc] initWithData:outData encoding:NSASCIIStringEncoding];
	temp = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	//int theTerm = [mdTask terminationStatus];
	//NSLog(@"md5: %@", temp);
	if ([temp isEqualToString:md5])
	{
		//NSLog(@"file at %@ is OK", path);
		return YES;
		
	}
	
	return NO;
}
-(void)patchOSdmg
{
	
	id newController = nil;
	newController =[[SMUpdaterProcess alloc] init];
	//NSLog(@"before dict");
	//NSLog(@"preserve:%@,%d",[NSString stringWithFormat:@"%d",[SMGeneralMethods boolForKey:@"preserve"]],[SMGeneralMethods boolForKey:@"preserve"]);
	NSMutableDictionary *tempoptions = [self getOptions];
	NSDictionary *thedict=[[NSDictionary alloc] initWithObjectsAndKeys:_displays,@"displays",_dlinks2,@"dlinks",[NSNumber numberWithBool:[SMGeneralMethods boolForKey:@"preserve"]],@"preserve",[NSNumber numberWithBool:[SMGeneralMethods boolForKey:@"updatenow"]],@"now",[NSNumber numberWithBool:[SMGeneralMethods boolForKey:@"install_perian"]],@"install_perian",[NSNumber numberWithBool:[SMGeneralMethods boolForKey:@"originalupdate"]],@"original",nil];
	//NSLog(@"%@",thedict);
	NSLog(@"4");
	[newController setUpdateData:thedict];
	[[self stack] pushController: newController];	
}
-(NSMutableDictionary *)getOptions
{
	NSMutableDictionary *theoptions = [[SMGeneralMethods dictForKey:@"Updater_Options"] mutableCopy];
	return theoptions;
}


- (float)heightForRow:(long)row				{ return 0.0f; }
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}
- (id)itemForRow:(long)row					{ return [_items objectAtIndex:row]; }
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title]; }
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title]; }




@end
