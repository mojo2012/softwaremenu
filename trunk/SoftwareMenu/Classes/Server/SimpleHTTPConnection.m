//
//  SimpleHTTPConnection.m
//  SimpleCocoaHTTPServer
//
//  Created by Jürgen Schweizer on 13.09.06.
//  Copyright 2006 Cultured Code.
//  License: Creative Commons Attribution 2.5 License
//           http://creativecommons.org/licenses/by/2.5/
//

#import "SimpleHTTPConnection.h"
#import "SimpleHTTPServer.h"
#import <netinet/in.h>      // for sockaddr_in
#import <arpa/inet.h>       // for inet_ntoa


@implementation SimpleHTTPConnection

- (id)initWithFileHandle:(NSFileHandle *)fh delegate:(id)dl
{
    if( self = [super init] ) {
        fileHandles = [fh retain];
        delegate = [dl retain];
        isMessageComplete = YES;
        message = NULL;

        // Get IP address of remote client
        CFSocketRef socket;
        socket = CFSocketCreateWithNative(kCFAllocatorDefault,
                                          [fileHandles fileDescriptor],
                                          kCFSocketNoCallBack, NULL, NULL);
        CFDataRef addrData = CFSocketCopyPeerAddress(socket);
        CFRelease(socket);
        if( addrData ) {
            struct sockaddr_in *sock = (struct sockaddr_in *)CFDataGetBytePtr(addrData);
            char *naddr = inet_ntoa(sock->sin_addr);
            [self setAddress:[NSString stringWithCString:naddr]];
            CFRelease(addrData);
        } else {
            [self setAddress:@"NULL"];
        }

        // Register for notification when data arrives
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(dataReceivedNotification:)
                   name:NSFileHandleReadCompletionNotification
                 object:fileHandles];
        [fileHandles readInBackgroundAndNotify];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if( message ) CFRelease(message);
    [delegate release];
    [fileHandles release];
    [super dealloc];
}

- (NSFileHandle *)fileHandle { return fileHandles; }

- (void)setAddress:(NSString *)value
{
    [address release];
    address = [value copy];
}
- (NSString *)address { return address; }


- (void)dataReceivedNotification:(NSNotification *)notification
{
    NSLog(@"Recieved data: %@",notification);
    NSData *data = [[notification userInfo] objectForKey:NSFileHandleNotificationDataItem];
    
    if ( [data length] == 0 ) {
        // NSFileHandle's way of telling us that the client closed the connection
        [delegate closeConnection:(SimpleCocoaConnection *) self];
    } else {
        [fileHandles readInBackgroundAndNotify];
        
        if( isMessageComplete ) {
            message = CFHTTPMessageCreateEmpty(kCFAllocatorDefault, TRUE);
        }
        Boolean success = CFHTTPMessageAppendBytes(message,
                                                   [data bytes],
                                                   [data length]);
        if( success ) {
            if( CFHTTPMessageIsHeaderComplete(message) ) {
                isMessageComplete = YES;
                CFURLRef url = CFHTTPMessageCopyRequestURL(message);
                [delegate newRequestWithURL:(NSURL *)url connection:self];
                CFRelease(url);
                CFRelease(message);
                message = NULL;
            } else {
                isMessageComplete = NO;
            }
        } else {
            NSLog(@"Incomming message not a HTTP header, ignored.");
            [delegate closeConnection:(SimpleCocoaConnection *) self];
        }
    }
}

@end
