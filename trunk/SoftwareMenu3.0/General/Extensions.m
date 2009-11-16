//
//  Extensions.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/7/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//

#import "Extensions.h"


@implementation NSFileManager (SoftwareMenuExtensions)
- (BOOL)constructPath:(NSString *)proposedPath
{
    BOOL isDir ;
    if(!([self fileExistsAtPath:proposedPath isDirectory:&isDir]&& isDir))
        if(![self createDirectoryAtPath:proposedPath attributes:nil])
            if([self constructPath:[proposedPath stringByDeletingLastPathComponent]])
                return [self createDirectoryAtPath:proposedPath attributes:nil];
            else
                return NO;
    return YES;     
}
@end
