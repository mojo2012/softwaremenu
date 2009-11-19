//
//  SMTweaks.m
//  SoftwareMenu
//
//  Created by Thomas on 3/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SMPhotosMenu.h"
#include <sys/param.h>
#include <sys/mount.h>
#include <stdio.h>
#import <objc/objc-class.h>

#define SCREEN_SAVER_PATH @"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SM.frss"
#define DEFAULT_IMAGES_PATH		@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/DefaultPhotos/"


@implementation BRImageProxyProvider (protectedAccess)
-(NSArray *)gimmeImages {
	Class klass = [self class];
	Ivar ret = class_getInstanceVariable(klass, "_images");
	return *(NSArray * *)(((char *)self)+ret->ivar_offset);
}
@end

@implementation SMPhotosMenu

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
        id preview = [[BRMediaParadeControl alloc] init];
        [preview setImageProxies:[SMImageReturns imageProxiesForPath:[SMGeneralMethods stringForKey:PHOTO_DIRECTORY_KEY]]];
        return [preview autorelease];
	}
	else if(item >= [settingNames count])
	{
//		SMMedia	*meta = [[SMMedia alloc] init];
//		[meta setTitle:(NSString *)[[_items objectAtIndex:item] title]];
//		[meta setBRImage:[SMPhotoPreview firstPhotoForPath:[paths objectAtIndex:item]]];
//		SMMediaPreview *preview =[[SMMediaPreview alloc] init];
//		[preview setAsset:meta];
        id preview = [[BRMediaParadeControl alloc] init];
        //[preview setMissingAssetType:[BRMediaType photo]];
        [preview setImageProxies:[SMImageReturns imageProxiesForPath:[paths objectAtIndex:item]]];
        return [preview autorelease];
		//return [preview autorelease];

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
			
		}
		SMMediaPreview *preview =[[SMMediaPreview alloc] init];
		[preview setShowsMetadataImmediately:YES];
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
					@"smSlideshowSettings",
                    @"screensaverOptions",
                    @"startscreensaver",
					nil];
	settingDisplays = [[NSMutableArray alloc] initWithObjects:
					   BRLocalizedString(@"About",@"About"),
					   BRLocalizedString(@"Start Slideshow",@"Start Slideshow"),
					   //BRLocalizedString(@"Slideshow Settings",@"Slideshow Settings"),
					   BRLocalizedString(@"Slideshow Settings",@"Slideshow Settings"),
                       BRLocalizedString(@"Screensaver Settings",@"Screensaver Settings"),
                       BRLocalizedString(@"Start ScreenSaver",@"Start ScreenSaver"),
					   nil];
	settingDescriptions = [[NSMutableArray alloc] initWithObjects:
						   @"Explains everything you need to know about the slideshow functionality",
						   @"Starts the slideshow",
						   //@"Settings from apple Photos menu",
						   @"Settings For Slideshow",
                           @"Settings For Screensaver",
                           @"Start Screensaver",
						   nil];
	settingNumberType = [[NSMutableArray alloc] initWithObjects:
						 [NSNumber numberWithInt:0],
						 [NSNumber numberWithInt:1],
						 //[NSNumber numberWithInt:2],
						 [NSNumber numberWithInt:3],
                         [NSNumber numberWithInt:5],
                         [NSNumber numberWithInt:4],
						 nil];
	
	
	_items = [[NSMutableArray alloc] initWithObjects:nil];
	_dividers = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
	_man = [NSFileManager defaultManager];
	paths = [[NSMutableArray alloc] initWithObjects:nil];
	_tempPath = nil;
	[self setListIcon:[[BRThemeInfo sharedTheme] photosImage] horizontalOffset:0.5f kerningFactor:0.2f];
    //NSString *a =[SMPreferences slideshowType];
    //NSLog(a);
    //[a writeToFile:@"/Users/frontrow/a.txt" atomically:YES];
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
		[_options addObject:[NSArray arrayWithObjects:[settingType objectAtIndex:counter],[settingNames objectAtIndex:counter],[settingDisplays objectAtIndex:counter],nil]];
		[_items addObject:item];
		[paths addObject:@"nil"];
		
	}
	NSFileManager *fileManager = [NSFileManager defaultManager];
	BOOL isDir;
	[_dividers setObject:[NSNumber numberWithInt:[_items count]] forKey:@"Current"];
	NSString *currentPath = [SMPreferences photoFolderPath];
    
    BRTextImageMenuItemLayer *current_item = [BRTextImageMenuItemLayer twoLineFolderMenuItem];
    [current_item setTitle:[SMGeneralMethods stringForKey:PHOTO_DIRECTORY_KEY]];
    NSNumber *numberofPhotos = [SMPhotoPreview numberOfPhotosForPath:currentPath];
    [current_item setSubtitle:[NSString stringWithFormat:@"(%@) Images in folder",numberofPhotos]];
    [current_item setLoadsThumbnails:YES];
    [current_item setThumbnailImage:[SMPhotoPreview firstPhotoForPath:currentPath]];
		[_items addObject:current_item];
		[paths addObject:currentPath];
    
	[_dividers setObject:[NSNumber numberWithInt:[_items count]] forKey:@"Favorites"];
    
	NSMutableArray *favorites = [[NSMutableArray alloc] initWithObjects:nil];
	[favorites addObjectsFromArray:[SMGeneralMethods arrayForKey:PHOTO_FAVORITES]];

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
				theDir = [SMGeneralMethods stringForKey:@"PhotoDirectory"];
				if([_man fileExistsAtPath:theDir isDirectory:&isDir] && isDir){}
				else{
					//NSLog(@"setDefault");
					theDir = DEFAULT_IMAGES_PATH;
				}

				if([[SMGeneralMethods stringForKey:@"SlideShowType"] isEqualToString:@"Floating Images"])
				{
					//[SMGeneralMethods runHelperApp:[NSArray arrayWithObjects:@"installScreenSaver",@"0",@"0",nil]];
					NSLog(@"wrong SS");
					/*NSString *oldScreenSaver = [[ATVSettingsFacade singleton] screenSaverSelectedPath];
					[[ATVSettingsFacade singleton] setScreenSaverSelectedPath:SCREEN_SAVER_PATH];
					[[ATVScreenSaverManager singleton] showScreenSaver];
					[[ATVSettingsFacade singleton] setScreenSaverSelectedPath:oldScreenSaver];*/
				}
				else
				{
					[SMGeneralMethods setString:@"SlideShow" forKey:@"SlideShowType"];

                    

                    NSSet *_set = [NSSet setWithObject:[BRMediaType photo]];
                    
                    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"mediaType == %@",[BRMediaType photo]];

                    NSArray *assets=[SMImageReturns mediaAssetsForPath:[SMGeneralMethods stringForKey:PHOTO_DIRECTORY_KEY]];
                    BRDataStore *store = [[BRDataStore alloc] initWithEntityName:@"Hello" predicate:_pred mediaTypes:_set];
                    int i =0;
                    for (i=0;i<[assets count];i++)
                    {
                        [store addObject:[assets objectAtIndex:i]];
                    }
                    
                     
                    BRPhotoControlFactory* controlFactory = [BRPhotoControlFactory standardFactory];
                    SMPhotoCollectionProvider* provider    = [SMPhotoCollectionProvider providerWithDataStore:store controlFactory:controlFactory];//[[ATVSettingsFacade sharedInstance] providerForScreenSaver];//[collection provider];

                    id controller4  = [SMPhotoBrowserController controllerForProvider:provider];
                    [controller4 setTitle:[[SMGeneralMethods stringForKey:PHOTO_DIRECTORY_KEY] lastPathComponent]];
                    [controller4 setColumnCount:2];
                    [controller4 removeSButton];
                    
                    [[self stack] pushController:controller4];
				}
				break;
			case kSMSSSettings:
				isDir =NO;
                BRSlideshowSettingsMusicController *a = [[BRSlideshowSettingsMusicController alloc] init];
				[[self stack] pushController:a];
                
				break;
			case kSMSSCustomSettings:
				isDir = NO;
				SMPhotosSettingsMenu *cusSettings = [[SMPhotosSettingsMenu alloc] init];
				[cusSettings initCustom];
				[[self stack] pushController:cusSettings];
				break;
            case 4:
            {
                [[ATVSettingsFacade singleton] setScreenSaverSelectedPath:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/SMM.frss/"];
                [[ATVScreenSaverManager singleton] showScreenSaver];
                break;
            }
            case 5:
            {
                id a =[[SMScreensaverSettingsMenu alloc] init];
                //[a initCustom];
                [[self stack] pushController:a];
                break;
            }
				
				
				
				
				
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
		//NSLog(@"row three");
		BRTextImageMenuItemLayer *theitem = [_items objectAtIndex:row];
		[theitem setTitle:[SMPreferences photoFolderPath]];
		[theitem setThumbnailImage:[SMPhotoPreview firstPhotoForPath:[SMPreferences photoFolderPath]]];
		return theitem;
	}
	if(row >[settingNames count])
	{
		BRTextImageMenuItemLayer *theitem = [_items objectAtIndex:row];
        //[theitem setThumbnailImage:[SMPhotoPreview firstPhotoForPath:[paths objectAtIndex:row]]];
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
        case 4:
            item = [BRTextMenuItemLayer menuItem];
			[item setTitle:[settingDisplays objectAtIndex:row]];
		default:
            item = [BRTextMenuItemLayer menuItem];
			[item setTitle:[settingDisplays objectAtIndex:row]];
			break;
	}
	return item;
		
	//return [_items objectAtIndex:row]; 
}

-(void)wasExhumed
{
	[self initCustom];
	[[self list] reload];
}

- (BOOL)brEventAction:(BREvent *)event
{
	int remoteAction =[event remoteAction];
	
	if ([(BRControllerStack *)[self stack] peekController] != self)
		return [super brEventAction:event];
	NSLog(@"event: %i, value: %i",remoteAction, [event value]);

	if([event value] == 0)
		return [super brEventAction:event];
	if(![[SMGeneralMethods sharedInstance] usingTakeTwoDotThree] && remoteAction>1)
		remoteAction ++;
	long row = [self getSelection];
	//NSMutableArray *favorites = nil;
	switch (remoteAction)
	{
		case kSMRemoteUp:  // tap up
			NSLog(@"type up");
			break;
		case kSMRemoteDown:  // tap down
			NSLog(@"type down");
			break;
		case kSMRemoteLeft:  // tap left
        {
            NSLog(@"type Left");
            if(row>=[settingNames count])
            {
                NSMutableArray *favorites = [[SMPreferences photoFavorites] mutableCopy];
                if([favorites containsObject:[paths objectAtIndex:row]])
                {
                    [favorites removeObjectAtIndex:[favorites indexOfObject:[paths objectAtIndex:row]]];
                    [paths removeObjectAtIndex:row];
                    [_items removeObjectAtIndex:row];
                    [SMPreferences setPhotoFavorites:favorites];
                    [[self list] reload];
                }
                break;
            }
            
        }
             
            
            
            
            
        case kBREventRemoteActionRight:  // tap right
            NSLog(@"type right");
            if(row>=[settingNames count])
            {
                [SMGeneralMethods setString:[paths objectAtIndex:row] forKey:@"PhotoDirectory"];
                [_tempPath release];
                _tempPath = [paths objectAtIndex:row];
                [_tempPath retain];
                //[self initCustom];
                [[self list] reload];
			}
            
			break;
		case kSMRemotePlay:  // tap play
			/*selitem = [self selectedItem];
			 [[_items objectAtIndex:selitem] setWaitSpinnerActive:YES];*/
			NSLog(@"type play");
			break;
	}
	return [super brEventAction:event];
}




@end



