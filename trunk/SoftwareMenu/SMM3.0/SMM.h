//
//  SMM.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/12/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

//#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
#import "AppleTV.h"
//#import "SMImageReturns.h"
#import "SMSubclasses.h"
#import "SMMPrefs.h"

//@protocol ATVScreenSaverPluginProtocol <NSObject>
//- (id)screenSaverControl;
//@end

@interface RUIPhloatoScreenSaver : NSObject <ATVScreenSaverPluginProtocol>
{
    //RUIPhloatoControl *_control;
    BRPhotoPlayer *blah;
}

- (id)init;
- (void)dealloc;
- (id)screenSaverControl;
- (void)setProvider:(id)arg1;

@end
@interface RUIPhloatoArtLoader : BRImageLoader
{
    struct CGSize _maxSize;
}

- (void)setMaxSize:(struct CGSize)arg1;
- (id)finalFormForImage:(id)arg1;

@end
@interface RUIPhloatoPlaneDelegate : NSObject
{
    //RUIPhloatoPlane *_plane;
}

- (id)initWithPlane:(id)arg1;
- (void)setPlane:(id)arg1;
- (void)animationDidStop:(id)arg1 finished:(BOOL)arg2;

@end
@interface RUIPhloatoPlane : NSObject
{
    BRControl *_planeLayer;
    RUIPhloatoArtLoader *_provider;
    NSMutableArray *_photoLayers;
    RUIPhloatoPlaneDelegate *_animationDelegate;
    NSTimer *_pullTimer;
    float _frameMultiplier;
    float _zPosition;
    BOOL _pullsImages;
    struct RUIPhloatoPlaneImagePosition *_table;
    long _currentEntryIndex;
    long _entryCount;
}

- (id)initWithPlaneLayer:(id)arg1 positionTable:(const struct RUIPhloatoPlaneImagePosition *)arg2 count:(long)arg3;
- (void)dealloc;
- (void)setProvider:(id)arg1;
- (id)provider;
- (void)setPullsImages:(BOOL)arg1;
- (BOOL)pullsImages;
- (void)setZPosition:(float)arg1;
- (float)zPosition;
- (void)setFrameMultiplier:(float)arg1;
- (float)frameMultiplier;

@end

@interface RUIPhotoScreenSaver : RUIPhloatoScreenSaver
{
}

- (id)init;

@end


@interface RUIPhloatoControl : BRControl
{
    RUIPhloatoPlane *_frontPlane;
    RUIPhloatoPlane *_middlePlane;
    RUIPhloatoPlane *_backPlane;
    NSTimer *_spinTimer;
    float _spinFrequency;
    BOOL _waitingForQueue;
}

- (id)init;
- (void)dealloc;
- (void)setProvider:(id)arg1;
- (void)setSpinFrequency:(float)arg1;
- (float)spinFrequency;
- (void)controlWasActivated;
- (void)controlWasDeactivated;

@end




@interface SMM : NSObject <ATVScreenSaverPluginProtocol>
{
    RUIPhloatoControl *_control;
}

- (id)init;
- (void)dealloc;
- (id)screenSaverControl;
- (void)setProvider:(id)arg1;


@end

