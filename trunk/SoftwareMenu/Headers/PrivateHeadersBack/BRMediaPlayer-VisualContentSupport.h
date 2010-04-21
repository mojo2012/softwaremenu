/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRMediaPlayer.h>

@interface BRMediaPlayer (VisualContentSupport)
- (BOOL)playingVisualContent;
- (id)visuals;
- (void)setClosedCaptionHandler:(id)arg1;
- (id)closedCaptionHandler;
- (id)blurredVideoFrame;
- (id)currentVideoFrame;
- (double)keyframeTimeNearTime:(double)arg1 searchForwards:(BOOL)arg2;
- (void)setSubtitleHandler:(id)arg1;
- (id)subtitleHandler;
- (id)localizedSubtitleLanguageSetting;
- (id)localizedListOfSubtitleOptions;
- (void)setSubtitleOptionWithLocalizedSetting:(id)arg1;
- (id)localizedAudioLanguageSetting;
- (id)localizedListOfAudioOptions;
- (void)setAudioOptionWithLocalizedSetting:(id)arg1;
@end

