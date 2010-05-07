//
//  SMWeatherControl.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/14/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SMWeather.h"

NSString *const kCAMediaTimingFunctionEaseIn;
NSString *const kCATransitionPush;
NSString *const kCATransitionFromRight;
NSString *const kCATransitionFade;

@interface SMWeatherControl : BRControl {
    BRTextControl   *_city;
    BRTextControl   *_region_country;
    BRTextControl   *_date;
    BRTextControl   *_text;
    BRTextControl   *_sunrise;
    BRTextControl   *_sunset;
    NSDictionary    *_infoDict;
    BRImageControl  *_centerImage;
    BRImageControl  *_weatherImage1;
    BRImageControl  *_weatherImage2;
    BRTextControl   *_temperature;
    BRTextControl   *_windSpeed;
    BRTextControl   *_windChill;
    BRTextControl   *_windDirection;
    BRTextControl   *_humidity;
    BRTextControl   *_pressure;
    BRTextControl   *_forecastDate1;
    BRTextControl   *_forecastDate2;
    BRTextControl   *_forecastHigh1;
    BRTextControl   *_forecastHigh2;
    BRTextControl   *_forecastLow1;
    BRTextControl   *_forecastLow2;
    BOOL             _firstLoad;
    NSTimeZone      *_timezone;
}
-(void)hideall;
-(void)showall;
-(void)setInfoDictionary:(NSDictionary *)infoDict;
-(BRImage *)imageForCode:(NSString *)code;
-(BRImage *)imageForCode:(NSString *)code forForecast:(BOOL)forecast;
-(int)convertTimeToInt:(NSString *)time;
-(NSDate*)parseDate:(NSString *)date;
-(void)checkInfoDict;
-(void)drawControls;
-(void)drawControlsN;
-(void)reload;
-(void)setTimeZones:(NSString *)tz;
-(void)loadUsDictionaryForCode:(NSNumber *)code;
-(void)loadEuDictionaryForCode:(NSNumber *)code;
-(NSDictionary *)loadDictionaryForCode:(int)code usUnits:(BOOL)us;
@end
