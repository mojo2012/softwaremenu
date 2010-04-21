//
//  helper.m
//  overflow
//
//  Created by Thomas Cool on 2/4/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "helperClass.h"


int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];	
	NSRunLoop *rl = [NSRunLoop currentRunLoop];
	
	[rl configureAsServer];
	if (argc < 3){
		printf("Segmentation Fault");
		printf("\n");
        exit(2);
    }
        //NSString *path = [NSString stringWithUTF8String:argv[0]];
		NSString *option = [NSString stringWithUTF8String:argv[1]]; //argument 1
		NSString *value = [NSString stringWithUTF8String:argv[2]]; //argument 2
    int rvalue;
    BOOL isRW=YES;
    helperClass *ohc = [[ helperClass alloc] init]; 
    if([ohc isWritable])
    {
        isRW=NO;
        [ohc makeSystemWritable];
    }
    if ([option isEqualToString:@"--extract"]) {
        rvalue=[ohc hideFrap:value];
    }
    else if ([option isEqualToString:@"--show"])
    {
        rvalue=[ohc showFrap:value];
    }
    else if ([option isEqualToString:@"--restartFinder"])
    {
        rvalue=[ohc restartFinder];
    }
    if (!isRW) {
        [ohc makeSystemReadOnly];
    }	
    [ohc release];
    [pool release];
    exit(rvalue);
}

