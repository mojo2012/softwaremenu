/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRMediaPlayerManager.h>

@interface BRMediaPlayerManager (Private)
- (Class)_findRegisteredPlayerClassForType:(id)arg1 visualContent:(BOOL)arg2;
- (id)_playerInstanceForAssetAtIndex:(long)arg1 inTrackList:(id)arg2;
- (id)_playerInstanceForClass:(Class)arg1;
- (int)_calculateAccessModeForExtrasAsset:(id)arg1;
@end
