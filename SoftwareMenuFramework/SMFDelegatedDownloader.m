//
//  SMFDelegatedDownloader.m
//  SoftwareMenuFramework
//
//  Created by Thomas Cool on 4/28/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMFDelegatedDownloader.h"

@interface SMFDelegatedDownloader (Private)
-(void)downloadDidComplete:(NSArray *)paths object:(id)cont;
@end

@implementation SMFDelegatedDownloader
-(id)delegate
{
    return _delegate;
}
-(void)setDelegate:(id)delegate
{
    if ([delegate respondsToSelector:@selector(downloadDidComplete:object:)]) {
        if (_delegate!=nil) {
            [_delegate release];
            _delegate=nil;
        }
        _delegate=[delegate retain];
    }
}
-(void)process
{
    [_progressBar removeFromParent];
    if (_delegate) {
        [_delegate downloadDidComplete:[self paths] object:self];
    }
}
-(void)dealloc
{
    if ([_delegate retainCount]>0) {
        [_delegate release];
        _delegate=nil;
    }
    [super dealloc];
}
@end
@implementation SMFDelegatedDownloader (Private)
-(void)downloadDidComplete:(NSArray *)paths object:(id)cont
{
    
}
@end