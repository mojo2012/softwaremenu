/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "BRPhotoMediaCollection.h"

@class NSDate, NSString;

@interface ATVInternetPhotosCollection : BRPhotoMediaCollection
{
    NSDate *_modDate;
    NSDate *_lastCheckedDate;
    NSString *_parentAccountName;
    NSString *_parentAccountID;
    NSString *_previewURL;
}

- (void)dealloc;
- (id)modDate;
- (void)setModDate:(id)arg1;
- (id)parentAccountName;
- (void)setParentAccountName:(id)arg1;
- (id)parentAccountID;
- (void)setParentAccountID:(id)arg1;
- (long)numberOfPhotos;
- (id)collectionDictionary;
- (BOOL)isLocal;
- (id)lastCheckedDate;
- (void)setLastCheckedDate:(id)arg1;
- (void)setPreviewURL:(id)arg1;
- (id)previewURL;

@end
