//
//  SMMainMenuMediaControl.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/8/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import "SMMainMenuMediaControl.h"


@implementation SMAsyncImageControl
-(void)returnInfo
{
    
    //[checkTimer release]
    //NSLog(@"cool");
    id a = [[[[BRApplicationStackManager singleton] stack] rootController] gimmeControl];
    //id b = [a gimmeCurControl];
    if([[SMGeneralMethods menuItemOptions]containsObject:[a _currentCategoryIdentifier]])
    {
        NSLog(@"current: %@",[a _currentCategoryIdentifier]);
        [self setDefaultImage:[self getImageForId:[a _currentCategoryIdentifier]]];
        [self layoutSubcontrols];
        _checkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTime) userInfo:nil repeats:NO];

    }
}
-(void)updateTime
{
    [_checkTimer invalidate];
    if([self respondsToSelector:@selector(returnInfo)])
    {
        [self returnInfo];
    }
}
-(id)getImageForId:(NSString *)idstr
{
    if ([idstr isEqualToString:@"SMsettings"])
    {
        return [[BRThemeInfo sharedTheme] gearImage];//[[SMThemeInfo sharedTheme] systemPrefsImage];
    }
    else if ([idstr isEqualToString:@"SMphotos"]) {
        return [[BRThemeInfo sharedTheme] photosImage];
    }
    return [[SMThemeInfo sharedTheme] softwareMenuImage];
}
@end
@implementation SMMainMenuShelfControl
-(BOOL)brEventAction:(BREvent *)arg1
{
    NSLog(@"event: %@",arg1);
    NSLog(@"event: %i",[arg1 remoteAction]);
    if ([arg1 remoteAction]==5) {
        NSLog(@"play");
        NSLog(@"cells: %@",_cells);
    }
    return [super brEventAction:arg1];
}
@end

