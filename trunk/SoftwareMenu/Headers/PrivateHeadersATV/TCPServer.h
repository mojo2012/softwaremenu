/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

@class NSNetService, NSString;

@interface TCPServer : NSObject
{
    id delegate;
    NSString *domain;
    NSString *name;
    NSString *type;
    unsigned short port;
    struct __CFSocket *ipv4socket;
    struct __CFSocket *ipv6socket;
    NSNetService *netService;
    BOOL publishConnection;
    struct __CFRunLoop *_runLoop;
    struct __CFRunLoopSource *_source4;
    struct __CFRunLoopSource *_source6;
}

- (id)init;
- (void)dealloc;
- (id)delegate;
- (void)setDelegate:(id)arg1;
- (id)domain;
- (void)setDomain:(id)arg1;
- (id)name;
- (void)setName:(id)arg1;
- (id)type;
- (void)setType:(id)arg1;
- (unsigned short)port;
- (void)setPort:(unsigned short)arg1;
- (void)publishConnection:(BOOL)arg1;
- (void)handleNewConnectionFromAddress:(id)arg1 inputStream:(id)arg2 outputStream:(id)arg3;
- (BOOL)start:(id *)arg1;
- (BOOL)stop;

@end

