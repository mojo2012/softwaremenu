/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@interface BRDropShadowControl : BRControl
{
    BRControl *_content;
    int _shadowStyle;
    float _sizeFactor;
}

- (id)init;
- (void)dealloc;
- (void)setShadowStyle:(int)arg1;
- (int)shadowStyle;
- (void)setShadowSizeFactor:(float)arg1;
- (float)shadowSizeFactor;
- (void)setContent:(id)arg1;
- (id)content;
- (void)layoutSubcontrols;

@end

