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
#import <QuartzCore/CIFilter.h>
#import <QuartzCore/CIVector.h>
#import <QuartzCore/CIImage.h>
#import <SoftwareMenuFramework/SoftwareMenuFramework.h>
#import "SMSlideshow.h"
#import "SMSSettings.h"
#import <SoftwareMenuFramework/CoreGraphicsFunctions.h>
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
+(BRController *)pluginOptions;
{
    return [[SMSSettings alloc]init];
}
+(BOOL)hasPluginSpecificOptions
{
    return YES;
}
-(BRControl *)backgroundControl
{
    if (_control == nil) {
        NSLog(@"creating new slideshow");
        _control = [[SMSlideshowControl alloc] init];
        [_control setAutoresizingMask:1];
        //[(BRImageControl *)_control setAutomaticDownsample:TRUE];
        [_control retain];
        [_control retain];
        [_control setTargetOpacity:0.3f];
//        CATransition *llayer = [CATransition animation];
//        [llayer setType:kCATransitionFade];
    }
    [_control setTargetOpacity:[SMSSettings opacity]];
    [_control setTransitionDuration:[SMSSettings transitionDuration]];
    [_control setTransitionStyle:[SMSSettings transitionStyle]];
    [_control setImageDuration:(NSTimeInterval)[SMSSettings imageDuration]];
    [_control setRandomOrder:[SMSSettings randomizeOrder]];
    [_control setAutoRotateEffect:[SMSSettings autoRotateTransitions]];
    
   // [_control setTransitionEffect:[SMSSettings transitionEffect]];
    [_control setFolder:[SMSSettings imageFolder]];

    CGRect a;
    a.size=[BRWindow maxBounds];
    [_control setFrame:a];
    [_control startSlideshowTimer];
    _lastFireDate=[NSDate date];
    [_lastFireDate retain];
    //NSLog(@"%@",_lastFireDate);
    //[NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(callU) userInfo:nil repeats:NO];
    return _control;
}

//-(void)updateImage
//{
//
//    if ([[_control parent] parent]==[[[BRApplicationStackManager singleton]stack]peekController]) {
//        [_control nextImage];
////        [(SMSlideshowControl *)_control setCurrentImage:[BRImage imageWithPath:[_imagePaths objectAtIndex:_imageNb++]]];
////        //CGSize size = [(BRImageControl *)_control preferredFrameSize];
////        //NSLog(@"width: %lf, height: %lf, aspectRatio: %lf",size.width,size.height,[(BRImageControl *)_control aspectRatio]);
////        if (_imageNb==[_imagePaths count]) {
////            _imageNb=0;
////        }
//        //BOOL crop=TRUE;
////        if (crop && [_control aspectRatio]>1) {
////            CGSize maxBounds= [BRWindow maxBounds];
////            CGRect newFrame;
////            newFrame.size.width=maxBounds.width;
////            newFrame.size.height=newFrame.size.width/[_control aspectRatio];
////            newFrame.origin.x=0;
////            newFrame.origin.y=(maxBounds.height-newFrame.size.height)/2.0f;
////            [_control setFrame:newFrame];
////        }
////        [_control layoutSubcontrols];
////        CALayer *layer = [_control layer];
////        ALog(@"layer: %@",layer);
////        NSLog(@"nslayer: %@",layer);
////        DLog(@"delegate: %@ self: %@" ,[layer delegate],_control);
////        DLog(@"Contents: %@",[layer contents]);
////        DLog(@"actions: %@",[_control actions]);
//        //NSLog(@"%@",_lastFireDate);
//        [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(callU) userInfo:nil repeats:NO];
//    }
//    else {
////        NSLog(@"not top controller");
//    }
//
//}
-(void)callU
{
   // NSLog(@"_laSTFire: %@",_lastFireDate);
    double time = [[NSDate date] timeIntervalSinceDate:_lastFireDate];
    if(time>29)
    {
        [_lastFireDate release];
        _lastFireDate=[NSDate date];
        [_lastFireDate retain];
        //[self updateImage];
        
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
    id controller = [BRController controllerWithContentControl:[[[SMSlideshowMext alloc] init] backgroundControl]];
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
    return controller;
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
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSData *shadingBitmapData = [NSData dataWithContentsOfFile:[bundle pathForResource:@"restrictedshine" ofType:@"tiff"]];
    NSBitmapImageRep *shadingBitmap = [[[NSBitmapImageRep alloc] initWithData:shadingBitmapData] autorelease];
    inputShadingImage = [[CIImage alloc] initWithBitmapImageRep:shadingBitmap];
    
    // Preload mask bitmap to use in transitions.
    NSData *maskBitmapData = [NSData dataWithContentsOfFile:[bundle pathForResource:@"transitionmask" ofType:@"jpg"]];
    NSBitmapImageRep *maskBitmap = [[[NSBitmapImageRep alloc] initWithData:maskBitmapData] autorelease];
    inputMaskImage = [[CIImage alloc] initWithBitmapImageRep:maskBitmap];

    targetOpacity=0.3f;
    useTimer=YES;
    random=NO;
    autoRotateEffect=TRUE;
    timerTime=30;
    transitionDuration=2.5;
    transitionStyle=SlideshowViewModTransitionStyle;
    _fileListing=[[NSArray alloc] init];
//    _orderArray=[[NSArray alloc] init];
    currentImage=0;
    slideshowInterval=10.0f;
    [self updateSubviewsTransition];
    return self;
}
-(void)setAutoRotateEffect:(BOOL)ar
{
    autoRotateEffect=ar;
}
-(BOOL)autoRotateEffect
{
    return autoRotateEffect;
}
- (NSTimeInterval)slideshowInterval {
    return slideshowInterval;
}
- (void)startSlideshowTimer {
    if (slideshowTimer == nil && [self slideshowInterval] > 0.0) {
        // Schedule an ordinary NSTimer that will invoke -advanceSlideshow: at regular intervals, each time we need to advance to the next slide.
        slideshowTimer = [[NSTimer scheduledTimerWithTimeInterval:[self slideshowInterval] target:self selector:@selector(advanceSlideshow:) userInfo:nil repeats:YES] retain];
        [self advanceSlideshow:slideshowTimer force:TRUE];
    }
}

-(void)advanceSlideshow:(NSTimer *)timer force:(BOOL)force
{
    int count = [_fileListing count];
    BOOL isVisible=NO;
    BOOL done=NO;
    id parent=[self parent];
    if (force) {
        done=TRUE;
        isVisible=TRUE;
    }
    else
        while (done==FALSE) {
            if (parent) 
            {
                if ([parent isKindOfClass:[BRController class]]) {
                    if ([parent topOfStack])                
                        isVisible=TRUE;
                    done=TRUE;
                }
                else if([parent isKindOfClass:[BRControl class]])
                {
                    parent=[parent parent];
                }
            }
            else
                done=TRUE;
        }
    if (_fileListing != nil && count > 0 && isVisible) {
        // Find the next Asset in the slideshow.
        int startIndex = currentImagePath ? [_fileListing indexOfObject:currentImagePath] : 0;
        int index = (startIndex + 1) % count;
        while (index != startIndex) {
            NSString *asset = [_fileListing objectAtIndex:index];
            
            // Load the full-size image.
            BRImage *image = [BRImage imageWithPath:asset];
            
            // Ask our SlideshowView to transition to the image.
            [self setCurrentImage:image];
            
            // Remember which slide we're now displaying.
            [currentImagePath release];
            
            currentImagePath = [asset retain];
            return;
            
            index = (index + 1) % count;
        }
        
    }

}
- (void)advanceSlideshow:(NSTimer *)timer {
    
    [self advanceSlideshow:timer force:FALSE];
}
- (void)stopSlideshowTimer {
    if (slideshowTimer != nil) {
        // Cancel and release the slideshow advance timer.
        [slideshowTimer invalidate];
        [slideshowTimer release];
        slideshowTimer = nil;
    }
}
- (void)setSlideshowInterval:(NSTimeInterval)newSlideshowInterval {
    if (slideshowInterval != newSlideshowInterval) {
        // Stop the slideshow, change the interval as requested, and then restart the slideshow (if it was running already).
        [self stopSlideshowTimer];
        slideshowInterval = newSlideshowInterval;
        if (slideshowInterval > 0.0) {
            [self startSlideshowTimer];
        }
    }
}
//-(void)nextImage
//{
//    int count = [_fileListing count];
//    if (count!=0) {
//        if (currentImage>=count-1) {
//            currentImage=0;
//        }
//        else 
//        {
//            currentImage++;
//        }
//        NSLog(@"nextImage: %@, loaded: %d",nextImage,loaded);
//        if (loaded && nextImage!=nil) {
//            ALog(@"NEXT image gg");
//            [self setCurrentImage:nextImage];
//        }
//        else
//        {
//            [self setCurrentImage:[BRImage imageWithPath:[_fileListing objectAtIndex:currentImage]]];
//        }
//        
//
//    }
//}

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
    if (!random) {
        _fileListing = [[files sortedArrayUsingSelector:@selector(compare:)] retain];
    }
    else {
        _fileListing = [[files shuffled]retain];
    }

    //_fileListing=[[files copy] retain];
}
-(NSArray *)files
{
    return _fileListing;
}
-(void)setImageDuration:(NSTimeInterval)imageDuration
{
    slideshowInterval=(NSTimeInterval)imageDuration;
}
-(NSTimeInterval)imageDuration
{
    return slideshowInterval;
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
-(void)setTransitionStyle:(SlideshowTransitionStyle)st
{
    transitionStyle=st;
    [self updateSubviewsTransition];
}
-(SlideshowTransitionStyle)transitionStyle
{
    return transitionStyle;
}





-(void)setCurrentImage:(BRImage *)image
{
//    DLog(@"Current: %@, Old: %@",curImage,oldImage);
    if(autoRotateEffect)
    {
        //transitionStyle=((transitionStyle +1) %NumberOfSlideshowViewTransitionStyles);
        [self setTransitionStyle:((transitionStyle +1) %NumberOfSlideshowViewTransitionStyles)];
        //[self updateSubviewsTransition];
    }
    //[self setTransitionStyle:(([self transitionStyle] + 1) % NumberOfSlideshowTransitionStyles)];
//    [self setImage:image];
    crop=TRUE;
    if(image!=nil)
    {
        if (curImage!=nil) {
            //[[curImage layer] removeAllAnimations];
            if (oldImage!=nil) {
                //[oldImage removeFromParent];
                [oldImage release];
                oldImage=nil;
            }
            oldImage=curImage;
        }
        curImage=[[BRImageControl alloc] init];
        [curImage setAutomaticDownsample:YES];
        [curImage setImage:image];
        if (crop && [curImage aspectRatio]>1) {
            CGSize maxBounds= [BRWindow maxBounds];
            CGRect newFrame;
            newFrame.size.width=maxBounds.width;
            newFrame.size.height=newFrame.size.width/[curImage aspectRatio];
            newFrame.origin.x=0;
            newFrame.origin.y=(maxBounds.height-newFrame.size.height)/2.0f;
            [curImage setFrame:newFrame];
        }
        else {
            CGSize maxBounds= [BRWindow maxBounds];
            CGRect newFrame;
            newFrame.size.height=maxBounds.height;
            newFrame.size.width=newFrame.size.height*[curImage aspectRatio];
            newFrame.origin.x=(maxBounds.width-newFrame.size.width)/2.0f;
            newFrame.origin.y=0;
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

           [oldImage removeFromParent];
           [oldImage release];
           oldImage=nil;


        }
        

        
        
        
    }

        

}


- (void)updateSubviewsTransition {
    CGRect rect = [BRWindow interfaceFrame];
    NSString *transitionType = nil;
    CIFilter *transitionFilter = nil;
    CIFilter *maskScalingFilter = nil;
    CGRect maskExtent;
//     NSLog(@"inputShading: %@, backing: %@",inputShadingImage,inputMaskImage);
    // Map our transitionStyle to one of Core Animation's four built-in CATransition types, or an appropriately instantiated and configured Core Image CIFilter.  (The code used to construct the CIFilters here is very similar to that in the "Reducer" code sample from WWDC 2005.  See http://developer.apple.com/samplecode/Reducer/ )
    switch (transitionStyle) {
        case SlideshowViewFadeTransitionStyle:
            transitionType = @"fade";
            break;
            
        case SlideshowViewMoveInTransitionStyle:
            transitionType = @"moveIn";
            break;
            
        case SlideshowViewPushTransitionStyle:
            transitionType = @"push";
            break;
            
        case SlideshowViewRevealTransitionStyle:
            transitionType = @"reveal";
            break;
            
        case SlideshowViewCopyMachineTransitionStyle:
            transitionFilter = [[CIFilter filterWithName:@"CICopyMachineTransition"] retain];
            [transitionFilter setDefaults];
            [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
            break;
            
        case SlideshowViewDisintegrateWithMaskTransitionStyle:
            transitionFilter = [[CIFilter filterWithName:@"CIDisintegrateWithMaskTransition"] retain];
            [transitionFilter setDefaults];
            
            // Scale our mask image to match the transition area size, and set the scaled result as the "inputMaskImage" to the transitionFilter.
            maskScalingFilter = [CIFilter filterWithName:@"CILanczosScaleTransform"];
            [maskScalingFilter setDefaults];
            maskExtent = [inputMaskImage extent];
            float xScale = rect.size.width / maskExtent.size.width;
            float yScale = rect.size.height / maskExtent.size.height;
            [maskScalingFilter setValue:[NSNumber numberWithFloat:yScale] forKey:@"inputScale"];
            [maskScalingFilter setValue:[NSNumber numberWithFloat:xScale / yScale] forKey:@"inputAspectRatio"];
            [maskScalingFilter setValue:inputMaskImage forKey:@"inputImage"];
            
            [transitionFilter setValue:[maskScalingFilter valueForKey:@"outputImage"] forKey:@"inputMaskImage"];
            break;
            
        case SlideshowViewDissolveTransitionStyle:
            transitionFilter = [[CIFilter filterWithName:@"CIDissolveTransition"] retain];
            [transitionFilter setDefaults];
            break;
            
        case SlideshowViewFlashTransitionStyle:
            transitionFilter = [[CIFilter filterWithName:@"CIFlashTransition"] retain];
            [transitionFilter setDefaults];
            [transitionFilter setValue:[CIVector vectorWithX:CGMidX(rect) Y:CGMidY(rect)] forKey:@"inputCenter"];
            [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
            break;
            
        case SlideshowViewModTransitionStyle:
            transitionFilter = [[CIFilter filterWithName:@"CIModTransition"] retain];
            [transitionFilter setDefaults];
            [transitionFilter setValue:[CIVector vectorWithX:CGMidX(rect) Y:CGMidY(rect)] forKey:@"inputCenter"];
            NSLog(@"originx %lf y: %lf w: %lf, h: %lf, midX: %lf, midY: %lf",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height,CGMidX(rect),CGMidY(rect));

            break;
            
        case SlideshowViewPageCurlTransitionStyle:
           
            transitionFilter = [[CIFilter filterWithName:@"CIPageCurlTransition"] retain];
            [transitionFilter setDefaults];
            [transitionFilter setValue:[NSNumber numberWithFloat:-M_PI_4] forKey:@"inputAngle"];
            [transitionFilter setValue:inputShadingImage forKey:@"inputShadingImage"];
            [transitionFilter setValue:inputShadingImage forKey:@"inputBacksideImage"];
            [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
            break;
            
        case SlideshowViewSwipeTransitionStyle:
            transitionFilter = [[CIFilter filterWithName:@"CISwipeTransition"] retain];
            [transitionFilter setDefaults];
            break;
            
        case SlideshowViewRippleTransitionStyle:
        default:
            transitionFilter = [[CIFilter filterWithName:@"CIRippleTransition"] retain];
            [transitionFilter setDefaults];
            [transitionFilter setValue:[CIVector vectorWithX:(rect.origin.x+rect.size.width/2) Y:(rect.origin.y+rect.size.height/2)] forKey:@"inputCenter"];
            [transitionFilter setValue:[CIVector vectorWithX:rect.origin.x Y:rect.origin.y Z:rect.size.width W:rect.size.height] forKey:@"inputExtent"];
            [transitionFilter setValue:inputShadingImage forKey:@"inputShadingImage"];
            break;
    }
    
    // Construct a new CATransition that describes the transition effect we want.
    CATransition *transition = [CATransition animation];
    if (transitionFilter) {
        // We want to build a CIFilter-based CATransition.  When an CATransition's "filter" property is set, the CATransition's "type" and "subtype" properties are ignored, so we don't need to bother setting them.
        [transition setFilter:transitionFilter];
    } else {
        // We want to specify one of Core Animation's built-in transitions.
        [transition setType:transitionType];
        [transition setSubtype:@"fromLeft"];
    }
//    NSLog(@"transitionStyle: %i, transition: %@\nfilter: %@, type: %@",transitionStyle,transition,transitionFilter,transitionType);
    // Specify an explicit duration for the transition.
    [transition setDuration:self.transitionDuration];
    
    // Associate the CATransition we've just built with the "subviews" key for this SlideshowView instance, so that when we swap ImageView instances in our -transitionToImage: method below (via -replaceSubview:with:).
    [self setActions:[NSDictionary dictionaryWithObject:transition forKey:@"sublayers"]];
    //[self setAnimations:[NSDictionary dictionaryWithObject:transition forKey:@"sublayers"]];
}

@end


