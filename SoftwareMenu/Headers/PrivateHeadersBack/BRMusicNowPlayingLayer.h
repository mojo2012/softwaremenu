/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class NSMutableDictionary, NSTimer;

@interface BRMusicNowPlayingLayer : BRControl
{
    NSMutableDictionary *_currentTrackInfo;
    NSTimer *_flipRearrangeTimer;
    int _scheduledAnimationCount;
    float _coverArtRotation;
    float _coverArtSizeX;
    float _coverArtSizeY;
    float _stateIconWidth;
    float _textWidth;
    BOOL _shuffleState;
    BOOL _repeatState;
    BOOL _geniusState;
    BOOL _isRadio;
    struct CGPoint _randomOffset;
    struct CGPoint _coverArtPosition;
    struct CGPoint _trackNameTextPosition;
    struct CGPoint _artistNameTextPosition;
    struct CGPoint _albumNameTextPosition;
    struct CGPoint _trackXofXTextPosition;
    struct CGPoint _transportPosition;
    struct CGPoint _stateIconsLowerRightCornerPosition;
    float _coverArtReflectionAmount;
    struct CGSize _transportSize;
    BOOL _flip;
}

- (id)init;
- (void)dealloc;
- (void)layoutSubcontrols;
- (void)setCurrentTrackInfo:(id)arg1 WithTransition:(BOOL)arg2 TransitionDirection:(int)arg3 TransitionDuration:(float)arg4 NewTrackKicksInTime:(double)arg5 OldTrackFadeOutTime:(double)arg6 isRadio:(BOOL)arg7;
- (id)currentTrackInfo;
- (void)setElapsedTime:(double)arg1;
- (void)setElapsedTime:(double)arg1 andDuration:(double)arg2;
- (int)frontLayerSide;
- (void)setShuffleState:(BOOL)arg1;
- (void)setRepeatMode:(int)arg1;
- (void)setGeniusState:(BOOL)arg1;
- (void)setPlayerState:(int)arg1;
- (void)controlWasDeactivated;
- (void)controlWasActivated;
- (void)performFlipAnimation:(float)arg1;
- (void)animationDidStop:(id)arg1 finished:(BOOL)arg2;
- (void)removeAllPendingActions;
- (void)updateCoverArt:(id)arg1;

@end
