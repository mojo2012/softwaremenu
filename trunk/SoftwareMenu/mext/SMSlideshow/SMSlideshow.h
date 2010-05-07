//
//  SMSlideshow.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/12/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
@protocol SMMextProtocol
// For loading a control behind the main menu
-(BRControl *)backgroundControl;
// For loading a controller on menu press
-(BRController *)controller;
// Check if plugin has custom settings menu
-(BOOL)hasPluginSpecificOptions;
// Summary for plugin
+(NSString *)pluginSummary;
// Developer Name
+(NSString *)developer;


@optional
-(BRController *)options;

@end
@interface SMImageControl : BRImageControl
{
    int padding[32];
}

@end

@interface SMSlideshowControl : BRControl
{
    int padding[32];
    float           targetOpacity;
    BOOL            random;
    BOOL            useTimer;
    unsigned int    timerTime;
    float           transitionDuration;
    unsigned int    currentImage;
    BRImage         *img;
    BRImageControl  *curImage;
    BRImageControl  *oldImage;
    NSArray         *_fileListing;
    NSArray         *_orderArray;
    
}
/*
 *  Displays Next Image in list
 */
-(void)nextImage;
-(void)updateCurrentImage;

/*
 *  ImageTime
 */
-(void)setImageDuration:(unsigned int)imageDuration;
-(unsigned int)imageDuration;

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
 *  Set Next Image (should only be called when initializing;
 */
-(void)setImage:(BRImage *)image;
-(BRImage *)image;


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


