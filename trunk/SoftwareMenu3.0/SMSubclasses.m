//
//  SMSubclasses.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/5/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import "SMSubclasses.h"
#define PHOTO_DIRECTORY_KEY		@"PhotoDirectory"





@implementation SMPhotoBrowserController

- (void)_handleSlideshowSelection:(id)arg1
{
//    NSMutableDictionary *dict = [[[BRSettingsFacade singleton] slideshowPlaybackOptions] mutableCopy];
//    BOOL b = [SMPreferences playsMusicInSlideShow];
//    if(b)
//    {
//        NSLog(@"play music");
//    }
   // [dict setObject:@"YES" forKey:@"PlayMusic"];
    
    //id someClass = NSClassFromString(@"BRMediaPlayerController");
    //int b;
   // id player = [[BRPhotoPlayer alloc ]init ];
    
    //[player setPlayerSpecificOptions:dict];
   // NSLog(@"optionsDict: %@",dict);
    //[player setMediaAtIndex:0 inCollection:[SMImageReturns photoCollectionForPath:[SMPreferences photoFolderPath]] error:nil];
    
   // id controller_two = [someClass controllerForPlayer:player];
    //BRPhotoControlFactory* controlFactory = [BRPhotoControlFactory standardFactory];
    //SMPhotoCollectionProvider* provider    = [SMPhotoCollectionProvider providerWithDataStore:[SMImageReturns dataStoreForPath:[SMPreferences photoFolderPath]] controlFactory:controlFactory];
    id controller_three = [BRFullScreenPhotoController fullScreenPhotoControllerForProvider:_provider startIndex:0];
    [[self stack] pushController:controller_three];
    [controller_three _startSlideshow];
    //[[BRMediaPlayerManager singleton] presentMediaAssetAtIndex:0 inCollection:[SMImageReturns photoCollectionForPath:[SMPreferences photoFolderPath]] options:nil];
    //[[BRFullScreenPhotoController fullScreenPhotoControllerForProvider: startIndex:0] ]
}

//Nothing Really
- (void)removeSButton
{
    [_slideshowButton setText:@"Play"];
}
@end
@implementation SMPhotoCollectionProvider
//Adding something to return a collection
-(BOOL)canHaveZeroData
{
    return NO;
}
-(id)collection
{
    BRPhotoMediaCollection *collection = [BRPhotoMediaCollection collectionWithCollectionInfo:[NSDictionary dictionary]];
    [collection setMediaAssets:[[self dataStore] data]];
    [collection setCollectionName:@"PhotoCollection"];
    [collection setCollectionType:[BRMediaCollectionType iPhotoFolder]];
    return collection;
}
@end
@implementation SMPhotoMediaCollection
-(id)imageProxy
{
    return [BRPhotoImageProxy imageProxyWithAsset:[self keyAsset]];  
}
-(BOOL)isLocal
{
    return YES;
}
-(id)description
{
    return @"ILOOSE";
}
-(unsigned int)hash
{
    //NSLog(@"blahblah: %@",_mediaAssets);
    return 10;
}
-(int)count
{
    return [[self mediaAssets]count];
}
-(id)provider
{
    //NSLog(@"calling provider");
    return [BRImageProxyProvider providerWithAssets:[self mediaAssets]];
}
-(id)archivableCollectionInfo
{
    return @"200";
}
-(id)collectionID
{
    //NSLog(@"calling collectionID");
    return @"200";
}
@end
@implementation SMPhotoControlFactory
+(id)mainMenuFactory
{
    return [[SMPhotoControlFactory alloc] initForMainMenu:YES];
}
//Returns the control shown on main menu
-(id)controlForData:(id)arg1 currentControl:(id)arg2 requestedBy:(id)arg3
{
    id returnObj;
    //can have different objects and return the proper one
    if([arg1 isKindOfClass:[SMPhotoMediaCollection class]])
    {
        //return a cycler control with images from the datastore
        BRDataStore *store = [SMImageReturns dataStoreForAssets:[arg1 mediaAssets]];
        BRPhotoControlFactory* controlFactory = [BRPhotoControlFactory mainMenuFactory];
        SMPhotoCollectionProvider* provider    = [SMPhotoCollectionProvider providerWithDataStore:store controlFactory:controlFactory];
        returnObj = [BRCyclerControl cyclerWithProvider:provider];
        if([[arg1 mediaAssets]count]>0)
            [returnObj setAcceptsFocus:YES];
        [returnObj setObject:arg1];
        [returnObj setStartIndex:0];
    }
    else if([arg1 isKindOfClass:[BRImageProxyProvider class]])
    {
        //return a simple image
        returnObj = [[BRAsyncImageControl alloc] init];
        [returnObj setDefaultImage:[[[arg1 dataAtIndex:0]asset] coverArt]];
        [returnObj setAcceptsFocus:NO];
    }
    //returning nothing is also acceptable
    return returnObj;
}
@end
