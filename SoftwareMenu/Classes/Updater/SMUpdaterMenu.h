//
//  SMUpdaterMenu.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 12/4/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMUpdaterMenu : SMFMediaMenuController {
    NSMutableArray *_descriptions;
    NSMutableArray *_names;
    int sel_version;
}
-(id)getChoices:(NSString *)URL;
@end
