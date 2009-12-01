//
//  Extensions.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/7/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSFileManager (SoftwareMenuExtensions)
- (BOOL)constructPath:(NSString *)proposedPath;
@end

@interface NSString (SoftwareMenuExtensions)
- (NSString *)stringByReplacingAllOccurancesOfString:(NSString *)search withString:(NSString *)replacement;
@end
@interface NSMutableString (SoftwareMenuExtensions)
- (void)replaceAllOccurancesOfString:(NSString *)search withString:(NSString *)replacement;
@end