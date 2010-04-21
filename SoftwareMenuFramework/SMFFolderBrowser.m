//
//  SMFolderBrowser.m
//  SoftwareMenuFramework
//
//  Created by Thomas on 4/19/09.
//  Copyright 2010 Thomas Cool. All rights reserved.
//





@implementation SMFFolderBrowser


- (id) previewControlForItem: (long) item
{
	////NSLog(@"%@ %s", self, _cmd);
	SMFBaseAsset	*meta = [[SMFBaseAsset alloc] init];
	[meta setTitle:[_paths objectAtIndex:item]];
	[meta setCoverArt:[SMFPhotoPreview firstPhotoForPath:[_paths objectAtIndex:item]]];
	BRMetadataPreviewControl *obj = [[BRMetadataPreviewControl alloc] init];
	[obj setShowsMetadataImmediately:NO];
	[obj setAsset:meta];
	return (obj);
}
-(id)init{
	self = [super init];
	[self addLabel:@"org.tomcool.Software.SMF"];
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
	[self setListIcon:[[SMFThemeInfo sharedTheme] folderIcon] horizontalOffset:0.5f kerningFactor:0.2f];
}
- (void)dealloc
{
	[_man release];
	[_items release];
	[super dealloc];  
}

-(id)initCustom
{
    [_paths removeAllObjects];
    [_items removeAllObjects];
	BRTextMenuItemLayer *thisFolder = [BRTextMenuItemLayer folderMenuItem];
	[thisFolder setTitle:[NSString stringWithFormat:@"%@ Images",[path lastPathComponent],nil]];
	[_paths addObject:path];
	[_items addObject:thisFolder];
	long ii, count = [[_man directoryContentsAtPath:path] count];	
	BOOL isDir;
	for ( ii = 0; ii < count; ii++ )
	{
		NSString *idStr = [[_man directoryContentsAtPath:path] objectAtIndex:ii];
		if([_man fileExistsAtPath:[path stringByAppendingPathComponent:idStr] isDirectory:&isDir] &&isDir && ![idStr isEqualToString:@"OSBoot"])
		{
			NSDictionary *items = [SMFPhotoPreview numberOfInterestingFilesForPath:[path stringByAppendingPathComponent:idStr]];
			int files = [[items valueForKey:@"Folders"] intValue] + [[items valueForKey:@"Images"] intValue];
			if(files != 0)
			{
				if(![idStr hasPrefix:@"."] || [SMFPreferences boolForKey:SHOW_HIDDEN_KEY])
				{
					BRTextMenuItemLayer * hello = [BRTextMenuItemLayer folderMenuItem];
					[hello setTitle:idStr];
					[hello setRightJustifiedText:[NSString stringWithFormat:@"(%@)",[SMFPhotoPreview numberOfPhotosForPath:[path stringByAppendingPathComponent:idStr]],nil]];
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

-(void)itemSelected:(long)row
{
	if(row>=[_items count])
	{
		
	}
	else if(row == 0)
	{
		SMFPhotoPreview *folder = [[SMFPhotoPreview alloc] initWithPath:path];
		[[self stack] pushController:folder];
	}
	else if(row>0)
	{
		SMFFolderBrowser *folder = [[SMFFolderBrowser alloc] init];
		[folder setPath:[_paths objectAtIndex:row]];
		[folder initCustom];
		[[self stack] pushController:folder];
	}
}

- (id)itemForRow:(long)row					
{ 
	return [_items objectAtIndex:row];
}



@end
