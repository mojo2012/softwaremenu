/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRMediaPlayerController.h>

@interface BRMediaPlayerController (ControlManagement)
- (void)_clearClosedCaptionText;
- (void)_clearSubtitleText;
- (void)_updatePlaybackControls;
- (void)_updateExplantoryText;
- (id)_closedCaptionControlForType:(id)arg1;
- (id)_subtitleControlForType:(id)arg1;
- (id)_transportControlForType:(id)arg1;
- (void)_handleShowChapterMarkers;
- (void)_handleHideChapterMarkers;
- (id)_descriptionOverlayForType:(id)arg1;
- (id)_audioVisualizer;
- (BOOL)_enterAudioSubtitleChapterPicker;
- (BOOL)_cycleInfoDisplay:(id)arg1;
@end

