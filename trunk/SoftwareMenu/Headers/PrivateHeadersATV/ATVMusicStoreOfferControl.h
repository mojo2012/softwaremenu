/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "BRControl.h"

@class ATVMusicStoreOffer, BRImageControl, BRTextControl;

@interface ATVMusicStoreOfferControl : BRControl
{
    ATVMusicStoreOffer *_storeOffer;
    BRTextControl *_widescreenTextControl;
    BRImageControl *_hdImageControl;
    BRImageControl *_ddImageControl;
    BRImageControl *_ccImageControl;
    BRImageControl *_digitalExtrasControl;
}

- (void)dealloc;
- (void)setWidescreen:(BOOL)arg1 andHD:(BOOL)arg2;
- (void)setDolbyDigital:(BOOL)arg1;
- (void)setClosedCaption:(BOOL)arg1;
- (void)setHasDigitalExtras:(BOOL)arg1;
- (void)layoutSubcontrols;

@end

