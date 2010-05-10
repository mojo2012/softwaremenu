//
//  Extensions.h
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/7/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSFileManager (SMFExtensions)
- (BOOL)constructPath:(NSString *)proposedPath;
+(NSArray *)directoryContentsAtPath:(NSString *)path;
@end

@interface NSString (SMFExtensions)
- (NSString *)stringByReplacingAllOccurancesOfString:(NSString *)search withString:(NSString *)replacement;
@end
@interface NSMutableString (SMFExtensions)
- (void)replaceAllOccurancesOfString:(NSString *)search withString:(NSString *)replacement;
@end