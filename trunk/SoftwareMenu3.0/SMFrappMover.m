//
//  SoftwareScriptsMenu.m
//  QuDownloader
//
//  Created by Thomas on 10/17/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "SMFrappMover.h"

#define SETTINGSPATH						@"/Users/frontrow/Library/Application Support/SoftwareMenu/settings.plist"

@implementation SMFrappMover
- (id) previewControlForItem: (long) row
{
	if(row >=[_items count])
		return nil;
	SMMedia	*meta = [[SMMedia alloc] init];
	[meta setDefaultImage];
	[meta setTitle:[[_items objectAtIndex:row] title]];
	if(row>2) {[meta setDescription:BRLocalizedString(@"Change Order of Frap",@"Change Order of Frap")];}
	SMMediaPreview *preview =[[SMMediaPreview  alloc] init];
	[preview setAsset:meta];
	[preview setShowsMetadataImmediately:YES];
	return [preview autorelease];
}

/*-(void)testURLs
{
	//NSLog(@"1");
	NSString *updateUrl = @"http://web.me.com/tomcool420/SoftwareMenu/updates.plist";
	NSData *outData = [NSData dataWithContentsOfURL:[NSURL URLWithString:updateUrl]];
	NSString *error;
	NSPropertyListFormat format;
	//NSLog(@"2");
	id vDict;
	vDict = [NSPropertyListSerialization propertyListFromData:outData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
	//NSLog(@"***************************");
	//NSLog(@"%@",vDict);
}*/

- (NSArray *)frapEnumerator
{
	BOOL isDir;
	NSMutableArray *frappliances = [[NSMutableArray alloc] init];
	
	NSString *pluginPath = @"/System/Library/CoreServices/Finder.app/Contents/PlugIns/";
	NSFileManager * manager = [NSFileManager defaultManager];
	NSArray *filelist = [manager directoryContentsAtPath:pluginPath];
	NSEnumerator *fileEnum = [filelist objectEnumerator]; 
	NSString *file;
    while (file = [fileEnum nextObject]) {
		//NSLog(@"%@",file);
		[manager changeCurrentDirectoryPath:pluginPath];
        if ([manager fileExistsAtPath:file isDirectory:&isDir] && isDir) {
            NSString *fullpath = [pluginPath stringByAppendingPathComponent:file];
            if ([[file pathExtension] isEqualToString:@"frappliance"]) [frappliances addObject:fullpath];
			//NSLog(@"frap found at %@",fullpath);
			
            
        }
	}
	return frappliances;
}

-(NSArray *)frapOrderDict:(NSArray *)frapList
{
	NSMutableArray *theorders=[[NSMutableArray alloc] init];
	NSEnumerator *frapEnum=[frapList objectEnumerator];
	NSString *frapPath;
	while (frapPath=[frapEnum nextObject])
	{
		NSString *infoPath=[frapPath stringByAppendingPathComponent:@"/Contents/Info.plist"];
		NSDictionary *infoplist=[[NSDictionary alloc] initWithContentsOfFile:infoPath];
		id preforders = [infoplist valueForKey:@"FRAppliancePreferedOrderValue"];
        if ([preforders respondsToSelector:@selector(floatValue)]) {
            preforders=[NSNumber numberWithFloat:[preforders floatValue]];
        }
		[theorders addObject:[[NSDictionary alloc] initWithObjectsAndKeys:preforders,@"order",frapPath,@"fullpath",[frapPath lastPathComponent],@"name",nil]];
	}
	[theorders writeToFile:@"/Users/frontrow/orders.plist" atomically:YES];
	//NSLog(@"the orders: %@",theorders);
	return theorders;
}
-(id)init
{
	self = [super init];
	[[self list] removeDividers];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: BRLocalizedString(@"Frap Order",@"Frap Order")];
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	return self;
	
}

-(id)initCustom
{
	[_items removeAllObjects];
	[_items removeAllObjects];
	
	NSArray *theFrapList=[[NSArray alloc] init];
	theFrapList=[self frapEnumerator];
	//}
	NSArray *FrapOrderArray=[[NSArray alloc] initWithArray:[self frapOrderDict:theFrapList]];
	NSLog(@"1");
	NSArray *names = [NSArray arrayWithObjects:
						   BRLocalizedString(@"Help",@"Help"),
						   BRLocalizedString(@"Backup",@"Backup"),
						   BRLocalizedString(@"Restore",@"Restore"),
						   nil];
	NSArray *types = [NSArray arrayWithObjects:
						   [NSNumber numberWithInt:0],
						   [NSNumber numberWithInt:1],
						   [NSNumber numberWithInt:2],
						   nil];
	
	NSSortDescriptor *lastDescriptor =[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
	NSSortDescriptor *firstDescriptor =[[[NSSortDescriptor alloc] initWithKey:@"name"
								 ascending:YES
								  selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray *thedescriptors = [NSArray arrayWithObjects:lastDescriptor,firstDescriptor, nil];
	NSMutableArray *thesortedArray;
	thesortedArray = [[FrapOrderArray sortedArrayUsingDescriptors:thedescriptors] mutableCopy];
	
	int counter , i = [names count];
	for(counter = 0;counter<i;counter++)
	{
		NSLog(@"%d",counter);
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							 [types objectAtIndex:counter],LAYER_TYPE,
							 [names objectAtIndex:counter],LAYER_NAME,
							 nil]];
		id item1 = [BRTextMenuItemLayer menuItem];
		[item1 setTitle:[names objectAtIndex:counter]];
		[_items addObject:item1];
	}
	NSLog(@"2");
	
	int marker1 =[_items count];

	
	NSEnumerator *enumerator = [thesortedArray objectEnumerator];
	id anObject;
	
	
	

	while (anObject = [enumerator nextObject]) 
	{
		//NSLog(@"anObject: %@",anObject);
		id item = [[BRTextMenuItemLayer alloc] init];
		[item setTitle:[[anObject valueForKey:@"name"] stringByDeletingPathExtension]];
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							 anObject,LAYER_NAME,
							 [NSNumber numberWithInt:3],LAYER_TYPE,
							 nil]];
		[item setRightJustifiedText:[[anObject valueForKey:@"order"] stringValue]];
		[_items addObject:item];
	}


	id list = [self list];
	[list setDatasource: self];
	[[self list] addDividerAtIndex:marker1 withLabel:@"Frappliances"];
	NSLog(@"3");
    NSLog(@"last: %@",[[NSBundle bundleWithPath:[ATV_PLUGIN_PATH stringByAppendingPathComponent:[@"Sapphire" stringByAppendingPathExtension:@"frappliance"]]] infoDictionary]);

	return self;
}

-(void)itemSelected:(long)row
{
	
	NSArray *option = [_options objectAtIndex:row];
	BOOL isDir;
	switch([[option valueForKey:LAYER_TYPE] intValue])
	{
		case 0:
			break;
		case 1:
			isDir = NO;
			NSMutableDictionary *settingsDict = [[NSMutableDictionary alloc] initWithDictionary:nil];
			
			if([[NSFileManager defaultManager] fileExistsAtPath:SETTINGSPATH])
			{
				NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:SETTINGSPATH];
				[settingsDict addEntriesFromDictionary:tempdict];
			}
			
			[settingsDict setValue:[option valueForKey:@"data"] forKey:@"OrderBak"];
			[settingsDict writeToFile:SETTINGSPATH atomically:YES];
			[self initCustom];
			break;
		case 2:
			isDir = YES;
			NSMutableDictionary *settingsDicts =[[NSMutableDictionary alloc] initWithContentsOfFile:SETTINGSPATH];
			NSArray *backupArray=[[NSArray alloc] initWithArray:[settingsDicts valueForKey:@"OrderBak"]];
			NSEnumerator *enumerator = [backupArray objectEnumerator];
			id anObject;
			while (anObject = [enumerator nextObject]) 
			{
				[SMGeneralMethods runHelperApp:[NSArray arrayWithObjects:@"-changeOrder", [anObject valueForKey:@"fullpath"],[[anObject valueForKey:@"order"] stringValue],nil]];
			}
			[self initCustom];
			break;
		case 3:
			isDir = NO;
			id newController = [[SoftwarePasscodeController alloc] initWithTitle:[[option valueForKey:LAYER_NAME] valueForKey:@"name"]
																 withDescription:BRLocalizedString(@"Please enter a new value for prefered Order", @"Please enter a new value for prefered Order")
																	   withBoxes:4
																		 withKey:nil];
			[newController setChangeOrder:[[option valueForKey:LAYER_NAME] valueForKey:@"fullpath"]];
			[[self stack] pushController:newController];
			/*CFPreferencesSetAppValue(CFSTR("option"), (CFNumberRef)[NSNumber numberWithLong:row],kCFPreferencesCurrentApplication);
			//NSLog(@"theNumber : %@",(CFNumberRef)[NSNumber numberWithLong:row]);
			BRTextEntryController *textinput = [[BRTextEntryController alloc] initWithTextEntryStyle:3];
			NSLog(@"name: %@",[[option valueForKey:LAYER_NAME] valueForKey:@"name"]);
			[textinput setTitle:[NSString stringWithFormat:@"Move: %@",[[option valueForKey:LAYER_NAME] valueForKey:@"name"]]];
			[textinput setInitialTextEntryText:[NSString stringWithFormat:@"%d",[[[option valueForKey:LAYER_NAME] valueForKey:@"order"]intValue]]];
			[textinput setPromptText:@"enter a number"];
			[textinput setTextEntryCompleteDelegate:self];
			[[self stack] pushController:textinput];*/
	}
}


- (void) textDidEndEditing: (id) sender
{
	NSString *thetext = [sender stringValue];
	NSNumber *thestatus= (NSNumber *)(CFPreferencesCopyAppValue((CFStringRef)@"option", kCFPreferencesCurrentApplication));
	[SMGeneralMethods runHelperApp:[NSArray arrayWithObjects:@"-changeOrder", [[[_options objectAtIndex:[thestatus intValue]] valueForKey:LAYER_NAME] valueForKey:@"fullpath"],thetext,nil]];
	[[self stack] popController];
	[self initCustom];
	//NSLog(@"check it: %i", [[BRSettingsFacade singleton] slideshowSecondsPerSlide]);
	
}
- (void) textDidChange: (id) sender
{
	//Do Nothing Now
}
-(void)wasExhumed
{
	[self initCustom];
}
- (void)wasExhumedByPoppingController:(id)fp8
{
	[self initCustom];      
}



//	Data source methods:




@end
