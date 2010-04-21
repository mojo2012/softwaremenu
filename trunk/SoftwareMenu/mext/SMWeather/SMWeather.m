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

static SMWeatherControl *_control;

@implementation SMWeatherMext

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
-(void)callU
{
    //[NSString stringWithContentsOfURL:<#(NSURL *)url#>]
    NSString *data=[NSString stringWithContentsOfFile:@"/Users/frontrow/data.xml"];
//    NSError *error;
//    NSString *data2=[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://weather.yahooapis.com/forecastrss?w=2442047"]
//                                         usedEncoding:NSUTF8StringEncoding 
//                                                error:&error];
//    NSLog(@"error: %@",error);
//    //NSString *decodedString = [NSString stringWithUTF8String:[data2 cStringUsingEncoding:NSUnicodeStringEncoding]];
//
//    //    [data2 writeToFile:@"/Users/frontrow/hello.xml" atomically:YES];
//    NSLog(@"data: %@",data2);
//    NSXMLDocument* b=[NSXMLDocument alloc];
//    
//     [b initWithContentsOfURL:[NSURL URLWithString:@"http://weather.yahooapis.com/forecastrss?w=2442047"]
//                                              options:NSXMLDocumentTidyXML 
//                                                error:&error];
//    [b setCharacterEncoding:@"UTF-8"];
//    
//    
//    NSLog(@"b: %@",b);
    NSXMLDocument *doc = [[NSXMLDocument alloc]initWithXMLString:data options:NSXMLDocumentTidyXML error:nil];
    NSDictionary *dict = [SMYahooWeather parseYahooRSS:doc];
//    NSLog(@"dict: %@",dict);
    [_control setInfoDictionary:[NSDictionary dictionary]];
    
    [_control setInfoDictionary:dict];
    [NSTimer scheduledTimerWithTimeInterval:1800 target:self selector:@selector(callU) userInfo:nil repeats:NO];
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
    return nil;
}
+(BOOL)hasPluginSpecificOptions
{
    return YES;
}
+(BRController *)pluginOptions;
{
    id a =[[SMWeatherController alloc]init];
    return a;
//    id a =[[SMWeatherSettings alloc] init];
//    return [a retain];
}
-(BRController *)ioptions;
{
    id a =[[SMWeatherController alloc]init];
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
