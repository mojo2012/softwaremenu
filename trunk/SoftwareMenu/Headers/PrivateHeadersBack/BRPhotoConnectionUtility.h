/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

@class NSDictionary, PhotoConnection;

@interface BRPhotoConnectionUtility : NSObject
{
    id _collection;
    PhotoConnection *_photoConnection;
    NSDictionary *_albumDictionary;
    NSDictionary *_collectionPlaybackOptions;
    NSDictionary *_playbackOptions;
}

+ (id)photoConnectionUtilityForCollection:(id)arg1 delegate:(id)arg2 playbackOptions:(id)arg3;
- (id)initWithCollection:(id)arg1 delegate:(id)arg2 playbackOptions:(id)arg3;
- (void)dealloc;
- (id)photoConnection;
- (id)albumDictionary;
- (id)playbackOptionsWithStartIndex:(long)arg1;
- (id)playbackOptionsWithShuffle:(BOOL)arg1 startIndex:(long)arg2;

@end
