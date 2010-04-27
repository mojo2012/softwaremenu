//
//  SMFSpinnerMenu.h
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 4/27/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMFSpinnerMenu :  BRTextWithSpinnerController {
    BRAutoScrollingTextControl *    _ctrl;
}
-(void)textDidChange:(NSString *)string;
-(void)textDidEndEditing:(NSString *)string;
@end
