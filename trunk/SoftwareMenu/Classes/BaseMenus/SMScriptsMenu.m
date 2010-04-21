//
//  SoftwareScriptsMenu.m
//  QuDownloader
//
//  Created by Thomas on 10/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SMScriptsMenu.h"

@implementation SMScriptsMenu
- (id) previewControlForItem: (long) row
{
	if(row >=[_items count])
		return nil;
	NSDictionary * theoptions = [_options objectAtIndex:row];
	NSString *theoption =[theoptions valueForKey:LAYER_NAME];
	NSLog(@"1: %@",theoption);
	
	//NSLog(@"%@",theoption);
	SMFBaseAsset	*meta = [[SMFBaseAsset alloc] init];
	[meta setTitle:theoption];
	switch([[theoptions valueForKey:LAYER_TYPE] intValue])
	{
		case 0:
			[meta setCoverArt:[[SMThemeInfo sharedTheme] infoImage]];
			break;
		case 1:
			[meta setCoverArt:[[SMThemeInfo sharedTheme] refreshImage]];
			break;
		case 2:
			[meta setCoverArt:[[SMThemeInfo sharedTheme] standbyImage]];
			break;
		case 4:
			[meta setCoverArt:[[SMThemeInfo sharedTheme] scriptImage]];
			NSString *launchPath = [SCRIPTS_FOLDER stringByAppendingPathComponent:theoption];
			NSString *script=[NSString stringWithContentsOfFile:launchPath];
			NSArray *splitscript = [script componentsSeparatedByString:@"\n"];
			NSString *info = [splitscript objectAtIndex:1];
			if([info hasPrefix:@"#SM:"])
			{
				[meta setSummary:[info substringFromIndex:4]];
			}
			

			break;
		default:
            break;
			//[meta setDefaultImage];
	}


	SMFMediaPreview *preview = [[SMFMediaPreview alloc] init];
	[preview setShowsMetadataImmediately:YES];
	//[preview setDeletterboxAssetArtwork:YES];
	
	
	[preview setAsset:meta];
	[meta release];
	return [preview autorelease];
}
-(id)init{
	self = [super init];
	[[self list] removeDividers];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: BRLocalizedString(@"Scripts",@"Scripts")];
	[self setListIcon:[[SMThemeInfo sharedTheme] scriptImage] horizontalOffset:0.5f kerningFactor:0.2f];
	_items = [[NSMutableArray alloc] init];
	_options = [[NSMutableArray alloc] init];
	_runoption = [[NSMutableDictionary alloc] init];
    [self initCustom];
	return self;
}
- (void)dealloc
{
	[super dealloc];  
}
+(NSArray *)scripts
{
    NSMutableArray *scripts=[[NSMutableArray alloc]init];
    NSFileManager *fileManager = [NSFileManager defaultManager];
	long i, count = [[fileManager directoryContentsAtPath:SCRIPTS_FOLDER] count];
	//NSLog(@"_runoption 2: %@",_runoption);
	for ( i = 0; i < count; i++ )
	{
        
		NSString *idStr = [[fileManager directoryContentsAtPath:SCRIPTS_FOLDER] objectAtIndex:i];
		if([[idStr pathExtension] isEqualToString:@"sh"])
            [scripts addObject:idStr];
        if([[idStr pathExtension] isEqualToString:@"py"])
            [scripts addObject:idStr];
    }
    return scripts;
            
}
+(void)runScript:(NSString *)path displayResult:(BOOL)display asRoot:(BOOL)root
{
    if (!root) {
        [SMScriptsMenu runScript:path displayResult:display];
    }
    else {
        NSString *str = [[SMHelper helperManager]runScriptWithReturn:path];
        NSString *the_text = [[[[@"Script Path:   " stringByAppendingString:path] 
                                stringByAppendingString:@"\n\n\n"] 
                               stringByAppendingString:@"Result:\n"] 
                              stringByAppendingString:str];
        
        BRScrollingTextControl *textControls = [[BRScrollingTextControl alloc] init];
        [textControls setTitle:[path lastPathComponent]];
        [textControls setText:the_text];
        BRController *theController =  [BRController controllerWithContentControl:textControls];
        [textControls release];
        [[[BRApplicationStackManager singleton] stack] pushController:theController];
    }

}
+(void)runScript:(NSString *)path displayResult:(BOOL)display
{
    if (!display) 
    {
        [NSTask launchedTaskWithLaunchPath:@"/bin/bash/" arguments:[NSArray arrayWithObject:path]];
    }
    else
    {
        NSTask *task = [[NSTask alloc] init];
        NSArray *args = [NSArray arrayWithObjects:path,nil];
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
        NSString *the_text = [[[[@"Script Path:   " stringByAppendingString:path] stringByAppendingString:@"\n\n\n"] stringByAppendingString:@"Result:\n"] stringByAppendingString:string];
        BRScrollingTextControl *textControls = [[BRScrollingTextControl alloc] init];
        [textControls setTitle:[path lastPathComponent]];
        [textControls setText:the_text];
        BRController *theController =  [BRController controllerWithContentControl:textControls];
        [[[BRApplicationStackManager singleton] stack] pushController:theController];
        
        //Releasing Alloc'ed objects
        [outPipe release];
        [task release];
        [string release];
        [textControls release];
        
    }

}
-(id)initCustom
{
	[_items		removeAllObjects];
	[_options	removeAllObjects];
	[_runoption removeAllObjects];
	
	
	if([[NSFileManager defaultManager] fileExistsAtPath:SCRIPTS_PREFS])
	{
		NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:SCRIPTS_PREFS];
		NSArray *hello = [tempdict allKeys];
		if([hello count]!=0 && [hello containsObject:@"BoolFormat1"])
		{
			//NSLog(@"should work %@ %@",[onBoot className],[NSString class],nil);
			[_runoption addEntriesFromDictionary:tempdict];
			[_runoption removeObjectForKey:@"BoolFormat1"];
		}
	}
	[_runoption setObject:[NSNumber numberWithBool:YES] forKey:@"BoolFormat1"];
	//NSLog(@"_runoption 1: %@",_runoption);
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithInt:0],LAYER_TYPE,
						 @"Info",LAYER_NAME,
						 nil]];
	id item99 = [[BRTextMenuItemLayer alloc] init];
	[item99 setTitle:BRLocalizedString(@"Info",@"Info")];
	[_items addObject:item99];
	
	
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
						 [NSNumber numberWithInt:1],LAYER_TYPE,
						 @"Refresh",LAYER_NAME,
						 nil]];
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
		NSString *thename =[obje valueForKey:@"name"];
		NSDictionary *option = [NSDictionary dictionaryWithObjectsAndKeys:
						   [NSNumber numberWithInt:2],LAYER_TYPE,
						   thename,LAYER_NAME,
						   nil];
		[_options addObject:option];
		id item = [[BRTextMenuItemLayer alloc] init];
		[item setTitle:[obje valueForKey:@"name"]];
		[_items addObject:item];
	}
	int nonBuiltinLoc = [_items count];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	long i, count = [[fileManager directoryContentsAtPath:SCRIPTS_FOLDER] count];
	//NSLog(@"_runoption 2: %@",_runoption);
	for ( i = 0; i < count; i++ )
	{

		NSString *idStr = [[fileManager directoryContentsAtPath:SCRIPTS_FOLDER] objectAtIndex:i];
		if([[idStr pathExtension] isEqualToString:@"sh"])
		{
			
			/************
			 *checking to see how the script should run
			 ************/
			[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithInt:4],LAYER_TYPE,
								 idStr,LAYER_NAME,
								 nil]];
			id item1 = [[BRTextMenuItemLayer alloc] init];
			[item1 setTitle:idStr];
			if([[[_runoption valueForKey:idStr]valueForKey:@"runoption"] isEqualToString:@"FaF"])
			{
				//NSLog(@"idStr: %@ FAF",idStr);
				[item1 setRightJustifiedText:@"FaF"];
			}
			else if([[[_runoption valueForKey:idStr]valueForKey:@"runoption"] isEqualToString:@"FaW"])
			{
				//NSLog(@"idStr: %@ FAW",idStr);
				[item1 setRightJustifiedText:@"FaW"];
			}
			else
			{
				//NSLog(@"idStr: %@ NEITHER",idStr);
				NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
				[tempDict addEntriesFromDictionary:[_runoption valueForKey:idStr]];
				[tempDict setValue:@"FAF" forKey:@"runoption"];
				[_runoption setObject:tempDict forKey:idStr];
				[tempDict release];
				[item1 setRightJustifiedText:@"FaF"];
			}
			//NSLog(@"_runoption 3.4 : %@",_runoption);
			/************
			*checking to see if the script should show on boot
			************/
			if([[[_runoption valueForKey:idStr] valueForKey:@"onBoot"] boolValue])
			{
				[item1 setLeftIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[BRThemeInfo sharedTheme] selectedSettingImage], @"BRMenuIconImageKey",nil]];
			}
			else if([[[_runoption valueForKey:idStr]valueForKey:@"onBoot"] boolValue])
			{
			}
			else
			{
				NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
				[tempDict addEntriesFromDictionary:[_runoption valueForKey:idStr]];
				[tempDict setValue:[NSNumber numberWithBool:NO] forKey:@"onBoot"];
				[_runoption setObject:tempDict forKey:idStr];
				
			}
			[_items addObject:item1];
		}
	}
	//NSLog(@"_runoption 3: %@",_runoption);
	[_runoption writeToFile:SCRIPTS_PREFS atomically:YES];
	
	id list = [self list];
	[list setDatasource: self];
	[[self list] addDividerAtIndex:nonBuiltinLoc withLabel:BRLocalizedString(@"Scripts Folder",@"Scripts Folder")];
	[[self list] addDividerAtIndex:builtinLoc withLabel:BRLocalizedString(@"Builtin Scripts",@"Builtin Folder")];
	return self;
}
- (BOOL)brEventAction:(BREvent *)event
{
	int remoteAction =[event remoteAction];
	
	if ([(BRControllerStack *)[self stack] peekController] != self)
	{
		NSLog(@"not SMMenu");
		return [super brEventAction:event];
	}
	
	if([event value] == 0)
		return [super brEventAction:event];
	
	if(![[SMGeneralMethods sharedInstance] usingTakeTwoDotThree] && remoteAction>1)
		remoteAction ++;
	long row = [self getSelection];
	
	
	//int itemCount = [[(BRListControl *)[self list] datasource] itemCount];
	
	//NSLog(@"hashval =%i",hashVal);
	switch (remoteAction)
	{
		case kSMRemoteLeft:  // tap left
			NSLog(@"tap left");
			//NSLog(@"selection :%d",selitem);
				if(row > (long)2);
				{
					NSLog(@">2");
					NSArray * selectedOption = [_options objectAtIndex:row];
					NSString *temptype = [selectedOption valueForKey:LAYER_TYPE];
					//NSLog(@"temtype: %@",temptype);
					if([temptype intValue] == 4)
					{
						
						NSLog(@"type =3");
						NSString *temptitle = [selectedOption valueForKey:LAYER_NAME];
						NSMutableDictionary *tempdict =[[NSMutableDictionary alloc] initWithDictionary:[_runoption valueForKey:temptitle]];
						NSNumber *tempoption = [tempdict valueForKey:@"onBoot"];
						NSLog(@"tempDict: %@",tempdict);
						if([tempoption boolValue])	{tempoption = [NSNumber numberWithBool:NO];}
						else						{tempoption =[NSNumber numberWithBool:YES];}
						[tempdict setValue:tempoption forKey:@"onBoot"];
						[_runoption setValue:tempdict forKey:temptitle];
						[_runoption writeToFile:SCRIPTS_PREFS atomically:YES];
						NSLog(@"_runoption: %@",_runoption);
						[self initCustom];
					}
				
			}
		
			
			break;
		case kSMRemoteRight:  // tap right
			//NSLog(@"type right");
			//[self setSelectedItem:1];
			row = 0;
			
			row = [self getSelection];
			//NSLog(@"selection :%d",selitem);
				if(row > (long)2);
				{
					NSArray * selectedOption = [_options objectAtIndex:row];
					//NSLog(@"selected option %@",selectedOption);
					NSString *temptype = [selectedOption valueForKey:LAYER_TYPE];
					//NSLog(@"temtype: %@",temptype);
					if([temptype intValue] == 4)
					{
						
						
						NSString *temptitle = [selectedOption valueForKey:LAYER_NAME];
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
						NSLog(@"_runoption: %@",_runoption);
						[_runoption writeToFile:SCRIPTS_PREFS atomically:YES];
						[self initCustom];
					}
					
				
			}
			break;
	}
	return [super brEventAction:event];
}

-(void)itemSelected:(long)fp8
{
	if([[_items objectAtIndex:fp8]dimmed])
		return;
	BOOL isDir;
	NSArray *option = [_options objectAtIndex:fp8];
	switch([[option valueForKey:LAYER_TYPE] intValue])
	{
		case 0:
			isDir = NO;
			NSString *downloadedDescription = @"This is basically the same as the scripts menu from iscripts. It does have a couple of differences:\npressing the right arrow key on a scripts will change the mode for that script from FaF (Fire and Forget) to FaW (Fire and Wait)\"\nPressing the Left arrow key enables the script to show in the main softwareMenu categories\n (for scripts you run a lot)";
			id newController=[[SMInfo alloc] init];
			[newController setDescription:downloadedDescription];
			[newController setTheName:@"SoftwareMenu Scripts"];
			[newController setTheImage:[[SMThemeInfo sharedTheme] scriptImage]];
			[[self stack] pushController:newController];
			break;
		case 1:
			[self initCustom];
			break;
		case 2:
			[NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments:[NSArray arrayWithObject:[[NSBundle bundleForClass:[self class]] pathForResource:@"Reboot" ofType:@"sh"]]];
			break;
		case 4:
			isDir = NO;
			NSString *thename = [option	valueForKey:LAYER_NAME];
			NSString *runtype = [[_runoption valueForKey:thename] valueForKey:@"runoption"];
			if([runtype isEqualToString:@"FaF"])
			{
				NSString *launchPath = [SCRIPTS_FOLDER stringByAppendingPathComponent:thename];
				NSLog(@"launchPath: %@",launchPath);
				[NSTask launchedTaskWithLaunchPath:@"/bin/bash/" arguments:[NSArray arrayWithObject:launchPath]];
			}
			else if ([runtype isEqualToString:@"FaW"])
			{
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
			}
	}
}



//	Data source methods:





@end
