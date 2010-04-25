//
//  SMFPhotoMethods.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 4/25/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMFPhotoMethods.h"

@implementation SMFPhotoMethods
static NSArray *coverArtExtention=nil;
+(void)initialize
{
    coverArtExtention=[[NSArray alloc] initWithObjects:
                       @"jpg",
                       @"jpeg",
                       @"tif",
                       @"tiff",
                       @"png",
                       @"gif",
                       nil];
}
+(NSArray *)mediaAssetsForPath:(id)path
{

    NSArray *contents = [NSFileManager directoryContentsAtPath:path];
	long i, count = [contents count];	
	NSMutableArray *assets =[NSMutableArray array];
	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [contents objectAtIndex:i];
		if([coverArtExtention containsObject:[[idStr pathExtension] lowercaseString]])
		{
			BRPhotoMediaAsset * asset = [[BRPhotoMediaAsset alloc] init];
			[asset setFullURL:[path stringByAppendingPathComponent:idStr]];
			[asset setThumbURL:[path stringByAppendingPathComponent:idStr]];
			[asset setCoverArtURL:[path stringByAppendingPathComponent:idStr]];
			[asset setIsLocal:YES];
			[assets addObject:asset];
		}
	}
	return assets;
}
+(NSArray *)imageProxiesForPath:(NSString *)path
{
    return [SMFPhotoMethods imageProxiesForPath:path nbImages:-1];
}
+(NSArray *)imageProxiesForPath:(NSString *)path nbImages:(long)nb
{
    NSArray *assets = [SMFPhotoMethods mediaAssetsForPath:path];
    NSMutableArray *proxies = [[NSMutableArray alloc] init];
    if (nb<0 || nb>[assets count]) {nb=[assets count];}
    int i;
    for (i=0;i<nb;i++)
    {
        [proxies addObject:[NSClassFromString(@"BRXMLImageProxy") imageProxyForAsset:[assets objectAtIndex:i]]];
    }
    return (NSArray *)proxies;
}
+(NSMutableArray *)loadImagePathsForPath:(NSString *)path
{
    NSArray *contents = [NSFileManager directoryContentsAtPath:path];
    NSMutableArray *imagePaths = [NSMutableArray array];
    long i, count = [contents count];	
    for ( i = 0; i < count; i++ )
    {
        NSString *idStr = [contents objectAtIndex:i];
        if([coverArtExtention containsObject:[[idStr pathExtension] lowercaseString]])
            [imagePaths addObject:[path stringByAppendingPathComponent:idStr]];
    }
    return imagePaths;
}

+(id)firstPhotoForPath:(NSString *)path
{
    NSArray *contents = [NSFileManager directoryContentsAtPath:path];
    long i, count = [contents count];	
    
    for ( i = 0; i < count; i++ )
    {
        NSString *idStr = [contents objectAtIndex:i];
        if([coverArtExtention containsObject:[[idStr pathExtension] lowercaseString]])
        {
            return [BRImage imageWithPath:[path stringByAppendingPathComponent:idStr]];
        }
    }
    return nil;
}
+(id)photoCollectionForPath:(NSString *)path
{
    NSArray *assets = [SMFPhotoMethods mediaAssetsForPath:path];
    id collection = [[SMFPhotoMediaCollection alloc]init];
    [collection setMediaAssets:assets];
    if([assets count]>0)
        [collection setKeyAssetID:[[assets objectAtIndex:0] assetID]];
    [collection setCollectionName:[path lastPathComponent]];
    [collection setCollectionType:[BRMediaCollectionType iPhotoSlideshow]];
    return collection;
}

+(BRDataStore *)dataStoreForAssets:(NSArray*)assets
{
    NSSet *_set = [NSSet setWithObject:[BRMediaType photo]];
    
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"mediaType == %@",[BRMediaType photo]];
    BRDataStore *store = [[BRDataStore alloc] initWithEntityName:@"PhotoDataStore" predicate:_pred mediaTypes:_set];
    int i =0;
    for (i=0;i<[assets count];i++)
    {
        [store addObject:[assets objectAtIndex:i]];
    }
    return [store autorelease];
}
+(BRDataStore *)dataStoreForPath:(NSString *)path
{
    return [SMFPhotoMethods dataStoreForAssets:[SMFPhotoMethods mediaAssetsForPath:path]];
}
@end

@implementation SMFPhotoMediaCollection
-(id)imageProxy                 {return [BRPhotoImageProxy imageProxyWithAsset:[self keyAsset]];}
-(BOOL)isLocal                  {return YES;}
-(id)description                {return @"SoftwareMenuFramework Collection";}
-(unsigned int)hash             {return 10;}
-(int)count                     {return [[self mediaAssets]count];}
-(id)provider                   {return [BRImageProxyProvider providerWithAssets:[self mediaAssets]];}
-(id)archivableCollectionInfo   {return @"200";}
-(id)collectionID               {return @"200";}
@end

@implementation SMFPhotoControlFactory
+(id)mainMenuFactory
{
    return [[SMFPhotoControlFactory alloc] initForMainMenu:YES];
}
+(id)standardFactory
{
    return [[SMFPhotoControlFactory alloc] initForMainMenu:NO];
}
//Returns the control shown on main menu
-(id)initForMainMenu:(BOOL)arg1
{
    self = [super initForMainMenu:arg1];
    _mainmenu = arg1;
    return self;
}
-(id)controlForData:(id)arg1 currentControl:(id)arg2 requestedBy:(id)arg3
{
    id returnObj;
    if([arg1 isKindOfClass:[SMFPhotoMediaCollection class]])
    {
        BRDataStore *store = [SMFPhotoMethods dataStoreForAssets:[arg1 mediaAssets]];
        BRPhotoControlFactory* controlFactory = [BRPhotoControlFactory mainMenuFactory];
        SMFPhotoCollectionProvider* provider    = [SMFPhotoCollectionProvider providerWithDataStore:store controlFactory:controlFactory];
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
        [returnObj setAcceptsFocus:YES];
    }
    else if([arg1 isKindOfClass:[BRPhotoMediaAsset class]])
    {
        returnObj = [[BRAsyncImageControl alloc] init];
        [returnObj setDefaultImage:[arg1 coverArt]];
        [returnObj setAcceptsFocus:YES];
    }
    else if([arg1 isKindOfClass:[BRDividerControl class]])
    {
        NSLog(@"divider");
        returnObj=arg1;
    }
    //returning nothing is also acceptable only for main menu
    return returnObj;
}
@end
@implementation SMFPhotoCollectionProvider
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