//
//  SMBrowserOptions.m
//  SoftwareMenu
//
//  Created by Thomas on 5/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//


#import <objc/objc-class.h>
@interface PhotoConnection:NSObject
@end
@interface PhotoXMLConnection : PhotoConnection
- (id)initWithDictionary:(id)fp8;
- (id)rootAlbums;
- (NSMutableArray *)gimmeRootContainers;

@end
@implementation PhotoXMLConnection (SMAccess)
-(NSMutableDictionary *)gimmePhotos {
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "mPhotos");
	return *(NSMutableDictionary * *)(((char *)self)+ret->ivar_offset);
}
-(NSMutableArray *)gimmeRootContainers {
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "mRootContainers");
	return *(NSMutableArray * *)(((char *)self)+ret->ivar_offset);
}
@end


@implementation SMBrowserOptions
-(id)initWithPath:(NSString *)path
{
	self = [super init];
	_path = path;
	[_path retain];
	NSArray *names = [NSArray arrayWithObjects:
					  @"photodirectory",
					  @"favorites",
					  @"Play Slideshow",
					  @"Delete Folder",
					  @"Move Folder",
					  @"Rename Folder",
					  nil];
	NSArray *numbers = [NSArray arrayWithObjects:
						[NSNumber numberWithInt:0],
						[NSNumber numberWithInt:1],
						[NSNumber numberWithInt:5],
						[NSNumber numberWithInt:2],
						[NSNumber numberWithInt:3],
						[NSNumber numberWithInt:4],
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
			if([[SMPreferences stringForKey:PHOTO_DIRECTORY_KEY] isEqualToString:_path])
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
		case 1:
		case -1:
			favorites = [[NSMutableArray alloc] initWithObjects:nil];
			[favorites addObjectsFromArray:[SMGeneralMethods arrayForKey:@"PhotosFavorites"]];
			//NSLog(@"favorites: %@",favorites);
			if(![favorites containsObject:_path])
			{
				[item setTitle:@"Add to Favorites"];
				//[_options replaceObjectAtIndex:row withObject:[NSNumber numberWithInt:1]];
			}
			else
			{
				[item setTitle:@"Remove from Favorites"];
				//[_options replaceObjectAtIndex:row withObject:[NSNumber numberWithInt:-1]];
			}
		default:
			break;
	}
	return item;
}
-(void)itemSelected:(long)row
{
	NSMutableArray * favorites = nil;
	NSLog(@"_options selected: %@",_options);
	CFPreferencesAppSynchronize(myDomain);
	switch ([[[_options objectAtIndex:row] valueForKey:LAYER_INT] intValue]) {
		case 0:
			[SMGeneralMethods setString:_path forKey:PHOTO_DIRECTORY_KEY];
			[[self list] reload];
			break;
		case 1:
		case -1:
			[favorites addObjectsFromArray:[SMGeneralMethods arrayForKey:@"PhotosFavorites"]];
			NSLog(@"favorites: %@ \n path: %@",favorites, _path);
			if(![favorites containsObject:_path])
			{
				NSLog(@"adding");
				[favorites addObject:_path];
				NSLog(@"before: %@",favorites); 
				[SMGeneralMethods setArray:favorites forKey:@"PhotosFavorites"];
				NSLog(@"done");
			}
			else
			{
				NSLog(@"removing");
				[favorites removeObject:_path];
				[SMGeneralMethods setArray:favorites forKey:@"PhotosFavorites"];
			}
			[[self list] reload];
			break;
		case 5:
			/*theDir = _path;
			//NSLog(@"thDir: %@",theDir);
			if(theDir==nil || ![[NSFileManager defaultManager] fileExistsAtPath:theDir isDirectory:&isDir] || !isDir)
				theDir = DEFAULT_IMAGES_PATH;
			//NSLog(@"theDir: %@",theDir);
			if([[NSFileManager defaultManager] fileExistsAtPath:theDir isDirectory:&isDir] && isDir){}
			else
			{
				theDir = DEFAULT_IMAGES_PATH;
			}
			//NSLog(@"theDir: %@",theDir);
			NSMutableArray *photoArray = [NSMutableArray arrayWithObjects:nil];
			
			NSEnumerator *assetEnum = [[SMDefaultPhotos applePhotosForPath:theDir] objectEnumerator];
			id obj;
			while((obj = [assetEnum nextObject]) != nil)
			{
				NSString *assetID = [obj coverArtID];
				[photoArray addObject:assetID];
			}
			NSDictionary *Collectionstoo = [BRIPhotoMediaCollection createPhotoDictFromListOfLocalPhotos:photoArray];
			
			PhotoXMLConnection *PhotoConnections = [[PhotoXMLConnection alloc] initWithDictionary:Collectionstoo];
			
			NSSet *mediaSet=[NSSet setWithObject:[BRMediaType photo]];
			BRMediaHost *mediaHost = [BRMediaHost localMediaProviderAdvertisingMediaTypes:mediaSet];
			
			NSMutableArray * photoRootContainers = [PhotoConnections gimmeRootContainers];
			NSMutableDictionary * dict = [[photoRootContainers objectAtIndex:0] mutableCopy];
			[dict setObject:[[BRSettingsFacade singleton] slideshowPlaybackOptions] forKey:@"slideshow options"];
			[photoRootContainers removeLastObject];
			[photoRootContainers addObject:dict];
			
			
			
			
			SMDefaultPhotoCollection *collectionthree = [[SMDefaultPhotoCollection alloc] initWithProvider:mediaHost 
																								dictionary:[[PhotoConnections rootAlbums] objectAtIndex:0]
																									  path:theDir
																						andPhotoConnection:PhotoConnections];
			
			
			BRPhotoBrowserController *photoBrowser = [[BRPhotoBrowserController alloc] initWithCollection:collectionthree withPlaybackOptions:[[BRSettingsFacade singleton] slideshowPlaybackOptions]];
			[[self stack] pushController:photoBrowser];*/
			break;
			
	
		default:
			
			break;
	}
}
@end
