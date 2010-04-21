/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRSingleton.h>

@class NSLock, NSMutableDictionary;

@interface BRFeatureManager : BRSingleton
{
    NSMutableDictionary *_featureDatabase;
    NSMutableDictionary *_featureCodeLookupTable;
    NSLock *_featureLock;
}

+ (id)singleton;
+ (void)setSingleton:(id)arg1;
- (id)init;
- (void)dealloc;
- (void)enableFeatureNamed:(id)arg1;
- (void)disableFeatureNamed:(id)arg1;
- (BOOL)isFeatureEnabled:(id)arg1;
- (id)availableFeatures;
- (void)resetFeatures;
- (void)toggleSettingForCode:(id)arg1;

@end

