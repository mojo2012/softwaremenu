/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

@interface BRMediaCollectionEditor : NSObject
{
    id _collection;
}

+ (void)setImplementationClass:(Class)arg1;
+ (id)editorForCollection:(id)arg1;
- (id)initWithMediaCollection:(id)arg1;
- (void)dealloc;
- (id)collectionCopyWithName:(id)arg1;
- (void)addMediaObjectToCollection:(id)arg1;
- (void)removeMediaObjectFromCollection:(id)arg1;
- (void)clearCollection;
- (id)collection;

@end
