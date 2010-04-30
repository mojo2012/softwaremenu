/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRBaseMediaCollection.h>

@class BRMediaCollectionType, NSArray, NSString;

@interface BRPhotoMediaCollection : BRBaseMediaCollection
{
    NSString *_collectionName;
    NSString *_keyAssetID;
    NSString *_description;
    NSArray *_mediaAssets;
    NSString *_collectionID;
    BRMediaCollectionType *_collectionType;
    double _date;
    BOOL _dateCalculated;
}

+ (id)collectionWithCollectionInfo:(id)arg1;
- (id)initWithCollectionInfo:(id)arg1;
- (void)dealloc;
- (unsigned int)hash;
- (BOOL)isEqual:(id)arg1;
- (id)collectionName;
- (void)setCollectionName:(id)arg1;
- (id)playbackOptions;
- (id)keyAssetID;
- (void)setKeyAssetID:(id)arg1;
- (id)keyAsset;
- (id)description;
- (void)setDescription:(id)arg1;
- (id)collectionID;
- (void)setCollectionID:(id)arg1;
- (id)mediaAssets;
- (void)setMediaAssets:(id)arg1;
- (id)collectionType;
- (void)setCollectionType:(id)arg1;
- (id)date;
- (void)setDate:(id)arg1;
- (BOOL)isLibrary;
- (id)archivableCollectionInfo;

@end
