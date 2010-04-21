//
//  SMParade.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/12/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMParade.h"
#define DEFAULT_IMAGES_PATH		@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/DefaultPhotos/"
#define PHOTO_DIRECTORY_KEY		@"PhotoDirectory"
#define myDomain                (CFStringRef)@"com.apple.frontrow.appliance.SoftwareMenu"

           
@interface SMParadeMext (private) 
+ (NSString *)stringForKey:(NSString *)theKey;
+ (NSString *)photoFolderPath;
+ (NSArray *)imageProxiesForPath:(NSString *)path;
+ (NSArray *)mediaAssetsForPath:(id)path;
@end


@implementation SMParadeMext

-(BRControl *)backgroundControl
{
    CGRect a;
    
    a.size=[BRWindow maxBounds];
    BRMediaParadeControl * control = [[BRMediaParadeControl alloc] init];
    id proxies = [SMParadeMext imageProxiesForPath:[SMParadeMext photoFolderPath]];
    [control setImageProxies:proxies];
    [control setFrame:a];
    [control setOpacity:0.3];
    return [control autorelease];
}
-(BRController *)controller
{
    id controller= [[SMParadeController alloc] init];
    return controller;
    return nil;
}
-(BRController *)ioptions
{
    id controller = [[SMParadeController alloc]init];
    return controller;
}
-(BOOL)hasPluginSpecificOptions
{
    return YES;
}
+(NSString *)pluginSummary
{
    return @"Shows a Media Parade of pictures in your current photo folder in background";
}
+(NSString *)developer
{
    return @"Thomas Cool";
}
@end

@implementation SMParadeMext (private)
+ (NSString *)stringForKey:(NSString *)theKey
{
	CFPreferencesAppSynchronize(myDomain);
	NSString * myString = (NSString *)CFPreferencesCopyAppValue((CFStringRef)theKey, myDomain);
	return (NSString *)myString;
}

+(NSString *)photoFolderPath
{
    NSString * path = [SMParadeMext stringForKey:PHOTO_DIRECTORY_KEY];
    
    if (path == nil)
    {
        path = DEFAULT_IMAGES_PATH;
    }
    return [path autorelease];
}
+(NSArray *)imageProxiesForPath:(NSString *)path
{
    
    NSArray *assets = [SMParadeMext mediaAssetsForPath:path];
    NSMutableArray *proxies = [[NSMutableArray alloc] init];
    int nb=[assets count];
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

@end
