//
//  SMWeather.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/12/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMWeather.h"
#import <BackRow/BackRow.h>
#import "SMYahooWeather.h"
#import "SMWeatherControl.h"
#import "SMWeatherController.h"
#import "SMWeatherBaseController.h"
#import "SMWeatherSelector.h"

static SMWeatherControl *_control;

@implementation SMWeatherMext

+(SMWeatherControl *)control
{
    if (_control==nil) {
        _control=[[SMWeatherControl alloc]init];
        [_control retain];
        [_control retain];
    }
    
        return _control;
    
}
+(void)reload
{
    //NSLog(@"control: %@",_control);
    if (_control==nil) {
        return;
    }
    [_control retain];
    [_control reload];
    
}
+(NSDictionary *)loadDictionaryForCode:(int)code
{
    return [SMWeatherMext loadDictionaryForCode:code usUnits:NO];
}
+(NSDictionary *)loadDictionaryForCode:(int)code usUnits:(BOOL)us
{
    NSURL *url;
    if (us) {
        url=[NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%i",code,nil]];
        
    }
    else
        url=[NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%i&u=c",code,nil]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
	NSURLResponse *response = nil;
    NSError *error;
	NSData *documentData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSXMLDocument *doc;
    if (error!=nil) {
        NSLog(@"error: %@",error);
        return [NSDictionary dictionary];
    }
    else {
        NSStringEncoding responseEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)[response textEncodingName]));
        NSString *documentString = [[NSString alloc] initWithData:documentData encoding:responseEncoding];
        doc=[[NSXMLDocument alloc]initWithXMLString:documentString options:NSXMLDocumentTidyXML error:nil];
        
    }
    NSDictionary *dict = [SMYahooWeather parseYahooRSS:doc];
    [doc release];
    return dict;
    
}
-(BRControl *)backgroundControl
{

    if (_control==nil) {
        _control=[[SMWeatherControl alloc]init];
        [_control retain];
        [_control retain];
    }
    else {
        return _control;
    }
    CGRect frame;
    frame.size=[BRWindow maxBounds];
    [_control setFrame:frame];
    //BRAlertControl *control = [BRAlertController alertOfType:1
//                                titled:@"Weather Error" 
//                           primaryText:@"not yet working" 
//                         secondaryText:@"Due to the fact that the dev does not have \n internet on his atv right now..."];
//    CGRect a;
//    
//    a.size=[BRWindow maxBounds];
//    [control setFrame:a];
//    [control setOpacity:0.3];
//    NSLog(@"returning controlwithframe");
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(callU) userInfo:nil repeats:NO];
    return _control;

}
-(void)hide
{
    [_control hideall];
}
-(void)callU
{
//    int code = [SMWeatherController yWeatherCode];
    int time = [SMWeatherController refreshMinutes];
//    BOOL us = [SMWeatherController USUnits];
//    NSURL *url;
//    if (us) {
//        url=[NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%i",code,nil]];
//    }
//    else
//        url=[NSURL URLWithString:[NSString stringWithFormat:@"http://weather.yahooapis.com/forecastrss?w=%i&u=c",code,nil]];
//             
//    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
//	NSURLResponse *response = nil;
//    NSString *data=[NSString stringWithContentsOfFile:@"/Users/frontrow/data.xml"];
//    NSError *error;
//	NSData *documentData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSXMLDocument *doc;
//    if (error!=nil) {
//        NSLog(@"error: %@",error);
//        doc=[[NSXMLDocument alloc]initWithXMLString:data options:NSXMLDocumentTidyXML error:nil];
//    }
//    else {
//        NSStringEncoding responseEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((CFStringRef)[response textEncodingName]));
//        NSString *documentString = [[NSString alloc] initWithData:documentData encoding:responseEncoding];
//        //NSLog(@"documentString: %@",documentString);
//        doc=[[NSXMLDocument alloc]initWithXMLString:documentString options:NSXMLDocumentTidyXML error:nil];
//        
//    }
//    NSDictionary *dict = [SMYahooWeather parseYahooRSS:doc];
//    [_control setInfoDictionary:[NSDictionary dictionary]];
    [_control reload];
    [NSTimer scheduledTimerWithTimeInterval:time*60 target:self selector:@selector(callU) userInfo:nil repeats:NO];
}
-(void)callU2
{
    NSString *data=[NSString stringWithContentsOfFile:@"/Users/frontrow/data2.xml"];
    NSXMLDocument *doc = [[NSXMLDocument alloc]initWithXMLString:data options:NSXMLDocumentTidyXML error:nil];
    NSDictionary *dict = [SMYahooWeather parseYahooRSS:doc];
    
    [_control setInfoDictionary:dict];
    [NSTimer scheduledTimerWithTimeInterval:1800 target:self selector:@selector(callU) userInfo:nil repeats:NO];

}
-(BRController *)controller
{
    return [[SMWeatherSelector alloc]init];
}
+(BOOL)hasPluginSpecificOptions
{
    return YES;
}
+(BRController *)pluginOptions;
{
    //id a =[[SMWeatherController alloc]init];
    return [[SMWeatherBaseController alloc]init];
}
-(BRController *)ioptions;
{
    id a =[[SMWeatherBaseController alloc]init];
    return a;
//    id a =[[SMWeatherSettings alloc] init];
//    [[[BRApplicationStackManager singleton]stack]pushController:a];
//    return nil;
}
+(NSString *)pluginSummary
{
    return @"Displays Weather Information in background";
}
+(NSString *)developer
{
    return @"Thomas Cool";
}
-(void)setupSubcontrols
{
    
}
@end
