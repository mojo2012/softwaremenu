//
//  SMSSettings.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 5/8/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMSSettings : SMFMediaMenuController {

}
+(float)transitionDuration;
+(NSString *)transitionEffect;
+(int)imageDuration;
+(float)opacity;
+(NSString *)imageFolder;
+(BOOL)randomizeOrder;

-(void)dirSelected:(NSString *)dir;
@end
