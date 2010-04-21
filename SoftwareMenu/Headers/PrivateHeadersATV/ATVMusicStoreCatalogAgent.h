/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

@interface ATVMusicStoreCatalogAgent : NSObject
{
}

+ (void)initialize;
+ (id)catalogHandler;
+ (void)checkForPurchases;
+ (void)setPurchaseFunction:(void *)arg1;
+ (void)setRentalFunction:(void *)arg1;
+ (void)setSubscribeFunction:(void *)arg1;
+ (void)setDownloadFunction:(void *)arg1;
+ (void)acquireItem:(id)arg1;
+ (void)subscribeToItem:(id)arg1;
+ (long)downloadItem:(id)arg1;
+ (void)registerClass:(Class)arg1 withTemplateName:(id)arg2;
+ (void)sendPingForItem:(id)arg1;
+ (BOOL)storeVersionIsCompatibileForPageDictionary:(id)arg1 redirectURL:(id *)arg2;
+ (void)controlForObject:(id)arg1;
+ (int)itemType:(id)arg1;
+ (id)mediaTypeForItem:(id)arg1;
+ (id)mediaAssetForStoreOffer:(id)arg1;
+ (id)coverArtForItem:(id)arg1;
+ (id)coverArtURLForItem:(id)arg1 featured:(BOOL)arg2 thumbnail:(BOOL)arg3;
+ (BOOL)showAllTitles:(id)arg1;
+ (BOOL)showTitleAndSubtitle:(id)arg1;
+ (BOOL)isItemFeatured:(id)arg1;
+ (BOOL)isItemOrdered:(id)arg1;
+ (BOOL)isTemplateParameterSet:(id)arg1 forItem:(id)arg2;

@end

