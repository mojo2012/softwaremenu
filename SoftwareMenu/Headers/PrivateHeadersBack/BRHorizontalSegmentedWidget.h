/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class BRImage, BRImageControl, NSMutableArray;

@interface BRHorizontalSegmentedWidget : BRControl
{
    BRImage *_leftImage;
    BRImage *_centerImage;
    BRImage *_rightImage;
    BRImageControl *_leftEndLayer;
    NSMutableArray *_centerLayers;
    BRImageControl *_rightEndLayer;
    float _animationDuration;
    BOOL _animationEnabled;
    int _numSegments;
}

- (id)init;
- (void)dealloc;
- (void)setLeftFile:(id)arg1 centerFile:(id)arg2 rightFile:(id)arg3;
- (void)setLeftImage:(id)arg1 centerImage:(id)arg2 rightImage:(id)arg3;
- (void)setNumSegments:(int)arg1;
- (void)setAnimationDuration:(float)arg1;
- (float)animationDuration;
- (void)setSublayerAnimationEnabled:(BOOL)arg1;
- (BOOL)sublayerAnimationEnabled;

@end
