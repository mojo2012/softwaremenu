/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class BRImage, BRImageControl, BRTextControl, NSDictionary;

@interface BRPhotoBrowserBannerButton : BRControl
{
    float _minimumWidth;
    BRControl *_focusControl;
    BRImageControl *_imageControl;
    BRImage *_focusedImage;
    BRImage *_unFocusedImage;
    BRTextControl *_textControl;
    NSDictionary *_textAttributes;
}

+ (id)button;
+ (id)slideshowButton;
+ (id)saveSearchButton;
+ (id)removeSavedSearchButton;
- (id)init;
- (void)dealloc;
- (void)controlWasFocused;
- (void)controlWasUnfocused;
- (void)setText:(id)arg1;
- (id)text;
- (void)setFocusedImage:(id)arg1;
- (id)focusedImage;
- (void)setUnFocusedImage:(id)arg1;
- (id)unFocusedImage;
- (struct CGSize)preferredFrameSize;
- (void)layoutSubcontrols;

@end
