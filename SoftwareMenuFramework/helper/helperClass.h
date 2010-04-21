//
//  helperClass.h
//  overflow
//
//  Created by Thomas Cool on 2/4/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface helperClass : NSObject {
    NSFileManager *_man;
    BOOL wasWritable;
}
- (int)hideFrap:(NSString *)path;
- (int)showFrap:(NSString *)path;

- (int)isWritable;
- (BOOL)makeSystemWritable;
- (void) makeSystemReadOnly;
@end
