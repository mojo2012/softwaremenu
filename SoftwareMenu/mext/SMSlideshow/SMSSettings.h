//
//  SMSSettings.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 5/8/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMSlideshow.h"

@interface SMSSettings : SMFMediaMenuController {

}
+(float)transitionDuration;
+(int)imageDuration;
+(float)opacity;
+(NSString *)imageFolder;
+(BOOL)randomizeOrder;
+(BOOL)autoRotateTransitions;

-(void)dirSelected:(NSString *)dir;
+(SlideshowTransitionStyle)transitionStyle;
+(void)setTransitionStyle:(SlideshowTransitionStyle)style;
@end
