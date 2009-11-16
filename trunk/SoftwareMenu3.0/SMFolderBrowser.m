//
//  SMFolderBrowser.m
//  SoftwareMenu
//
//  Created by Thomas on 4/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMFolderBrowser.h"



@implementation SMFolderBrowser
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
	SMMedia	*meta = [[SMMedia alloc] init];
	[meta setTitle:[_paths objectAtIndex:item]];
	[meta setBRImage:[SMPhotoPreview firstPhotoForPath:[_paths objectAtIndex:item]]];
	BRMetadataPreviewControl *obj = [[BRMetadataPreviewControl alloc] init];
	[obj setShowsMetadataImmediately:NO];
	[obj setAsset:meta];
	return (obj);
}
-(id)init{
	self = [super init];
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_paths = [[NSMutableArray alloc] initWithObjects:nil];
	_man = [NSFileManager defaultManager];
	[[self list] removeDividers];
	return self;
}
- (void)setPath:(NSString *)thePath
{
	[path release];
	path = thePath;
	[path retain];
	[self setListTitle: [path lastPathComponent]];
	[self setListIcon:[[SMThemeInfo sharedTheme] folderIcon] horizontalOffset:0.5f kerningFactor:0.2f];
}
- (void)dealloc
{
	[_man release];
	[_items release];
	[super dealloc];  
}

-(id)initCustom
{

	BRTextMenuItemLayer *thisFolder = [BRTextMenuItemLayer folderMenuItem];
	[thisFolder setTitle:[NSString stringWithFormat:@"%@ Images",[path lastPathComponent],nil]];
	[_paths addObject:path];
	[_items addObject:thisFolder];
	long ii, count = [[_man directoryContentsAtPath:path] count];	
	BOOL isDir;
	//NSLog(@"count: %@", [NSNumber numberWithInt:count]);
	//NSLog(@"array: %@", [_man directoryContentsAtPath:path]);
	for ( ii = 0; ii < count; ii++ )
	{
		NSString *idStr = [[_man directoryContentsAtPath:path] objectAtIndex:ii];
		if([_man fileExistsAtPath:[path stringByAppendingPathComponent:idStr] isDirectory:&isDir] &&isDir && ![idStr isEqualToString:@"OSBoot"])
		{
			NSDictionary *items = [SMPhotoPreview numberOfInterestingFilesForPath:[path stringByAppendingPathComponent:idStr]];
			int files = [[items valueForKey:@"Folders"] intValue] + [[items valueForKey:@"Images"] intValue];
			if(files != 0)
			{
				if(![idStr hasPrefix:@"."] || [SMGeneralMethods boolForKey:SHOW_HIDDEN_KEY])
				{
					BRTextMenuItemLayer * hello = [BRTextMenuItemLayer folderMenuItem];
					[hello setTitle:idStr];
					[hello setRightJustifiedText:[NSString stringWithFormat:@"(%@)",[SMPhotoPreview numberOfPhotosForPath:[path stringByAppendingPathComponent:idStr]],nil]];
					[_items addObject:hello];
					[_paths addObject:[path stringByAppendingPathComponent:idStr]];
				}				
			}
		}
	}
	id list = [self list];
	[list setDatasource: self];
	[[self list] addDividerAtIndex:0 withLabel:@"Current Folder"];
	[[self list] addDividerAtIndex:1 withLabel:[NSString stringWithFormat:@"%@ subdirectories",[path lastPathComponent],nil]];
	return self;
}

- (BOOL)brEventAction:(BREvent *)event
{
	int remoteAction =[event remoteAction];
	
	if ([(BRControllerStack *)[self stack] peekController] != self)
		return [super brEventAction:event];
	
	if([event value] == 0)
		return [super brEventAction:event];
	
	if(![[SMGeneralMethods sharedInstance] usingTakeTwoDotThree] && remoteAction>1)
		remoteAction ++;
	long row = [self getSelection];
	//int itemCount = [[(BRListControl *)[self list] datasource] itemCount];
	
	//NSLog(@"hashval =%i",hashVal);
	NSMutableArray * favorites = nil;
	switch (remoteAction)
	{
		case kBREventRemoteActionUp:  // tap up
			//NSLog(@"type up");
			break;
		case kBREventRemoteActionDown:  // tap down
			//NSLog(@"type down");
			break;
		case kBREventRemoteActionLeft:  // tap left

            favorites = [[NSMutableArray alloc] init];
				[favorites addObjectsFromArray:[SMPreferences photoFavorites]];
				if(![favorites containsObject:[_paths objectAtIndex:row]])
				{
					[favorites addObject:[_paths objectAtIndex:row]];
					//[SMGeneralMethods setArray:favorites forKey:@"PhotosFavorites"];
                    [SMPreferences setPhotoFavorites:favorites];
				}
				[[self list] reload];
			/*favorites =[[NSMutableArray alloc] initWithObjects:nil];
			[favorites release];
			id controller = [[SMBrowserOptions alloc]initWithPath:[_paths objectAtIndex:row]];
			[[self stack] pushController:controller];*/
			
			
			break;
		case kBREventRemoteActionRight:  // tap right
				[SMGeneralMethods setString:[_paths objectAtIndex:row] forKey:@"PhotoDirectory"];
				[[self list] reload];
			break;
		case kBREventRemoteActionPlay:  // tap play
			/*selitem = [self selectedItem];
			 [[_items objectAtIndex:selitem] setWaitSpinnerActive:YES];*/
			//NSLog(@"type play");
			break;
	}
	return [super brEventAction:event];
}
-(void)itemSelected:(long)row
{
	if(row>=[_items count])
	{
		
	}
	else if(row == 0)
	{
		SMPhotoPreview *folder = [[SMPhotoPreview alloc] initWithPath:path];
		[[self stack] pushController:folder];
	}
	else if(row>0)
	{
		SMFolderBrowser *folder = [[SMFolderBrowser alloc] init];
		[folder setPath:[_paths objectAtIndex:row]];
		[folder initCustom];
		[[self stack] pushController:folder];
	}
}

- (id)itemForRow:(long)row					
{ 
	BRTextMenuItemLayer *theitem = [_items objectAtIndex:row];
	if([[_paths objectAtIndex:row] isEqualToString:[SMGeneralMethods stringForKey:@"PhotoDirectory"]])
	{
		[theitem setLeftIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[BRThemeInfo sharedTheme] selectedSettingImage], @"BRMenuIconImageKey",nil]];
	}
	else
	{
		[theitem setLeftIconInfo:nil];
	}
	return theitem;
}



@end
