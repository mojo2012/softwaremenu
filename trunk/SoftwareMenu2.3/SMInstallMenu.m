//
//  SoftwareMenu.m
//  QuDownloader
//
//  Created by Thomas on 10/8/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SMInstallMenu.h"
#import "SMDownloadController.h"
#import "SoftwareInstaller.h"
#import "SMInfo.h"
#import "SMGeneralMethods.h"

#define DEBUG_MODE false
static NSString  * bak_vers = nil;
static NSString  * _current_vers= nil;

@implementation SMInstallMenu
-(void)setInformationDictionary:(NSDictionary *)information
{
	_theInformation=[information mutableCopy];
	[_theInformation retain];
}
- (id) previewControlForItem: (long) item
{
	////NSLog(@"%@ %s", self, _cmd);
	NSString *resourcePath = nil;
	NSString *appPng = nil;
	NSArray * theoptions = [_options objectAtIndex:item];
	appPng = [[SMGeneralMethods sharedInstance] getImagePathforDict:[NSDictionary dictionaryWithObjectsAndKeys:[theoptions valueForKey:TYPE_KEY],TYPE_KEY,[theoptions valueForKey:NAME_KEY],NAME_KEY,nil]];

	BRImageAndSyncingPreviewController *obj = [[BRImageAndSyncingPreviewController alloc] init];
	
	
	id sp = [BRImage imageWithPath:appPng];
	
	[obj setImage:sp];
	return (obj);
}

-(id)init{
	//NSLog(@"init");
	if(DEBUG_MODE)
	{
		NSString *thelog = [NSString stringWithContentsOfFile:[NSString  stringWithFormat:@"/Users/frontrow/log.txt"]];
		thelog = [thelog stringByAppendingString:(@"\n")];
		[@"DEBUG MODE ON" writeToFile:@"/Users/frontrow/log.txt" atomically:YES];
		log = [NSFileHandle fileHandleForWritingAtPath:@"/Users/frontrow/Software.log"];
		[log retain];
		[log seekToEndOfFile];
	}
	//[self writeToLog:@"init"];
	return [super init];
}
- (void)dealloc
{
	//[self writeToLog:@"dealloc"];
	//NSLog(@"dealloc");
	[_theInformation release];
	if(DEBUG_MODE)
	{
		[log closeFile];
		[log release];
	}
	
	[super dealloc];  
}

-(id)initCustom;
{
	[[self list] removeDividers];
	NSString *name=[[NSString alloc] initWithString:[_theInformation valueForKey:@"name"]];
	NSString *version=[_theInformation valueForKey:@"version"];
	NSString *thelicense =[[NSString alloc] initWithString:[_theInformation valueForKey:@"license"]];
	//NSLog(@"after allocations");
	[self checkVarious];
	//NSLog(@"after checkvarious");
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: name];
	
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	
	
	//Adding option for Info
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Info",LAYER_TYPE,@"Info",LAYER_NAME,MISC_KEY,TYPE_KEY,@"info",NAME_KEY,nil]];
	id item1 = [[BRTextMenuItemLayer alloc] init];
	[item1 setTitle:@"Info"];
	[_items addObject: item1];
	//NSLog(@"after 1");
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Info",LAYER_TYPE,@"License",LAYER_NAME,MISC_KEY,TYPE_KEY,@"license",NAME_KEY,nil]];
	id item2 = [[BRTextMenuItemLayer alloc] init];
	[item2 setTitle:@"License"];
	if([thelicense isEqualToString:@"No License added"])
	{
		[item2 setRightJustifiedText:@"No License Provided"];
		[item2 setDimmed:YES];
	}
	[_items	addObject:item2];
	
	/*[_options addObject:@"Reboot"];
	id item8 = [[BRTextMenuItemLayer alloc] init];
	[item8 setTitle:@"Restart Finder"];
	[_items addObject:item8];*/
	
	int iii = [_options count];
	
	//NSLog(@"after seperator");
	if(EXISTS==false)
	{
		//download and install plugin
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Download",LAYER_TYPE,@"Install",LAYER_NAME,FRAP_KEY,TYPE_KEY,name,NAME_KEY,nil]];

		id item2 = [BRTextMenuItemLayer networkMenuItem];
		
		[item2 setTitle:@"Install"];
		[item2 setRightJustifiedText:version];
		[_items addObject:item2];
	}
	else
	{
		if (UPTODATE==false)
		{
			
			[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Download",LAYER_TYPE,@"Update",LAYER_NAME,FRAP_KEY,TYPE_KEY,name,NAME_KEY,nil]];
			id item3 = [BRTextMenuItemLayer networkMenuItem];
			[item3 setTitle:@"Update"];
			[item3 setRightJustifiedText:version];
			[_items addObject:item3];
			
		}
		//This means it Exists
		//Offer option to Backup
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Manage",LAYER_TYPE,@"Backup",LAYER_NAME,MISC_KEY,TYPE_KEY,@"backup",NAME_KEY,nil]];
		id item4 = [[BRTextMenuItemLayer alloc] init];
		[item4 setTitle:@"Backup"];
		[item4 setRightJustifiedText:_current_vers];
		[_items addObject:item4];
		if(![name isEqualToString:@"SoftwareMenu"])
		{
			//Offer option to Remove
			[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Manage",LAYER_TYPE,@"Remove",LAYER_NAME,MISC_KEY,TYPE_KEY,@"remove",NAME_KEY,nil]];
			[_options addObject:[NSArray arrayWithObjects:@"Manage",@"Remove",nil]];
			id item5 = [[BRTextMenuItemLayer alloc] init];
			[item5 setTitle:@"Remove"];
			[_items addObject:item5];
		}
	}
	//NSLog(@"before BAK_EXISTS");
	if (BAK_EXISTS)
	{		
		/***********
		 *Restoring from Backup
		 ***********/
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Manage",LAYER_TYPE,@"Restore",LAYER_NAME,MISC_KEY,TYPE_KEY,@"restore",NAME_KEY,nil]];
		id item6 = [BRTextMenuItemLayer menuItem];
		[item6 setTitle:@"Restore"];
		[item6 setRightJustifiedText:bak_vers];
		[_items addObject:item6];
		
		
		/***********
		 *Removing the Backup
		 ***********/
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Manage",LAYER_TYPE,@"RemoveB",LAYER_NAME,MISC_KEY,TYPE_KEY,@"remove",NAME_KEY,nil]];
		id item8 =[BRTextMenuItemLayer menuItem];
		[item8 setTitle:@"Remove Backup"];
		[item8 setRightJustifiedText:bak_vers];
		[_items addObject:item8];
	}
	
	
	//NSLog(@"at end of init");
	id list = [self list];
	[list setDatasource: self];
	//NSLog(@"%@",_current_vers);
	[[self list] addDividerAtIndex:iii withLabel:name];
	return self;
}
-(void)checkVarious
{
	
	//NSLog(@"===== CheckVarious =====");
	
	NSString *frapPath= [[NSString alloc] initWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",[_theInformation valueForKey:@"name"]];
	NSString *bakPath= [[NSString alloc] initWithFormat:@"/Users/frontrow/Documents/Backups/%@.bak/",[_theInformation valueForKey:@"name"]];
	
	NSFileManager *manager = [NSFileManager defaultManager];
	
	if ([manager fileExistsAtPath:frapPath])
	{
		
		
		EXISTS = true;
		NSString * infoPath = [frapPath stringByAppendingString:@"Contents/Info.plist"];
		NSDictionary * info =[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:infoPath]];
		_current_vers =[[NSString alloc]initWithString:[info objectForKey:@"CFBundleVersion"]];
		[_theInformation setObject:_current_vers forKey:@"currentvers"];
		//CFPreferencesSetAppValue(CFSTR("currentvers"), (CFStringRef)[NSString stringWithString:_current_vers],kCFPreferencesCurrentApplication);
		
		//NSLog(@"version: %@ is installed; version %@ is most recent", _current_vers, version);
		
		//if([_current_vers isEqualToString:[_theInformation valueForKey:@"version"]])
		if([_current_vers compare:[_theInformation valueForKey:@"version"]]!=NSOrderedAscending)

		{
			
			
			//NSLog(@"frap is up to date");
			UPTODATE = true;
		}
		else
		{
			//NSLog(@"you are not up to date");
			UPTODATE = false;
		}
		
	}
	else
	{
		EXISTS = false;
		[_theInformation setObject:@"0.0.0 - not installed" forKey:@"currentvers"];
	}
	if([manager fileExistsAtPath:bakPath])
	{
		
		BAK_EXISTS = true;
		NSString *bakInfoPath = [bakPath stringByAppendingString:@"Contents/Info.plist"];
		NSDictionary * info =[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:bakInfoPath]];
		
		bak_vers = [[NSString alloc]initWithString:[info objectForKey:@"CFBundleVersion"]];
		[_theInformation setObject:bak_vers forKey:@"bakvers"];
	}
	else
	{
		BAK_EXISTS = false;
		bak_vers=[[NSString alloc]initWithString:@"0.0 -- not Backed Up"];
		[_theInformation setObject:@"0.0 -- not Backed Up" forKey:@"bakvers"];
	}
}

-(long)defaultIndex
{
	return 0;
}

-(void)itemSelected:(long)fp8
{
	[[SMGeneralMethods sharedInstance] helperFixPerm];
	NSString *thename= [_theInformation valueForKey:@"name"];
	NSString *theOnlineVersion = [_theInformation valueForKey:@"version"];
	NSString *thebackvers = [_theInformation valueForKey:@"bakvers"];
	NSString *thecurrentvers = [_theInformation valueForKey:@"currentvers"];
	NSDictionary * selectedOption = [_options objectAtIndex:fp8];

	if([[selectedOption valueForKey:LAYER_TYPE] isEqualToString:@"Info"])
	{
		
			id infoController=nil;
			infoController=[[SMInfo alloc] init];
		if([[selectedOption valueForKey:LAYER_NAME] isEqualToString:@"Info"])
		{
			[infoController setTheName:[NSString stringWithString:[_theInformation valueForKey:@"name"]]];
			[infoController setDescriptionWithURL:[_theInformation valueForKey:@"description"]];
		}
		else if(![[_theInformation valueForKey:@"license"] isEqualToString:@"No License added"] && [[selectedOption valueForKey:LAYER_NAME] isEqualToString:@"License"])
		{
			
			[infoController setTheName:[NSString stringWithFormat:@"License for %@",[_theInformation valueForKey:@"name"]]];
			[infoController setDescriptionWithURL:[_theInformation valueForKey:@"license"]];
			
		} 
		[infoController setVersions:theOnlineVersion withBak:thebackvers withCurrent:thecurrentvers];
		[[self stack] pushController:infoController];
	}
	

	
	
	
	else if([[selectedOption valueForKey:LAYER_TYPE] isEqualToString:@"Download"])
	{
		
		id downloadController = nil;
		downloadController =[[SMDownloaderInstaller alloc] init];
		if([[selectedOption valueForKey:LAYER_NAME] isEqualToString:@"Install"])
		{
			[_theInformation setObject:@"NO" forKey:@"update"];
		}
		else if ([[selectedOption valueForKey:LAYER_NAME] isEqualToString:@"Update"])
		{
			[_theInformation setObject:@"YES" forKey:@"update"];
		}
		[_theInformation setObject:[_theInformation valueForKey:@"url"] forKey:@"downloadtext"];
		[downloadController setInformationDict:_theInformation];
		[[self stack] pushController: downloadController];
		return;
	}
	
	
	else if([[selectedOption valueForKey:LAYER_TYPE] isEqualToString:@"Manage"])
	{
		
		NSTask *helperTask = [[NSTask alloc] init];
		NSString *helperPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
		[helperTask setLaunchPath:helperPath];
		if([[selectedOption valueForKey:LAYER_NAME] isEqualToString:@"Remove"])
		{
			[helperTask setArguments:[NSArray arrayWithObjects:@"-r", [FRAP_PATH stringByAppendingPathComponent:[thename stringByAppendingString:@".frappliance"]],@"0", nil]];
		}
		else if([[selectedOption valueForKey:LAYER_NAME] isEqualToString:@"RemoveB"])
		{
			[helperTask setArguments:[NSArray arrayWithObjects:@"-r", [BAK_PATH stringByAppendingPathComponent:[thename stringByAppendingString:@".bak"]],@"0", nil]];
		}
		else if([[selectedOption valueForKey:LAYER_NAME] isEqualToString:@"Backup"])
		{
			[helperTask setArguments:[NSArray arrayWithObjects:@"-backup", [thename stringByAppendingString:@".frappliance"],@"0", nil]];
		}
		else if([[selectedOption valueForKey:LAYER_NAME] isEqualToString:@"Restore"])
		{
			[helperTask setArguments:[NSArray arrayWithObjects:@"-restore", [thename stringByAppendingString:@".frappliance"],@"0", nil]];
		}
		[helperTask launch];
		[helperTask waitUntilExit];
		int theTerm =[helperTask terminationStatus];
		[self initCustom];
		return;
	}

	
	
}
/*-(void)willBeBuried
{
	//NSLog(@"willBuried");
	//[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:[[self list] datasource]];
	[super willBeBuried];
}*/



-(void)willBePopped
{
	NSString *thename= [_theInformation valueForKey:@"name"];
	
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithDictionary:nil];
	
	if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/settings.plist" stringByExpandingTildeInPath]])
	{
		NSDictionary *tempdict1 = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/settings.plist" stringByExpandingTildeInPath]];
		[settings addEntriesFromDictionary:tempdict1];
		////NSLog(@"adding from temp dict");
	}
	/*if([[settings objectForKey:@"ARF"] isEqualToString:@"YES"])
	{
		NSMutableDictionary *show_hide = [[NSMutableDictionary alloc] initWithDictionary:nil];
		
		if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/log2.plist" stringByExpandingTildeInPath]])
		{
			NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/log2.plist" stringByExpandingTildeInPath]];
			[show_hide addEntriesFromDictionary:tempdict];
			////NSLog(@"adding from temp dict");
		}
		
		NSString *var = [show_hide objectForKey:thename];
		if([var isEqualToString:@"YES"] && ![[NSFileManager defaultManager] fileExistsAtPath:[[NSString alloc] initWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",thename]])
			[NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments:[NSArray arrayWithObjects:@"/System/Library/CoreServices/Finder.app/Contents/Plugins/SoftwareMenu.frappliance/Contents/Resources/reset.sh",nil]];
		if([var isEqualToString:@"NO"] && [[NSFileManager defaultManager] fileExistsAtPath:[[NSString alloc] initWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",thename]])
			[NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments:[NSArray arrayWithObjects:@"/System/Library/CoreServices/Finder.app/Contents/Plugins/SoftwareMenu.frappliance/Contents/Resources/reset.sh",nil]];
		if([var isEqualToString:@"YES"] && [[show_hide objectForKey:@"Update"] isEqualToString:@"YES"] &&[[NSFileManager defaultManager] fileExistsAtPath:[[NSString alloc] initWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",thename]])
			[NSTask launchedTaskWithLaunchPath:@"/bin/bash" arguments:[NSArray arrayWithObjects:@"/System/Library/CoreServices/Finder.app/Contents/Plugins/SoftwareMenu.frappliance/Contents/Resources/reset.sh",nil]];
	}
	//NSLog(@"willBePopped");
	[[NSNotificationCenter defaultCenter] removeObserver:self name:nil object:[[self list] datasource]];*/
	[super willBePopped];
}


- (void)wasExhumedByPoppingController:(id)fp8
{
	


	[self initCustom];	
}
-(void)wasExhumed
{
	
	
	[self initCustom];	
}

//	Data source methods:

- (float)heightForRow:(long)row				{ return 0.0f; }
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}
- (id)itemForRow:(long)row					{ return [_items objectAtIndex:row]; }
- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title]; }
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title]; }

@end
@implementation SMDownloaderInstaller

-(void) processdownload
{
	[self appendSourceText:@"Installing"];
	NSTask *helperTask = [[NSTask alloc] init];
	NSString *helperPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
	NSFileManager *man = [NSFileManager defaultManager];
	
	if ([[SMGeneralMethods sharedInstance] helperCheckPerm])
	{
		[[SMGeneralMethods sharedInstance] helperFixPerm];
		[self appendSourceText:@"Fixed Permissions"];

	}
	[helperTask setLaunchPath:helperPath];
	if([man fileExistsAtPath:[@"/System/Library/Finder/Contents/Plugins/" stringByAppendingPathComponent:[[_theInformation valueForKey:@"name"] stringByAppendingPathExtension:@"frappliance"]]])
	{
		[helperTask setArguments:[NSArray arrayWithObjects:@"-update", _outputPath,@"0", nil]];
	}
	else
	{
		[helperTask setArguments:[NSArray arrayWithObjects:@"-i", _outputPath,@"0", nil]];
	}
		
	[helperTask launch];
	//int theTerm=[helperTask terminationStatus];
	[helperTask waitUntilExit];
	[helperTask release];
	[self appendSourceText:@"Press Menu When you are done"];



}


@end


