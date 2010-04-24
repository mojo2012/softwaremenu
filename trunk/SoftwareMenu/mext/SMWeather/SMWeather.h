//
//  SMWeather.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/12/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
#import "SMWeatherController.h"
@protocol SMMextProtocol
// For loading a control behind the main menu
-(BRControl *)backgroundControl;
// For loading a controller on menu press
-(BRController *)controller;
// Check if plugin has custom settings menu
+(BOOL)hasPluginSpecificOptions;
// Summary for plugin
+(NSString *)pluginSummary;
// Developer Name
+(NSString *)developer;

-(BRController *)ioptions;


@optional
-(BRController *)pluginOptions;

@end

@interface SMWeatherMext : NSObject<SMMextProtocol> {
}
-(BRControl *)backgroundControl;
-(BRController *)controller;
@end
