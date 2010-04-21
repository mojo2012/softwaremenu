//
//  SMYahooWeather.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/14/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMYahooWeather.h"


@implementation SMYahooWeather
+(NSDictionary *)parseYahooRSS:(NSXMLDocument *)rootElt
{
#define XMLATSTR(dict,element,key)    [(dict) setObject:[[(element) attributeForName:(key)]stringValue]forKey:(key)]
#define XMLATSTRK(dict,element,key,keyt)    [(dict) setObject:[[(element) attributeForName:(key)]stringValue]forKey:(keyt)]
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    NSArray *val=[rootElt nodesForXPath:@"./rss/channel/yweather:location" error:nil];
    if([val count]!=0)
    {
        NSXMLElement *elt=[val objectAtIndex:0];
        XMLATSTR(dict,elt,@"city");
        XMLATSTR(dict,elt,@"region");
        XMLATSTR(dict,elt,@"country");
    }
    val = [rootElt nodesForXPath:@"./rss/channel/yweather:units" error:nil];
    if([val count]!=0)
    {
        NSXMLElement *elt=[val objectAtIndex:0];
        XMLATSTR(dict,elt,@"temperature");
        XMLATSTR(dict,elt,@"distance");
        XMLATSTRK(dict,elt,@"pressure",@"pressureU");
        XMLATSTRK(dict,elt,@"speed",@"speedU");
    }
    val = [rootElt nodesForXPath:@"./rss/channel/yweather:wind" error:nil];
    if([val count]!=0)
    {
        NSXMLElement *elt=[val objectAtIndex:0];
        XMLATSTR(dict,elt,@"chill");
        XMLATSTR(dict,elt,@"direction");
        XMLATSTR(dict,elt,@"speed");
    }
    val = [rootElt nodesForXPath:@"./rss/channel/yweather:atmosphere" error:nil];
    if([val count]!=0)
    {
        NSXMLElement *elt=[val objectAtIndex:0];
        XMLATSTR(dict,elt,@"humidity");
        XMLATSTR(dict,elt,@"visibility");
        XMLATSTR(dict,elt,@"pressure");
        XMLATSTR(dict,elt,@"rising");
    }
    val = [rootElt nodesForXPath:@"./rss/channel/yweather:astronomy" error:nil];
    if([val count]!=0)
    {
        NSXMLElement *elt=[val objectAtIndex:0];
        XMLATSTR(dict,elt,@"sunrise");
        XMLATSTR(dict,elt,@"sunset");
    }
    //    val = [rootElt nodesForXPath:@"./rss/channel/item/yweather:atmosphere" error:nil];
    //    if([val count]!=0)
    //    {
    //        NSXMLElement *elt=[val objectAtIndex:0];
    //        XMLATSTR(dict,elt,@"sunrise");
    //        XMLATSTR(dict,elt,@"sunset");
    //    }
    val=[rootElt nodesForXPath:@"./rss/channel/item" error:nil];
    NSLog(@"val: %@",val);
    if ([val count]!=0) {
        NSXMLElement *elt=[val objectAtIndex:0];
        val=[elt nodesForXPath:@"./yweather:condition" error:nil];
        if ([val count]!=0) {
            NSXMLElement *elt2=[val objectAtIndex:0];
            XMLATSTR(dict,elt2,@"text");
            XMLATSTR(dict,elt2,@"code");
            XMLATSTR(dict,elt2,@"temp");
            XMLATSTR(dict,elt2,@"date");
        }
        val=[elt nodesForXPath:@"./yweather:forecast" error:nil];
        if([val count]!=0)
        {
            NSMutableArray *forecasts=[[NSMutableArray alloc]init];
            int i;
            for(i=0;i<[val count];i++)
            {
                NSMutableDictionary *tempDict=[[NSMutableDictionary alloc]init];
                NSXMLElement *elt2=[val objectAtIndex:i];
                XMLATSTR(tempDict,elt2,@"day");
                XMLATSTR(tempDict,elt2,@"date");
                XMLATSTR(tempDict,elt2,@"low");
                XMLATSTR(tempDict,elt2,@"high");
                XMLATSTR(tempDict,elt2,@"text");
                XMLATSTR(tempDict,elt2,@"code");
                [forecasts addObject:tempDict];
            }
            [dict setObject:forecasts forKey:@"forecast"];
        }
    }
    NSLog(@"dict: %@",dict);
    return dict;
}
@end
