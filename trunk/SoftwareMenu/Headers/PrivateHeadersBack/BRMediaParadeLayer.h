/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@interface BRMediaParadeLayer : BRControl
{
    struct CGSize _animationBounds;
    struct CGSize _maxImageBounds;
    BOOL _paused;
}

- (id)init;
- (void)setProvider:(id)arg1;
- (id)provider;
- (long)maxImages;
- (void)setImages:(id)arg1;
- (void)layoutSubcontrols;
- (void)setPaused:(BOOL)arg1;
- (BOOL)paused;

@end

