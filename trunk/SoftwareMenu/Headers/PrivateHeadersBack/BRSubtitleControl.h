/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

#import "BRSubtitleHandler-Protocol.h"

@class NSAttributedString, NSDictionary;

@interface BRSubtitleControl : BRControl <BRSubtitleHandler>
{
    struct CGColor *_fillColor;
    float _radius;
    float _backgroundPadding;
    NSAttributedString *_subtitleString;
    NSDictionary *_defaultSubtitleAttributes;
    float _scalingFactor;
    NSDictionary *_subtitleBox;
}

- (id)init;
- (void)dealloc;
- (void)drawInContext:(struct CGContext *)arg1;
- (void)displaySubtitle:(id)arg1;
- (void)eraseSubtitle;
- (void)setScalingFactor:(float)arg1;

@end

