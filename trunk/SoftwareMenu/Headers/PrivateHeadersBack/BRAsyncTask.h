/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

@class BRAsyncTaskContext, NSString, NSThread;

@interface BRAsyncTask : NSObject
{
    NSThread *_callingThread;
    id _target;
    SEL _selector;
    id _object;
    id _result;
    BRAsyncTaskContext *_context;
    int _state;
    NSString *_identifier;
}

+ (void)initialize;
+ (id)voidReturnValue;
+ (id)taskWithSelector:(SEL)arg1 onTarget:(id)arg2 withObject:(id)arg3;
+ (id)taskWithSelector:(SEL)arg1 onTarget:(id)arg2 withObject:(id)arg3 withContext:(id)arg4;
- (void)dealloc;
- (id)description;
- (void)run;
- (void)cancel;
- (int)state;
- (SEL)selector;
- (id)target;
- (id)object;
- (id)context;
- (void)setIdentifier:(id)arg1;
- (id)identifier;

@end
