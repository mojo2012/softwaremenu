/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRAudioVisualizerControl.h>

@class BRMediaPlayer, BRMusicNowPlayingLayer, NSString, NSTimer;

@interface BRMusicNowPlayingControl : BRAudioVisualizerControl
{
    BRMusicNowPlayingLayer *_layer;
    BRMediaPlayer *_player;
    NSString *_lastAssetID;
    NSTimer *_flipTimer;
    NSTimer *_delayedContentUpdateTimer;
    NSTimer *_flipRearrangeTimer;
    NSTimer *_assetChangeAnimationUnblockTimer;
    double _flipDuration;
    double _flipInterval;
    double _assetChangeAnimationBlockTime;
    double _assetChangeAnimationDuration;
    double _newTrackKicksInTime;
    double _oldTrackFadeOutTime;
    double _postFlipAssetChangeAnimationBlockTime;
    int _transitionDirection;
    BOOL _assetChangeAnimationBlockFlag;
    BOOL _buffering;
}

- (id)init;
- (void)dealloc;
- (void)setPlayer:(id)arg1;
- (id)player;
- (BOOL)displayTrackPopup;
- (void)controlWasActivated;
- (void)controlWasDeactivated;
- (void)layoutSubcontrols;

@end
