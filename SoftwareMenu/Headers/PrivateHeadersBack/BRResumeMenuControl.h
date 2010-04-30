/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class BRImageControl, BRListControl, BRResumeMenuControlLayoutManager;

@interface BRResumeMenuControl : BRControl
{
    BRListControl *_resumeMenu;
    BRImageControl *_blurControl;
    BRResumeMenuControlLayoutManager *_layoutManager;
    float _blurOversizeFactor;
}

- (id)init;
- (void)dealloc;
- (void)layoutSubcontrols;
- (BOOL)brEventAction:(id)arg1;
- (id)list;
- (void)setBlurredImage:(id)arg1;
- (void)setBlurOversizeFactor:(float)arg1;
- (id)preferredActionForKey:(id)arg1;

@end
