//
//  SMUpdaterPreprocess.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 12/1/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//



@interface SMUpdaterPreprocess : SMController {
    BRTextControl *         _OSText;
    BRTextControl *         _IRInstalletText;
    BRTextControl *         _IRDataText;
    BRTextControl *         _EFIInstallerText;
    BRTextControl *         _EFIDataText;
    BRTextControl *         _SIInstallerText;
    BRTextControl *         _SIDataText;
}
-(void)layoutSubcontrols;
@end
