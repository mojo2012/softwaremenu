//
//  SMWeather.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/12/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BackRow/BackRow.h>
//#import <SoftwareMenuFramework/SoftwareMenuFramework.h>


@interface SMWeatherMext : NSObject<SMMextProtocol> {
}
//+(SMWeatherControl *)control;
//+(void)reload;
+(NSDictionary *)loadDictionaryForCode:(int)code;
+(NSDictionary *)loadDictionaryForCode:(int)code usUnits:(BOOL)us;
+(void)reload;
-(BRControl *)backgroundControl;
-(BRController *)controller;
@end
