//
//  NSMutableArray-SMFExtensions.h
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 5/8/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSArray (SMFExtensions)
/*
 *  Returns an autoreleased array with shuffled contents
 */
- (NSArray *) shuffled;
@end
