//
//  SMTweaks.m
//  SoftwareMenu
//
//  Created by Thomas on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMScreenSaverMenu.h"
#import "SMGeneralMethods.h"
#import "SMMedia.h"
#import "SoftwareSettings.h"
#import "SMDefaultPhotos.h"
#import "AGProcess.h"
#import "SMMediaPreview.h"
#include <sys/param.h>
#include <sys/mount.h>
#include <stdio.h>
#import <objc/objc-class.h>
#import "SMFolderBrowser.h"
#import "SMPhotoPreview.h"
#import "SMScreenSaverSettingsMenu.h"
#import "SMInfo.h"
#define SCREEN_SAVER_PATH @"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SM.frss"


@implementation SMScreenSaverDefaultSettings

-(id)init
{
	self = [super init];
	//NSLog(@"set title");
	[self setListTitle: BRLocalizedString(@"Default Settings",@"Default Settings")];
	//NSLog(@"setimage");
	[self setListIcon:[[BRThemeInfo sharedTheme] photoSettingsImage] horizontalOffset:0.5f kerningFactor:0.2f];
	//NSLog(@"done");
	return self;
}

@end

@interface IPSlideshow : NSObject
@end
@implementation IPSlideshow (protectedAccess)
-(NSMutableDictionary *)gimmeAlbumDict {
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "mAlbumDictionary");
	return *(NSMutableDictionary * *)(((char *)self)+ret->ivar_offset);
}


@end

@interface ATVScreenSaverManager
+(id)singleton;
- (void)showScreenSaver;
@end
@interface ATVSettingsFacade : BRSettingsFacade
- (void)setScreenSaverSelectedPath:(id)fp8;
- (id)screenSaverSelectedPath;
- (id)screenSaverPaths;
- (id)screenSaverCollectionForScreenSaver:(id)fp8;

@end
@interface PhotoConnection
@end
@implementation BRIPhotoMediaCollection (protectedAccess)
-(NSMutableDictionary *)gimmeCollectionDict {
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "_collectionDictionary");
	return *(NSMutableDictionary * *)(((char *)self)+ret->ivar_offset);
}
-(NSMutableArray *)gimmeConnectionDict {
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "_imageList");
	return *(NSMutableArray * *)(((char *)self)+ret->ivar_offset);
}
@interface PhotoXMLConnection : PhotoConnection
- (id)initWithDictionary:(id)fp8;
@end
@implementation PhotoXMLConnection (protectedAccess)
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

@implementation SMScreenSaverMenu
static NSDate *lastFilterChangeDate = nil;

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
    // If subclassing BRMediaMenuController, this function is called when the selection cursor
    // passes over an item.
	if(item >= [_items count])
		return nil;
	else if([[_dividers valueForKey:@"Favorites"]intValue] != [[_dividers valueForKey:@"Current"]intValue] && item == [settingNames count])
	{
		SMMedia	*meta = [[SMMedia alloc] init];
		[meta setTitle:(NSString *)[[_items objectAtIndex:item] title]];
		[meta setBRImage:[SMPhotoPreview firstPhotoForPath:[SMGeneralMethods stringForKey:PHOTO_DIRECTORY_KEY]]];
		SMMediaPreview *preview =[[SMMediaPreview alloc] init];
		[preview setAsset:meta];
		return [preview autorelease];
	}
	else if(item >= [settingNames count])
	{
		SMMedia	*meta = [[SMMedia alloc] init];
		[meta setTitle:(NSString *)[[_items objectAtIndex:item] title]];
		[meta setBRImage:[SMPhotoPreview firstPhotoForPath:[paths objectAtIndex:item]]];
		SMMediaPreview *preview =[[SMMediaPreview alloc] init];
		[preview setAsset:meta];
		return [preview autorelease];

	}
	else
	{
		
		
		SMMedia	*meta = [[SMMedia alloc] init];
		[meta setTitle:(NSString *)[[_items objectAtIndex:item] title]];
		[meta setDescription:[settingDescriptions objectAtIndex:item]];	
		switch([[settingNumberType objectAtIndex:item] intValue])
		{
			case kSMSSAbout:
				[meta setBRImage:[[SMThemeInfo sharedTheme] infoImage]];
				//[meta setDefaultImage];
				break;
			case kSMSSStart:
				[meta setPhotosImage];
				break;
			case kSMSSSettings:
				[meta setPhotosSettingsImage];
				break;
			default:
				[meta setDefaultImage];
				break;
			
		} SMSSType;
		SMMediaPreview *preview =[[SMMediaPreview alloc] init];
		[preview setShowsMetadataImmediately:YES];
		//[previewtoo setDeletterboxAssetArtwork:YES];
		[preview setAsset:meta];
		
		return [preview autorelease];
	}
}
- (void)dealloc
{
	[_man release];
	[paths release];
	[_items release];
	
	[settingNames release];
	[settingDisplays release];
	[settingType release];
	[settingDescriptions release];
	[settingNumberType release];
	[_dividers release];
	[paths release];
	//NSWorkspace *workspace;
	[_man release];
	[_items release];
	[_options release];
	[super dealloc];  
}
-(id)init
{
	
	self=[super init];
	[[SMGeneralMethods sharedInstance] helperFixPerm];
	[SMGeneralMethods checkFolders];
	[[self list] removeDividers];
	
	[self addLabel:@"com.tomcool420.Software.SoftwareMenu"];
	[self setListTitle: BRLocalizedString(@"Slideshow Menu",@"Slideshow Menu")];
	settingNames = [[NSMutableArray alloc] initWithObjects:
					@"About",
					@"SlideshowStart",
					@"slideshowSettings",
					@"smSlideshowSettings",
					nil];
	settingDisplays = [[NSMutableArray alloc] initWithObjects:
					   BRLocalizedString(@"About",@"About"),
					   BRLocalizedString(@"Start Slideshow",@"Start Slideshow"),
					   BRLocalizedString(@"Slideshow Settings",@"Slideshow Settings"),
					   BRLocalizedString(@"SM Slideshow Settings",@"SM Slideshow Settings"),
					   nil];
	settingDescriptions = [[NSMutableArray alloc] initWithObjects:
						   @"Explains everything you need to know about the slideshow functionality",
						   @"Starts the slideshow",
						   @"Settings from apple Photos menu",
						   @"Settings from SoftwareMenu Photos... yea apple didn't do a complete enough job ;)",
						   nil];
	settingNumberType = [[NSMutableArray alloc] initWithObjects:
						 [NSNumber numberWithInt:0],
						 [NSNumber numberWithInt:1],
						 [NSNumber numberWithInt:2],
						 [NSNumber numberWithInt:3],
						 nil];
	
	
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_dividers = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
	_man = [NSFileManager defaultManager];
	paths = [[NSMutableArray alloc] initWithObjects:nil];
	_tempPath = nil;
	[self setListIcon:[[BRThemeInfo sharedTheme] photosImage] horizontalOffset:0.5f kerningFactor:0.2f];
	return self;
}
-(id)initCustom
{
	NSLog(@"initCustom");
	[_items removeAllObjects];
	[paths removeAllObjects];
	[_dividers removeAllObjects];
	[[self list] removeDividers];
	
	int i,counter;
	i=[settingNames count];
	for(counter=0;counter<i;counter++)
	{
		BRTextMenuItemLayer *item =[[BRTextMenuItemLayer alloc]init];
		[item setTitle:[settingDisplays objectAtIndex:counter]];
		//[_options addObject:[NSArray arrayWithObjects:[settingType objectAtIndex:counter],[settingNames objectAtIndex:counter],[settingDisplays objectAtIndex:counter],nil]];
		[_items addObject:item];
		[paths addObject:@"nil"];
		
	}
	//Now let's go through the Non Builtin Scripts ... Located in ~/Documents/Scripts/ -- Shamelessly taken from Emulators Plugin
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDir;
	[_dividers setObject:[NSNumber numberWithInt:[_items count]] forKey:@"Current"];
	NSString *currentFile = nil;
	NSLog(@"file: %@",[SMGeneralMethods stringForKey:@"PhotoDirectory"]);
	if(_tempPath !=nil)
	{
		currentFile = _tempPath;
		[_tempPath release];
		_tempPath = nil;
		[_tempPath retain];
	}
	else
	{
		currentFile = [SMGeneralMethods stringForKey:@"PhotoDirectory"];
	}
	if([fileManager fileExistsAtPath:currentFile isDirectory:&isDir] && isDir)
	{
		//NSLog(@"Exists");
		BRTextImageMenuItemLayer *current_item = [BRTextImageMenuItemLayer twoLineFolderMenuItem];
		[current_item setTitle:[SMGeneralMethods stringForKey:@"PhotoDirectory"]];
		//[current_item setTitleImage:[[BRThemeInfo sharedTheme] photosImage]];
		NSNumber *numberofPhotos = [SMPhotoPreview numberOfPhotosForPath:currentFile];
		[current_item setSubtitle:[NSString stringWithFormat:@"(%@) Images in folder",numberofPhotos]];
		[current_item setLoadsThumbnails:YES];
		if([numberofPhotos boolValue])
		{
			[current_item setThumbnailImage:[SMPhotoPreview firstPhotoForPath:currentFile]];
		}
		else
		{
			[current_item setThumbnailImage:[[SMThemeInfo sharedTheme] folderIcon]];
		}
		//[current_item setLeftImageIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[BRThemeInfo sharedTheme] selectedSettingImage], @"BRMenuIconImageKey",nil]];
		[_items addObject:current_item];
		[paths addObject:currentFile];
	}
	int current = [_items count];
	[_dividers setObject:[NSNumber numberWithInt:[_items count]] forKey:@"Favorites"];
	NSMutableArray *favorites = [[NSMutableArray alloc] initWithObjects:nil];
	[favorites addObjectsFromArray:[SMGeneralMethods arrayForKey:@"PhotosFavorites"]];
	NSEnumerator *objEnum = [favorites objectEnumerator];
	id obj;
	while((obj = [objEnum nextObject]) != nil)
	{
		if([fileManager fileExistsAtPath:obj isDirectory:&isDir] &&isDir)
		{
			NSNumber *numberOfPhotos = [SMPhotoPreview numberOfPhotosForPath:obj];
			BRTextImageMenuItemLayer * favoritesLayer = [BRTextImageMenuItemLayer twoLineFolderMenuItem];
			[favoritesLayer setTitle:obj];
			[favoritesLayer setSubtitle:[NSString stringWithFormat:@"(%@)",numberOfPhotos,nil]];
			if([numberOfPhotos intValue] == 0)	{[favoritesLayer setThumbnailImage:[[BRThemeInfo sharedTheme] missingImage]];}
			else								{[favoritesLayer setThumbnailImage:[SMPhotoPreview firstPhotoForPath:obj]];}

			[_items addObject:favoritesLayer];
			[paths addObject:obj];
		}
	}
	
	[_dividers setObject:[NSNumber numberWithInt:[_items count]] forKey:@"Volumes"];
	NSLog(@"1");
	
	
	NSString *thepath = @"/Volumes/";
	long ii, count = [[fileManager directoryContentsAtPath:thepath] count];	
	for ( ii = 0; ii < count; ii++ )
	{
		NSString *idStr = [[fileManager directoryContentsAtPath:thepath] objectAtIndex:ii];
		if([fileManager fileExistsAtPath:[thepath stringByAppendingPathComponent:idStr] isDirectory:&isDir] &&isDir && ![idStr isEqualToString:@"OSBoot"])
		{
			NSNumber *numberOfPhotos = [SMPhotoPreview numberOfPhotosForPath:[thepath stringByAppendingPathComponent:idStr]];
			BRTextImageMenuItemLayer * mountsLayer = [BRTextImageMenuItemLayer twoLineFolderMenuItem];
			[mountsLayer setTitle:[thepath stringByAppendingPathComponent:idStr]];
			[mountsLayer setSubtitle:[NSString stringWithFormat:@"(%@)",numberOfPhotos,nil]];
			if([numberOfPhotos intValue] == 0)	{[mountsLayer setThumbnailImage:[[BRThemeInfo sharedTheme] missingImage]];}
			else								{[mountsLayer setThumbnailImage:[SMPhotoPreview firstPhotoForPath:[thepath stringByAppendingPathComponent:idStr]]];}
			[_items addObject:mountsLayer];
			[paths addObject:[thepath stringByAppendingPathComponent:idStr]];
		}
	}
	[_dividers setObject:[NSNumber numberWithInt:[_items count]] forKey:@"Folders"];
	if([fileManager fileExistsAtPath:@"/Users/frontrow/Pictures" isDirectory:&isDir] && isDir)
	{
		NSNumber *numberOfPhotos = [SMPhotoPreview numberOfPhotosForPath:@"/Users/frontrow/Pictures"];

		BRTextImageMenuItemLayer * picturesLayer = [BRTextImageMenuItemLayer twoLineFolderMenuItem];
		[picturesLayer setTitle:@"~/frontrow/Pictures"];
		[picturesLayer setSubtitle:[NSString stringWithFormat:@"(%@)",[SMPhotoPreview numberOfPhotosForPath:@"/Users/frontrow/Pictures"]]];
		if([numberOfPhotos intValue] == 0)	{[picturesLayer setThumbnailImage:[[BRThemeInfo sharedTheme] missingImage]];}
		else								{[picturesLayer setThumbnailImage:[SMPhotoPreview firstPhotoForPath:@"/Users/frontrow/Pictures"]];}
		[_items addObject:picturesLayer];
		[paths addObject:@"/Users/frontrow/Pictures"];
	}
	NSNumber *numberOfPhotos = [SMPhotoPreview numberOfPhotosForPath:@"/Users/frontrow"];

	BRTextImageMenuItemLayer * homeLayer = [BRTextImageMenuItemLayer twoLineFolderMenuItem];
	[homeLayer setTitle:@"~/frontrow"];
	[homeLayer setSubtitle:[NSString stringWithFormat:@"(%@)",[SMPhotoPreview numberOfPhotosForPath:@"/Users/frontrow/"]]];
	[_items addObject:homeLayer];
	[paths addObject:[@"/Users/frontrow" stringByExpandingTildeInPath]];
	if([numberOfPhotos intValue] == 0)	{[homeLayer setThumbnailImage:[[BRThemeInfo sharedTheme] missingImage]];}
	else								{[homeLayer setThumbnailImage:[SMPhotoPreview firstPhotoForPath:@"/Users/frontrow"]];}
	id list = [self list];
	//[[self list] addDividerAtIndex:8 withLabel:BRLocalizedString(@"Installs",@"Installs")];
	//[[self list] addDividerAtIndex:0 withLabel:BRLocalizedString(@"Restart Finder",@"Restart Finder")];
	[list setDatasource: self];
	if([[_dividers valueForKey:@"Favorites"]intValue] != [[_dividers valueForKey:@"Current"]intValue])
		[[self list] addDividerAtIndex:[[_dividers valueForKey:@"Current"]intValue] withLabel:@"Current"];
	if([[_dividers valueForKey:@"Volumes"]intValue] != [[_dividers valueForKey:@"Favorites"]intValue])
		[[self list] addDividerAtIndex:[[_dividers valueForKey:@"Favorites"]intValue] withLabel:@"Favorites"];
	if([[_dividers valueForKey:@"Folders"]intValue] != [[_dividers valueForKey:@"Volumes"]intValue])
		[[self list] addDividerAtIndex:[[_dividers valueForKey:@"Volumes"]intValue] withLabel:@"Volumes"];
	[[self list] addDividerAtIndex:[[_dividers valueForKey:@"Folders"]intValue] withLabel:@"Folders"];
	NSLog(@"3");
	NSLog(@"paths: %@",paths);
	return self;
}
-(void)itemSelected:(long)row
{
	NSString *theDir = nil;
	if(row>=[settingNames count])
	{
		SMFolderBrowser *folder = [[SMFolderBrowser alloc] init];
		[folder setPath:[paths objectAtIndex:row]];
		[folder initCustom];
		[[self stack] pushController:folder];
	}
	else
	{
		BOOL isDir;
		switch([[settingNumberType objectAtIndex:row]intValue])
		{
			case kSMSSAbout:
				isDir = NO;
				SMInfo *infoController = [[SMInfo alloc] init];
				NSLog(@"1");
				NSString *downloadedDescription = [NSString  stringWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"PhotosAbout" ofType:@"txt"] encoding:NSUTF8StringEncoding error:NULL];
				[infoController setDescription:downloadedDescription];
				NSLog(@"2");
				[infoController setTheImage:[[SMThemeInfo sharedTheme] photosImage]];
				[infoController setTheName:@"Photos Help"];
				NSLog(@"3");
				[[self stack] pushController:infoController];
				//isDir =NO;
				//BRSlideshowSettingsTimePerSlideController *sstime = [[BRSlideshowSettingsTimePerSlideController alloc] init];
				//[[self stack] pushController:sstime];
				break;
			case kSMSSStart:
				isDir = NO;
				if([[SMGeneralMethods stringForKey:@"SlideShowType"] isEqualToString:@"Floating Images"])
				{
					//[SMGeneralMethods runHelperApp:[NSArray arrayWithObjects:@"installScreenSaver",@"0",@"0",nil]];
					
					NSString *oldScreenSaver = [[ATVSettingsFacade singleton] screenSaverSelectedPath];
					[[ATVSettingsFacade singleton] setScreenSaverSelectedPath:SCREEN_SAVER_PATH];
					[[ATVScreenSaverManager singleton] showScreenSaver];
					[[ATVSettingsFacade singleton] setScreenSaverSelectedPath:oldScreenSaver];
				}
				else
				{
					[SMGeneralMethods setString:@"SlideShow" forKey:@"SlideShowType"];
					theDir = [SMGeneralMethods stringForKey:@"PhotoDirectory"];
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
					[[self stack] pushController:photoBrowser];
					
				}
				break;
			case kSMSSSettings:
				isDir =NO;
				BRSlideshowSettingsController *settings = [[BRSlideshowSettingsController alloc] init];
				[[self stack] pushController:settings];
				break;
			case kSMSSCustomSettings:
				isDir = NO;
				SMScreenSaverSettingsMenu *cusSettings = [[SMScreenSaverSettingsMenu alloc] init];
				[cusSettings initCustom];
				[[self stack] pushController:cusSettings];
				break;
				
				
				
				
				
		}
		/*switch(row)
		{
			case 0:
				theDir = [SMGeneralMethods stringForKey:@"PhotoDirectory"];
				BOOL isDir;
				if(theDir==nil || ![[NSFileManager defaultManager] fileExistsAtPath:theDir isDirectory:&isDir] || !isDir)
					theDir = DEFAULT_IMAGES_PATH;
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
				[[ATVSettingsFacade singleton] setScreenSaverPhotoCollection:collectionthree forScreenSaverType:@"ScreenSaverFloatingPhotoType"];
				NSLog(@"screensaverPhotos: %@", [[ATVDefaultPhotos screenSaverPhotosForType:@"ScreenSaverFloatingPhotoType"] objectAtIndex:0]);
				NSLog(@"screensaverPaths: %@", [[ATVSettingsFacade singleton] screenSaverPaths]);
				[[ATVScreenSaverManager singleton] showScreenSaver];
		}*/
	}

	
	[[self list] reload];
}
/*- (float)heightForRow:(long)row				{ return 0.0f; }
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}*/
- (id)itemForRow:(long)row					
{ 
	//NSLog(@"itemForRow");
	if(row >= [_items count])
		return nil;
	if(row == [settingNames count])
	{
		NSLog(@"row three");
		BRTextImageMenuItemLayer *theitem = [_items objectAtIndex:row];
		[theitem setTitle:[SMGeneralMethods stringForKey:@"PhotoDirectory"]];
		return theitem;
	}
	if(row >[settingNames count])
	{
		NSLog(@"beyond row three");
		BRTextImageMenuItemLayer *theitem = [_items objectAtIndex:row];
		//NSLog(@"title: %@",(NSString *)[theitem title]);
		/*if([[paths objectAtIndex:row] isEqualToString:[SMGeneralMethods stringForKey:@"PhotoDirectory"]])
		{
			[theitem setLeftIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:[[BRThemeInfo sharedTheme] selectedSettingImage], @"BRMenuIconImageKey",nil]];
		}
		else
		{
			[theitem setLeftIconInfo:nil];
		}*/
		return theitem;

	}
	//NSLog(@"after special");
	BRTextMenuItemLayer *item  = nil;
	switch (row) {
		case 0:
			//NSLog(@"PhotoController");
			item = [BRTextMenuItemLayer menuItem];
			[item setTitle:[settingDisplays objectAtIndex:row]];
			break;
		case 1:
			//NSLog(@"PhotoController");
			item = [BRTextMenuItemLayer menuItem];
			[item setTitle:[settingDisplays objectAtIndex:row]];
			break;
		case 2:
			item = [BRTextMenuItemLayer menuItem];
			[item setTitle:[settingDisplays objectAtIndex:row]];
			break;
		case 3:
			item = [BRTextMenuItemLayer menuItem];
			[item setTitle:[settingDisplays objectAtIndex:row]];
		default:
			break;
	}
	return item;
		
	//return [_items objectAtIndex:row]; 
}
/*- (long)rowForTitle:(id)title				{ return (long)[_items indexOfObject:title]; }
- (id)titleForRow:(long)row					{ return [[_items objectAtIndex:row] title]; }*/
/*- (id)titleForRow:(long)row					
 {
 return [settingDisplays objectAtIndex:row];
 }
 - (long) rowForTitle: (id) title
 {
 long result = -1;
 long i, count = [self itemCount];
 for ( i = 0; i < count; i++ )
 {
 if ( [title isEqualToString: [self titleForRow: i]] )
 {
 result = i;
 break;
 }
 }
 
 return ( result );
 }*/
-(void)wasExhumed
{
	[self initCustom];
	[[self list] reload];
}
- (BOOL)brEventAction:(BREvent *)event
{
	long selitem;
	unsigned int hashVal = (uint32_t)((int)[event page] << 16 | (int)[event usage]);
	if ([(BRControllerStack *)[self stack] peekController] != self)
		hashVal = 0;
	
	//int itemCount = [[(BRListControl *)[self list] datasource] itemCount];
	
	//NSLog(@"hashval =%i",hashVal);
	switch (hashVal)
	{
		case 65676:  // tap up
			//NSLog(@"type up");
			break;
		case 65677:  // tap down
			//NSLog(@"type down");
			break;
		case 65675:  // tap left
			//NSLog(@"type left");
			selitem = 0;
			
			selitem = [self getSelection];
			//NSLog(@"selection :%d",selitem);
			if(![self usingTakeTwoDotThree] || lastFilterChangeDate == nil || [lastFilterChangeDate timeIntervalSinceNow] < -0.4f)
			{
				[lastFilterChangeDate release];
				lastFilterChangeDate = [[NSDate date] retain];
				NSMutableArray *favorites = [[NSMutableArray alloc] initWithObjects:nil];
				[favorites addObjectsFromArray:[SMGeneralMethods arrayForKey:@"PhotosFavorites"]];
				if([favorites containsObject:[paths objectAtIndex:selitem]])
				{
					[favorites removeObjectAtIndex:[favorites indexOfObject:[paths objectAtIndex:selitem]]];
					[SMGeneralMethods setArray:favorites forKey:@"PhotosFavorites"];
					[_items removeObjectAtIndex:[paths indexOfObject:[paths objectAtIndex:selitem]]];
					[paths removeObjectAtIndex:[paths indexOfObject:[paths objectAtIndex:selitem]]];
					[[self list] removeDividers];
					if([[_dividers valueForKey:@"Favorites"]intValue] != [[_dividers valueForKey:@"Current"]intValue])
						[[self list] addDividerAtIndex:[[_dividers valueForKey:@"Current"]intValue] withLabel:@"Current"];
					int i = [[_dividers valueForKey:@"Volumes"] intValue];
					i--;
					[_dividers setObject:[NSNumber numberWithInt:i] forKey:@"Volumes"];
					
					i= [[_dividers valueForKey:@"Folders"] intValue];
					i--;
					[_dividers setObject:[NSNumber numberWithInt:i] forKey:@"Folders"];
					if([[_dividers valueForKey:@"Volumes"]intValue] != [[_dividers valueForKey:@"Favorites"]intValue])
						[[self list] addDividerAtIndex:[[_dividers valueForKey:@"Favorites"]intValue] withLabel:@"Favorites"];
					if([[_dividers valueForKey:@"Folders"]intValue] != [[_dividers valueForKey:@"Volumes"]intValue])
						[[self list] addDividerAtIndex:[[_dividers valueForKey:@"Volumes"]intValue] withLabel:@"Volumes"];
					[[self list] addDividerAtIndex:[[_dividers valueForKey:@"Folders"]intValue] withLabel:@"Folders"];

					//[[self list] addDividerAtIndex:8 withLabel:BRLocalizedString(@"Installs",@"Installs")];
					//[[self list] addDividerAtIndex:0 withLabel:BRLocalizedString(@"Restart Finder",@"Restart Finder")];
					[[self list] reload];
					
					
					
					
				}
			}
			
			
			break;
		case 65674:  // tap right
			//NSLog(@"type right");
			//[self setSelectedItem:1];
			selitem = 0;
			
			selitem = [self getSelection];
			if(selitem>=[settingNames count])
			{
				if(![self usingTakeTwoDotThree] || lastFilterChangeDate == nil || [lastFilterChangeDate timeIntervalSinceNow] < -0.4f)
				{
					[lastFilterChangeDate release];
					lastFilterChangeDate = [[NSDate date] retain];
					NSLog(@"Row: %@",[NSNumber numberWithInt:selitem]);
					NSLog(@"path: %@",[paths objectAtIndex:selitem]);
					[SMGeneralMethods setString:[paths objectAtIndex:selitem] forKey:@"PhotoDirectory"];
					[_tempPath release];
					_tempPath = [paths objectAtIndex:selitem];
					[_tempPath retain];
					[self initCustom];
					[[self list] reload];
				}
			}

			break;
		case 65673:  // tap play
			/*selitem = [self selectedItem];
			 [[_items objectAtIndex:selitem] setWaitSpinnerActive:YES];*/
			//NSLog(@"type play");
			break;
	}
	return [super brEventAction:event];
}




@end



