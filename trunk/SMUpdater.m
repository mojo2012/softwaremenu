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
#define UPDATE_URL			@"http://web.me.com/tomcool420/SoftwareMenu/updates.plist"


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
	NSLog(@"hello");
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: BRLocalizedString(@"Settings",@"Settings")];
	
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	NSArray *values=[[NSArray alloc] initWithArray:[self getChoices:UPDATE_URL]];
	id item1 = [[BRTextMenuItemLayer alloc] init];
	[_options addObject:[[NSArray alloc] initWithObjects:@"README",nil]];
	[item1 setTitle:BRLocalizedString(@"README FIRST",@"README FIRST")];
	[_items addObject:item1];
	
	NSFileManager *man = [NSFileManager defaultManager];
	if([man fileExistsAtPath:@"/Users/frontrow/Updates/final.dmg"])
	{
		id item3 = [[BRTextMenuItemLayer alloc] init];
		[_options addObject:[[NSArray alloc] initWithObjects:@"osupdate",nil]];
		[item3 setTitle:BRLocalizedString(@"Update now!",@"Update now")];
		[_items addObject:item3];
		
	}
	int i;
	i=[_items count];
	NSEnumerator *enumeratorToo = [values objectEnumerator];
	id obje;
	while((obje = [enumeratorToo nextObject]) != nil) 
		
	{
		NSString *thename =[NSString stringWithFormat:BRLocalizedString(@"Update/Downgrade to %@",@"Update/Downgrade to %@"),[obje valueForKey:@"display"]];;
		NSArray *option = [[NSArray alloc] initWithObjects:@"updating",[obje valueForKey:@"atv_version"],[obje valueForKey:@"xml_location"],[obje valueForKey:@"display"],nil];
		[_options addObject:option];
		id item = [[BRTextMenuItemLayer alloc] init];
		[item setTitle:thename];
		[_items addObject:item];
	}
	id list = [self list];
	[list setDatasource: self];
	[[self list] addDividerAtIndex:i withLabel:BRLocalizedString(@"Updates",@"Updates")];
	if([man fileExistsAtPath:@"/Users/frontrow/Updates/final.dmg"])
	{
		[[self list] addDividerAtIndex:1 withLabel:BRLocalizedString(@"Update NOW",@"Update Now")];
	}
	NSLog(@"bye");
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
	else if(![[[_options objectAtIndex:fp8]objectAtIndex:0] isEqualToString:@"README"])
	{
		_displays=[[_options objectAtIndex:fp8] objectAtIndex:3];
		[self start_updating:[[_options objectAtIndex:fp8] objectAtIndex:2]];
	}
	/*id newController = nil;
	newController =[[SMDownloaderSTD alloc] init];
	[newController setdownloadTitle:@"ATV2.1"];
	[newController setFileURL:@"http://mesu.apple.com/data/EFI/061-3046.20080212.U7tgG/AppleCapsule.efi"];
	[newController setFileText:@"hello hello"];
	//[newController initCustom:[self getChoices:@"http://web.me.com/tomcool420/SoftwareMenu/ATV21.xml"] withName:@"2.whatever"];
	[[self stack] pushController: newController];*/
	
}


-(id)init{
	//NSLog(@"init");
	
	return [super init];
}
- (void)dealloc
{
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

-(void)start_updating:(NSString *)xml_location
{
	NSLog(@"start updating");
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
	NSLog(@"%@",_dlinks);
	NSLog(@"end updating");
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
			NSLog(@"itemName: %@",itemName);
			NSLog(@"itemPath: %@",[atvpath stringByAppendingPathComponent:itemName]);
			if([[itemName pathExtension]isEqualToString:@"dmg"])
			{
				
				OSISRIGHT=[self checkmd5:[atvpath stringByAppendingPathComponent:@"OS.dmg"] withmd5:[md5s objectAtIndex:0]];
				if(OSISRIGHT)
				{
					NSLog(@"OS.dmg has correct MD5");
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
					NSLog(@"%@ has correct MD5",itemName);
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
	NSLog(@"downloadthemalready");
	//NSArray *titles=[[NSArray alloc] initWithObjects:@"OS",@"EFI Installer","EFI Updater","IR Installer","IR Updater","SI Installer",@"SI Updater",nil];
	
	//NSArray * thetitles = [[NSArray alloc] initWithObjects:@"OS",@"EFI Installer","EFI Updater","IR Installer","IR Updater","SI Installer",@"SI Updater",nil];

	NSLog(@"%@",_builtinfraps);
	//int thenumber=[_dlinks count];
	//NSLog(@"%i",thenumber);
	//if (_downloadnumber<7)
	//{
		
		NSLog(@"in if loop");
	id newController2 = nil;
	newController2 =[[SMDownloaderSTD alloc] init];
	//NSString *hello=[_builtinfraps objectAtIndex:_downloadnumber];
		NSLog(@"%@",[NSString stringWithFormat:BRLocalizedString(@"%@ for ATV%@",@"%@ for ATV%@"),[_builtinfraps objectAtIndex:_downloadnumber],_displays,nil]);
	//[newController2 setdownloadTitle:[NSString stringWithFormat:@"%@ for ATV%@",[_builtinfraps objectAtIndex:_downloadnumber],_displays,nil]];
		NSLog(@"%@",[_dlinks objectAtIndex:_downloadnumber]);
	//[newController2 setFileURL:[_dlinks objectAtIndex:_downloadnumber]];
	NSLog(@"%@",[_dlinks objectAtIndex:_downloadnumber]);
	NSLog(@"%@",[NSString stringWithFormat:@"downloading file %d/%d\n URL: \n %@",_downloadnumber+1,[_dlinks count],[_dlinks objectAtIndex:_downloadnumber],nil]);
	//[newController2 setFileText:[NSString stringWithFormat:@"downloading file %d/7\n URL: \n %@",_downloadnumber+1,[_dlinks objectAtIndex:_downloadnumber],nil]];
	NSMutableDictionary *hellotwo =[[NSMutableDictionary alloc] initWithObjectsAndKeys:[_dlinks objectAtIndex:_downloadnumber],@"url",
									[NSString stringWithFormat:BRLocalizedString(@"%@ for ATV%@",@"%@ for ATV%@"),[_builtinfraps objectAtIndex:_downloadnumber],_displays,nil],@"name",
									[NSString stringWithFormat:BRLocalizedString(@"downloading file %d/%d\n URL: \n %@",@"downloading file %d/%d\n URL: \n %@"),_downloadnumber+1,[_dlinks count],[_dlinks objectAtIndex:_downloadnumber],nil],@"downloadtext",nil];
	NSLog(@"hellotwo: %@",hellotwo);
	[newController2 setInformationDict:hellotwo];
				
	//[newController initCustom:[self getChoices:@"http://web.me.com/tomcool420/SoftwareMenu/ATV21.xml"] withName:@"2.whatever"];
	[[self stack] pushController: newController2];
	//}
	
	
}
- (void)wasExhumedByPoppingController:(id)fp8
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
		if([[obje pathExtension] isEqualToString:@"dmg"])
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
	[self patchOSdmg];
	
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
			NSLog(@"file at %@ is OK", path);
			return YES;
			
        }
		
        return NO;
}
-(void)patchOSdmg
{
	
	NSLog(@"patchOS");
	id newController = nil;
	newController =[[SMUpdaterProcess alloc] init];
	NSDictionary *thedict=[[NSDictionary alloc] initWithObjectsAndKeys:_displays,@"displays",_dlinks2,@"dlinks",@"preserve",@"preserve",@"NO",@"now",@"NO",@"original",nil];
	NSLog(@"%@",thedict);
	[newController setUpdateData:thedict];
	[[self stack] pushController: newController];
	
}

- (float)heightForRow:(long)row				{ return 0.0f; }
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}
- (id)itemForRow:(long)row					{ return [_items objectAtIndex:row]; }
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title]; }
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title]; }




@end
