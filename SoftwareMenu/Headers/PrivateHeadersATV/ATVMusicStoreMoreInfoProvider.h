/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

#import "BRProvider-Protocol.h"

@class NSDictionary, NSMutableArray;

@interface ATVMusicStoreMoreInfoProvider : NSObject <BRProvider>
{
    NSDictionary *_catalogItem;
    NSMutableArray *_items;
}

+ (id)providerWithCatalogItem:(id)arg1;
- (id)initWithCatalogItem:(id)arg1;
- (void)dealloc;
- (id)controlFactory;
- (long)dataCount;
- (id)dataAtIndex:(long)arg1;
- (id)hashForDataAtIndex:(long)arg1;

@end
