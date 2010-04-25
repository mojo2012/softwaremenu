//
//  SMWeatherController.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/16/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMWeather.h"

extern NSString *kWeatherDefaultKey;
extern NSString *kWeatherWatchKey;
extern NSString *kWeatherUSUnitsKey;
extern NSString *kWeatherTimeZoneKey;
extern NSString *kWeatherRemoveKey;
extern NSString *kWeatherCityKey;

@interface SMWeatherController : SMFCenteredMenuController {
    int                     _code;
    int                     _current;
    NSMutableDictionary    *_location;
}
- (id)initWithCode:(int)code;
+(int)yWeatherCode;
+(void)setYWeatherCode:(int)code;
+(int)refreshMinutes;
+(void)setRefreshMinutes:(int)min;
+(BOOL)USUnitsForCode:(int)code;
+(BOOL)USUnits;
+(void)setUSUnits:(BOOL)units;
+(NSDictionary *)Locations;
+(void)setLocations:(NSDictionary *)locations;
+(void)setDefaultYWeatherCode;
+(NSString *)tzForCode:(int)code;

-(void)setTimeZone:(NSString *)tz forCode:(NSNumber *)code;
-(void)remove:(NSNumber *)code;
-(void)save;
@end
