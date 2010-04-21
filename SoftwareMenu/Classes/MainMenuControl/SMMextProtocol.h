//
//  SMMextProtocol.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/13/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


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

@optional
-(BRController *)pluginOptions;

@end
