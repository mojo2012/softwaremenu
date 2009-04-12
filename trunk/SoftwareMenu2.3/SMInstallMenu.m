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
#import "SMMedia.h"

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
	//NSString *resourcePath = nil;
	NSString *appPng = nil;
	NSArray * theoptions = [_options objectAtIndex:item];
	SMMedia *meta = [[SMMedia alloc ] init];
	
	appPng = [[SMGeneralMethods sharedInstance] getImagePathforDict:[NSDictionary dictionaryWithObjectsAndKeys:[theoptions valueForKey:TYPE_KEY],TYPE_KEY,[theoptions valueForKey:NAME_KEY],NAME_KEY,nil]];
	[meta setImagePath:appPng];
	BRMetadataPreviewControl *preview = [[BRMetadataPreviewControl alloc] init];
	[preview setAsset:meta];
	[preview setShowsMetadataImmediately:YES];
	return (preview);
}

-(id)init{
	//NSLog(@"init");
	self=[super init];
	_man = [NSFileManager defaultManager];
	return self;
}
- (void)dealloc
{
	//[self writeToLog:@"dealloc"];
	//NSLog(@"dealloc");
	[_man release];
	[_theInformation release];
	[super dealloc];  
}

-(id)initCustom;
{
	[[self list] removeDividers];
	NSString *name=[[NSString alloc] initWithString:[_theInformation valueForKey:@"name"]];
	NSString *version=[_theInformation valueForKey:@"version"];
	NSString *displayName =[_theInformation valueForKey:@"displayName"];
	NSString *thelicense =[_theInformation valueForKey:@"license"];
	[self checkVarious];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: displayName];
	
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	
	
	//Adding option for Info
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Info",LAYER_TYPE,@"Info",LAYER_NAME,[NSNumber numberWithInt:1],LAYER_INT,MISC_KEY,TYPE_KEY,@"info",NAME_KEY,nil]];
	id item1 = [[BRTextMenuItemLayer alloc] init];
	[item1 setTitle:@"Info"];
	[_items addObject: item1];
	//NSLog(@"after 1");
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Info",LAYER_TYPE,@"License",LAYER_NAME,[NSNumber numberWithInt:2],LAYER_INT,MISC_KEY,TYPE_KEY,@"license",NAME_KEY,nil]];
	id item2 = [[BRTextMenuItemLayer alloc] init];
	[item2 setTitle:@"License"];
	if([thelicense isEqualToString:@"No License added"])
	{
		[item2 setRightJustifiedText:@"No License Provided"];
		[item2 setDimmed:YES];
	}
	[_items	addObject:item2];

	int iii = [_options count];
	
	//NSLog(@"after seperator");
	if(![self frapExists])
	{
		//download and install plugin
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Download",LAYER_TYPE,@"Install",LAYER_NAME,[NSNumber numberWithInt:4],LAYER_INT,FRAP_KEY,TYPE_KEY,name,NAME_KEY,nil]];

		id item2 = [BRTextMenuItemLayer networkMenuItem];
		
		[item2 setTitle:@"Install"];
		[item2 setRightJustifiedText:version];
		[_items addObject:item2];
	}
	else
	{
		if ([self frapUpToDate])
		{
			
			[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Download",LAYER_TYPE,@"Update",LAYER_NAME,[NSNumber numberWithInt:5],LAYER_INT,FRAP_KEY,TYPE_KEY,name,NAME_KEY,nil]];
			id item3 = [BRTextMenuItemLayer networkMenuItem];
			[item3 setTitle:@"Update"];
			[item3 setRightJustifiedText:version];
			[_items addObject:item3];
			
		}
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Manage",LAYER_TYPE,@"-backup",LAYER_NAME,[NSNumber numberWithInt:10],LAYER_INT,MISC_KEY,TYPE_KEY,@"backup",NAME_KEY,nil]];
		id item4 = [[BRTextMenuItemLayer alloc] init];
		[item4 setTitle:@"Backup"];
		[item4 setRightJustifiedText:[_theInformation objectForKey:@"installedVersion"]];
		[_items addObject:item4];
		
		if(![name isEqualToString:@"SoftwareMenu"] && ![name isEqualToString:@"softwaremenu"])
		{
			[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Manage",LAYER_TYPE,@"-r",LAYER_NAME,[NSNumber numberWithInt:10],LAYER_INT,MISC_KEY,TYPE_KEY,@"remove",NAME_KEY,nil]];
			[_options addObject:[NSArray arrayWithObjects:@"Manage",@"Remove",nil]];
			id item5 = [[BRTextMenuItemLayer alloc] init];
			[item5 setTitle:@"Remove"];
			[_items addObject:item5];
		}
	}
	if ([self bakExists])
	{		
		/***********
		 *Restoring from Backup
		 ***********/
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Manage",LAYER_TYPE,@"-restore",LAYER_NAME,[NSNumber numberWithInt:10],LAYER_INT,MISC_KEY,TYPE_KEY,@"restore",NAME_KEY,nil]];
		id item6 = [BRTextMenuItemLayer menuItem];
		[item6 setTitle:@"Restore"];
		[item6 setRightJustifiedText:bak_vers];
		[_items addObject:item6];
		
		
		/***********
		 *Removing the Backup
		 ***********/
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Manage",LAYER_TYPE,@"-rb",LAYER_NAME,[NSNumber numberWithInt:10],LAYER_INT,MISC_KEY,TYPE_KEY,@"remove",NAME_KEY,nil]];
		id item8 =[BRTextMenuItemLayer menuItem];
		[item8 setTitle:@"Remove Backup"];
		[item8 setRightJustifiedText:bak_vers];
		[_items addObject:item8];
	}
	
	
	id list = [self list];
	[list setDatasource: self];
	[[self list] addDividerAtIndex:iii withLabel:name];
	return self;
}
-(void)getVersions
{
	if([self frapExists])
	{
		NSString *frapPath= [NSString stringWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",[_theInformation valueForKey:@"name"]];
		NSString *infoPath = [[NSString stringWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",[_theInformation valueForKey:@"name"]] stringByAppendingString:@"Contents/Info.plist"];
		NSDictionary * info =[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:infoPath]];
		NSString * current_vers =[[NSString alloc] initWithString:[info objectForKey:@"CFBundleVersion"]];
		[_theInformation setObject:current_vers forKey:@"installedVersion"];
	}
	if([self bakExists])
	{
		NSString *bakPath = [NSString stringWithFormat:@"/Users/frontrow/Documents/Backups/%@.bak/",[_theInformation valueForKey:@"name"]];
		NSString *bakInfoPath = [bakPath stringByAppendingString:@"Contents/Info.plist"];
		NSDictionary * info =[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:bakInfoPath]];
		NSString * backup_vers = [[NSString alloc]initWithString:[info objectForKey:@"CFBundleVersion"]];
		[_theInformation setObject:backup_vers forKey:@"backupVersion"];
	}
}

-(BOOL)frapExists
{
	NSString *frapPath= [NSString stringWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",[_theInformation valueForKey:@"name"]];
	if([_man fileExistsAtPath:frapPath]){return (YES);}
	[_theInformation setObject:@"0.0.0 - not installed" forKey:@"installedVersion"];
	return(NO);
}

-(BOOL)bakExists
{
	NSString *bakPath = [NSString stringWithFormat:@"/Users/frontrow/Documents/Backups/%@.bak/",[_theInformation valueForKey:@"name"]];
	if([_man fileExistsAtPath:bakPath]){return (YES);}
	[_theInformation setObject:@"0.0 - not Backed up" forKey:@"backupVersion"];
	return(NO);
}

-(BOOL)frapUpToDate
{
	NSString *frapPath= [NSString stringWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",[_theInformation valueForKey:@"name"]];
	NSString * infoPath = [frapPath stringByAppendingString:@"Contents/Info.plist"];
	if([[_theInformation valueForKey:@"installedVersion"] compare:[_theInformation valueForKey:@"version"]]!=NSOrderedAscending){return (YES);}
	return (NO);
}


-(long)defaultIndex
{
	return 0;
}

-(void)itemSelected:(long)row
{
	[[SMGeneralMethods sharedInstance] helperFixPerm];
	NSString *thename= [_theInformation valueForKey:@"name"];
	NSString *theOnlineVersion = [_theInformation valueForKey:@"version"];
	NSString *thebackvers = [_theInformation valueForKey:@"bakvers"];
	NSString *thecurrentvers = [_theInformation valueForKey:@"currentvers"];
	NSDictionary * selectedOption = [_options objectAtIndex:row];
	NSString *misc = nil;
	id infoController=nil;
	switch ([[selectedOption objectForKey:LAYER_INT] intValue]) 
	{
		case kSMInInfo:
			misc=@"!";
			infoController=[[SMInfo alloc] init];
			[infoController setTheName:[_theInformation valueForKey:@"name"]];
			[infoController setDescriptionWithURL:[_theInformation valueForKey:@"description"]];
			[infoController setVersions:theOnlineVersion withBak:thebackvers withCurrent:thecurrentvers];
			[[self stack] pushController:infoController];
			break;
		case kSMInLicense:
			misc=@"!";
			infoController=[[SMInfo alloc] init];
			[infoController setTheName:[NSString stringWithFormat:@"License for %@",[_theInformation valueForKey:@"name"]]];
			[infoController setDescriptionWithURL:[_theInformation valueForKey:@"license"]];
			[infoController setVersions:theOnlineVersion withBak:thebackvers withCurrent:thecurrentvers];
			[[self stack] pushController:infoController];
			break;
		case kSMInUpdate:
		case kSMInInstall:
			if([[selectedOption valueForKey:LAYER_NAME] isEqualToString:@"Install"])		{[_theInformation setObject:@"NO" forKey:@"update"];}
			else if ([[selectedOption valueForKey:LAYER_NAME] isEqualToString:@"Update"])	{[_theInformation setObject:@"YES" forKey:@"update"];}
			id downloadController = nil;
			downloadController =[[SMDownloaderInstaller alloc] init];
			[_theInformation setObject:[_theInformation valueForKey:@"url"] forKey:@"downloadtext"];
			[downloadController setInformationDict:_theInformation];
			[[self stack] pushController: downloadController];
			break;
		case kSMInManage:
			misc=@"!";
			NSArray *taskArray = [NSArray arrayWithObjects:[selectedOption objectForKey:LAYER_NAME],[thename stringByAppendingString:@".frappliance"],@"0"];
			[SMGeneralMethods runHelperApp:taskArray];
			[self initCustom];
			break;

	} InType;
	return;
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


- (void)wasExhumedByPoppingController:(id)row
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


