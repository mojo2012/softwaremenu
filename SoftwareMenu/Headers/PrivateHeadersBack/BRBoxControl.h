/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class BRTextControl;

@interface BRBoxControl : BRControl
{
    BRTextControl *_label;
    BRControl *_content;
    float _margin;
    float _labelVerticalOffset;
}

- (void)dealloc;
- (struct CGSize)preferredFrameSize;
- (id)label;
- (void)setLabel:(id)arg1;
- (void)setLabelMargin:(float)arg1;
- (float)labelMargin;
- (id)content;
- (void)setLabelVerticalOffset:(float)arg1;
- (float)labelVerticalOffset;
- (void)setContent:(id)arg1;
- (void)layoutSubcontrols;

@end
