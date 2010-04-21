/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRVideoLoadMonitor.h>

@class NSTimer;

@interface BRVideoRingBufferLoadMonitor : BRVideoLoadMonitor
{
    float _lastBufferingProgress;
    NSTimer *_bufferedRangePoller;
    struct BRTimeRange _bufferedRange;
    BOOL _playable;
}

- (id)initWithMovie:(struct MovieType **)arg1;
- (void)stopMonitoring;
- (BOOL)moviePlayable;
- (float)bufferingProgress;
- (struct BRTimeRange)bufferedRange;
- (double)maxMovieTime;
- (void)playheadMoved;

@end

