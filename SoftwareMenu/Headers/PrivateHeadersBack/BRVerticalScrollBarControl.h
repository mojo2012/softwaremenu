/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class BRImageControl;

@interface BRVerticalScrollBarControl : BRControl
{
    BRImageControl *_image;
    float _position;
}

- (id)init;
- (void)dealloc;
- (void)setScrollPosition:(float)arg1;
- (void)setImage:(id)arg1;
- (id)image;
- (void)layoutSubcontrols;

@end

