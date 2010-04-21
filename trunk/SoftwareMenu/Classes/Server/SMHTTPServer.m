//
//  SMHTTPServer.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/10/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMHTTPServer.h"
#import <stdio.h>
#import <string.h>
#import <sys/socket.h>
#include <arpa/inet.h>

@implementation SMHTTPServer
static SMHTTPServer *singleton = nil;

+ (SMHTTPServer*)singleton
{
    if (singleton == nil) {
        singleton = [[super allocWithZone:NULL] init];

    }
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self singleton] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}
-(id)init
{
    self=[super init];
    _server=[[SimpleHTTPServer alloc] initWithTCPPort:50000
                                             delegate:self];
    NSLog(@"Server: %@",_server);
    //NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://localhost:50000/hello"]];
    //NSLog(@"data: %@",data);
    return self;
}
- (int)retainCount
{
    return 15000;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}
-(void)stopProcessing
{
    NSLog(@"Stop proc");
}
-(void)processURL:(NSString *)url connection:(SimpleHTTPConnection *)con
{
    NSAutoreleasePool *pool =[[NSAutoreleasePool alloc]init];
    NSLog(@"Process %@",url);
    NSString *path=[NSHomeDirectory() stringByAppendingPathComponent:@"1288403.jpg"];
    NSData *data=[NSData dataWithContentsOfFile:path];
    [_server replyWithData:(NSData *)data MIMEType:@"Image/jpeg"];
    [pool drain];
}
@end
