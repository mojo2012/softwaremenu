//
//  loadUpdates.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 11/7/09.
//  Copyright 2009 Thomas Cool. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "loadUpdatesDownloadClass.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];	
	NSRunLoop *rl = [NSRunLoop currentRunLoop];
    [rl configureAsServer];
    loadUpdatesDownloadClass *uc = [[loadUpdatesDownloadClass alloc] init];
    int j = [uc downloadUpdates];
    if (j!=0)
        return j;
    j = [uc checkForUpdates];
    NSLog(@"sending notification");
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName:kSMDownloaderDone 
                                                                   object:@"aha"
                                                                 userInfo:[NSDictionary dictionaryWithObject:@"hello" forKey:@"hello"] 
                                                       deliverImmediately:YES];
    [pool release];
    return j;   
}
