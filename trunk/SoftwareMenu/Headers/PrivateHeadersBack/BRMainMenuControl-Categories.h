/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRMainMenuControl.h>

@interface BRMainMenuControl (Categories)
+ (id)_categoryTextAttributes;
- (void)_updateCategoryProvider;
- (void)_showCategoryList;
- (void)_hideCategoryList;
- (void)_updateCategoryList;
- (void)_updateCategoryListAfterDelay:(double)arg1;
- (void)_categoryListTimerFired:(id)arg1;
- (void)_categoryListChanged:(id)arg1;
- (long)_focusedCategoryIndex;
- (float)_calculateLongestStringForColumn:(long)arg1;
- (id)_categoryListActions;
- (id)_categoryListSlowActions;
- (BOOL)_isCategoryListActive;
- (void)_updateCategoryRemembery;
- (void)_highlightDefaultCategory;
@end

