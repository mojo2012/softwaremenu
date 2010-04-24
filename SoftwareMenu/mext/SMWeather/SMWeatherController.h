//
//  SMWeatherController.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/16/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMWeather.h"

@interface SMWeatherController : BRMenuController {
    int padding [48];
	NSMutableArray *	_items;
	NSMutableArray *	_options;
    int                 _current;
}
+(int)yWeatherCode;
+(void)setYWeatherCode:(int)code;
+(int)refreshMinutes;
+(void)setRefreshMinutes:(int)min;
+(BOOL)USUnits;
+(void)setUSUnits:(BOOL)units;
+(NSDictionary *)Locations;
+(void)setLocations:(NSDictionary *)locations;
+(void)setDefaultYWeatherCode;
+(NSString *)tzForCode:(int)code;
-(float)heightForRow:(long)row;
-(BOOL)rowSelectable:(long)row;
-(long)itemCount;
-(id)itemForRow:(long)row;
-(long)rowForTitle:(id)title;
-(id)titleForRow:(long)row;
-(int)getSelection;
-(id)everyLoad;
@end
