/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <AppleTV/ATVRemoteControlMessageHandler.h>

@interface ATVRemoteControlMessageHandler (InternalMessageHandling)
- (BOOL)_processTouchEvent:(unsigned long)arg1 value:(unsigned long)arg2 eventDictionary:(id)arg3;
- (void)_refreshConnectionTimeoutTimer;
- (void)_connectionTimedOut:(id)arg1;
@end

