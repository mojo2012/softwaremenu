/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@interface BRControl (BRControlRendering)
- (void)setNeedsDisplay;
- (void)setNeedsDisplayInRect:(struct CGRect)arg1;
- (void)drawInContext:(struct CGContext *)arg1;
- (void)setMasksToBounds:(BOOL)arg1;
- (BOOL)masksToBounds;
- (void)setBackgroundColor:(struct CGColor *)arg1;
- (struct CGColor *)backgroundColor;
- (void)setOpacity:(float)arg1;
- (float)opacity;
- (void)setHidden:(BOOL)arg1;
- (BOOL)isHidden;
- (void)setContentMode:(int)arg1;
- (int)contentMode;
@end
