/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "BRPhotoMediaAsset.h"

@class ATVDotMacSecondaryAccount, NSString;

@interface ATVDotMacAsset : BRPhotoMediaAsset
{
    NSString *_parentAccountName;
    NSString *_parentCollectionIdentifier;
    ATVDotMacSecondaryAccount *_secondaryAccount;
    NSString *_dotMacIdentifier;
}

+ (id)assetWithParentAccountName:(id)arg1 parentCollectionIdentifier:(id)arg2 secondaryAccount:(id)arg3 assetInfo:(id)arg4;
- (id)initWithParentAccountName:(id)arg1 parentCollectionIdentifier:(id)arg2 secondaryAccount:(id)arg3 assetInfo:(id)arg4;
- (void)dealloc;
- (BOOL)isLocal;
- (id)mediaType;
- (id)imageProxy;
- (id)secondaryAccount;
- (void)setSecondaryAccount:(id)arg1;
- (id)parentAccountName;
- (void)setParentAccountName:(id)arg1;
- (id)parentCollectionIdentifier;
- (void)setParentCollectionIdentifier:(id)arg1;
- (id)dotMacIdentifier;
- (void)setDotMacIdentifier:(id)arg1;
- (void)configureWithAssetInfo:(id)arg1;

@end

