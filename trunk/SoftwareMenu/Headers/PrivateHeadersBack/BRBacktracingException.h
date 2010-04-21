/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSException.h"

@interface BRBacktracingException : NSException
{
}

+ (void)install;
+ (void)setSignificantRaiseHandler:(void *)arg1;
+ (id)backtraceSkippingFrames:(int)arg1;
+ (void)logBacktraceSkippingFrames:(int)arg1 withMessage:(id)arg2;
+ (id)backtrace;
+ (void)logBacktraceWithMessage:(id)arg1;
- (id)initWithName:(id)arg1 reason:(id)arg2 userInfo:(id)arg3;
- (id)backtrace;
- (void)raise;
- (void)raiseWithoutReporting;

@end

