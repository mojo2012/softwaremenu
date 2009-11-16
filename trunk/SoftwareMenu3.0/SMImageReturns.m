//
//  SMPreviewControlReturns.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/5/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//


#import "SMImageReturns.h"
#import "SMSubclasses.h"

@implementation SMImageReturns
+(NSArray *)imageProxiesForPath:(NSString *)path
{
    return [SMImageReturns imageProxiesForPath:path nbImages:-1];
}

+(NSArray *)imageProxiesForPath:(NSString *)path nbImages:(long)nb
{
    NSArray *assets = [SMImageReturns mediaAssetsForPath:path];
    NSMutableArray *proxies = [[NSMutableArray alloc] init];
    if (nb<0 || nb>[assets count]) {nb=[assets count];}
    int i;
    id bRXMLImageProxy = NSClassFromString(@"BRXMLImageProxy");
    for (i=0;i<nb;i++)
    {
        [proxies addObject:[bRXMLImageProxy imageProxyForAsset:[assets objectAtIndex:i]]];
    }
    return (NSArray *)proxies;
}

+(NSArray *)mediaAssetsForPath:(id)path
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
    NSLog(@"path: %@",path);
	long i, count = [[fileManager directoryContentsAtPath:path] count];	
	NSMutableArray *photos =[NSMutableArray arrayWithObjects:nil];
	for ( i = 0; i < count; i++ )
	{
		NSString *idStr = [[fileManager directoryContentsAtPath:path] objectAtIndex:i];
		if([coverArtExtention containsObject:[[idStr pathExtension] lowercaseString]])
		{
            //NSLog(@"valid extensions: %@",idStr);
			//Class cls = NSClassFromString( @"BRPhotoMediaAsset" );
			BRPhotoMediaAsset * asset = [[BRPhotoMediaAsset alloc] init];
			[asset setFullURL:[path stringByAppendingPathComponent:idStr]];
			[asset setThumbURL:[path stringByAppendingPathComponent:idStr]];
			[asset setCoverArtURL:[path stringByAppendingPathComponent:idStr]];
			[asset setIsLocal:YES];
			[photos addObject:asset];
           // NSLog(@"path: %@",[path stringByAppendingPathComponent:idStr]);
		}
	}
	return (NSArray *)photos;
}
+(id)photoCollectionForPath:(NSString *)path
{
    NSArray *assets = [SMImageReturns mediaAssetsForPath:path];
    SMPhotoMediaCollection * collection = [[SMPhotoMediaCollection alloc]init];
    [collection setMediaAssets:assets];
    if([assets count]>0)
        [collection setKeyAssetID:[[assets objectAtIndex:0] assetID]];
    [collection setCollectionName:[path lastPathComponent]];
    [collection setCollectionType:[BRMediaCollectionType iPhotoSlideshow]];
    return collection;
}
+(id)dataStoreForPath:(NSString *)path
{
    NSArray * assets=[SMImageReturns mediaAssetsForPath:path];
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
+(id)dataStoreForAssets:(NSArray*)assets
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
@end
