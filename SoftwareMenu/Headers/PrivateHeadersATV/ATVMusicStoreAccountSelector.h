/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

@interface ATVMusicStoreAccountSelector : NSObject
{
}

+ (id)accountSelector;
- (BOOL)hasPreferredAccount;
- (id)preferredAccount;
- (id)createNewAccount;
- (id)updateAccount:(id)arg1;
- (id)askUserForNewUsernameForAccount:(id)arg1;
- (id)askUserForUsername;
- (id)askUserForPasswordForAccount:(id)arg1;
- (id)setAccountOptionsForAccount:(id)arg1;
- (long)askIfAccountPasswordShouldBeRemembered:(id)arg1;

@end

