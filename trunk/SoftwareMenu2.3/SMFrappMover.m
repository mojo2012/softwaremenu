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
- (id) previewControlForItem: (long) item
{
	////NSLog(@"%@ %s", self, _cmd);
	NSString *resourcePath = nil;
	NSString *appPng = nil;
	NSArray * theoptions = [_options objectAtIndex:item];
	NSString *theoption =[theoptions valueForKey:@"name"];
	if([theoption isEqualToString:@"Help"])
	{
		resourcePath = @"info";
	}
	//NSLog(@"%@",theoption);
	
	
	if([theoption isEqualToString:@"Backup"])
	{
		resourcePath = @"refresh";
	}
		//NSLog(@"%@", appPng);
	appPng = [[NSBundle bundleForClass:[self class]] pathForResource:resourcePath ofType:@"png"];
	//BRImageAndSyncingPreviewController *obj = [[BRImageAndSyncingPreviewController alloc] init];
	BRMetadataPreviewControl *obj = [[BRMetadataPreviewControl alloc]init];
	BRMetadataControl *obj2 =[[BRMetadataControl alloc]init];
	NSString *settingsname=@"hello";
	NSString *settingsdescription=@"hello";
	NSMutableDictionary *settingsMeta=[[NSMutableDictionary alloc] init];
	[settingsMeta setObject:settingsname forKey:@"metatitlekey"];
	[settingsMeta setObject:[NSNumber numberWithInt:1] forKey:@"fileclassutility"];
	[settingsMeta setObject:settingsdescription forKey:@"metadescriptionkey"];
	id sp = [BRImage imageWithPath:appPng];
	id sp2= @"hello";
	[obj2 setTitle:@"hello"];
	[obj2 setSummary:@"hello"];
	[obj setAsset:obj2];
	[obj setImageProvider:sp];
	//[obj setStatusMessage:BRLocalizedString(@"hello",@"hello")];
	return (obj);
}
-(id)init{
	//NSLog(@"init");
	
	return [super init];
}

- (void)dealloc
{
	[super dealloc];  
}
- (BOOL)helperCheckPerm
{
	NSString *helperPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
	NSFileManager *man = [NSFileManager defaultManager];
	NSDictionary *attrs = [man fileAttributesAtPath:helperPath traverseLink:YES];
	NSNumber *curPerms = [attrs objectForKey:NSFilePosixPermissions];
	////NSLog(@"curPerms: %@", curPerms);
	if ([curPerms intValue] < 2541)
	{
		//NSLog(@"installHelper permissions: %@ are not sufficient, dying in scriptsmenu", curPerms);
		return (NO);
	}
	
	return (YES);
	
}
-(void)testURLs
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
}

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
		NSNumber *preforder = [infoplist valueForKey:@"FRAppliancePreferedOrderValue"];
		[theorders addObject:[[NSDictionary alloc] initWithObjectsAndKeys:preforder,@"order",frapPath,@"fullpath",[frapPath lastPathComponent],@"name",nil]];
	}
	[theorders writeToFile:@"/Users/frontrow/orders.plist" atomically:YES];
	//NSLog(@"the orders: %@",theorders);
	return theorders;
}
	

-(id)initWithIdentifier:(NSString *)initId
{
	//NSLog(@"hello");
	[self testURLs];
	//if ([initID isEqualToString:@"start")
	//{
	//NSLog(@"init");
	NSArray *theFrapList=[[NSArray alloc] init];
	theFrapList=[self frapEnumerator];
	//}
	NSArray *FrapOrderArray=[[NSArray alloc] initWithArray:[self frapOrderDict:theFrapList]];
	
	//NSLog(@"after oderdict");
	[FrapOrderArray writeToFile:@"/Users/frontrow/orders2.plist" atomically:YES];
	[[self list] removeDividers];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: BRLocalizedString(@"Frap Order",@"Frap Order")];
	/*NSString *scriptPNG = [[NSBundle bundleForClass:[self class]] pathForResource:@"script" ofType:@"png"];
	id folderImage = [BRImage imageWithPath:scriptPNG];
	[self setListIcon:folderImage horizontalOffset:0.5f kerningFactor:0.2f];*/
	
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options = [[NSMutableArray alloc] initWithObjects:nil];
	NSSortDescriptor *lastDescriptor =[[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];
	NSSortDescriptor *firstDescriptor =[[[NSSortDescriptor alloc] initWithKey:@"name"
								 ascending:YES
								  selector:@selector(localizedCaseInsensitiveCompare:)] autorelease];
	NSArray *thedescriptors = [NSArray arrayWithObjects:lastDescriptor,firstDescriptor, nil];
	NSMutableArray *thesortedArray;
	thesortedArray = [FrapOrderArray sortedArrayUsingDescriptors:thedescriptors];
	
	
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Help",@"name",nil]];
	id item1 = [[BRTextMenuItemLayer alloc] init];
	[item1 setTitle:BRLocalizedString(@"Help",@"Help")];
	[_items addObject:item1];
	
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Backup",@"name",FrapOrderArray,@"data",nil]];
	id item2 = [[BRTextMenuItemLayer alloc] init];
	[item2 setTitle:BRLocalizedString(@"Backup",@"Backup")];
	[_items addObject:item2];
	
	[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"Restore",@"name",nil]];
	id item3 = [[BRTextMenuItemLayer alloc] init];
	[item3 setTitle:BRLocalizedString(@"Restore",@"Restore")];
	[_items addObject:item3];
	
	int marker1 =[_items count];

	
	NSEnumerator *enumerator = [thesortedArray objectEnumerator];
	id anObject;
	
	
	

	while (anObject = [enumerator nextObject]) 
	{
		id item = [[BRTextMenuItemLayer alloc] init];
		[item setTitle:[[anObject valueForKey:@"name"] stringByDeletingPathExtension]];
		[_options addObject:anObject];
		[item setRightJustifiedText:[[anObject valueForKey:@"order"] stringValue]];
		[_items addObject:item];
	}


	id list = [self list];
	[list setDatasource: self];
	[[self list] addDividerAtIndex:marker1 withLabel:@"Frappliances"];
	return self;
}

-(void)itemSelected:(long)fp8
{
	
	NSArray *option = [_options objectAtIndex:fp8];
	NSString *thename = (NSString *)[option valueForKey:@"name"];
	if ([thename isEqualToString:@"Help"])
	{
		//NSLog(@"Help");
	}
	else if([thename isEqualToString:@"Backup"])
	{
		NSMutableDictionary *settingsDict = [[NSMutableDictionary alloc] initWithDictionary:nil];
		
		if([[NSFileManager defaultManager] fileExistsAtPath:SETTINGSPATH])
		{
			NSDictionary *tempdict = [NSDictionary dictionaryWithContentsOfFile:SETTINGSPATH];
			[settingsDict addEntriesFromDictionary:tempdict];
		}
		
		[settingsDict setValue:[option valueForKey:@"data"] forKey:@"OrderBak"];
		[settingsDict writeToFile:SETTINGSPATH atomically:YES];
		[self initWithIdentifier:@"101"];
	}
	else if([thename isEqualToString:@"Restore"])
	{
		NSMutableDictionary *settingsDict =[[NSMutableDictionary alloc] initWithContentsOfFile:SETTINGSPATH];
		NSArray *backupArray=[[NSArray alloc] initWithArray:[settingsDict valueForKey:@"OrderBak"]];
		NSEnumerator *enumerator = [backupArray objectEnumerator];
		id anObject;
		while (anObject = [enumerator nextObject]) 
		{
			NSTask *helperTask = [[NSTask alloc] init];
			NSString *helperPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
			[helperTask setLaunchPath:helperPath];
			[helperTask setArguments:[NSArray arrayWithObjects:@"-changeOrder", [anObject valueForKey:@"fullpath"],[[anObject valueForKey:@"order"] stringValue],nil]];	
			[helperTask launch];
			[helperTask waitUntilExit];
			/*int theTerm = */[helperTask terminationStatus];
			[helperTask release];
		}
		[self initWithIdentifier:@"101"];
		
		
	}
	else
	{
		CFPreferencesSetAppValue(CFSTR("option"), (CFNumberRef)[NSNumber numberWithLong:fp8],kCFPreferencesCurrentApplication);
		//NSLog(@"theNumber : %@",(CFNumberRef)[NSNumber numberWithLong:fp8]);
		BRTextEntryController *textinput = [[BRTextEntryController alloc] init];
		[textinput setTitle:[NSString stringWithFormat:@"Order Number for Frappliance: %@",[option valueForKey:@"name"]]];
		[textinput setInitialTextEntryText:[option valueForKey:@"order"]];
		[textinput setPromptText:@"enter a number"];
		[textinput setTextEntryCompleteDelegate:self];
		[[self stack] pushController:textinput];
		//[self setOrder];
	}
}


- (void) textDidEndEditing: (id) sender
{
	NSString *thetext = [sender stringValue];
	//NSLog(@"thetext: %@",thetext);
	
	
	NSTask *helperTask = [[NSTask alloc] init];
	NSString *helperPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"installHelper" ofType:@""];
	//NSFileManager *man = [NSFileManager defaultManager];
	//NSDictionary *attrs = [man fileAttributesAtPath:helperPath traverseLink:YES];
	//NSNumber *curPerms = [attrs objectForKey:NSFilePosixPermissions];
	//[self appendSourceText:@"done installing"];
	[[SMGeneralMethods sharedInstance]helperFixPerm];
	//[self appendSourceText:@"done installing1"];
	
	//NSLog(@"installHelper curPerms: %@", curPerms);
	[helperTask setLaunchPath:helperPath];
	NSNumber *thestatus= (NSNumber *)(CFPreferencesCopyAppValue((CFStringRef)@"option", kCFPreferencesCurrentApplication));
	//NSLog(@"path: %@",[[_options objectAtIndex:[thestatus intValue]] valueForKey:@"fullpath"]);
	//NSLog(@"value: %@", [[[_options objectAtIndex:[thestatus intValue]] valueForKey:@"order"] stringValue]);
	[helperTask setArguments:[NSArray arrayWithObjects:@"-changeOrder", [[_options objectAtIndex:[thestatus intValue]] valueForKey:@"fullpath"],thetext,nil]];	
	[helperTask launch];
	[helperTask waitUntilExit];
	/*int theTerm = */[helperTask terminationStatus];
	[helperTask release];
	[[self stack] popController];
	[self initWithIdentifier:@"101"];
	//NSLog(@"check it: %i", [[BRSettingsFacade singleton] slideshowSecondsPerSlide]);
	
}
- (void) textDidChange: (id) sender
{
	//Do Nothing Now
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
