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
+(void)startSlideshowForPath:(NSString *)path
{
    
    NSSet *_set = [NSSet setWithObject:[BRMediaType photo]];
    
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"mediaType == %@",[BRMediaType photo]];
    
    NSArray *assets=[SMImageReturns mediaAssetsForPath:path];
    
    BRDataStore *store = [[BRDataStore alloc] initWithEntityName:@"PhotoStore" predicate:_pred mediaTypes:_set];
    int i;
    for (i=0;i<[assets count];i++)
    {
        [store addObject:[assets objectAtIndex:i]];
    }
    
    BRPhotoControlFactory* controlFactory = [BRPhotoControlFactory standardFactory];
    SMPhotoCollectionProvider* provider    = [SMPhotoCollectionProvider providerWithDataStore:store controlFactory:controlFactory];//[[ATVSettingsFacade sharedInstance] providerForScreenSaver];//[collection provider];
    
    SMPhotoBrowserController* controller4  = [SMPhotoBrowserController controllerForProvider:provider];
    [controller4 setTitle:[[SMPreferences stringForKey:path] lastPathComponent]];
    //[controller4 setColumnCount:2];
    [controller4 removeSButton];
    [[[BRApplicationStackManager singleton] stack] pushController:controller4];
}
+(void)startSlideshow
{
    [SMPreferences setString:@"SlideShow" forKey:@"SlideShowType"];
    
    
    
    NSSet *_set = [NSSet setWithObject:[BRMediaType photo]];
    
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"mediaType == %@",[BRMediaType photo]];
    
    NSArray *assets=[SMImageReturns mediaAssetsForPath:[SMPreferences stringForKey:PHOTO_DIRECTORY_KEY]];
    BRDataStore *store = [[BRDataStore alloc] initWithEntityName:@"Hello" predicate:_pred mediaTypes:_set];
    int i =0;
    for (i=0;i<[assets count];i++)
    {
        [store addObject:[assets objectAtIndex:i]];
    }
    
    
    BRPhotoControlFactory* controlFactory = [BRPhotoControlFactory standardFactory];
    SMPhotoCollectionProvider* provider    = [SMPhotoCollectionProvider providerWithDataStore:store controlFactory:controlFactory];//[[ATVSettingsFacade sharedInstance] providerForScreenSaver];//[collection provider];
    
    id controller4  = [SMPhotoBrowserController controllerForProvider:provider];
    [controller4 setTitle:[[SMPreferences stringForKey:PHOTO_DIRECTORY_KEY] lastPathComponent]];
    [controller4 setColumnCount:2];
    [controller4 removeSButton];
    
    [[[BRApplicationStackManager singleton] stack] pushController:controller4]; 
}

+ (id)photosForPath:(NSString *)thepath
{
	NSArray *coverArtExtention = [[NSArray alloc] initWithObjects:
								  @"jpg",
								  @"JPG",
								  @"jpeg",
								  @"tif",
								  @"tiff",
								  @"png",
								  @"gif",
								  nil];
	NSFileManager *fileManager = [NSFileManager defaultManager];
	long i, count = [[fileManager directoryContentsAtPath:thepath] count];	
	NSMutableArray *photos =[NSMutableArray arrayWithObjects:nil];
	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [[fileManager directoryContentsAtPath:thepath] objectAtIndex:i];
		if([coverArtExtention containsObject:[[idStr pathExtension] lowercaseString]])
		{
			Class cls = NSClassFromString( @"BRPhotoMediaAsset" );
			id asset = [[cls alloc] init];
			//NSLog(@"%@",[thepath stringByAppendingPathComponent:idStr]);
			[asset setFullURL:[thepath stringByAppendingPathComponent:idStr]];
			[asset setThumbURL:[thepath stringByAppendingPathComponent:idStr]];
			[asset setCoverArtURL:[thepath stringByAppendingPathComponent:idStr]];
			//[asset setDateTaken:[NSDate dateWithString:@"2009-04-04T22:02:28Z"]];
			[asset setIsLocal:YES];
			[photos addObject:asset];
            NSLog(@"path: %@",[thepath stringByAppendingPathComponent:idStr]);
		}
		else 
		{
			//NSLog(@"idStr not added: %@",idStr);
		}
		
	}
	return (NSArray *)photos;
}

- (id)previewControlForItem:(long)arg1
{
    if (arg1<[_items count]) {
        SMFBaseAsset *asset=[[SMFBaseAsset alloc] init];
        [asset setTitle:[[_items objectAtIndex:arg1] title]];
        [asset setSummary:[settingDescriptions objectAtIndex:arg1]];
        [asset setCoverArt:[[BRThemeInfo sharedTheme] photosImage]];
        SMFMediaPreview *preview = [[SMFMediaPreview alloc]init];
        [preview setAsset:asset];
        return preview;
        
    }
    else if (arg1<([_itemsFavs count]+[_items count])) {
        int row=arg1-[_items count];
        
        SMFBaseAsset *asset=[[SMFBaseAsset alloc]init];
        [asset setTitle:[[_items objectAtIndex:row] title]];
        [asset setCoverArt:[SMPhotoPreview firstPhotoForPath:[_optionsFavs objectAtIndex:row]]];
        
        
//        SMFBaseAsset *asset=[[SMFBaseAsset alloc] init];
//        [asset setTitle:[[_itemsFavs objectAtIndex:row] title]];
//        [asset setCoverArt:[SMPhotoPreview firstPhotoForPath:[_optionsFavs objectAtIndex:row]]];
//        //[asset setSummary:];
//        SMFMediaPreview *preview = [[SMFMediaPreview alloc]init];
        SMFMediaPreview *preview = [[SMFMediaPreview alloc]init];
        [preview setAsset:asset];
        return preview;
    }
    else if (arg1<([_itemsFavs count]+[_items count]+[_itemsFolders count])) {
        int row=arg1-[_items count]-[_itemsFavs count];
        SMFBaseAsset *asset=[[SMFBaseAsset alloc] init];
        [asset setTitle:[[_itemsFolders objectAtIndex:row] title]];
        [asset setCoverArt:[[BRThemeInfo sharedTheme]photosImage]];
        //[asset setSummary:];
        SMFMediaPreview *preview = [[SMFMediaPreview alloc]init];
        [preview setAsset:asset];
        return preview;
    }
    
    return nil;
}
-(long)itemCount
{
    return (long)([_items count]+[_itemsFavs count]+[_itemsFolders count]);
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
	
	
	_items = [[NSMutableArray alloc] init];
    int i,count=[settingNames count];
    for(i=0;i<count;i++)
    {
        BRTextMenuItemLayer *item=[BRTextMenuItemLayer folderMenuItem];
        [item setTitle:[settingDisplays objectAtIndex:i]];
        [_items addObject:item];
        [_options addObject:[settingNumberType objectAtIndex:i]];
    }
	_dividers = [[NSMutableDictionary alloc] initWithObjectsAndKeys:nil];
	_man = [NSFileManager defaultManager];
	paths = [[NSMutableArray alloc] initWithObjects:nil];
	_tempPath = nil;
	[self setListIcon:[[BRThemeInfo sharedTheme] photosImage] horizontalOffset:0.5f kerningFactor:0.2f];
    //NSString *a =[SMPreferences slideshowType];
    //NSLog(a);
    //[a writeToFile:@"/Users/frontrow/a.txt" atomically:YES];
    [self loadFolders];
	return self;
}
-(void)loadFolders
{
    [[self list] removeDividers];
    [[self list] addDividerAtIndex:[_items count] withLabel:@"Current"];
    BRTextImageMenuItemLayer *item = [BRTextImageMenuItemLayer twoLineFolderMenuItem];
    
    [_itemsFavs release];
    _itemsFavs =[[NSMutableArray alloc]init];
    [_optionsFavs release];
    _optionsFavs=[[NSMutableArray alloc] init];
    [_itemsFolders release];
    _itemsFolders =[[NSMutableArray alloc]init];
    [_optionsFolders release];
    _optionsFolders =[[NSMutableArray alloc]init];
    
    NSString *path=[SMPreferences photoFolderPath];
    [item setTitle:BRLocalizedString(@"Current Folder",@"Current Folder")];
    //NSNumber *numberofPhotos = [SMPhotoPreview numberOfPhotosForPath:currentPath];
    [item setSubtitle:path];
    [item setLoadsThumbnails:NO];
    [item setThumbnailImage:[SMPhotoPreview firstPhotoForPath:path]];
    [_itemsFavs addObject:item];
    [_optionsFavs addObject:path];
    
    item=[BRTextImageMenuItemLayer twoLineFolderMenuItem];
    NSString *ssfolder = [SMPreferences screensaverFolder];
    [item setTitle:BRLocalizedString(@"Screensaver Folder",@"Screensaver Folder")];
    [item setSubtitle:ssfolder];
    [item setLoadsThumbnails:NO];
    [item setThumbnailImage:[SMPhotoPreview firstPhotoForPath:ssfolder]];
    [_itemsFavs addObject:item];
    [_optionsFavs addObject:ssfolder];
    
    NSArray *favorites = [SMPreferences photoFavorites];
    NSFileManager *man = [NSFileManager defaultManager];
    int i,count=[favorites count];
    if (count>0) {
        [[self list] addDividerAtIndex:([_items count]+[_itemsFavs count]) withLabel:@"Favorites"];

        for(i=0;i<count;i++)
        {
            NSString *folder=[favorites objectAtIndex:i];
            if([man fileExistsAtPath:folder])
            {
                item=[BRTextImageMenuItemLayer twoLineFolderMenuItem];
                [item setTitle:[folder lastPathComponent]];
                [item setSubtitle:ssfolder];
                [item setLoadsThumbnails:NO];
                [item setThumbnailImage:[SMPhotoPreview firstPhotoForPath:folder]];
                [_itemsFavs addObject:item];
                [_optionsFavs addObject:folder];
            }
            
            
        }
    }
    [[self list] addDividerAtIndex:([_items count]+[_itemsFavs count]) withLabel:@"Folders"];
    item=[BRTextImageMenuItemLayer twoLineFolderMenuItem];
    [item setTitle:[NSHomeDirectory() lastPathComponent]];
    [item setSubtitle:NSHomeDirectory()];
    [item setThumbnailImage:[SMPhotoPreview firstPhotoForPath:NSHomeDirectory()]];
    [_itemsFolders addObject:item];
    [_optionsFolders addObject:NSHomeDirectory()];
    NSArray *folders=[man directoryContentsAtPath:@"/Volumes"];
    count=[folders count];
    for(i=0;i<count;i++)
    {
        NSString *folder=[folders objectAtIndex:i];
        item=[BRTextImageMenuItemLayer twoLineFolderMenuItem];
        [item setTitle:[folder lastPathComponent]];
        [item setSubtitle:[@"/Volumes/" stringByAppendingPathComponent:folder]];
        if([SMGeneralMethods isLocalDrive:[@"/Volumes/" stringByAppendingPathComponent:folder]])
            [item setThumbnailImage:[SMPhotoPreview firstPhotoForPath:[@"/Volumes/" stringByAppendingPathComponent:folder]]];
        else {
            [item setThumbnailImage:[[BRThemeInfo sharedTheme]networkPhotosImage]];
        }

        [_itemsFolders addObject:item];
        [_optionsFolders addObject:[@"/Volumes/" stringByAppendingPathComponent:folder]];
        
    }
    
    
}
//-(id)initCustom
//{
//	NSLog(@"initCustom");
//	[_items removeAllObjects];
//	[paths removeAllObjects];
//	[_dividers removeAllObjects];
//	[[self list] removeDividers];
//	
//	int i,counter;
//	i=[settingNames count];
//	for(counter=0;counter<i;counter++)
//	{
//		BRTextMenuItemLayer *item =[[BRTextMenuItemLayer alloc]init];
//		[item setTitle:[settingDisplays objectAtIndex:counter]];
//		[_options addObject:[NSArray arrayWithObjects:[settingType objectAtIndex:counter],[settingNames objectAtIndex:counter],[settingDisplays objectAtIndex:counter],nil]];
//		[_items addObject:item];
//		[paths addObject:@"nil"];
//		
//	}
//	NSFileManager *fileManager = [NSFileManager defaultManager];
//	BOOL isDir;
//	[_dividers setObject:[NSNumber numberWithInt:[_items count]] forKey:@"Current Photo Folder"];
//    
//	NSString *currentPath = [SMPreferences photoFolderPath];
    
//    BRTextImageMenuItemLayer *current_item = [BRTextImageMenuItemLayer twoLineFolderMenuItem];
//    [current_item setTitle:[SMPreferences photoFolderPath]];
//    NSNumber *numberofPhotos = [SMPhotoPreview numberOfPhotosForPath:currentPath];
//    [current_item setSubtitle:[NSString stringWithFormat:@"(%@) Images in folder",numberofPhotos]];
//    [current_item setLoadsThumbnails:NO];
//    [current_item setThumbnailImage:[SMPhotoPreview firstPhotoForPath:currentPath]];
//		[_items addObject:current_item];
//		[paths addObject:currentPath];
//    
//    
//    [_dividers setObject:[NSNumber numberWithInt:[_items count]] forKey:@"Current Screensaver Folder"];
//    NSString *ssfolder = [SMPreferences screensaverFolder];
//    BRTextImageMenuItemLayer *current_items = [BRTextImageMenuItemLayer twoLineFolderMenuItem];
//    [current_items setTitle:ssfolder];
//    NSNumber *numberofPhotoss = [SMPhotoPreview numberOfPhotosForPath:ssfolder];
//    [current_items setSubtitle:[NSString stringWithFormat:@"(%@) Images in folder",numberofPhotoss]];
//    [current_items setLoadsThumbnails:NO];
//    [current_items setThumbnailImage:[SMPhotoPreview firstPhotoForPath:ssfolder]];
//    [_items addObject:current_items];
//    [paths addObject:ssfolder];
//    
//    
//    
//	[_dividers setObject:[NSNumber numberWithInt:[_items count]] forKey:@"Favorites"];
//    
//	NSMutableArray *favorites = [[NSMutableArray alloc] initWithObjects:nil];
//	[favorites addObjectsFromArray:[SMGeneralMethods arrayForKey:PHOTO_FAVORITES]];
//
//	NSEnumerator *objEnum = [favorites objectEnumerator];
//	id obj;
//	while((obj = [objEnum nextObject]) != nil)
//	{
//		if([fileManager fileExistsAtPath:obj isDirectory:&isDir] &&isDir)
//		{
// 			NSNumber *numberOfPhotos = [SMPhotoPreview numberOfPhotosForPath:obj];
//			BRTextImageMenuItemLayer * favoritesLayer = [BRTextImageMenuItemLayer twoLineFolderMenuItem];
//			[favoritesLayer setTitle:obj];
//			[favoritesLayer setSubtitle:[NSString stringWithFormat:@"(%@)",numberOfPhotos,nil]];
//			if([numberOfPhotos intValue] == 0)	{[favoritesLayer setThumbnailImage:[[BRThemeInfo sharedTheme] missingImage]];}
//			else								{[favoritesLayer setThumbnailImage:[SMPhotoPreview firstPhotoForPath:obj]];}
//
//			[_items addObject:favoritesLayer];
//			[paths addObject:obj];
//		}
//	}
//	
//	[_dividers setObject:[NSNumber numberWithInt:[_items count]] forKey:@"Volumes"];
//	
//	
//	NSString *thepath = @"/Volumes/";
//	long ii, count = [[fileManager directoryContentsAtPath:thepath] count];	
//	for ( ii = 0; ii < count; ii++ )
//	{
//		NSString *idStr = [[fileManager directoryContentsAtPath:thepath] objectAtIndex:ii];
//		if([fileManager fileExistsAtPath:[thepath stringByAppendingPathComponent:idStr] isDirectory:&isDir] &&isDir && ![idStr isEqualToString:@"OSBoot"])
//		{
//			NSNumber *numberOfPhotos = [SMPhotoPreview numberOfPhotosForPath:[thepath stringByAppendingPathComponent:idStr]];
//			BRTextImageMenuItemLayer * mountsLayer = [BRTextImageMenuItemLayer twoLineFolderMenuItem];
//			[mountsLayer setTitle:[thepath stringByAppendingPathComponent:idStr]];
//			[mountsLayer setSubtitle:[NSString stringWithFormat:@"(%@)",numberOfPhotos,nil]];
//			if([numberOfPhotos intValue] == 0)	{[mountsLayer setThumbnailImage:[[BRThemeInfo sharedTheme] missingImage]];}
//			else								{[mountsLayer setThumbnailImage:[SMPhotoPreview firstPhotoForPath:[thepath stringByAppendingPathComponent:idStr]]];}
//			[_items addObject:mountsLayer];
//			[paths addObject:[thepath stringByAppendingPathComponent:idStr]];
//		}
//	}
//	[_dividers setObject:[NSNumber numberWithInt:[_items count]] forKey:@"Folders"];
//	if([fileManager fileExistsAtPath:@"/Users/frontrow/Pictures" isDirectory:&isDir] && isDir)
//	{
//		NSNumber *numberOfPhotos = [SMPhotoPreview numberOfPhotosForPath:@"/Users/frontrow/Pictures"];
//
//		BRTextImageMenuItemLayer * picturesLayer = [BRTextImageMenuItemLayer twoLineFolderMenuItem];
//		[picturesLayer setTitle:@"~/frontrow/Pictures"];
//		[picturesLayer setSubtitle:[NSString stringWithFormat:@"(%@)",[SMPhotoPreview numberOfPhotosForPath:@"/Users/frontrow/Pictures"]]];
//		if([numberOfPhotos intValue] == 0)	{[picturesLayer setThumbnailImage:[[BRThemeInfo sharedTheme] missingImage]];}
//		else								{[picturesLayer setThumbnailImage:[SMPhotoPreview firstPhotoForPath:@"/Users/frontrow/Pictures"]];}
//		[_items addObject:picturesLayer];
//		[paths addObject:@"/Users/frontrow/Pictures"];
//	}
//	NSNumber *numberOfPhotos = [SMPhotoPreview numberOfPhotosForPath:@"/Users/frontrow"];
//
//	BRTextImageMenuItemLayer * homeLayer = [BRTextImageMenuItemLayer twoLineFolderMenuItem];
//	[homeLayer setTitle:@"~/frontrow"];
//	[homeLayer setSubtitle:[NSString stringWithFormat:@"(%@)",[SMPhotoPreview numberOfPhotosForPath:@"/Users/frontrow/"]]];
//	[_items addObject:homeLayer];
//	[paths addObject:[@"/Users/frontrow" stringByExpandingTildeInPath]];
//	if([numberOfPhotos intValue] == 0)	{[homeLayer setThumbnailImage:[[BRThemeInfo sharedTheme] missingImage]];}
//	else								{[homeLayer setThumbnailImage:[SMPhotoPreview firstPhotoForPath:@"/Users/frontrow"]];}
//	id list = [self list];
//	//[[self list] addDividerAtIndex:8 withLabel:BRLocalizedString(@"Installs",@"Installs")];
//	//[[self list] addDividerAtIndex:0 withLabel:BRLocalizedString(@"Restart Finder",@"Restart Finder")];
//	[list setDatasource: self];
//    [[self list] addDividerAtIndex:[[_dividers valueForKey:@"Current Photo Folder"] intValue] withLabel:@"Current Photo Folder"];
//	if([[_dividers valueForKey:@"Favorites"]intValue] != [[_dividers valueForKey:@"Current Screensaver Folder"]intValue])
//		[[self list] addDividerAtIndex:[[_dividers valueForKey:@"Current Screensaver Folder"]intValue] withLabel:@"Current Screensaver Folder"];
//	if([[_dividers valueForKey:@"Volumes"]intValue] != [[_dividers valueForKey:@"Favorites"]intValue])
//		[[self list] addDividerAtIndex:[[_dividers valueForKey:@"Favorites"]intValue] withLabel:@"Favorites"];
//	if([[_dividers valueForKey:@"Folders"]intValue] != [[_dividers valueForKey:@"Volumes"]intValue])
//		[[self list] addDividerAtIndex:[[_dividers valueForKey:@"Volumes"]intValue] withLabel:@"Volumes"];
//	[[self list] addDividerAtIndex:[[_dividers valueForKey:@"Folders"]intValue] withLabel:@"Folders"];
//	return self;
//}
-(void)itemSelected:(long)row
{
	NSString *theDir = nil;
	if(row>=[settingNames count])
	{
        NSString *folderN;
        if (row<([_items count]+[_itemsFavs count])) {
            
            folderN = [_optionsFavs objectAtIndex:(row-[_items count])];
            NSLog(@"itemsFavs %@",[_optionsFavs objectAtIndex:(row-[_items count])]);
        }
        else if (row<([_items count]+[_itemsFavs count]+[_itemsFolders count])) {
            NSLog(@"folders");
            folderN= [_optionsFolders objectAtIndex:(row-[_items count]-[_optionsFavs count])];
        }
        NSLog(@"folder: %@",folderN);
		SMFFolderBrowser *folder = [[SMFolderBrowser alloc] init];
		[folder setPath:folderN];
		//[folder initCustom];
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
				theDir = [SMPreferences stringForKey:@"PhotoDirectory"];
				if([_man fileExistsAtPath:theDir isDirectory:&isDir] && isDir){}
				else{
					//NSLog(@"setDefault");
					theDir = DEFAULT_IMAGES_PATH;
				}

				if([[SMPreferences stringForKey:@"SlideShowType"] isEqualToString:@"Floating Images"])
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
                    [SMPhotosMenu startSlideshow];
				}
				break;
			case kSMSSSettings:
				isDir =NO;
                BRSlideshowSettingsMusicController *a = [[BRSlideshowSettingsMusicController alloc] init];
				[[self stack] pushController:a];
                
				break;
			case kSMSSCustomSettings:
				isDir = NO;
				SMPhotosSettingsMenuNew *cusSettings = [[SMPhotosSettingsMenuNew alloc] init];
				//[cusSettings initCustom];
				[[self stack] pushController:cusSettings];
                [cusSettings release];
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
-(void)textDidChange:(NSNotification *)notification
{
    NSLog(@"text is changing");
}
-(void)textDidEndEditing:(id)sender
{
    int z=kSMSSSSlideTime;
    [[self stack] popController];
    NSLog(@"returngType: %i, expected: %i, value: %i %i ",z,kSMSSSSlideTime,[[sender stringValue]intValue],0);
    switch (z) {
        case kSMSSSSlideTime:
        {
            NSLog(@"returnVal: %i",[[sender stringValue] intValue]);
            int value=[[sender stringValue] intValue];
            //[SMPreferences setInteger:value forKey:PHOTO_SPIN_FREQUENCY];
            [[ATVSettingsFacade singleton] setScreenSaverSecondsPerSlide:value];
            //NSLog(@"secondsPerSlide: %i",[[ATVSettingsFacade singleton] screenSaverSecondsPerSlide]);
            break; 
        }
        default:
            break;
    }
}
/*- (float)heightForRow:(long)row				{ return 0.0f; }
- (BOOL)rowSelectable:(long)row				{ return YES;}
- (long)itemCount							{ return (long)[_items count];}*/
//- (id)itemForRow:(long)row					
//{ 
//	//NSLog(@"itemForRow");
//	if(row >= [_items count])
//		return nil;
//	if(row == [settingNames count])
//	{
//		//NSLog(@"row three");
//		BRTextImageMenuItemLayer *theitem = [_items objectAtIndex:row];
//		[theitem setTitle:[SMPreferences photoFolderPath]];
//		[theitem setThumbnailImage:[SMPhotoPreview firstPhotoForPath:[SMPreferences photoFolderPath]]];
//		return theitem;
//	}
//	if(row >[settingNames count])
//	{
//		BRTextImageMenuItemLayer *theitem = [_items objectAtIndex:row];
//        //[theitem setThumbnailImage:[SMPhotoPreview firstPhotoForPath:[paths objectAtIndex:row]]];
//		return theitem;
//
//	}
//	//NSLog(@"after special");
//	BRTextMenuItemLayer *item  = nil;
//	switch (row) {
//		case 0:
//			//NSLog(@"PhotoController");
//			item = [BRTextMenuItemLayer menuItem];
//			[item setTitle:[settingDisplays objectAtIndex:row]];
//			break;
//		case 1:
//			//NSLog(@"PhotoController");
//			item = [BRTextMenuItemLayer menuItem];
//			[item setTitle:[settingDisplays objectAtIndex:row]];
//			break;
//		case 2:
//			item = [BRTextMenuItemLayer menuItem];
//			[item setTitle:[settingDisplays objectAtIndex:row]];
//			break;
//		case 3:
//			item = [BRTextMenuItemLayer menuItem];
//			[item setTitle:[settingDisplays objectAtIndex:row]];
//        case 4:
//            item = [BRTextMenuItemLayer menuItem];
//			[item setTitle:[settingDisplays objectAtIndex:row]];
//		default:
//            item = [BRTextMenuItemLayer menuItem];
//			[item setTitle:[settingDisplays objectAtIndex:row]];
//			break;
//	}
//	return item;
//		
//	//return [_items objectAtIndex:row]; 
//}
-(id)itemForRow:(long)row
{
//    NSLog(@"row: %i",row);
    if (row<[_items count]) {
        return [_items objectAtIndex:row];
    }
    else if(row<([_items count]+[_itemsFavs count])){
        int realrow=row-[_items count];
        return [_itemsFavs objectAtIndex:realrow];
    }
    else if(row<([_items count]+[_itemsFavs count]+[_itemsFolders count])){
        int realrow=row-[_items count]-[_itemsFavs count];
        return [_itemsFolders objectAtIndex:realrow];
    }

    return nil;
}
-(void)wasExhumed
{
	//[self initCustom];
    [self loadFolders];
	[[self list] reload];
}

//- (BOOL)brEventAction:(BREvent *)event
//{
//	int remoteAction =[event remoteAction];
//	
//	if ([(BRControllerStack *)[self stack] peekController] != self)
//		return [super brEventAction:event];
//	NSLog(@"event: %i, value: %i",remoteAction, [event value]);
//
//	if([event value] == 0)
//		return [super brEventAction:event];
//	if(![[SMGeneralMethods sharedInstance] usingTakeTwoDotThree] && remoteAction>1)
//		remoteAction ++;
//	long row = [self getSelection];
//	//NSMutableArray *favorites = nil;
//	switch (remoteAction)
//	{
//		case kSMRemoteUp:  // tap up
//			NSLog(@"type up");
//			break;
//		case kSMRemoteDown:  // tap down
//			NSLog(@"type down");
//			break;
//		case kSMRemoteLeft:  // tap left
//        case kSMRemoteRight:
//        {
//            NSLog(@"type Left");
//            if(row>=[settingNames count])
//            {
//                //[[SMBrowserOptions alloc ]initWithPath:[paths objectAtIndex:row]];
//                [[self stack]pushController:[[SMBrowserOptions alloc ]initWithPath:[paths objectAtIndex:row]]];
//            }
//            break;
//        }
//             
//            
//            
//            
//            
////        case kBREventRemoteActionRight:  // tap right
////            NSLog(@"type right");
////            if(row>=[settingNames count])
////            {
////                [SMGeneralMethods setString:[paths objectAtIndex:row] forKey:@"PhotoDirectory"];
////                [_tempPath release];
////                _tempPath = [paths objectAtIndex:row];
////                [_tempPath retain];
////                //[self initCustom];
////                [[self list] reload];
////			}
////            
////			break;
//		case kSMRemotePlay:  // tap play
//			/*selitem = [self selectedItem];
//			 [[_items objectAtIndex:selitem] setWaitSpinnerActive:YES];*/
//			NSLog(@"type play");
//			break;
//        case kBREventRemoteActionPlayHold:
//        {
//            [[self stack]pushController:[[SMUpdaterMenu alloc]init]];
//            break;
//        }
//	}
//	return [super brEventAction:event];
//}

- (id)titleForRow:(long)row					
{ 
    if(row<[_items count])
        return [[_items objectAtIndex:row] title];
    else if (row<([_items count]+[_itemsFavs count])) {
        return [[_itemsFavs objectAtIndex:(row - [_items count])]title];
    }
    else if (row<([_items count]+[_itemsFavs count]+[_itemsFolders count])) {
        return [[_itemsFolders objectAtIndex:(row - [_items count]-[_itemsFavs count])]title];
    }
    return nil;
}


@end



