/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

@class NSLock, NSMutableSet, NSTimer;

@interface BRPreferenceManager : NSObject
{
    NSLock *_preferencesLock;
    NSTimer *_prefsSyncTimer;
    NSMutableSet *_domains;
}

+ (id)sharedPreferences;
- (id)init;
- (void)dealloc;
- (id)objectForKey:(id)arg1 forDomain:(id)arg2;
- (int)integerForKey:(id)arg1 forDomain:(id)arg2 withValueForMissingPrefs:(int)arg3;
- (float)floatForKey:(id)arg1 forDomain:(id)arg2 withValueForMissingPrefs:(float)arg3;
- (double)doubleForKey:(id)arg1 forDomain:(id)arg2;
- (BOOL)boolForKey:(id)arg1 forDomain:(id)arg2 withValueForMissingPrefs:(BOOL)arg3;
- (id)stringForKey:(id)arg1 forDomain:(id)arg2;
- (id)descriptionForKey:(id)arg1 forDomain:(id)arg2;
- (BOOL)canSetPreferencesForKey:(id)arg1 forDomain:(id)arg2;
- (BOOL)setInteger:(int)arg1 forKey:(id)arg2 forDomain:(id)arg3;
- (BOOL)setFloat:(float)arg1 forKey:(id)arg2 forDomain:(id)arg3;
- (BOOL)setDouble:(double)arg1 forKey:(id)arg2 forDomain:(id)arg3;
- (BOOL)setBool:(BOOL)arg1 forKey:(id)arg2 forDomain:(id)arg3;
- (BOOL)setObject:(id)arg1 forKey:(id)arg2 forDomain:(id)arg3;
- (void)syncDomain:(id)arg1;

@end
