//
//  SMMainMenuPU.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 3/13/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//




@implementation SMMainMenuPU
-(void)controlWasActivated
{
    [super controlWasActivated];
    CGRect frame = [self frame];
    frame.size.width=[BRWindow maxBounds].width/2.;
    [self setFrame:frame];
    [self dismissContextMenu];
}
@end
