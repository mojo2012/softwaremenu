/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class BRImage, BRImageControl;

@interface BRScrollBarControl : BRControl
{
    BRControl *_layer;
    BRImageControl *_upArrow;
    BRImageControl *_downArrow;
    BRImage *_fullUpArrow;
    BRImage *_emptyUpArrow;
    BRImage *_fullDownArrow;
    BRImage *_emptyDownArrow;
}

- (id)init;
- (void)dealloc;
- (void)setUpArrowEnabled:(BOOL)arg1;
- (void)setDownArrowEnabled:(BOOL)arg1;
- (void)layoutSubcontrols;

@end
