/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRListControl.h>

@interface BRListControl (ScrollControl)
- (BOOL)_scrollUp:(id)arg1;
- (BOOL)_scrollDown:(id)arg1;
- (void)_ensureSelectionFocusable;
- (long)_backwardIndexForRowCount:(long)arg1 hitBoundary:(char *)arg2;
- (long)_forwardIndexForRowCount:(long)arg1 hitBoundary:(char *)arg2;
- (void)_refillList;
- (void)_setNewScrollIndex:(long)arg1;
@end
