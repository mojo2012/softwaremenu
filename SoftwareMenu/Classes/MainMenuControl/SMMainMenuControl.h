//
//  SMMainMenuControl.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/11/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@interface BRListControl (SMExtensions)
-(BOOL)widgetHidden;
-(void)setWidgetHidden:(BOOL)hide;
@end

@interface BRApplianceColumnControl (SM)
-(void)test;
-(id)appliance;
@end


@interface SMMainMenuControl : BRMainMenuControl {
    NSBundle *_controlBundle;
}
-(BOOL)topGradientIsThere;
-(void)hideTopGradient;
-(void)showTopGradient;
@end
