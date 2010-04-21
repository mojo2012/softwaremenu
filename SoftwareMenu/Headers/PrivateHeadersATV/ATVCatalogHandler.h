/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

#import "BRSelectionHandler-Protocol.h"

@class NSDictionary;

@interface ATVCatalogHandler : NSObject <BRSelectionHandler>
{
    NSDictionary *_item;
}

- (void)dealloc;
- (BOOL)handleSelectionForControl:(id)arg1;
- (void)_playOrPauseAsset:(id)arg1;
- (void)_previewItemSelected:(id)arg1;
- (void)_podcastItemSelected:(id)arg1;
- (BOOL)_handleFavoriteListItemSelection:(id)arg1 listItem:(id)arg2;
- (BOOL)_handleStoreOfferItemSelection:(id)arg1;
- (void)_warningForAction:(int)arg1 withObject:(id)arg2;
- (void)_warningForActionResponse:(id)arg1;
- (void)_confirmAction:(int)arg1 withObject:(id)arg2;
- (void)_transactionConfirmedForItem:(id)arg1;
- (void)_confirmActionResponse:(id)arg1;
- (void)_runMusicStoreTransactionDialogWithObject:(id)arg1;
- (void)_downloadItem:(id)arg1;
- (void)_parentalControlPasscodeSuccessful:(id)arg1;

@end

