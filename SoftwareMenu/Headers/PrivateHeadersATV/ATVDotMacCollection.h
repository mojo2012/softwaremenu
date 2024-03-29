/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <AppleTV/ATVInternetPhotosCollection.h>

#import "ATVDotMacAuthentication-Protocol.h"

@class ATVDotMacSecondaryAccount, NSString;

@interface ATVDotMacCollection : ATVInternetPhotosCollection <ATVDotMacAuthentication>
{
    ATVDotMacSecondaryAccount *_secondaryAccount;
    BOOL _requiresAuthentication;
    NSString *_keyImageDotMacIdentifier;
    BOOL _initialAuthCheckComplete;
}

- (id)initWithCollectionInfo:(id)arg1;
- (void)dealloc;
- (id)keyImageDotMacIdentifier;
- (void)setKeyImageDotMacIdentifier:(id)arg1;
- (id)archivableCollectionInfo;
- (id)mediaTypes;
- (id)imageProxy;
- (BOOL)isAuthenticated;
- (BOOL)requiresAuthentication;
- (void)setRequiresAuthentication:(BOOL)arg1;
- (id)secondaryAccount;
- (void)setSecondaryAccount:(id)arg1;
- (BOOL)initialAuthCheckComplete;
- (void)setInitialAuthCheckComplete:(BOOL)arg1;

@end

