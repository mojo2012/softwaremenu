/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

#import "BRProvider-Protocol.h"

@class NSArray;

@interface BRApplianceCategoryProvider : NSObject <BRProvider>
{
    NSArray *_categories;
}

- (void)dealloc;
- (void)setCategories:(id)arg1;
- (id)categories;
- (long)defaultCategoryIndex;
- (long)categoryIndexForIdentifier:(id)arg1;
- (id)controlFactory;
- (long)dataCount;
- (id)dataAtIndex:(long)arg1;
- (id)hashForDataAtIndex:(long)arg1;

@end
