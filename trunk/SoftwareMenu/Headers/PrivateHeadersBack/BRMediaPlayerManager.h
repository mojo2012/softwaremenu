/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRSingleton.h>

@class BRWindow, NSDictionary, NSMutableArray, NSTimer;

@interface BRMediaPlayerManager : BRSingleton
{
    NSMutableArray *_registrations;
    NSDictionary *_singletons;
    BRWindow *_shroudyMcShroud;
    BRWindow *_playerWindow;
    NSTimer *_popupDelay;
    NSTimer *_autoPresentTimer;
    NSTimer *_safetyTimer;
    SEL _postShroudRemovalSelector;
    double _autoPresentTimeout;
    int _playerWindowState;
    BOOL _playerWindowBeingRemoved;
    BOOL _playerWindowBeingAdded;
    BOOL _playerWindowRemovedWhileBeingAdded;
    BOOL _screensaverUp;
    float _savedVolume;
}

+ (id)singleton;
+ (void)setSingleton:(id)arg1;
- (id)init;
- (void)dealloc;
- (void)registerPlayerClass:(Class)arg1;
- (id)playerForMediaAsset:(id)arg1 error:(id *)arg2;
- (id)playerForMediaAssetAtIndex:(long)arg1 inTrackList:(id)arg2 error:(id *)arg3;
- (id)playerForMediaAssetAtIndex:(long)arg1 inCollection:(id)arg2 error:(id *)arg3;
- (void)presentPlayer:(id)arg1 options:(id)arg2;
- (void)presentMediaAsset:(id)arg1 options:(id)arg2;
- (void)presentMediaAssetAtIndex:(long)arg1 inTrackList:(id)arg2 options:(id)arg3;
- (void)presentMediaAssetAtIndex:(long)arg1 inCollection:(id)arg2 options:(id)arg3;
- (void)removePresentation;
- (void)endPresentation;
- (id)presentationWindow;
- (BOOL)presentationCanBeScreenSaver;
- (id)activePlayer;
- (id)activeAudioPlayer;
- (id)audioPlayer;
- (id)airtunesAudioPlayer;
- (void)stopMediaPlayersWithMediaFromProvider:(id)arg1;
- (id)audioVisualizer;
- (void)showVolumeControl;
- (void)setAutoPresentTimeout:(double)arg1;
- (double)autoPresentTimeout;

@end

