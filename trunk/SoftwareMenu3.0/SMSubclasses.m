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
//This is what happens normally when you select an image
/*-(void)_handleSelection:(id)arg1
{
 //Example of how to get image information
    NSLog(@"arg1: %@",arg1);
    NSLog(@"arg1 provider: %@",[arg1 imageProxy]);
    NSLog(@"arg1 provider object: %@",[[arg1 imageProxy] object]);
    NSLog(@"arg1 provider object fullURL: %@",[[[arg1 imageProxy] object] fullURL]);
    //[self _dumpFocusTree];
}*/
//What happens when you press slideshow button
- (void)_handleSlideshowSelection:(id)arg1
{
    NSMutableDictionary *dict = [[BRSettingsFacade sharedInstance] slideshowPlaybackOptions];
    id someClass = NSClassFromString(@"BRMediaPlayerController");
    //int b;
    id player = [[BRPhotoPlayer alloc ]init ];
    
    [player setPlayerSpecificOptions:dict];
    
    [player setMediaAtIndex:0 inCollection:[SMImageReturns photoCollectionForPath:[SMPreferences photoFolderPath]] error:nil];
    
    id controller_two = [someClass controllerForPlayer:player];
    [[self stack] pushController:controller_two];
}

//Nothing Really
- (void)removeSButton
{
    [_slideshowButton setText:@"Play"];
}
@end
@implementation SMPhotoCollectionProvider
//Adding something to return a collection
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
//-(void)setMediaAssets:(id)arg1
//{
//    [_mediaAssets release];
//    [super setMediaAssets:arg1];
//    _mediaAssets=arg1;
//    [_mediaAssets retain];
//    
//}
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
-(id)controlForData:(id)arg1 currentControl:(id)arg2 requestedBy:(id)arg3
{
    id returnObj;
    if([arg1 isKindOfClass:[SMPhotoMediaCollection class]])
    {
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
        returnObj = [[BRAsyncImageControl alloc] init];
        [returnObj setDefaultImage:[[[arg1 dataAtIndex:0]asset] coverArt]];
        [returnObj setAcceptsFocus:NO];
    }
    return returnObj;
}
@end
