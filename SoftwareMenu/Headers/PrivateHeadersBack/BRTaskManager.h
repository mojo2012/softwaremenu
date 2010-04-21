/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRSingleton.h>

@class NSConditionLock, NSMutableArray;

@interface BRTaskManager : BRSingleton
{
    NSMutableArray *_taskQueue;
    NSConditionLock *_queueLock;
    int _numberOfTaskThreadsRunning;
    int _numberOfFinishingThreads;
}

+ (id)singleton;
+ (void)setSingleton:(id)arg1;
- (id)init;
- (void)dealloc;
- (void)scheduleTask:(id)arg1;
- (void)cancelTask:(id)arg1;

@end

