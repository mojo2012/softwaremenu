//
//  SMFSimpleDirectoryChooserController.h
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 3/4/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SMFSimpleDirectoryChooserController : SMFCenteredMenuController {
    id _delegate;
    NSString *_topFolder;
    NSString *_folder;
    NSFileManager *_man;
}

- (void) textDidChange: (id) sender;
- (void) textDidEndEditing: (id) sender;

//Delegate needs to implement this:
- (void) dirSelected:(NSString *)dir;
@end
