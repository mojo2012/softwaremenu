/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

@class BRListControl;

@interface ListAnimationDelegate : NSObject
{
    BRListControl *_list;
    long _animationBalance;
}

- (id)initWithList:(id)arg1;
- (void)clearScroll;
- (void)incrementBalance;
- (void)decrementBalance;
- (BOOL)scrolling;
- (void)animationDidStart:(id)arg1;
- (void)animationDidStop:(id)arg1 finished:(BOOL)arg2;

@end

