//
//  BackRowExtensions.h
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 4/24/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface BRTextMenuItemLayer (SMFExtensions)
-(void)setRightIcon:(BRImage *)image;
-(void)setLeftIcon:(BRImage *)image;
@end

@interface NSFileManager (SMFExtensions)
+(NSArray *)directoryContentsAtPath:(NSString *)path;
@end