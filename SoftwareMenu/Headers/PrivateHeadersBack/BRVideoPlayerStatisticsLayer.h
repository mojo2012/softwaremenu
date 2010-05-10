/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class BRTextControl, NSDictionary, NSString;

@interface BRVideoPlayerStatisticsLayer : BRControl
{
    struct BRVideoPlaybackStats _stats;
    NSString *_location;
    BRTextControl *_locationField;
    BRTextControl *_movieDimensionsField;
    BRTextControl *_droppedFrameCountField;
    BRTextControl *_hardwareCodecInUseField;
    BRTextControl *_postProcessingField;
    NSDictionary *_singleLineAttributes;
    NSDictionary *_multiLineAttributes;
}

- (id)init;
- (void)dealloc;
- (void)setFrame:(struct CGRect)arg1;
- (void)setLocation:(id)arg1;
- (void)setStats:(struct BRVideoPlaybackStats)arg1;
- (struct CGSize)minimumSize;

@end
