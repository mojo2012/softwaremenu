/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class BRProviderGroup;

@interface BRGridControl : BRControl
{
    BRProviderGroup *_group;
    BRControl *_requester;
    struct _NSRange _range;
    float _lastGapHeight;
    double _heightToRange;
    double _controlHeight;
    float _allColumnWidths;
    long _columnCount;
    float _horizontalGap;
    float _verticalGap;
    float _leftMargin;
    float _rightMargin;
    float _bottomMargin;
    float _bottomMarginFactor;
    float _topMargin;
    float _topMarginFactor;
    BOOL _wrapsNavigation;
    BOOL _explicitlyAcceptsFocus;
}

- (id)init;
- (void)dealloc;
- (void)setProvider:(id)arg1;
- (void)setProviders:(id)arg1;
- (id)providers;
- (long)dataCount;
- (long)rowCount;
- (void)setAllColumnWidths:(float)arg1;
- (void)setColumnCount:(long)arg1;
- (long)columnCount;
- (void)setHorizontalGap:(float)arg1;
- (float)horizontalGap;
- (void)setVerticalGap:(float)arg1;
- (float)verticalGap;
- (void)setVerticalMargins:(float)arg1;
- (void)setLeftMargin:(float)arg1;
- (float)leftMargin;
- (void)setRightMargin:(float)arg1;
- (float)rightMargin;
- (void)setProviderRequester:(id)arg1;
- (id)providerRequester;
- (id)visibleControlsWithRange:(struct _NSRange *)arg1;
- (id)visibleControlAtIndex:(long)arg1;
- (float)heightToMaximum:(float)arg1;
- (float)positionOfColumn:(long)arg1;
- (float)heightOfControlAtIndex:(long)arg1;
- (BOOL)brEventAction:(id)arg1;
- (id)focusedControlForEvent:(id)arg1 focusPoint:(struct CGPoint *)arg2;
- (void)setWrapsNavigation:(BOOL)arg1;
- (BOOL)wrapsNavigation;
- (void)setBottomMargin:(float)arg1;
- (void)setTopMargin:(float)arg1;
- (void)visibleScrollRectChanged;
- (void)layoutSubcontrols;
- (struct CGSize)preferredFrameSize;
- (id)initialFocus;

@end
