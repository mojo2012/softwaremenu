/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <AppleTV/ATVFlickrProvider.h>

@class ATVInternetPhotosAccount;

@interface ATVFlickrContactsProviderForAccount : ATVFlickrProvider
{
    ATVInternetPhotosAccount *_account;
}

+ (id)providerForAccount:(id)arg1;
- (id)initWithAccount:(id)arg1;
- (void)dealloc;
- (id)hashForDataAtIndex:(long)arg1;
- (id)_data;
- (BOOL)_handlesObject:(id)arg1;

@end

