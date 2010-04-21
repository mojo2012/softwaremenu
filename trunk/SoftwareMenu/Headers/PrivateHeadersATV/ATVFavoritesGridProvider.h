/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

#import "BRProvider-Protocol.h"

@class NSArray;

@interface ATVFavoritesGridProvider : NSObject <BRProvider>
{
    int _itemType;
    NSArray *_favorites;
}

+ (id)providerWithItemType:(int)arg1;
- (id)initWithItemType:(int)arg1;
- (void)dealloc;
- (id)dataAtIndex:(long)arg1;
- (long)dataCount;
- (id)controlFactory;
- (id)hashForDataAtIndex:(long)arg1;

@end

