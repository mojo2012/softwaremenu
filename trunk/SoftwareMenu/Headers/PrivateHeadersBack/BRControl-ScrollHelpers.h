/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@interface BRControl (ScrollHelpers)
- (void)scrollPoint:(struct CGPoint)arg1;
- (void)scrollRectToVisible:(struct CGRect)arg1;
- (void)visibleScrollRectChanged;
- (struct CGRect)visibleScrollRect;
- (id)parentScrollControl;
- (void)scrollingCompleted;
- (void)scrollingInitiated;
@end

