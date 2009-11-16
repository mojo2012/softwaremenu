//
//  BRMainMenuController-SMExtensions.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/8/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BRMainMenuController (SMExtensions)
-(BRMainMenuControl *)gimmeControl;
@end
@interface BRMainMenuControl (SMExtensions)
-(BRControl *)gimmeCurControl;
@end

@interface BRCyclerControl (SMExtensions) 
-(id)gimmeProvider;
-(BRControl *)gimmeControl;
@end

