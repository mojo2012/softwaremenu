//
//  SMSlideshow.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/12/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMSlideshow.h"
#define DEFAULT_IMAGES_PATH		@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/DefaultPhotos/"
#define PHOTO_DIRECTORY_KEY		@"PhotoDirectory"
#define myDomain                (CFStringRef)@"com.apple.frontrow.appliance.SoftwareMenu"
@interface ATVSettingsFacade
@end
@class SMPhotoCollectionProvider,SMImageReturns;
@interface SMSlideshowMext (private)
+ (NSString *)stringForKey:(NSString *)theKey;
+ (NSDictionary *)screensaverSlideshowPlaybackOptions;
+ (NSString *)photoFolderPath;
+ (NSArray *)imageProxiesForPath:(NSString *)path;
+ (NSArray *)mediaAssetsForPath:(id)path;
+(id)photoCollectionForPath:(NSString *)path;
-(void)loadImagesPaths;
+(NSMutableArray *)loadImagePathsForPath:(NSString *)thepath;

@end
static BRImageControl *_control = nil;
static int _imageNb =0;
@implementation SMSlideshowMext

-(BRControl *)backgroundControl
{
    if (_control == nil) {
        _control = [[BRImageControl alloc] init];
        [_control setAutoresizingMask:1];
        [_control setAutomaticDownsample:TRUE];
        [_control retain];
        [_control retain];
    }
    [self loadImagesPaths];
    if(_imageNb>[_imagePaths count])
        _imageNb=0;
    [_control setImage:[BRImage imageWithPath:[_imagePaths objectAtIndex:_imageNb]]];
    CGRect a;
    a.size=[BRWindow maxBounds];
    [_control setFrame:a];
    [_control setOpacity:0.3];
    _lastFireDate=[NSDate date];
    [_lastFireDate retain];
    //NSLog(@"%@",_lastFireDate);
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(callU) userInfo:nil repeats:NO];
    return _control;
}
//-(BRControl *)backgroundControl
//{
//    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"PFC"];
//    
//    NSSet *_set = [NSSet setWithObject:[BRMediaType photo]];
//    
//    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"mediaType == %@",[BRMediaType photo]];
//    
//    NSArray *assets=[SMImageReturns mediaAssetsForPath:path];
//    
//    BRDataStore *store = [[BRDataStore alloc] initWithEntityName:@"PhotoStore" predicate:_pred mediaTypes:_set];
//    int i;
//    for (i=0;i<[assets count];i++)
//    {
//        [store addObject:[assets objectAtIndex:i]];
//    }
//    
//    BRPhotoControlFactory* controlFactory = [BRPhotoControlFactory standardFactory];
//    SMPhotoCollectionProvider* provider    = [SMPhotoCollectionProvider providerWithDataStore:store controlFactory:controlFactory];//[[ATVSettingsFacade sharedInstance] providerForScreenSaver];//[collection provider];
//    
//    _control = [BRFullScreenPhotoController fullScreenPhotoControllerForProvider:provider startIndex:0];
////    [_control _startSlideshow];
////    NSLog(@"options: %@",[[ATVSettingsFacade singleton] slideshowScreensaverPlaybackOptions]);
////    BRPhotoPlayer *player = [[BRPhotoPlayer alloc] init];
////    [player setPlayerSpecificOptions:[[ATVSettingsFacade singleton]slideshowScreensaverPlaybackOptions]];
////    [player setMuted:YES];
////    [player setMediaAtIndex:0 inCollection:[[ATVSettingsFacade singleton] screenSaverCollection] error:nil];
////    
////    _control =[BRMediaPlayerController controllerForPlayer:player];
//    [_control retain];
//    
//    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(callN) userInfo:nil repeats:NO];
//    return _control;
//}

-(void)callN
{
    [_control _nextSlide];
    [_control _prefetchNextImage];
    //[_control _initiatePlayback];
}
-(void)updateImage
{
    if ([[_control parent] parent]==[[[BRApplicationStackManager singleton]stack]peekController]) {
        NSLog(@"root");
        [_control setImage:[BRImage imageWithPath:[_imagePaths objectAtIndex:_imageNb++]]];
        if (_imageNb==[_imagePaths count]) {
            _imageNb=0;
        }
        [_control layoutSubcontrols];

        //NSLog(@"%@",_lastFireDate);
        [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(callU) userInfo:nil repeats:NO];
    }
    else {
//        NSLog(@"not top controller");
    }

}
-(void)callU
{
   // NSLog(@"_laSTFire: %@",_lastFireDate);
    double time = [[NSDate date] timeIntervalSinceDate:_lastFireDate];
    if(time>29)
    {
        [_lastFireDate release];
        _lastFireDate=[NSDate date];
        [_lastFireDate retain];
        [self updateImage];
        NSLog(@"upating after time: %lf",time);
        
    }
    else {
//        NSLog(@"not upating after time: %lf",time);
    }

}
-(BOOL)hasPluginSpecificOptions
{
    return NO;
}
+(NSString *)pluginSummary
{
    return @"Displays the first image of your photo folder in background and on menu press returns a slideshow of the folder";
}
-(BRController *)controller
{
    BRPhotoPlayer *player = [[BRPhotoPlayer alloc] init];
    [player setPlayerSpecificOptions:[SMSlideshowMext screensaverSlideshowPlaybackOptions]];
    id collection;
    collection = [SMSlideshowMext photoCollectionForPath:[SMSlideshowMext photoFolderPath]];
    [player setMuted:YES];
    [player setMediaAtIndex:_imageNb inCollection:collection error:nil];
    BRController *control= [BRMediaPlayerController controllerForPlayer:player];
    CGRect a;
    
    a.size=[BRWindow maxBounds];
    [control setFrame:a];
    [control setOpacity:0.3];
    return control;
}
+(NSString *)developer
{
    return @"Thomas Cool";
}
-(void)loadImagesPaths
{
    [_imagePaths release];
    _imagePaths=[[SMSlideshowMext loadImagePathsForPath:[SMSlideshowMext photoFolderPath]]retain];
}
@end

@implementation SMSlideshowMext (private)
   +(NSDictionary *)screensaverSlideshowPlaybackOptions
{
    NSMutableDictionary *a = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithBool:NO],@"None",
                              [NSNumber numberWithBool:YES],@"Random",
                              @"NO",@"PanAndZoom",
                              @"YES",@"RepeatSlideShow",
                              [NSNumber numberWithInt:5],@"SecondsPerSlide",
                              [NSNumber numberWithBool:NO],@"ShuffleSlides",
                              @"Dissolve",@"TransitionName",
                              @"NO",@"PlayMusic",
                              nil];
    return a;
    
}
+(id)photoCollectionForPath:(NSString *)path
{
    NSArray *assets = [SMSlideshowMext mediaAssetsForPath:path];
    id collection = [[NSClassFromString(@"SMPhotoMediaCollection") alloc]init];
    [collection setMediaAssets:assets];
    if([assets count]>0)
        [collection setKeyAssetID:[[assets objectAtIndex:0] assetID]];
    [collection setCollectionName:[path lastPathComponent]];
    [collection setCollectionType:[BRMediaCollectionType iPhotoSlideshow]];
    return collection;
}

+ (NSString *)stringForKey:(NSString *)theKey
{
	CFPreferencesAppSynchronize(myDomain);
	NSString * myString = (NSString *)CFPreferencesCopyAppValue((CFStringRef)theKey, myDomain);
	return (NSString *)myString;
}

+(NSString *)photoFolderPath
{
    NSString * path = [SMSlideshowMext stringForKey:PHOTO_DIRECTORY_KEY];
    
    if (path == nil)
    {
        path = DEFAULT_IMAGES_PATH;
    }
    return [path autorelease];
}
+(NSArray *)imageProxiesForPath:(NSString *)path
{
    
    NSArray *assets = [SMSlideshowMext mediaAssetsForPath:path];
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
+(NSMutableArray *)loadImagePathsForPath:(NSString *)thepath
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    NSSet *coverArtExtension = [NSSet setWithObjects:
                                @"jpg",
                                @"jpeg",
                                @"tif",
                                @"tiff",
                                @"png",
                                @"gif",
                                nil];;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray * a = [fileManager directoryContentsAtPath:thepath];
    long i, count = [[fileManager directoryContentsAtPath:thepath] count];	
    
    for ( i = 0; i < count; i++ )
    {
        NSString *idStr = [a objectAtIndex:i];
        if([coverArtExtension containsObject:[[idStr pathExtension] lowercaseString]])
            [array addObject:[thepath stringByAppendingPathComponent:idStr]];
            
    }
    return array;
}
+(id)firstPhotoForPath:(NSString *)thepath
    {
        NSSet *coverArtExtension = [NSSet setWithObjects:
                                    @"jpg",
                                    @"jpeg",
                                    @"tif",
                                    @"tiff",
                                    @"png",
                                    @"gif",
                                    nil];;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray * a = [fileManager directoryContentsAtPath:thepath];
        long i, count = [[fileManager directoryContentsAtPath:thepath] count];	
        
        for ( i = 0; i < count; i++ )
        {
            NSString *idStr = [a objectAtIndex:i];
            if([coverArtExtension containsObject:[[idStr pathExtension] lowercaseString]])
            {
                return [BRImage imageWithPath:[thepath stringByAppendingPathComponent:idStr]];
            }
            
        }
        return nil;
    }
                       
@end

