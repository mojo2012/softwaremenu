//
//  SMPhotoPreview.m
//  SoftwareMenu
//
//  Created by Thomas on 4/19/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMPhotoPreview.h"


@implementation SMPhotoPreview

+(id)numberOfPhotosForPath:(NSString *)thepath
{
	int number = 0;
	NSArray *coverArtExtention = [[NSArray alloc] initWithObjects:
								  @"jpg",
								  @"jpeg",
								  @"tif",
								  @"tiff",
								  @"png",
								  @"gif",
								  nil];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	long i, count = [[fileManager directoryContentsAtPath:thepath] count];	
	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [[fileManager directoryContentsAtPath:thepath] objectAtIndex:i];
		if([coverArtExtention containsObject:[[idStr pathExtension]lowercaseString]])
		{
			number ++;
		}
		//NSLog(@"%@",idStr);
		
	}
	return [NSNumber numberWithInt:number];
	
}
+(NSDictionary *)numberOfInterestingFilesForPath:(NSString *)thepath
{
	BOOL isDir;
	int number = 0;
	int folders = 0;
	NSArray *coverArtExtention = [[NSArray alloc] initWithObjects:
								  @"jpg",
								  @"jpeg",
								  @"tif",
								  @"tiff",
								  @"png",
								  @"gif",
								  nil];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	long i, count = [[fileManager directoryContentsAtPath:thepath] count];	
	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [[fileManager directoryContentsAtPath:thepath] objectAtIndex:i];
		if([coverArtExtention containsObject:[[idStr pathExtension] lowercaseString]])
		{
			number ++;
		}
		if([fileManager fileExistsAtPath:[thepath stringByAppendingPathComponent:idStr] isDirectory:&isDir] && isDir)
		{
			folders ++;
		}
		
	}
	return [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithInt:number],@"Images",
			[NSNumber numberWithInt:folders],@"Folders",
			nil];
	//NSLog(@"folders: %@",[NSNumber numberWithInt:folders]);

}
+(id)firstPhotoForPath:(NSString *)thepath
{
	NSArray *coverArtExtention = [[NSArray alloc] initWithObjects:
								  @"jpg",
								  @"jpeg",
								  @"tif",
								  @"tiff",
								  @"png",
								  @"gif",
								  nil];
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray * a = [fileManager directoryContentsAtPath:thepath];
	long i, count = [[fileManager directoryContentsAtPath:thepath] count];	

	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [a objectAtIndex:i];
		if([coverArtExtention containsObject:[[idStr pathExtension] lowercaseString]])
		{
			return [BRImage imageWithPath:[thepath stringByAppendingPathComponent:idStr]];
		}
		
	}
	return [[SMThemeInfo sharedTheme] folderIcon];
}
	
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
	[meta setTitle:[[_paths objectAtIndex:item] lastPathComponent]];
	if(![[[_paths objectAtIndex:item] lastPathComponent] isEqualToString:@"nil"])
	{
		[meta setDescription:[_paths objectAtIndex:item]];
		[meta setImagePath:[_paths objectAtIndex:item]];
	}
	BRMetadataPreviewControl *obj = [[BRMetadataPreviewControl alloc] init];
	[obj setShowsMetadataImmediately:NO];
	[obj setAsset:meta];
	return (obj);
}
-(id)initWithPath:(NSString *)thepath{
	[path release];
	path=thepath;
	[path retain];
	self = [super init];
	NSLog(@"after self");
	[self setListTitle: [path lastPathComponent]];
	[self setListIcon:[[SMThemeInfo sharedTheme] folderIcon] horizontalOffset:0.5f kerningFactor:0.2f];
	
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_paths = [[NSMutableArray alloc] initWithObjects:nil];
	_man = [NSFileManager defaultManager];
	NSArray *coverArtExtention = [[NSArray alloc] initWithObjects:
								  @"jpg",
								  @"JPG",
								  @"jpeg",
								  @"tif",
								  @"tiff",
								  @"png",
								  @"gif",
								  nil];
	long i, count = [[_man directoryContentsAtPath:path] count];
	NSLog(@"contents at %@: %@",path,[_man directoryContentsAtPath:path]);
	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [[_man directoryContentsAtPath:path] objectAtIndex:i];
		if([coverArtExtention containsObject:[[idStr pathExtension] lowercaseString]])
		{
			BRTextMenuItemLayer * hello = [BRTextMenuItemLayer menuItem];
			[hello setTitle:idStr];
			//[hello setRightJustifiedText:[NSString stringWithFormat:@"(%@)",[SMPhotoPreview photosForPath:[path stringByAppendingPathComponent:idStr]],nil]];
			[_items addObject:hello];
			[_paths addObject:[path stringByAppendingPathComponent:idStr]];
			
		}
		else
		{
			NSLog(@"lowercase pathextension: %@",[[idStr pathExtension] lowercaseString]);
		}
		//NSLog(@"%@",idStr);
		
	}
	if ([_items count]==0)
	{
		BRTextMenuItemLayer *one = [BRTextMenuItemLayer menuItem];
		[one setTitle:@"Empty Folder"];
		[_items addObject:one];
		[_paths addObject:@"nil"];
	}
	//NSLog(@"items: %@",_items);
	id list = [self list];
	[list setDatasource: self];
	
	[[self list] removeDividers];
	return self;
}
- (void)setPath:(NSString *)thePath
{
	[path release];
	path = thePath;
	[path retain];
	[path retain];
	[self setListTitle: [path lastPathComponent]];
	[self setListIcon:[[SMThemeInfo sharedTheme] folderIcon] horizontalOffset:0.5f kerningFactor:0.2f];
}

- (void)dealloc
{
	[_man release];
	[super dealloc];  
}
-(id)initCustom
{
		return self;
}


//	Data source methods:

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
