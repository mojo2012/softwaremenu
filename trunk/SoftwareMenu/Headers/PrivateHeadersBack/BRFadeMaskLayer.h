/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@interface BRFadeMaskLayer : BRControl
{
    float _topFadeHeight;
    float _bottomFadeHeight;
    float _leftFadeWidth;
    float _rightFadeWidth;
    struct CGFunction *_shadingFunction;
}

- (id)init;
- (void)dealloc;
- (void)setTopFadeHeight:(float)arg1;
- (float)topFadeHeight;
- (void)setBottomFadeHeight:(float)arg1;
- (float)bottomFadeHeight;
- (void)setLeftFadeWidth:(float)arg1;
- (float)leftFadeWidth;
- (void)setRightFadeWidth:(float)arg1;
- (float)rightFadeWidth;
- (void)drawInContext:(struct CGContext *)arg1;
- (void)setEnableMaskAnimation:(BOOL)arg1;

@end

