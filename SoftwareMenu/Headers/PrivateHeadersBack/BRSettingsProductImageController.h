/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRMenuController.h>

@class BRImageControl, BRProgressBarWidget, BRReflectionControl, BRTextControl;

@interface BRSettingsProductImageController : BRMenuController
{
    BRImageControl *_productImage;
    BRImageControl *_overlayControl;
    BRReflectionControl *_overlayReflectionControl;
    BRTextControl *_instructionsLabel;
    BRTextControl *_progressLabel;
    BRProgressBarWidget *_progressBar;
    struct CGPoint _overlayOffset;
    struct CGSize _overlayScale;
}

- (id)init;
- (void)dealloc;
- (void)layoutSubcontrols;
- (void)setProductImageToDefault;
- (void)setProductImage:(id)arg1;
- (id)productImage;
- (void)setOverlayImage:(id)arg1 withOffset:(struct CGPoint)arg2 scale:(struct CGSize)arg3;
- (void)setOverlayReflectionAmount:(float)arg1;
- (void)setInstructionText:(id)arg1 withAttributes:(id)arg2;
- (BOOL)isProgressHidden;
- (void)setProgressHidden:(BOOL)arg1;
- (void)setProgressLabel:(id)arg1 withAttributes:(id)arg2;
- (void)setProgressPercentage:(float)arg1;
- (id)progress;
- (id)progressLabel;

@end
