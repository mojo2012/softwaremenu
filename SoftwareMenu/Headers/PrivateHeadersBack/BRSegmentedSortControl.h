/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class BRImageControl, NSArray, NSMutableArray, NSMutableDictionary;

@interface BRSegmentedSortControl : BRControl
{
    BRImageControl *_leftEndCapLayer;
    NSMutableArray *_dividerLayers;
    NSMutableArray *_contentLayers;
    NSMutableArray *_textLayers;
    BRImageControl *_rightEndCapLayer;
    NSArray *_segmentNames;
    NSMutableDictionary *_images;
    int _selectedSegment;
    float _widthRatio;
}

- (id)initWithSegmentNames:(id)arg1 selectedSegment:(int)arg2;
- (id)initWithSegmentNames:(id)arg1 selectedSegment:(int)arg2 widthRatio:(float)arg3;
- (void)dealloc;
- (int)segmentCount;
- (void)setSelectedSegment:(int)arg1;
- (int)selectedSegment;
- (float)visualHorizontalCenter;
- (BOOL)brEventAction:(id)arg1;
- (void)layoutSubcontrols;

@end

