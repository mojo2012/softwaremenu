//
//  SMScriptOptions.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/23/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
//#import <SoftwareMenuFramework/SMFCenteredMenuController.h>


@class SMFCenteredMenuController;
@interface SMScriptOptions : SMFCenteredMenuController {
    NSString            *       _scriptName;
    NSMutableDictionary *       _scriptOptions;
}
-(id)initWithScriptName:(NSString *)scriptName;
-(void)setScriptName:(NSString *)name;
-(NSString *)scriptName;
@end
