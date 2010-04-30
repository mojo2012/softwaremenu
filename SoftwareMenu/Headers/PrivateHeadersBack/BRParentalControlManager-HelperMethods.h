/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRParentalControlManager.h>

@interface BRParentalControlManager (HelperMethods)
+ (BOOL)storeAccessRestricted;
- (int)computeAccessModeForAsset:(id)arg1;
- (int)computeAccessModeForPurchase;
- (int)computeAccessModeForPurchaseWithMediaType:(id)arg1 withRatingSystemID:(id)arg2 withRank:(id)arg3 isExplicit:(BOOL)arg4;
- (int)computeAccessModeForAppliance:(id)arg1 withCategoryIdentifier:(id)arg2;
- (id)thresholdForMediaType:(id)arg1 withRatingSystemID:(id)arg2;
@end
