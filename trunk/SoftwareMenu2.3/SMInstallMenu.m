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

@implementation SMInstallMenu
-(void)setInformationDictionary:(NSDictionary *)information
{
	_theInformation=[information mutableCopy];
	[_theInformation retain];
}
- (id) previewControlForItem: (long) item
{
	NSLog(@"preview Control");
	NSString *appPng = nil;
	NSArray * theoptions = [_options objectAtIndex:item];
	SMMedia *meta = [[SMMedia alloc ] init];
	switch([[theoptions valueForKey:LAYER_INT] intValue])
	{
		case kSMInInfo:
			appPng = [[NSBundle bundleForClass:[self class]] pathForResource:@"info" ofType:@"png"];
			[meta setTitle:@"Additional Information"];
			break;
		case kSMInLicense:
			appPng = [[NSBundle bundleForClass:[self class]] pathForResource:@"scriptLicense" ofType:@"png"];
			[meta setTitle:@"License File"];
			//[meta setDescription:@"Read Me"];
			break;
		case kSMInUpdate:
		case kSMInInstall:
			appPng = [SMGeneralMethods getImagePath:[theoptions valueForKey:NAME_KEY]];
			[meta setTitle:[theoptions valueForKey:NAME_KEY]];
			break;
		case kSMInManage:
		case kSMInRemove:
			appPng = [[NSBundle bundleForClass:[self class]] pathForResource:@"trashempty" ofType:@"png"];
			break;
		case kSMInBackup:
			appPng = [[NSBundle bundleForClass:[self class]] pathForResource:@"timemachine" ofType:@"png"];
			break;
			
	} InType;
	[meta setImagePath:appPng];
	if(![_man fileExistsAtPath:appPng])
	{
		[meta setDefaultImage];
	}
	BRMetadataPreviewControl *preview = [[BRMetadataPreviewControl alloc] init];
	[preview setAsset:meta];
	[preview setShowsMetadataImmediately:YES];
	NSLog(@"Preview Control done");
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

	[_options release];
	[_items release];
	[_man release];
	[_theInformation release];
	[super dealloc];  
}

-(id)initCustom;
{
	NSLog(@"1");
	[[self list] removeDividers];
	NSString *name=[[NSString alloc] initWithString:[_theInformation valueForKey:@"name"]];
	NSString *version=[_theInformation valueForKey:@"version"];
	NSString *displayVersion=[_theInformation valueForKey:@"displayVersion"];
	NSString *displayName =[_theInformation valueForKey:@"displayName"];
	NSString *thelicense =[_theInformation valueForKey:@"license"];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: displayName];
	
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	
	////////////////
	//    INFO    //
	////////////////
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Info",LAYER_TYPE,@"Info",LAYER_NAME,[NSNumber numberWithInt:1],LAYER_INT,MISC_KEY,TYPE_KEY,@"info",NAME_KEY,nil]];
	id item1 = [[BRTextMenuItemLayer alloc] init];
	[item1 setTitle:@"Info"];
	[_items addObject: item1];

	////////////////
	//   License  //
	////////////////
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Info",LAYER_TYPE,@"License",LAYER_NAME,[NSNumber numberWithInt:2],LAYER_INT,MISC_KEY,TYPE_KEY,@"license",NAME_KEY,nil]];
	id item2 = [[BRTextMenuItemLayer alloc] init];
	[item2 setTitle:@"License"];
	if([thelicense isEqualToString:@"No License added"])
	{
		[item2 setRightJustifiedText:@"No License Provided"];
		[item2 setDimmed:YES];
	}
	[_items	addObject:item2];

	//// Seperator 1 Index
	int iii = [_options count];
	
	///Does the plugins exist?
	if(![self frapExists])
	{
		////////////////
		//   install  //
		////////////////
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Download",LAYER_TYPE,@"Install",LAYER_NAME,[NSNumber numberWithInt:4],LAYER_INT,FRAP_KEY,TYPE_KEY,name,NAME_KEY,nil]];

		id item2 = [BRTextMenuItemLayer networkMenuItem];
		
		[item2 setTitle:@"Install"];
		[item2 setRightJustifiedText:displayVersion];
		[_items addObject:item2];
	}
	else
	{
		///Is the plugin up to date?
		if (![self frapUpToDate])
		{
			////////////////
			//   Update   //
			////////////////
			[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Download",LAYER_TYPE,@"Update",LAYER_NAME,[NSNumber numberWithInt:5],LAYER_INT,FRAP_KEY,TYPE_KEY,name,NAME_KEY,nil]];
			id item3 = [BRTextMenuItemLayer networkMenuItem];
			[item3 setTitle:@"Update"];
			[item3 setRightJustifiedText:displayVersion];
			[_items addObject:item3];
			
		}
		////////////////
		//   backup   //
		////////////////
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Manage",LAYER_TYPE,@"-backup",LAYER_NAME,[NSNumber numberWithInt:6],LAYER_INT,MISC_KEY,TYPE_KEY,@"backup",NAME_KEY,nil]];
		id item4 = [[BRTextMenuItemLayer alloc] init];
		[item4 setTitle:@"Backup"];
		[item4 setRightJustifiedText:[_theInformation objectForKey:@"installedVersion"]];
		[_items addObject:item4];
		
		//cannot delete SoftwareMenu
		if(![name isEqualToString:@"SoftwareMenu"] && ![name isEqualToString:@"softwaremenu"])
		{
			////////////////
			//   Remove   //
			////////////////
			[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Manage",LAYER_TYPE,@"-r",LAYER_NAME,[NSNumber numberWithInt:7],LAYER_INT,MISC_KEY,TYPE_KEY,@"remove",NAME_KEY,nil]];
			[_options addObject:[NSArray arrayWithObjects:@"Manage",@"Remove",nil]];
			id item5 = [[BRTextMenuItemLayer alloc] init];
			[item5 setTitle:@"Remove"];
			[_items addObject:item5];
		}
	}
	///Does a Backup Exists?
	if ([self bakExists])
	{		
		///////////////////////
		//   Restore Backup  //
		///////////////////////
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Manage",LAYER_TYPE,@"-restore",LAYER_NAME,[NSNumber numberWithInt:6],LAYER_INT,MISC_KEY,TYPE_KEY,@"restore",NAME_KEY,nil]];
		id item6 = [BRTextMenuItemLayer menuItem];
		[item6 setTitle:@"Restore"];
		[item6 setRightJustifiedText:[_theInformation objectForKey:@"backupVersion"]];
		[_items addObject:item6];
		
		
		///////////////////////
		//   Remove Backup   //
		///////////////////////
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Manage",LAYER_TYPE,@"-rb",LAYER_NAME,[NSNumber numberWithInt:7],LAYER_INT,MISC_KEY,TYPE_KEY,@"remove",NAME_KEY,nil]];
		id item8 =[BRTextMenuItemLayer menuItem];
		[item8 setTitle:@"Remove Backup"];
		[item8 setRightJustifiedText:[_theInformation objectForKey:@"backupVersion"]];
		[_items addObject:item8];
	}
	
	
	id list = [self list];
	[list setDatasource: self];
	///Add the Seperator
	[[self list] addDividerAtIndex:iii withLabel:name];
	NSLog(@"4");
	return self;
}
-(void)getVersions
{
	if([self frapExists])
	{
		NSString *infoPath = [[NSString stringWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",[_theInformation valueForKey:@"name"]] stringByAppendingString:@"Contents/Info.plist"];
		NSDictionary * info =[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:infoPath]];
		NSString * current_vers =[NSString stringWithString:[info objectForKey:@"CFBundleVersion"]];
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
	NSDictionary *infoDict = [NSDictionary dictionaryWithContentsOfFile:infoPath];
	NSLog(@"name:%@",[_theInformation objectForKey:@"name"]);
	if(![[_theInformation objectForKey:@"name"] isEqualToString:@"nitoTV"])
	{
		if([[infoDict valueForKey:@"installedVersion"] compare:[_theInformation valueForKey:@"version"]]!=NSOrderedAscending){return (YES);}
	}
	else
	{
		NSLog(@"installed: %@, online %@",[infoDict valueForKey:@"CFBundleShortVersionString"],[_theInformation valueForKey:@"shortVersion"]);
		if([[infoDict valueForKey:@"CFBundleShortVersionString"] compare:[_theInformation valueForKey:@"shortVersion"]]!=NSOrderedAscending){return (YES);}
	}
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
	NSString *update = @"NO";
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
			update =@"YES";
		case kSMInInstall:
			[_theInformation setObject:update forKey:@"update"];
			id downloadController = nil;
			downloadController =[[SMDownloaderInstaller alloc] init];
			[_theInformation setObject:[_theInformation valueForKey:@"url"] forKey:@"downloadtext"];
			[downloadController setInformationDict:_theInformation];
			[[self stack] pushController: downloadController];
			break;
		case kSMInBackup:
		case kSMInRemove:
		case kSMInManage:
			misc=@"!";
			NSArray *taskArray = [NSArray arrayWithObjects:[selectedOption objectForKey:LAYER_NAME],[thename stringByAppendingString:@".frappliance"],@"0",nil];
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


