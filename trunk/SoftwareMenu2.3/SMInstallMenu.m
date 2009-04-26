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
#import "SMMediaPreview.h"

#define DEBUG_MODE false
static NSString  * bak_vers = nil;

@implementation SMInstallMenu
-(void)setInformationDictionary:(NSDictionary *)information
{
	[_theInformation release];
	_theInformation=[information mutableCopy];
	[self setListTitle:[_theInformation valueForKey:@"displayName"]];
	[_theInformation retain];
}
- (id) previewControlForItem: (long) item
{
	NSArray * theoptions = [_options objectAtIndex:item];
	SMMedia *meta = [[SMMedia alloc ] init];
	switch([[theoptions valueForKey:LAYER_INT] intValue])
	{
		case kSMInInfo:
			[meta setBRImage:[[SMThemeInfo sharedTheme] infoImage]];
			[meta setTitle:@"Additional Information"];
			break;
		case kSMInLicense:
			[meta setBRImage:[[SMThemeInfo sharedTheme] licenseImage]];	
			[meta setTitle:@"License File"];
			break;
		case kSMInUpdate:
		case kSMInInstall:
			[meta setImagePath:[SMGeneralMethods getImagePath:[theoptions valueForKey:NAME_KEY]]];
			[meta setTitle:[theoptions valueForKey:NAME_KEY]];
			break;
		case kSMInManage:
		case kSMInRemove:
		case kSMInRemoveB:
			[meta setBRImage:[[SMThemeInfo sharedTheme] trashEmptyImage]];
			break;
		case kSMInRestore:
		case kSMInBackup:
			[meta setBRImage:[[SMThemeInfo sharedTheme] timeMachineImage]];
			break;
			
	} InType;

	SMMediaPreview *preview = [[SMMediaPreview alloc] init];
	[preview setAsset:meta];
	[preview setShowsMetadataImmediately:YES];
	return (preview);
}

-(id)init{
	//NSLog(@"init");
	self=[super init];
	_man = [NSFileManager defaultManager];
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
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
	[[self list] removeDividers];
	[_items removeAllObjects];
	[_options removeAllObjects];
	NSString *name=[[NSString alloc] initWithString:[_theInformation valueForKey:@"name"]];
	NSString *version=[_theInformation valueForKey:@"version"];
	NSString *displayVersion=[_theInformation valueForKey:@"displayVersion"];
	NSString *displayName =[_theInformation valueForKey:@"displayName"];
	NSString *thelicense =[_theInformation valueForKey:@"license"];

	

	
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
	if(![self frapExists]) //Does Not Exist
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
	else //Exists
	{
		///Is the plugin up to date?
		if (![self frapUpToDate]) //Not Up to Date
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
	if ([self bakExists]) //backup exists
	{		
		///////////////////////
		//   Restore Backup  //
		///////////////////////
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Manage",LAYER_TYPE,@"-restore",LAYER_NAME,[NSNumber numberWithInt:9],LAYER_INT,MISC_KEY,TYPE_KEY,@"restore",NAME_KEY,nil]];
		id item6 = [BRTextMenuItemLayer menuItem];
		[item6 setTitle:@"Restore"];
		[item6 setRightJustifiedText:[_theInformation objectForKey:@"backupVersion"]];
		[_items addObject:item6];
		
		
		///////////////////////
		//   Remove Backup   //
		///////////////////////
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Manage",LAYER_TYPE,@"-rb",LAYER_NAME,[NSNumber numberWithInt:8],LAYER_INT,MISC_KEY,TYPE_KEY,@"remove",NAME_KEY,nil]];
		id item8 =[BRTextMenuItemLayer menuItem];
		[item8 setTitle:@"Remove Backup"];
		[item8 setRightJustifiedText:[_theInformation objectForKey:@"backupVersion"]];
		[_items addObject:item8];
	}
	
	
	id list = [self list];
	[list setDatasource: self];
	///Add the Seperator
	[[self list] addDividerAtIndex:iii withLabel:name];
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
			[infoController setTheImage:[BRImage imageWithPath:[SMGeneralMethods getImagePath:[_theInformation valueForKey:@"name"]]]];
			[infoController setVersions:theOnlineVersion withBak:thebackvers withCurrent:thecurrentvers];
			[[self stack] pushController:infoController];
			break;
		case kSMInLicense:
			misc=@"!";
			infoController=[[SMInfo alloc] init];
			[infoController setTheName:[NSString stringWithFormat:@"License for %@",[_theInformation valueForKey:@"name"]]];
			[infoController setDescriptionWithURL:[_theInformation valueForKey:@"license"]];
			//[infoController setTheImage:[BRImage imageWithPath:[SMGeneralMethods getImagePath:[selectedOption valueForKey:NAME_KEY]]]];
			[infoController setTheImage:[[SMThemeInfo sharedTheme] licenseImage]];
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
		case kSMInRestore:
		case kSMInRemoveB:
		case kSMInManage:
			misc=@"!";
			NSArray *taskArray = [NSArray arrayWithObjects:[selectedOption objectForKey:LAYER_NAME],[thename stringByAppendingString:@".frappliance"],@"0",nil];
			[SMGeneralMethods runHelperApp:taskArray];
			[self initCustom];
			break;

	} InType;
	switch ([[selectedOption objectForKey:LAYER_INT] intValue]) 
	{
		case kSMInRestore:
		case kSMInRemove:
			[SMGeneralMethods terminateFinder];
	} InType;
	return;
}



-(void)willBePopped
{
	
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithDictionary:nil];
	
	if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/settings.plist" stringByExpandingTildeInPath]])
	{
		NSDictionary *tempdict1 = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/settings.plist" stringByExpandingTildeInPath]];
		[settings addEntriesFromDictionary:tempdict1];
		////NSLog(@"adding from temp dict");
	}
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
- (id)itemForRow:(long)row					
{ 
	BRTextMenuItemLayer *theItem = [_items objectAtIndex:row];
	return theItem; 
}
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
	[SMGeneralMethods terminateFinder];



}


@end


