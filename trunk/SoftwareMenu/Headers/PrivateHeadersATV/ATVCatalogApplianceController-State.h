/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <AppleTV/ATVCatalogApplianceController.h>

@interface ATVCatalogApplianceController (State)
- (void)_enterWaitingForInitialState;
- (void)_enterErrorState;
- (void)_enterWaitingForControlState;
- (void)_enterCompleteState;
- (void)_showWaitTimer:(id)arg1;
- (void)_handleWaitingForControlAction:(int)arg1;
- (void)_updateStateForAction:(int)arg1;
- (void)_swapInNewController:(id)arg1;
@end
