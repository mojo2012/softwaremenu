//
//  SMPhotoPreview.m
//  SoftwareMenuFramework
//
//  Created by Thomas on 4/19/09.
//  Copyright 2010 Thomas Cool. All rights reserved.
//




@implementation SMPhotoPreview

+(id)numberOfPhotosForPath:(NSString *)thepath
{
	int number = 0;
    NSSet *coverArtExtension = [SMThemeInfo imageExtensions];
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
    NSSet *coverArtExtension = [SMThemeInfo imageExtensions];
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
    NSSet *coverArtExtension = [SMThemeInfo imageExtensions];
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
	return [[SMThemeInfo sharedTheme] folderIcon];
}


- (id) previewControlForItem: (long) item
{
    if (item>=[_items count])
        return nil;
    SMFMediaPreview *preview = [[SMFMediaPreview alloc]init];
    SMFBaseAsset *asset=[[SMFBaseAsset alloc]init];
    [asset setTitle:BRLocalizedString(@"Check For Updates",@"Check For Updates")];
    [asset setSummary:BRLocalizedString(@"Check online for new updates",@"Check online for new updates")];
    if(![[_paths objectAtIndex:item] isEqualToString:@"nil"])
        [asset setCoverArt:BRImageD([_paths objectAtIndex:item])];
    [preview setAsset:asset];
    return preview;
}
-(id)initWithPath:(NSString *)thepath{
    self = [super init];
	[path release];
	path=thepath;
	[path retain];
	
	[self setListTitle: [path lastPathComponent]];
	[self setListIcon:[[SMThemeInfo sharedTheme] folderIcon] horizontalOffset:0.5f kerningFactor:0.2f];
	
	[self addLabel:@"org.tomcool.Software.Shared"];
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_paths = [[NSMutableArray alloc] initWithObjects:nil];
	_man = [NSFileManager defaultManager];
    NSSet *coverArtExtension = [SMThemeInfo imageExtensions];
	long i, count = [[_man directoryContentsAtPath:path] count];
	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [[_man directoryContentsAtPath:path] objectAtIndex:i];
		if([coverArtExtension containsObject:[[idStr pathExtension] lowercaseString]])
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
    NSLog(@"items: %@",_items);
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

//- (id)itemForRow:(long)row					
//{ 
//	BRTextMenuItemLayer *theitem = [_items objectAtIndex:row];
//    
//    [theitem setLeftIconInfo:nil];
//	
//	return theitem;
//}


@end
