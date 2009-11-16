//
//  SMMainMenuMediaControl.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/8/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMAsyncImageControl : BRAsyncImageControl {
    NSTimer *_checkTimer;
}
-(void)returnInfo;
-(id)getImageForId:(NSString *)idstr;
@end
@interface SMMainMenuShelfControl : BRMainMenuShelfControl
{
    
}
@end