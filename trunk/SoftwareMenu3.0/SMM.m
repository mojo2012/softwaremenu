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
    if ([a isEqualToString:@"Floating" ]) {
        control = _control;
    }
    else if([a isEqualToString:@"Slideshow" ])
    {
        BRPhotoPlayer *player = [[BRPhotoPlayer alloc] init];
        [player setPlayerSpecificOptions:[[ATVSettingsFacade singleton] slideshowScreensaverPlaybackOptions]];
        //NSString *a;
        [player setMediaAtIndex:0 inCollection:[SMImageReturns photoCollectionForPath:[SMMPrefs photoFolderPath]] error:nil];
        control =[BRMediaPlayerController controllerForPlayer:player];
        
    }
    else 
    {
        control = [[BRMediaParadeControl alloc] init];
        [control setImageProxies:[SMImageReturns imageProxiesForPath:[SMMPrefs photoFolderPath]]];
    }

    return control;
}
-(id)init
{
    self = [super init];
    _control= [[RUIPhloatoControl alloc] init];
    NSLog(@"atv spin freq: %i",[SMMPrefs screensaverSpinFrequency]);
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
    
    
    BRPhotoControlFactory* controlFactory = [BRPhotoControlFactory standardFactory];
    SMPhotoCollectionProvider* provider    = [SMPhotoCollectionProvider providerWithDataStore:store controlFactory:controlFactory];
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