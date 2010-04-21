//
//  SMFPhotoPreview.m
//  SoftwareMenuFramework
//
//  Created by Thomas on 4/19/09.
//  Copyright 2010 Thomas Cool. All rights reserved.
//




@implementation SMFPhotoPreview

+(id)numberOfPhotosForPath:(NSString *)thepath
{
	int number = 0;
    NSSet *coverArtExtension = [SMFThemeInfo coverArtExtensions];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	long i, count = [[fileManager directoryContentsAtPath:thepath] count];	
	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [[fileManager directoryContentsAtPath:thepath] objectAtIndex:i];
		if([coverArtExtension containsObject:[[idStr pathExtension]lowercaseString]])
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
    NSSet *coverArtExtension = [SMFThemeInfo coverArtExtensions];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	long i, count = [[fileManager directoryContentsAtPath:thepath] count];	
	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [[fileManager directoryContentsAtPath:thepath] objectAtIndex:i];
		if([coverArtExtension containsObject:[[idStr pathExtension] lowercaseString]])
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
    NSSet *coverArtExtension = [SMFThemeInfo coverArtExtensions];
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray * a = [fileManager directoryContentsAtPath:thepath];
	long i, count = [[fileManager directoryContentsAtPath:thepath] count];	
    
	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [a objectAtIndex:i];
		if([coverArtExtension containsObject:[[idStr pathExtension] lowercaseString]])
		{
			return [BRImage imageWithPath:[thepath stringByAppendingPathComponent:idStr]];
		}
		
	}
	return [[SMFThemeInfo sharedTheme] folderIcon];
}


- (id) previewControlForItem: (long) item
{
	////NSLog(@"%@ %s", self, _cmd);
    NSLog(@"showing preview");
//	SMFMedia	*meta = [[SMFMedia alloc] init];
//	[meta setTitle:[[_paths objectAtIndex:item] lastPathComponent]];
//	if(![[[_paths objectAtIndex:item] lastPathComponent] isEqualToString:@"nil"])
//	{
//		[meta setDescription:[_paths objectAtIndex:item]];
//		[meta setImagePath:[_paths objectAtIndex:item]];
//	}
//	BRMetadataPreviewControl *obj = [[BRMetadataPreviewControl alloc] init];
//	[obj setShowsMetadataImmediately:NO];
//	[obj setAsset:meta];
//	return (obj);
    SMFBaseAsset *asset = [[SMFBaseAsset alloc]init];
    [asset setTitle:[[_paths objectAtIndex:item] lastPathComponent]];
    if(![[[_paths objectAtIndex:item] lastPathComponent] isEqualToString:@"nil"])
	{
		//[asset setSummary:[_paths objectAtIndex:item]];
		[asset setCoverArt:[BRImage imageWithPath:[_paths objectAtIndex:item]]];
	}
    SMFMediaPreview *a =[[SMFMediaPreview alloc] init];
    [a setAsset:asset];
    [a setShowsMetadataImmediately:NO];
    return a;
}
-(id)initWithPath:(NSString *)thepath{
	[path release];
	path=thepath;
	[path retain];
	self = [super init];
	[self setListTitle: [path lastPathComponent]];
	[self setListIcon:[[SMFThemeInfo sharedTheme] folderIcon] horizontalOffset:0.5f kerningFactor:0.2f];
	
	[self addLabel:@"org.tomcool.Software.Shared"];
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_paths = [[NSMutableArray alloc] initWithObjects:nil];
	_man = [NSFileManager defaultManager];
    NSSet *coverArtExtension = [SMFThemeInfo coverArtExtensions];
	long i, count = [[_man directoryContentsAtPath:path] count];
	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [[_man directoryContentsAtPath:path] objectAtIndex:i];
		if([coverArtExtension containsObject:[[idStr pathExtension] lowercaseString]])
		{
			BRTextMenuItemLayer * hello = [BRTextMenuItemLayer menuItem];
			[hello setTitle:idStr];
			//[hello setRightJustifiedText:[NSString stringWithFormat:@"(%@)",[SMFPhotoPreview photosForPath:[path stringByAppendingPathComponent:idStr]],nil]];
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
	[self setListIcon:[[SMFThemeInfo sharedTheme] folderIcon] horizontalOffset:0.5f kerningFactor:0.2f];
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
    
    [theitem setLeftIconInfo:nil];
	
	return theitem;
}


@end
