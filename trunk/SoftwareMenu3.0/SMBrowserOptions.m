//
//  SMBrowserOptions.m
//  SoftwareMenu
//
//  Created by Thomas on 5/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


@implementation SMBrowserOptions
-(id)initWithPath:(NSString *)path
{
	self = [super init];
	_path = path;
	[_path retain];
	NSArray *names = [NSArray arrayWithObjects:
					  @"photodirectory",
                      @"screensaverdirectory",
					  @"favorites",
					  @"Play Slideshow",
					  //@"Delete Folder",
					  //@"Move Folder",
					  //@"Rename Folder",
					  nil];
	NSArray *numbers = [NSArray arrayWithObjects:
						[NSNumber numberWithInt:0],
                        [NSNumber numberWithInt:6],
						[NSNumber numberWithInt:1],
						[NSNumber numberWithInt:5],
						//[NSNumber numberWithInt:2],
						//[NSNumber numberWithInt:3],
						//[NSNumber numberWithInt:4],
						nil];
	
	[self setListTitle: [_path lastPathComponent]];
	[self setListIcon:[[SMThemeInfo sharedTheme] folderIcon] horizontalOffset:0.5f kerningFactor:0.2f];
	
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_options =[[NSMutableArray alloc] initWithObjects:nil];
	long i, count = [numbers count];
	for ( i = 0; i < count; i++ )
	{
		BRTextMenuItemLayer * hello = [BRTextMenuItemLayer menuItem];
		[hello setTitle:[names objectAtIndex:i]];
		[_items addObject:hello];
		[_options addObject:[NSDictionary dictionaryWithObjectsAndKeys:
							 [numbers objectAtIndex:i],LAYER_INT,
							 nil]];
		
	}
	id list = [self list];
	[list setDatasource: self];
	
	[[self list] removeDividers];
	return self;
}
- (id)itemForRow:(long)row					
{ 
	NSLog(@"_options row:%@",_options);
	BRTextMenuItemLayer *item = [_items objectAtIndex:row];
	NSMutableArray *favorites = nil;
	switch ([[[_options objectAtIndex:row] valueForKey:LAYER_INT] intValue]) {
		case 0:
			if([[SMPreferences photoFolderPath] isEqualToString:_path])
			{
				[item setDimmed:YES];
				[item setTitle:@"Already set as Photo Directory"];
			}
			else
			{
				[item setDimmed:NO];
				[item setTitle:@"Set as Photo Directory"];
			}
			break;
        case 6:
            if([[SMPreferences screensaverFolder] isEqualToString:_path])
			{
				[item setDimmed:YES];
				[item setTitle:@"Already set as Screensaver Directory"];
			}
			else
			{
				[item setDimmed:NO];
				[item setTitle:@"Set as Screensaver Directory"];
			}
            break;
        case 1:
        {
            NSMutableArray *a=[SMPreferences photoFavorites];
            if ([a containsObject:_path]) {
                [item setTitle:@"Remove From Favorites"];
            }
            else {
                [item setTitle:@"Add to Favorites"];
            }
            break;

        }
		default:
			break;
	}
	return item;
}
-(void)itemSelected:(long)row
{
	NSMutableArray * favorites = nil;
	//NSLog(@"_options selected: %@",_options);
	//CFPreferencesAppSynchronize(myDomain);
	switch ([[[_options objectAtIndex:row] valueForKey:LAYER_INT] intValue]) {
		case 0:
			[SMGeneralMethods setString:_path forKey:PHOTO_DIRECTORY_KEY];
			[[self list] reload];
			break;
        case 6:
            
            [SMPreferences setScreensaverFolder:_path];
            [[self list] reload];
            break;
        case 1:
        {
            NSMutableArray *a=[SMPreferences photoFavorites];
            if ([a containsObject:_path]) {
                [a removeObject:_path];
            }
            else {
                [a addObject:_path];
            }
            [SMPreferences setPhotoFavorites:a];
            [[self list] reload];
            break;
        }
        case 5:
        {
            BRDataStore *store = [SMImageReturns dataStoreForPath:_path];
            SMPhotoCollectionProvider* provider    = [SMPhotoCollectionProvider providerWithDataStore:store controlFactory:[BRPhotoControlFactory standardFactory]];         
            id controller4  = [SMPhotoBrowserController controllerForProvider:provider];
            [controller4 setTitle:[_path lastPathComponent]];
            [controller4 removeSButton];
            
            [[self stack] pushController:controller4];
            break;
        }
		default:
			
			break;
	}
}
@end
