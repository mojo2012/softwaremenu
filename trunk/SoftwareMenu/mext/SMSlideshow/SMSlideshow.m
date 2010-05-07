//
//  SMSlideshow.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/12/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//
#import <QuartzCore/CABasicAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import <QuartzCore/CAMediaTimingFunctionBuiltin.h>
#import <QuartzCore/CIFilter.h>
#import <QuartzCore/CATransition.h>
#import <SoftwareMenuFramework/SoftwareMenuFramework.h>
#import "SMSlideshow.h"
#define DEFAULT_IMAGES_PATH		@"/System/Library/PrivateFrameworks/AppleTV.framework/Resources/DefaultPhotos/"
#define PHOTO_DIRECTORY_KEY		@"PhotoDirectory"
#define myDomain                (CFStringRef)@"com.apple.frontrow.appliance.SoftwareMenu.Slideshow"
#define SoftwareMenuDomain      (CFStringRef)@"com.apple.frontrow.appliance.SoftwareMenu"
@interface ATVSettingsFacade
@end
@class CATransition;
@implementation SMImageControl
//-(id)preferredActionForKey:(id)arg1
//{
//    DLog(@"arg1 prefered: %@",arg1);
//    id a = [super preferredActionForKey:arg1];
//    DLog(@"a: %@",a);
//    if ([a isEqualToString:@"onOrderIn"]) {
////        CATransition *l   = [CATransition animation];
////        [l setType:kCATransitionFade];
////        [l setDuration:3.f];
//        //[l begin];
//        DLog(@"weird");
//        return l;
//        
//    }
//    return a;
//}

@end

@interface SMSlideshowMext (private)
+ (NSString *)stringForKey:(NSString *)theKey forDomain:(CFStringRef)domain;
+ (NSString *)photoFolderPath;
-(void)loadImagesPaths;

@end

//static int _imageNb =0;
@implementation SMSlideshowMext
//static BRImageControl *_control = nil;

-(BRControl *)backgroundControl
{
    if (_control == nil) {
        _control = [[SMSlideshowControl alloc] init];
        [_control setAutoresizingMask:1];
        //[(BRImageControl *)_control setAutomaticDownsample:TRUE];
        [_control retain];
        [_control retain];
        [_control setTargetOpacity:0.3f];
//        CATransition *llayer = [CATransition animation];
//        [llayer setType:kCATransitionFade];
    }
    [_control setFolder:[SMSlideshowMext photoFolderPath]];
    [self loadImagesPaths];
//    if(_imageNb>[_imagePaths count])
//        _imageNb=0;
//    [(BRImageControl *)_control setImage:[BRImage imageWithPath:[_imagePaths objectAtIndex:_imageNb]]];
    CGRect a;
    a.size=[BRWindow maxBounds];
    [_control setFrame:a];
    //[_control setOpacity:0.3];
    _lastFireDate=[NSDate date];
    [_lastFireDate retain];
    //NSLog(@"%@",_lastFireDate);
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(callU) userInfo:nil repeats:NO];
    return _control;
}

-(void)updateImage
{

    if ([[_control parent] parent]==[[[BRApplicationStackManager singleton]stack]peekController]) {
        [_control nextImage];
//        [(SMSlideshowControl *)_control setCurrentImage:[BRImage imageWithPath:[_imagePaths objectAtIndex:_imageNb++]]];
//        //CGSize size = [(BRImageControl *)_control preferredFrameSize];
//        //NSLog(@"width: %lf, height: %lf, aspectRatio: %lf",size.width,size.height,[(BRImageControl *)_control aspectRatio]);
//        if (_imageNb==[_imagePaths count]) {
//            _imageNb=0;
//        }
        //BOOL crop=TRUE;
//        if (crop && [_control aspectRatio]>1) {
//            CGSize maxBounds= [BRWindow maxBounds];
//            CGRect newFrame;
//            newFrame.size.width=maxBounds.width;
//            newFrame.size.height=newFrame.size.width/[_control aspectRatio];
//            newFrame.origin.x=0;
//            newFrame.origin.y=(maxBounds.height-newFrame.size.height)/2.0f;
//            [_control setFrame:newFrame];
//        }
//        [_control layoutSubcontrols];
//        CALayer *layer = [_control layer];
//        ALog(@"layer: %@",layer);
//        NSLog(@"nslayer: %@",layer);
//        DLog(@"delegate: %@ self: %@" ,[layer delegate],_control);
//        DLog(@"Contents: %@",[layer contents]);
//        DLog(@"actions: %@",[_control actions]);
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
//    BRPhotoPlayer *player = [[BRPhotoPlayer alloc] init];
//    [player setPlayerSpecificOptions:[SMSlideshowMext screensaverSlideshowPlaybackOptions]];
//    id collection;
//    collection = [SMSlideshowMext photoCollectionForPath:[SMSlideshowMext photoFolderPath]];
//    [player setMuted:YES];
//    [player setMediaAtIndex:_imageNb inCollection:collection error:nil];
//    BRController *control= [BRMediaPlayerController controllerForPlayer:player];
//    CGRect a;
//    
//    a.size=[BRWindow maxBounds];
//    [control setFrame:a];
//    [control setOpacity:0.3];
//    return control;
    return nil;
}
+(NSString *)developer
{
    return @"Thomas Cool";
}

@end

@implementation SMSlideshowMext (private)
-(void)loadImagesPaths
{
    [_imagePaths release];
    _imagePaths=[[SMFPhotoMethods loadImagePathsForPath:[SMSlideshowMext photoFolderPath]]retain];
}



+ (NSString *)stringForKey:(NSString *)theKey forDomain:(CFStringRef)domain;
{
	CFPreferencesAppSynchronize(myDomain);
	NSString * myString = (NSString *)CFPreferencesCopyAppValue((CFStringRef)theKey, domain);
	return (NSString *)myString;
}

+(NSString *)photoFolderPath
{
    NSString * path = [SMSlideshowMext stringForKey:PHOTO_DIRECTORY_KEY forDomain:SoftwareMenuDomain];
    
    if (path == nil)
    {
        path = DEFAULT_IMAGES_PATH;
    }
    return [path autorelease];
}



               
@end
@implementation SMSlideshowControl
-(id)init
{
    self=[super init];
    targetOpacity=0.3f;
    useTimer=YES;
    random=NO;
    timerTime=30;
    transitionDuration=2.5;
    _fileListing=[[NSArray alloc] init];
    _orderArray=[[NSArray alloc] init];
    currentImage=0;
    return self;
}
-(void)nextImage
{
    int count = [_fileListing count];
    if (count!=0) {
        if (currentImage>=count-1) {
            currentImage=0;
        }
        else 
        {
            currentImage++;
        }
        [self setCurrentImage:[BRImage imageWithPath:[_fileListing objectAtIndex:currentImage]]];

    }
}
-(void)updateCurrentImage
{
    int count = [_fileListing count];
    if (count!=0) {
        if (currentImage>=count) {
            currentImage=0;
        }
        [self setCurrentImage:[BRImage imageWithPath:[_fileListing objectAtIndex:currentImage]]];
        
    }
    
}
-(void)setFolder:(NSString *)folder
{
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:folder isDirectory:&isDir]&&isDir) {
        [self setFiles:[SMFPhotoMethods photoPathsForPath:folder]];
        
    }
}
-(void)setFiles:(NSArray *)files
{
    if (_fileListing!=nil) {
        [_fileListing release];
        _fileListing=nil;
    }
    _fileListing=[[files copy] retain];
    [self updateCurrentImage];
}
-(NSArray *)files
{
    return _fileListing;
}
-(void)setImageDuration:(unsigned int)imageDuration
{
    timerTime=imageDuration;
}
-(unsigned int)imageDuration
{
    return timerTime;
}
-(void)setUseTimer:(BOOL)use
{
    useTimer=use;
}
-(BOOL)useTimer
{
    return useTimer;
}
-(void)setRandomOrder:(BOOL)randomOrder
{
    random=randomOrder;
}
-(BOOL)randomOrder
{
    return random;
}
-(void)setTransitionDuration:(float)transitionTime
{
    if (transitionTime>0.0f) {
        transitionDuration=transitionTime;
    }
}
-(float)transitionDuration
{
    return transitionDuration;
}

-(void)setTargetOpacity:(float)op
{
    targetOpacity=op;
}
-(float)targetOpacity
{
    return targetOpacity;
}
-(void)setImage:(BRImage *)image;
{
    if (img!=nil) {
        [img release];
        img=nil;
    }
    img=[image retain];
}
-(BRImage *)image
{
    return img;
}
-(void)controlWasActivated
{
    [super controlWasActivated];
    [self setCurrentImage:img];
}
-(void)setCurrentImage:(BRImage *)image
{
//    DLog(@"Current: %@, Old: %@",curImage,oldImage);
    [self setImage:image];
    BOOL crop=TRUE;
    if(img!=nil)
    {
        if (curImage!=nil) {
            [[curImage layer] removeAllAnimations];
            if (oldImage!=nil) {
                [oldImage removeFromParent];
                [oldImage release];
                oldImage=nil;
            }
            oldImage=curImage;
        }
        curImage=[[BRImageControl alloc] init];
        [curImage setImage:img];
        if (crop && [curImage aspectRatio]>1) {
            CGSize maxBounds= [BRWindow maxBounds];
            CGRect newFrame;
            newFrame.size.width=maxBounds.width;
            newFrame.size.height=newFrame.size.width/[curImage aspectRatio];
            newFrame.origin.x=0;
            newFrame.origin.y=(maxBounds.height-newFrame.size.height)/2.0f;
            [curImage setFrame:newFrame];
        }
        [curImage setOpacity:targetOpacity];
        if (oldImage!=nil) {
            [self insertControl:curImage above:oldImage];
        }
        else {
            [self addControl:curImage];
        }
       if (oldImage!=nil) {
            /*CABasicAnimation *oldAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
            oldAnimation.duration=0.25f;
            oldAnimation.fromValue=[NSNumber numberWithFloat:targetOpacity];
            oldAnimation.toValue=[NSNumber numberWithFloat:0.0f];
            oldAnimation.repeatCount=1;
            oldAnimation.autoreverses=NO;
            [oldImage addAnimation:oldAnimation forKey:@"animateOpacity"];*/
           [oldImage removeFromParent];
           //oldImage.opacity=0.0f;
            //[oldImage setOpacity:0.0f];
            
            /*CABasicAnimation *theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
            theAnimation.duration=self.transitionDuration;
            theAnimation.fromValue=[NSNumber numberWithFloat:0.0f];
            theAnimation.toValue=[NSNumber numberWithFloat:targetOpacity];
            theAnimation.repeatCount=1;
            theAnimation.autoreverses=NO;
            [curImage addAnimation:theAnimation forKey:@"animateOpacity"];
            [curImage setOpacity:targetOpacity];
//            [curImage setOpacity:0.5f];
//            CATransition *transition=[CATransition animation];
//            transition.duration=self.transitionDuration;
//            [transition setType:@"moveIn"];
//            [transition setSubtype:@"fromLeft"];
//            transition.autoreverses=NO;
//            [curImage addAnimation:transition forKey:@"moveIn"];
        }
        else {
            [curImage setOpacity:targetOpacity];*/
        }
        
        
//        CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
//        
//        [filter setDefaults];
//        
//        [filter setValue:[NSNumber numberWithFloat:5.0] forKey:@"inputRadius"];
//        
//        
//        
//        // name the filter so we can use the keypath to animate the inputIntensity
//        
//        // attribute of the filter
//        
//        [filter setName:@"pulseFilter"];
//        
//        
//        
//        // set the filter to the selection layer's filters
//        
//        [[curImage layer] setFilters:[NSArray arrayWithObject:filter]];
//        
//        
//        
//        // create the animation that will handle the pulsing.
//        
//        CABasicAnimation* pulseAnimation = [CABasicAnimation animation];
//        
//        
//        
//        // the attribute we want to animate is the inputIntensity
//        
//        // of the pulseFilter
//        
//        pulseAnimation.keyPath = @"filters.pulseFilter.inputIntensity";
//        
//        
//        
//        // we want it to animate from the value 0 to 1
//        
//        pulseAnimation.fromValue = [NSNumber numberWithFloat: 0.0];
//        
//        pulseAnimation.toValue = [NSNumber numberWithFloat: 1.5];
//        
//        
//        
//        // over one a one second duration, and run an infinite
//        
//        // number of times
//        
//        pulseAnimation.duration = 1.0;
//        
//        pulseAnimation.repeatCount = 3.0f;
//        
//        
//        
//        // we want it to fade on, and fade off, so it needs to
//        
//        // automatically autoreverse.. this causes the intensity
//        
//        // input to go from 0 to 1 to 0
//        
//        pulseAnimation.autoreverses = YES;
//        
//        
//        
//        // use a timing curve of easy in, easy out..
//        //DLog(@"name: %@",kCAMediaTimingFunctionEaseIn);
//        //pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeIn"];
//        
//        
//        
//        // add the animation to the selection layer. This causes
//        
//        // it to begin animating. We'll use pulseAnimation as the
//        
//        // animation key name
//        
//        [[curImage layer] addAnimation:pulseAnimation forKey:@"pulseAnimation"];

        
        
        
        
    }

    
        

}
-(id)actionForLayer:(id)arg1 forKey:(id)arg2
{
    //DLog(@"Slideshwo WAction ForLayer:%@ ForKey:%@",arg1,arg2);

    srand(time(NULL));
    int rV = rand()%4;
    id a = [super actionForLayer:arg1 forKey:arg2];
    if ([arg2 isEqualToString:@"sublayers"]) {
        CATransition *transition=[CATransition animation];
        [transition setType:@"fade"];
        switch (rV) {
            case 0:
                [transition setSubtype:@"fromLeft"];
                break;
            case 1:
                [transition setSubtype:@"fromRight"];
                break;
            case 2:
                [transition setSubtype:@"fromTop"];
                break;
            case 3:
                [transition setSubtype:@"fromBottom"];
                break;
            default:
                [transition setSubtype:@"fromLeft"];
                break;
        }
        //[transition setSubtype:@"fromLeft"];
        [transition setDuration:transitionDuration];
        return transition;

        //if ([arg1 isHidden]) {
//            theAnimation = [[CATransition alloc] init];
//            theAnimation.duration = 1.0;
//            theAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//            theAnimation.type = kCATransitionFade;
////            theAnimation.fromValue=[NSNumber numberWithFloat:[_bg opacity]];
////            
////            theAnimation.toValue=[NSNumber numberWithFloat:0.0];
////theAnimation.subtype = kCATransitionFromRight;
//            return theAnimation;
//        }
    }
    
    return a;
}
@end

