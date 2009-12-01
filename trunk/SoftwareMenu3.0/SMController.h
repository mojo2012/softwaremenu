//
//  SMController.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/30/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//



@interface SMController : BRController {
    int padding[128];
    int m_screen_saver_timeout;
}
- (void) disableScreenSaver;
- (void) enableScreenSaver;
- (CGRect)getMasterFrame;
- (BOOL)is1080i;
- (CGSize)sizeFor1080i;
@end
