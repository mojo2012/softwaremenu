//
//  SMYahooWeather.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/14/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMYahooWeather : NSObject {

}
+(NSDictionary *)parseYahooRSS:(NSXMLDocument *)rootElt;
@end
