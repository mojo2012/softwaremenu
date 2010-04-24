/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

#import "NSCoding-Protocol.h"

@class NSMutableDictionary, NSString;

@interface BRAccount : NSObject <NSCoding>
{
    int _version;
    NSString *_assignedGUID;
    NSString *_accountName;
    NSString *_password;
    NSMutableDictionary *_metadata;
    BOOL _automaticAuthentication;
    BOOL _accountOptionsSet;
    BOOL _isSystemAccount;
}

- (id)initWithAccountName:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (void)encodeWithCoder:(id)arg1;
- (void)dealloc;
- (id)type;
- (id)accountName;
- (void)setAccountName:(id)arg1;
- (id)password;
- (void)setPassword:(id)arg1;
- (id)metadataValueForKey:(id)arg1;
- (void)setMetadataValue:(id)arg1 forKey:(id)arg2;
- (void)authenticate;
- (BOOL)isAuthenticated;
- (BOOL)isPasswordRequired;
- (BOOL)allowAutomaticAuthentication;
- (void)setAutomaticAuthentication:(BOOL)arg1;
- (void)markAsDirty;
- (BOOL)accountOptionsSet;
- (void)markAccountOptionsAsSet;
- (void)resetAccountOptions;

@end
