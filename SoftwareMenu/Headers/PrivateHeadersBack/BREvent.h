/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

@class NSDictionary;

@interface BREvent : NSObject
{
    int _action;
    int _value;
    BOOL _retrigger;
    double _timeStamp;
    unsigned int _originator;
    NSDictionary *_eventDictionary;
    BOOL _allowRetrigger;
}

+ (id)eventWithAction:(int)arg1 value:(int)arg2;
+ (id)eventWithAction:(int)arg1 value:(int)arg2 atTime:(double)arg3;
+ (id)eventWithAction:(int)arg1 value:(int)arg2 atTime:(double)arg3 originator:(unsigned int)arg4;
+ (id)eventWithAction:(int)arg1 value:(int)arg2 atTime:(double)arg3 originator:(unsigned int)arg4 eventDictionary:(id)arg5 allowRetrigger:(BOOL)arg6;
+ (id)eventWithEvent:(id)arg1 originator:(unsigned int)arg2 eventDictionary:(id)arg3 allowRetrigger:(BOOL)arg4;
+ (id)eventWithEvent:(id)arg1 originator:(unsigned int)arg2;
+ (double)nowTimeStamp;
- (id)initWithAction:(int)arg1 value:(int)arg2;
- (id)initWithAction:(int)arg1 value:(int)arg2 atTime:(double)arg3;
- (id)initWithAction:(int)arg1 value:(int)arg2 atTime:(double)arg3 originator:(unsigned int)arg4;
- (id)initWithAction:(int)arg1 value:(int)arg2 atTime:(double)arg3 originator:(unsigned int)arg4 eventDictionary:(id)arg5 allowRetrigger:(BOOL)arg6;
- (void)dealloc;
- (id)description;
- (BOOL)isEqual:(id)arg1;
- (int)remoteAction;
- (int)value;
- (BOOL)retriggerEvent;
- (void)makeRetriggerEvent;
- (double)timeStamp;
- (unsigned int)originator;
- (id)eventDictionary;
- (BOOL)allowRetrigger;

@end
