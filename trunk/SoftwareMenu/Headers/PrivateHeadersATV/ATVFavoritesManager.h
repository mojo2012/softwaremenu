/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "BRSingleton.h"

@class NSMutableArray, NSString;

@interface ATVFavoritesManager : BRSingleton
{
    NSMutableArray *_favorites;
    NSString *_pathToSavedFavorites;
}

+ (id)singleton;
+ (void)setSingleton:(id)arg1;
- (id)init;
- (void)dealloc;
- (void)addFavorite:(id)arg1;
- (void)removeFavorite:(id)arg1;
- (void)reloadFavorites;
- (id)favoriteForItemID:(id)arg1;
- (BOOL)favoriteExistsForItemID:(id)arg1;
- (id)favorites;

@end
