/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "BRControl.h"

@class BRImageControl, BRTextControl;

@interface ATVBSRLayer : BRControl
{
    BRImageControl *_appleLogo;
    BRTextControl *_currentResolutionLabel;
    BRTextControl *_countDownToNextResolutionLabel;
    BRTextControl *_canYouSeeTheAppleLogoLabel;
}

- (id)init;
- (void)dealloc;
- (void)layoutSubcontrols;
- (void)setCurrentResolutionString:(id)arg1;
- (void)setSecondsLeftBeforeNextDisplayModeChangeString:(id)arg1;

@end
