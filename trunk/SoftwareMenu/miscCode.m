//
//  miscCode.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 5/6/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "miscCode.h"


@implementation miscCode
-(void)pulse
{
    CIFilter *filter = [CIFilter filterWithName:@"CIBloom"];
    
    [filter setDefaults];
    
    [filter setValue:[NSNumber numberWithFloat:5.0] forKey:@"inputRadius"];
    
    
    
    // name the filter so we can use the keypath to animate the inputIntensity
    
    // attribute of the filter
    
    [filter setName:@"pulseFilter"];
    
    
    
    // set the filter to the selection layer's filters
    
    [_header setFilters:[NSArray arrayWithObject:filter]];
    
    
    
    // create the animation that will handle the pulsing.
    
    CABasicAnimation* pulseAnimation = [CABasicAnimation animation];
    
    
    
    // the attribute we want to animate is the inputIntensity
    
    // of the pulseFilter
    
    pulseAnimation.keyPath = @"filters.pulseFilter.inputIntensity";
    
    
    
    // we want it to animate from the value 0 to 1
    
    pulseAnimation.fromValue = [NSNumber numberWithFloat: 0.0];
    
    pulseAnimation.toValue = [NSNumber numberWithFloat: 1.5];
    
    
    
    // over one a one second duration, and run an infinite
    
    // number of times
    
    pulseAnimation.duration = 1.0;
    
    pulseAnimation.repeatCount = 1e100f;
    
    
    
    // we want it to fade on, and fade off, so it needs to
    
    // automatically autoreverse.. this causes the intensity
    
    // input to go from 0 to 1 to 0
    
    pulseAnimation.autoreverses = YES;
    
    
    
    // use a timing curve of easy in, easy out..
    
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    
    
    
    // add the animation to the selection layer. This causes
    
    // it to begin animating. We'll use pulseAnimation as the
    
    // animation key name
    
    [_header addAnimation:pulseAnimation forKey:@"pulseAnimation"];

}
-(void)fade
{
    CABasicAnimation *theAnimation;
    
    
    
    theAnimation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    
    theAnimation.duration=3.5;
    
    theAnimation.repeatCount=1;
    
    theAnimation.autoreverses=YES;
    
    theAnimation.fromValue=[NSNumber numberWithFloat:1.0];
    
    theAnimation.toValue=[NSNumber numberWithFloat:0.0];
    
    [_watermark addAnimation:theAnimation forKey:@"animateOpacity"];
}
@end
