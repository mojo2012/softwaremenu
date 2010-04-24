//
//  SMDOSingleton.m
//  SoftwareMenu
//
//  Created by Thomas Cool on 4/11/10.
//  Copyright 2010 Thomas Cool. All rights reserved.
//

#import "SMDOSingleton.h"
#import "SMDOServer.h"
@interface NSHost (Private)
+(void)_fixNSHostLeak;
@end
@interface NSSocketPort (Private)
+(void)_fixNSSocketPortLeak;
@end
@implementation SMDOSingleton
static SMDOSingleton *singleton = nil;

+ (SMDOSingleton*)singleton
{
    if (singleton == nil) {
        singleton = [[super allocWithZone:NULL] init];
        NSLog(@"Creating new singleton object");
    }
    return singleton;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self singleton] retain];
}
-(id)init
{
    self=[super init];
    NSLog(@"do singleton init");
    NSSocketPort *receivePort;
    receivePort = [[NSSocketPort alloc] initWithTCPPort:50001];
    if ([NSHost respondsToSelector:@selector(_fixNSHostLeak)]) {
        [NSHost _fixNSHostLeak];
    }
    if ([NSSocketPort respondsToSelector:
         @selector(_fixNSSocketPortLeak)]) {
        [NSSocketPort _fixNSSocketPortLeak];
    }
    _doServer=[[SMDOServer alloc] init];
    
    _connection = [NSConnection connectionWithReceivePort:receivePort 
                                                sendPort:nil];
    [_connection retain];
    // The port is retained by the connection
    //[receivePort release];
    
    // When clients use this connection, they will 
    // talk to the ChatterServer
    [_connection setRootObject:_doServer];
    [_connection setDelegate:self];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(connectionDidDie:) 
                                                 name:NSConnectionDidDieNotification 
                                               object:nil];
    return self;
    
}
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
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
- (BOOL)connection:(NSConnection *)ancestor 
shouldMakeNewConnection:(NSConnection *)conn
{
    NSLog(@"creating new connection: %d total connections", 
          [[NSConnection allConnections] count]);
    return YES;
}

- (void)connectionDidDie:(NSNotification *)note
{
    if ([_connection isValid]) {
        NSLog(@"2 is Valid");
    }
    NSConnection *connection = [note object];
    NSLog(@"connection did die: %@", connection);
}
@end
