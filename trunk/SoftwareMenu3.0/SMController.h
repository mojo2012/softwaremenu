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
    NSString *                  _title;
    BRHeaderControl *           _headerControl;
    BRWaitSpinnerControl *      _spinner;
    BRImage *                   _image;
    BRImageControl *            _imageControl;
}
- (void) disableScreenSaver;
- (void) enableScreenSaver;
- (CGRect)getMasterFrame;
- (BOOL)is1080i;
- (CGSize)sizeFor1080i;
@end
@interface SMController (layout)
-(void)layoutSpinner;
-(void)layoutHeader;
-(void)layoutImage;
@end

