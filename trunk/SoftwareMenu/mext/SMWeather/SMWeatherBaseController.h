//
//  SMWeatherBaseController.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/24/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMWeatherBaseController : SMFCenteredMenuController {
    NSMutableDictionary *_locations;
    int                  _current;
    int                  _notLocs;
}
-(void)loadLocations;
-(void)remove:(NSNumber *)code;
@end
