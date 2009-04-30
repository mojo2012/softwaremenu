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

@implementation SMInstallMenu
- (id) previewControlForItem: (long) item
{
	if(item >=[_items count])
		return nil;
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
			
	}
	SMMediaPreview *preview = [[SMMediaPreview alloc] init];
	[preview setAsset:meta];
	[preview setShowsMetadataImmediately:YES];
	return (preview);
}

-(id)initWithDictionary:(NSDictionary *)dict{
	//NSLog(@"init");
	self=[super init];
	[_theInformation release];
	_theInformation = [dict mutableCopy];
	[_theInformation retain];
	NSArray *layer_names = [NSArray arrayWithObjects:
							@"Info",
							@"License",
							@"Install",
							@"-backup",
							@"-r",
							@"-restore",
							@"-rb",
							nil];
	NSArray *displayNames = [NSArray arrayWithObjects:
							 BRLocalizedString(@"Info",@"Info"),
							 BRLocalizedString(@"License",@"License"),
							 BRLocalizedString(@"Install",@"Install"),
							 BRLocalizedString(@"Backup",@"Backup"),
							 BRLocalizedString(@"Remove",@"Remove"),
							 BRLocalizedString(@"Restore",@"Restore"),
							 BRLocalizedString(@"Remove Backup",@"Remove Backup"),
							 nil];
	NSArray *layer_ints = [NSArray arrayWithObjects:
						   [NSNumber numberWithInt:kSMInInfo],
						   [NSNumber numberWithInt:kSMInLicense],
						   [NSNumber numberWithInt:kSMInInstall],
						   [NSNumber numberWithInt:kSMInBackup],
						   [NSNumber numberWithInt:kSMInRemove],
						   [NSNumber numberWithInt:kSMInRestore],
						   [NSNumber numberWithInt:kSMInRemoveB],
						   nil];
	_man = [NSFileManager defaultManager];
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	int counter,ii=[layer_ints count];
	
	
	for( counter=0; counter < ii ; counter++)
	{
		id item = nil;
		if([[layer_ints objectAtIndex:counter] intValue] == kSMInInstall)	{item = [BRTextMenuItemLayer networkMenuItem];}
		else																{item = [BRTextMenuItemLayer menuItem];}

		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							 [layer_ints objectAtIndex:counter],LAYER_INT,
							 [layer_names objectAtIndex:counter],LAYER_NAME,
							 [displayNames objectAtIndex:counter],LAYER_DISPLAY,
							 nil]];
		[item setTitle:[displayNames objectAtIndex:counter]];
		[_items addObject:item];
		
	}
	[_items retain];
	[_options retain];
	[self setListTitle:[_theInformation valueForKey:@"displayName"]];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	id list = [self list];
	[list setDatasource: self];
	[[self list] addDividerAtIndex:2 withLabel:[_theInformation valueForKey:@"displayName"]];
	
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

-(NSString *)bakVersion
{
	NSString *bakPath = [NSString stringWithFormat:@"/Users/frontrow/Documents/Backups/%@.bak/",[_theInformation valueForKey:@"name"]];
	NSString *bakInfoPath = [bakPath stringByAppendingString:@"Contents/Info.plist"];
	NSDictionary * info =[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:bakInfoPath]];
	if([[info allKeys] containsObject:@"CFBundleShortVersionString"] && ![[_theInformation valueForKey:@"name"] isEqualToString:@"nitoTV"])
	{
		return [info objectForKey:@"CFBundleShortVersionString"];
		
	}
	else
		return [info objectForKey:@"CFBundleVersion"];
	
}
-(NSString *)installedVersion
{
	NSString *infoPath = [[NSString stringWithFormat:@"/System/Library/CoreServices/Finder.app/Contents/PlugIns/%@.frappliance/",[_theInformation valueForKey:@"name"]] stringByAppendingString:@"Contents/Info.plist"];
	NSDictionary * info =[NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:infoPath]];
	if([[info allKeys] containsObject:@"CFBundleShortVersionString"] && ![[_theInformation valueForKey:@"name"] isEqualToString:@"nitoTV"])
	{
		return [info objectForKey:@"CFBundleShortVersionString"];
		
	}
	else
		return [info objectForKey:@"CFBundleVersion"];
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
	if(![[_theInformation objectForKey:@"name"] isEqualToString:@"nitoTV"])
	{
		NSLog(@"installed: %@, online: %@",[infoDict valueForKey:@"CFBundleVersion"],[_theInformation valueForKey:@"version"],nil);
		if([[infoDict valueForKey:@"CFBundleVersion"] compare:[_theInformation valueForKey:@"version"]]!=NSOrderedAscending){return (YES);}
	}
	else
	{
		if([[infoDict valueForKey:@"CFBundleShortVersionString"] compare:[_theInformation valueForKey:@"shortVersion"]]!=NSOrderedAscending){return (YES);}
	}
	return (NO);
}

-(void)itemSelected:(long)row
{
	if([[_items objectAtIndex:row] dimmed])
		return;
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
			if([self frapExists] && ![self frapUpToDate])
				update =@"YES";
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
			[[self list] reload];
			break;

	}
	switch ([[selectedOption objectForKey:LAYER_INT] intValue]) 
	{
		case kSMInRestore:
		case kSMInRemove:
			[SMGeneralMethods terminateFinder];
	}
	return;
}



/*-(void)willBePopped
{
	
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithDictionary:nil];
	
	if([[NSFileManager defaultManager] fileExistsAtPath:[@"~/Library/Application Support/SoftwareMenu/settings.plist" stringByExpandingTildeInPath]])
	{
		NSDictionary *tempdict1 = [NSDictionary dictionaryWithContentsOfFile:[@"~/Library/Application Support/SoftwareMenu/settings.plist" stringByExpandingTildeInPath]];
		[settings addEntriesFromDictionary:tempdict1];
		////NSLog(@"adding from temp dict");
	}
	[super willBePopped];
}*/


-(void)wasExhumed
{
	[[self list] reload];	
}

//	Data source methods:



- (id)itemForRow:(long)row	
{ 
	BRTextMenuItemLayer *item =[_items objectAtIndex:row];
	switch ([[[_options objectAtIndex:row] valueForKey:LAYER_INT] intValue]) 
	{
		case kSMInInstall:
			if(![self frapExists])
			{
				[item setRightJustifiedText:[_theInformation valueForKey:@"displayVersion"]];
				[item setDimmed:NO];
			}
			else if([self frapExists] && ![self frapUpToDate])
			{
				[item setRightJustifiedText:[_theInformation valueForKey:@"displayVersion"]];
				[item setTitle:@"Update"];
				[item setDimmed:NO];
			}
			else
			{
				[item setDimmed:YES];
			}
			break;
		case kSMInBackup:
			if(![self frapExists])
				[item setDimmed:YES];
			else			
			{
				[item setRightJustifiedText:[self installedVersion]];
				[item setDimmed:NO];
			}
			break;
		case kSMInRemove:

			if(![self frapExists])
				[item setDimmed:YES];
			else 			
			{
				[item setDimmed:NO];
				[item setRightJustifiedText:[self installedVersion]];
			}
			if([[_theInformation valueForKey:@"name"] isEqualToString:@"SoftwareMenu"])
			{
				[item setDimmed:YES];
			}
			break;
		case kSMInRestore:
		case kSMInRemoveB:
			if(![self bakExists])
			{
				[item setDimmed:YES];		
			}
			else			
			{
				[item setRightJustifiedText:[self bakVersion]];
				[item setDimmed:NO];
			}
			break;
		default:
			break;
	}
	if([item dimmed])
		[item setRightJustifiedText:@""];
	[_items replaceObjectAtIndex:row withObject:item];
	return item;
}

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


