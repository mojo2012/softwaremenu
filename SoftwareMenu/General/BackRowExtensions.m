//
//  BackRowExtensions.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/24/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//



@implementation BRControllerStack (SoftwareMenuExtensions)
- (id)customRootController
{
    NSArray *controllers = [[[BRApplicationStackManager singleton] stack] controllers];
    if ([[controllers objectAtIndex:1] isKindOfClass:[SMMainMenuController class]]) {
        return [controllers objectAtIndex:1];
    }
    return [self rootController];
}
@end