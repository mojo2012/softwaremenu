/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@interface BRWebOverlayControl : BRControl
{
    BOOL _currentlyShowing;
}

- (id)init;
- (struct CGSize)preferredFrameSize;
- (BOOL)brEventAction:(id)arg1;
- (void)showControl;
- (void)hideControl;
- (void)toggleShownHidden;
- (BOOL)isShowing;

@end

