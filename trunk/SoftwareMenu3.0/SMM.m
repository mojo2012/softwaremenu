//
//  SMM.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/12/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import "SMM.h"
#import "SMDefines.h"
//#import "General/SMMPrefs.h"
//#import <BackRow/BackRow.h>


@implementation SMM
+(void)initialize
{
//    NSString* pathToBundle = [[NSBundle mainBundle] pathForResource:@"Photo"
//                                                             ofType:@"frss"];
    NSBundle* bundle = [NSBundle bundleWithPath:@"/System/Library/CoreServices/Finder.app/Contents/Screen Savers/Photo.frss"];
    
    NSLog(@"load");
    Class myClass = [bundle classNamed:@"RUIPhloatoControl"];
    NSAssert(myClass != nil, @"Couldn't load MyClass");
    [myClass initialize];
    Class myClassTwo = [bundle classNamed:@"RUIPhloatoPlane"];
    NSAssert(myClassTwo != nil, @"Couldn't load MyClassTwo");
    [myClassTwo initialize];
    Class myClassThree = [bundle classNamed:@"RUIPhloatoPlaneDelegate"];
    NSAssert(myClassThree != nil, @"Couldn't load MyClassTwo");
    [myClassThree initialize];
    
    Class myClassFour = [bundle classNamed:@"RUIPhloatoPlaneDelegate"];
    NSAssert(myClassFour != nil, @"Couldn't load MyClassFour");
    [myClassFour initialize];
    
    Class myClassFive = [bundle classNamed:@"RUIPhloatoArtLoader"];
    NSAssert(myClassFive != nil, @"Couldn't load MyClassFour");
    [myClassFive initialize];
    //[SMM initialize];
}
+(NSString *) className {
    // this function creates an NSString from the contents of the
    // struct objc_class, which means using this will not call this
    // function recursively, and it'll also return the *real* class
    // name.
    NSString * className = NSStringFromClass( self );
	
	// new method based on the BackRow NSException subclass, which conveniently provides us a backtrace
	// method!
	NSRange result = [[BRBacktracingException backtrace] rangeOfString:@"_validateBundleAtPath:"];
	NSLog(@"className");
	if(result.location != NSNotFound) {
        NSLog(@"returning weird");
		className = @"RUIRetailScreenSaver";
	}
	className = @"RUIRetailScreenSaver";
	return className;
}
-(id)screenSaverControl
{
    BRControl *control = nil;
    NSLog([SMMPrefs slideshowType]);
    NSString *a =[SMMPrefs slideshowType];
    NSLog(@"provider collection: %@",[[[ATVSettingsFacade singleton] providerForScreenSaver]collection]);
    NSLog(@"provider data: %@",[[[[ATVSettingsFacade singleton] providerForScreenSaver] collection] mediaAssets]);
    NSLog(@"provider data: %@",[[[[ATVSettingsFacade singleton] providerForScreenSaver] collection]imageProxy]);
    if ([a isEqualToString:@"Floating" ]) {
        control = _control;
    }
    else if([a isEqualToString:@"Slideshow" ])
    {
        BRPhotoPlayer *player = [[BRPhotoPlayer alloc] init];
        [player setPlayerSpecificOptions:[[ATVSettingsFacade singleton] slideshowScreensaverPlaybackOptions]];
        //NSString *a;
        
        id collection;
        if ([SMPreferences screensaverUseAppleProvider]) {
            collection = [[[ATVSettingsFacade singleton] providerForScreenSaver] collection];
            id c =[BRFullScreenPhotoController fullScreenPhotoControllerForProvider:[[ATVSettingsFacade singleton] providerForScreenSaver] startIndex:0];
            [c _startSlideshow];
            return c;

        }
        else {
            collection = [SMImageReturns photoCollectionForPath:[SMMPrefs photoFolderPath]];
        }
        [player setMediaAtIndex:0 inCollection:collection error:nil];
        control =[BRMediaPlayerController controllerForPlayer:player];

        
    }
    else 
    {
        control = [[BRMediaParadeControl alloc] init];
        id proxies;
        if ([SMPreferences screensaverUseAppleProvider]) {
            //NSLog(@"use SS");
            proxies = [NSArray arrayWithObject:[[[[ATVSettingsFacade singleton] providerForScreenSaver] collection]imageProxy]];
            //NSLog(@"proxies");
        }
        else{
            //NSLog(@"use Old");
            proxies = [SMImageReturns imageProxiesForPath:[SMMPrefs photoFolderPath]];
        }
        NSLog(@"proxies: %@",proxies);
        [control setImageProxies:proxies];
    }

    return control;
}
-(id)init
{
    self = [super init];
    _control= [[RUIPhloatoControl alloc] init];
    //NSLog(@"atv spin freq: %i",[SMMPrefs screensaverSpinFrequency]);
    //NSLog([SMMPrefs slideshowType]);
    [_control setSpinFrequency:[SMMPrefs screensaverSpinFrequency]];

    NSSet *_set = [NSSet setWithObject:[BRMediaType photo]];
    NSPredicate *_pred = [NSPredicate predicateWithFormat:@"mediaType == %@",[BRMediaType photo]];
    NSArray *assets=[SMImageReturns mediaAssetsForPath:[SMMPrefs photoFolderPath]];
    BRDataStore *store = [[BRDataStore alloc] initWithEntityName:@"Hello" predicate:_pred mediaTypes:_set];
    int i =0;
    for (i=0;i<[assets count];i++)
    {
        [store addObject:[assets objectAtIndex:i]];
    }
    
    
    id provider;
    if ([SMPreferences screensaverUseAppleProvider]) {
        provider = [[ATVSettingsFacade singleton] providerForScreenSaver];
    }
    else {
        BRPhotoControlFactory* controlFactory = [BRPhotoControlFactory standardFactory];
        provider = [SMPhotoCollectionProvider providerWithDataStore:store controlFactory:controlFactory];
    }
    [_control setProvider:provider];
    return self;
}
-(void)setProvider:(id)arg1
{
    [_control setProvider:[[ATVSettingsFacade singleton] providerForScreenSaver]];
}
//-(void)dealloc
//{
//    [_control release];
//    [super dealloc];
//}
@end
