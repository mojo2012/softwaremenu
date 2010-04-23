/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <AppleTV/ATVDotMacAsset.h>

@class NSString;

@interface ATVDotMacVideoAsset : ATVDotMacAsset
{
    long _duration;
    NSString *_title;
    NSString *_mediaURL;
    NSString *_description;
}

+ (id)assetWithParentAccountName:(id)arg1 parentCollectionIdentifier:(id)arg2 secondaryAccount:(id)arg3 assetInfo:(id)arg4;
- (void)dealloc;
- (id)mediaURL;
- (void)setMediaURL:(id)arg1;
- (id)title;
- (void)setTitle:(id)arg1;
- (long)duration;
- (void)setDuration:(long)arg1;
- (id)mediaDescription;
- (void)setDescription:(id)arg1;
- (id)mediaType;
- (void)configureWithAssetInfo:(id)arg1;

@end
