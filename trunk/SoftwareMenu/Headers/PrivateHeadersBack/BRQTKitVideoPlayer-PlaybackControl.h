/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRQTKitVideoPlayer.h>

@interface BRQTKitVideoPlayer (PlaybackControl)
- (BOOL)_handleStopActionWithError:(id *)arg1;
- (BOOL)_handlePauseActionWithError:(id *)arg1;
- (BOOL)_handlePlayActionWithError:(id *)arg1;
- (BOOL)_handleRateChangeState:(int)arg1 error:(id *)arg2;
- (int)_loadResumeStateForState:(int)arg1;
- (BOOL)_emergeFromLoadingState:(id *)arg1;
- (BOOL)_instantiateVideoWithError:(id *)arg1;
- (BOOL)_setNewState:(int)arg1 error:(id *)arg2;
- (void)_disposeVideo;
@end

