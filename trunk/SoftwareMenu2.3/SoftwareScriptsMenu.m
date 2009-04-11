//
//  SoftwareScriptsMenu.m
//  QuDownloader
//
//  Created by Thomas on 10/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SoftwareScriptsMenu.h"
#import "SMGeneralMethods.h"
#import "SMMedia.h"

@implementation SoftwareScriptsMenu
-(BOOL)usingTakeTwoDotThree
{
	if([(Class)NSClassFromString(@"BRController") instancesRespondToSelector:@selector(wasExhumed)])
	{
		return YES;
	}
	else
	{
		return NO;
	}
			
}
- (id) previewControlForItem: (long) item
{
	////NSLog(@"%@ %s", self, _cmd);
	NSString *resourcePath = nil;
	NSString *appPng = nil;
	NSArray * theoptions = [_options objectAtIndex:item];
	NSString *theoption =[theoptions objectAtIndex:0];
	if([theoption isEqualToString:@"base"] || [theoption isEqualToString:@"docs"] || [theoption isEqualToString:@"builtin"])
	{
		theoption =[theoptions objectAtIndex:1];
	}
	
	//NSLog(@"%@",theoption);
	SMMedia	*meta = [[SMMedia alloc] init];
	[meta setTitle:theoption];
			resourcePath = @"script";
			appPng = [[NSBundle bundleForClass:[self class]] pathForResource:resourcePath ofType:@"png"];

	if([theoption isEqualToString:@"Info"])
	{
		resourcePath = @"info";
		appPng = [[NSBundle bundleForClass:[self class]] pathForResource:resourcePath ofType:@"png"];
	}
	else if([theoption isEqualToString:@"Reboot"])
	{
		resourcePath = @"standby";
		appPng = [[NSBundle bundleForClass:[self class]] pathForResource:resourcePath ofType:@"png"];
	}
	else if([theoption isEqualToString:@"Refresh"])
	{
		resourcePath = @"refresh";
		appPng = [[NSBundle bundleForClass:[self class]] pathForResource:resourcePath ofType:@"png"];
	}
	else if([theoption isEqualToString:@"KillFinder"])
	{
		resourcePath = @"standby";
		appPng = [[NSBundle bundleForClass:[self class]] pathForResource:resourcePath ofType:@"png"];
	}
	//NSLog(@"%@", appPng);
	[meta setImagePath:appPng];
	if([[theoptions objectAtIndex:0]isEqualToString:@"docs"] || [[theoptions objectAtIndex:0]isEqualToString:@"builtin"])
	{
		NSString *launchPath = [@"/Users/frontrow/Documents/Scripts/" stringByAppendingString:theoption];
		NSString *script=[[NSString alloc] initWithContentsOfFile:launchPath];
		NSArray *splitscript = [script componentsSeparatedByString:@"\n"];
		NSString *info = [splitscript objectAtIndex:1];
		if([info hasPrefix:@"#SM:"])
		{
			[meta setDescription:[info substringFromIndex:4]];
		}
	}
	BRMetadataPreviewControl *obj = [[BRMetadataPreviewControl alloc] init];
	[obj setShowsMetadataImmediately:YES];
	
	
	
	[obj setAsset:meta];
	return (obj);
}
-(id)init{
	//NSLog(@"init");
	[[SMGeneralMethods sharedInstance] helperFixPerm];
	return [super init];
}
- (void)dealloc
{
	[super dealloc];  
}

-(id)initWithIdentifier:(NSString *)initId
{
	[[self list] removeDividers];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: BRLocalizedString(@"Scripts",@"Scripts")];
	NSString *scriptPNG = [[NSBundle bundleForClass:[self class]] pathForResource:@"script" ofType:@"png"];
	id folderImage = [BRImage imageWithPath:scriptPNG];
	[self setListIcon:folderImage horizontalOffset:0.5f kerningFactor:0.2f];
	
	_runoption = [[NSMutableDictionary alloc] initWithDictionary:nil];
	if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/scriptsprefs.plist" stringByExpandingTildeInPath]])
	{
		NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/scriptsprefs.plist" stringByExpandingTildeInPath]];
		[_runoption addEntriesFromDictionary:tempdict];
		//NSLog(@"adding from temp dict");
	}
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	
	
	 if (![[SMGeneralMethods sharedInstance] helperCheckPerm])
	 {
		 [_options addObject:[NSArray arrayWithObject:@"FixPerm"]];
		 id item98 = [[BRTextMenuItemLayer alloc] init];
		 [item98 setTitle:BRLocalizedString(@"FixPerm",@"FixPerm")];
		 [_items addObject:item98];
	 }
	
	[_options addObject:[NSArray arrayWithObject:@"Info"]];
	id item99 = [[BRTextMenuItemLayer alloc] init];
	[item99 setTitle:BRLocalizedString(@"Info",@"Info")];
	[_items addObject:item99];
	
	[_options addObject:[NSArray arrayWithObject:@"Refresh"]];
	id item0 = [[BRTextMenuItemLayer alloc] init];
	[item0 setTitle:BRLocalizedString(@"Refresh",@"Refresh")];
	[_items addObject:item0];
	
	
	
	int builtinLoc = [_items count];
	//Let's go throught the Builtin Scripts ... as usual
	NSArray *loginItemDictToo = [NSArray arrayWithContentsOfFile:[NSString  stringWithFormat:[[NSBundle bundleForClass:[self class]] pathForResource:@"Scripts" ofType:@"plist"]]];
	NSEnumerator *enumeratorToo = [loginItemDictToo objectEnumerator];
	id obje;
	while((obje = [enumeratorToo nextObject]) != nil) 
	{
		NSString *base = @"builtin";
		NSString *thename =[obje valueForKey:@"name"];
		NSArray *option = [[NSArray alloc] initWithObjects:base,thename,nil];
		[_options addObject:option];
		id item = [[BRTextMenuItemLayer alloc] init];
		[item setTitle:[obje valueForKey:@"name"]];
		[_items addObject:item];
	}
	int nonBuiltinLoc = [_items count];
	//Now let's go through the Non Builtin Scripts ... Located in ~/Documents/Scripts/ -- Shamelessly taken from Emulators Plugin
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *thepath = @"/Users/frontrow/Documents/Scripts/";
	long i, count = [[fileManager directoryContentsAtPath:thepath] count];	
	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [[fileManager directoryContentsAtPath:thepath] objectAtIndex:i];
		//NSLog(@"%@",idStr);
		if([[idStr pathExtension] isEqualToString:@"sh"])
		{
			
			NSString *base = @"docs";
			/************
			 *checking to see how the script should run
			 ************/
			[_options addObject:[[NSArray alloc] initWithObjects:base,idStr,nil]];
			id item1 = [[BRTextMenuItemLayer alloc] init];
			[item1 setTitle:idStr];
			if([[[_runoption valueForKey:idStr]valueForKey:@"runoption"] isEqualToString:@"FaF"])
			{
				//NSLog(@"already equal to FaF");
				[item1 setRightJustifiedText:@"FaF"];
			}
			else if([[[_runoption valueForKey:idStr]valueForKey:@"runoption"] isEqualToString:@"FaW"])
			{
				[item1 setRightJustifiedText:@"FaW"];
				//NSLog(@"FaW");
			}
			else
			{
				[_runoption setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"FaF",@"runoption",nil] forKey:idStr];
				[item1 setRightJustifiedText:@"FaF"];
			}
			
			/************
			*checking to see if the script should show on boot
			************/
			if([[[_runoption valueForKey:idStr]valueForKey:@"onBoot"] isEqualToString:@"YES"])
			{
				[item1 setLeftIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[BRThemeInfo sharedTheme] selectedSettingImage], @"BRMenuIconImageKey",nil]];
			}
			else if([[[_runoption valueForKey:idStr]valueForKey:@"onBoot"] isEqualToString:@"NO"])
			{
			}
			else
			{
				[_runoption setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"NO",@"onBoot",nil] forKey:idStr];
				
			}
			[_items addObject:item1];
		}
	}
	[_runoption writeToFile:@"Users/frontrow/Library/Application Support/SoftwareMenu/scriptsprefs.plist" atomically:YES];
	
	id list = [self list];
	[list setDatasource: self];
	[[self list] addDividerAtIndex:nonBuiltinLoc withLabel:BRLocalizedString(@"Scripts Folder",@"Scripts Folder")];
	[[self list] addDividerAtIndex:builtinLoc withLabel:BRLocalizedString(@"Builtin Scripts",@"Builtin Folder")];
	return self;
}
-(BOOL)checkExists:(NSString *)thename	
{
	NSString *frapPath= [[NSString alloc] initWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",thename];
	NSFileManager *manager = [NSFileManager defaultManager];
	if ([manager fileExistsAtPath:frapPath])
	{
		return YES;
	}
	else
	{
		return NO;
	}
}
static NSDate *lastFilterChangeDate = nil;
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
			//NSLog(@"type up");
			break;
		case 65677:  // tap down
			//NSLog(@"type down");
			break;
		case 65675:  // tap left
			//NSLog(@"type left");
			selitem = 0;
			
			selitem = [self getSelection];
			//NSLog(@"selection :%d",selitem);
			if(![self usingTakeTwoDotThree] || lastFilterChangeDate == nil || [lastFilterChangeDate timeIntervalSinceNow] < -0.4f)
			{
				[lastFilterChangeDate release];
				lastFilterChangeDate = [[NSDate date] retain];
				if(selitem >> (long)2);
				{
					NSArray * selectedOption = [_options objectAtIndex:selitem];
					//NSLog(@"selected option %@",selectedOption);
					NSString *temptype = [selectedOption objectAtIndex:0];
					//NSLog(@"temtype: %@",temptype);
					if([temptype isEqualToString:@"docs"])
					{
						
						
						NSString *temptitle = [selectedOption objectAtIndex:1];
						NSMutableDictionary *tempdict =[[NSMutableDictionary alloc] initWithDictionary:[_runoption valueForKey:temptitle]];
						NSString *tempoption = [tempdict valueForKey:@"onBoot"];
						if([tempoption isEqualToString:@"YES"])
						{
							tempoption = @"NO";
						}
						else
						{
							tempoption = @"YES";
						}
						//NSLog(@"HELLO: %@",tempoption);
						//NSLog(@"%ld",selitem);
						[tempdict setValue:tempoption forKey:@"onBoot"];
						[_runoption setValue:tempdict forKey:temptitle];
						[_runoption writeToFile:@"Users/frontrow/Library/Application Support/SoftwareMenu/scriptsprefs.plist" atomically:NO];
						[self initWithIdentifier:@"101"];
					}
				}
			}
		
			
			break;
		case 65674:  // tap right
			//NSLog(@"type right");
			//[self setSelectedItem:1];
			selitem = 0;
			
			selitem = [self getSelection];
			//NSLog(@"selection :%d",selitem);
			if(![self usingTakeTwoDotThree] || lastFilterChangeDate == nil || [lastFilterChangeDate timeIntervalSinceNow] < -0.4f)
			{
				[lastFilterChangeDate release];
				lastFilterChangeDate = [[NSDate date] retain];
				if(selitem >> (long)2);
				{
					NSArray * selectedOption = [_options objectAtIndex:selitem];
					//NSLog(@"selected option %@",selectedOption);
					NSString *temptype = [selectedOption objectAtIndex:0];
					//NSLog(@"temtype: %@",temptype);
					if([temptype isEqualToString:@"docs"])
					{
						
						
						NSString *temptitle = [selectedOption objectAtIndex:1];
						NSMutableDictionary *tempdict =[[NSMutableDictionary alloc] initWithDictionary:[_runoption valueForKey:temptitle]];
						NSString *tempoption = [tempdict valueForKey:@"runoption"];
						if([tempoption isEqualToString:@"FaF"])
						{
							tempoption = @"FaW";
						}
						else
						{
							tempoption = @"FaF";
						}
						//NSLog(@"HELLO: %@",tempoption);
						//NSLog(@"%ld",selitem);
						[tempdict setValue:tempoption forKey:@"runoption"];
						[_runoption setValue:tempdict forKey:temptitle];
						[_runoption writeToFile:@"Users/frontrow/Library/Application Support/SoftwareMenu/scriptsprefs.plist" atomically:YES];
						[self initWithIdentifier:@"101"];
					}
					
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
-(void)itemSelected:(long)fp8
{
	
	NSArray *option = [_options objectAtIndex:fp8];
	NSString *base = (NSString *)[option objectAtIndex:0];
	if ([[option objectAtIndex:0] isEqualToString:@"Refresh"])
	{
		//NSLog(@"refreshing ....");
		[self initWithIdentifier:@"101"];
	}
		else if([[option objectAtIndex:0] isEqualToString:@"FixPerm"])
	{
		[NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments:[NSArray arrayWithObject:[[NSBundle bundleForClass:[self class]] pathForResource:@"FixPerm" ofType:@"sh"]]];
	}
	else if([[option objectAtIndex:0] isEqualToString:@"Info"])
	{
		BRAlertController *alert = [BRAlertController alertOfType:0
														   titled:@"SoftwareMenu Scripts"
													  primaryText:@"This is basically the same as the scripts menu from iscripts. It does have a couple of differences:"
													secondaryText:@"pressing the right arrow key on a scripts will change the mode for that script from FaF (Fire and Forget) to FaW (Fire and Wait)"/*\nPressing the Left arrow key enables the script to show in the main softwareMenu categories\n (for scripts you run a lot)"*/];
		[[self stack] pushController:alert];
	}
	else
	{
		
		//NSLog(@"base is: %@",base);
		NSString *thename = (NSString *)[option objectAtIndex:1];
		//NSLog(@"thename is: %@",thename);
		//NSLog(@"===== scripts itemselected =====");
		if ([base isEqualToString:@"builtin"])
		{
			//NSLog(@"builtin");
			NSString *builtinlaunchpath = [[NSBundle bundleForClass:[self class]] pathForResource:@"Reboot" ofType:@"sh"];
			//NSLog(@"%@",builtinlaunchpath);
			[NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments:[NSArray arrayWithObject:[[NSBundle bundleForClass:[self class]] pathForResource:@"Reboot" ofType:@"sh"]]];
		}
		else if ([base isEqualToString:@"docs"])
		{
			NSString *runtype = [[_runoption valueForKey:thename] valueForKey:@"runoption"];
			//NSLog(@"%@",runtype);
			/*NSString *launchPath = [@"/Users/frontrow/Documents/Scripts/" stringByAppendingString:thename];
			//NSLog(@"launchPath: %@",launchPath);
			[NSTask launchedTaskWithLaunchPath:launchPath arguments:nil];*/
			if([runtype isEqualToString:@"FaF"])
			{
				NSString *launchPath = [@"/Users/frontrow/Documents/Scripts/" stringByAppendingString:thename];
				//NSLog(@"launchPath: %@",launchPath);
				[NSTask launchedTaskWithLaunchPath:@"/bin/bash/" arguments:[NSArray arrayWithObject:launchPath]];
				
			}
			else
			{
				
				
				//[self refreshControllerForModelUpdate];
				NSString *launchPath = [@"/Users/frontrow/Documents/Scripts/" stringByAppendingString:thename];
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
				[textControls setTitle:thename];
				[textControls setText:the_text];
				BRController *theController =  [BRController controllerWithContentControl:textControls];
				[[self stack] pushController:theController];
				
				/*BRAlertController *alert = [BRAlertController alertOfType:0
																   titled:thename
															  primaryText:string
															secondaryText:launchPath];
				[[self stack] pushController:alert];*/
			}
		}
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

//	Data source methods:

- (float)heightForRow:(long)row				{ return 0.0f; }
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}
- (id)itemForRow:(long)row					{ return [_items objectAtIndex:row]; }
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title]; }
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title]; }



@end
