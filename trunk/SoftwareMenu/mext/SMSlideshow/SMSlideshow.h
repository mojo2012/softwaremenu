//
//  SMSlideshow.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/12/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>

@interface SMImageControl : BRImageControl
{
    int padding[32];
}

@end
@class CIImage;
typedef enum {
    // Core Animation's four built-in transition types
    SlideshowViewFadeTransitionStyle,
    SlideshowViewMoveInTransitionStyle,
    SlideshowViewPushTransitionStyle,
    SlideshowViewRevealTransitionStyle,
    
    // Core Image's standard set of transition filters
    SlideshowViewCopyMachineTransitionStyle,
    SlideshowViewDisintegrateWithMaskTransitionStyle,
    SlideshowViewDissolveTransitionStyle,
    SlideshowViewFlashTransitionStyle,
    SlideshowViewModTransitionStyle,
    SlideshowViewPageCurlTransitionStyle,
    SlideshowViewRippleTransitionStyle,
    SlideshowViewSwipeTransitionStyle,
    
    NumberOfSlideshowViewTransitionStyles
} SlideshowTransitionStyle;
@interface SMSlideshowControl : BRControl
{
    int padding[32];
    float           targetOpacity;
    BOOL            random;
    BOOL            useTimer;
    BOOL            crop;
    unsigned int    timerTime;
    float           transitionDuration;
    unsigned int    currentImage;
    BRImage         *nextImage;
    BRImageControl  *curImage;
    BRImageControl  *oldImage;
    NSArray         *_fileListing;
    NSTimeInterval  slideshowInterval;
    NSTimer         *slideshowTimer;
    NSString        *currentImagePath;
    BOOL            autoRotateEffect;
    CIImage         *inputShadingImage;         // an environment-map image that the transition filter may use in generating the transition effect
    CIImage         *inputMaskImage;            // a mask image that the transition filter may use in generating the transition effect
    SlideshowTransitionStyle transitionStyle;
    
}

/*
 *  ImageTime
 */
-(void)setImageDuration:(NSTimeInterval)imageDuration;
-(NSTimeInterval)imageDuration;

-(void)setTransitionStyle:(SlideshowTransitionStyle)st;
-(SlideshowTransitionStyle)transitionStyle;

/*
 *  Should the timer be used
 */
-(void)setUseTimer:(BOOL)use;
-(BOOL)useTimer;


/*
 *  Sets how long the transition will last
 */
-(void)setTransitionDuration:(float)transitionTime;
-(float)transitionDuration;

/*
 *  Should images be displayed in a random order
 */
-(void)setRandomOrder:(BOOL)randomOrder;
-(BOOL)randomOrder;



/*
 *  Requires an NSArray with File Paths;
 */
-(void)setFiles:(NSArray *)files;
-(NSArray *)files;

/*
 *  Displays Files in selected Folder
 */
-(void)setFolder:(NSString *)folder;

/*
 *  This is the method that should in fact be called, not setImage
 */
-(void)setCurrentImage:(BRImage *)image;

/*
 *  Sets Opacity of the Images (don't want above 0.5 for main menu really)
 */
-(void)setTargetOpacity:(float)opacity;
-(float)targetOpacity;

-(void)setAutoRotateEffect:(BOOL)ar;
-(BOOL)autoRotateEffect;


/*
 *
 */
- (void)updateSubviewsTransition;
/*
 *  Starts Slideshow
 */
- (void)startSlideshowTimer;
/*
 *  Stops Slideshow
 */
- (void)stopSlideshowTimer;
/*
 *  Method that should be called to manually advance slideshow
 */
- (void)advanceSlideshow:(NSTimer *)timer;
- (void)advanceSlideshow:(NSTimer *)timer force:(BOOL)force;
@end
NSString *const kCAMediaTimingFunctionEaseIn;
@interface SMSlideshowMext : NSObject <SMMextProtocol>{
//    BRImageControl *_control;
//    int _imageNb;
    
    NSMutableArray *_imagePaths;
    BRImage *_nextImage;
    NSDate *_lastFireDate;
    SMSlideshowControl *_control;
}
@end


