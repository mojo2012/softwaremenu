//
//  BackRowExtensions.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 4/24/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "BackRowExtensions.h"



@implementation BRTextMenuItemLayer (SMFExtensions)

-(void)setRightIcon:(BRImage *)image
{
    if (image = nil) {
        [self setRightIconInfo:nil];
    }
    else {
        [self setRightIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                image, @"BRMenuIconImageKey",nil]];
    }
    
    
}
-(void)setLeftIcon:(BRImage *)image
{
    if (image = nil) {
        NSLog(@"nil image");
        [self setLeftIconInfo:nil];
    }
    else {
        NSLog(@"non nil image");
        [self setLeftIconInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                               image, @"BRMenuIconImageKey",nil]];
    }
}
@end

@implementation NSFileManager (SMFExtensions)
+(NSArray *)directoryContentsAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] directoryContentsAtPath:path];
}
@end