/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRSettingsFacade.h>

@interface BRSettingsFacade (Private)
- (void)_networkStateChanged:(id)arg1;
- (void)_setSlideshowSelectedPlaylistName:(id)arg1 forHost:(id)arg2;
- (id)_slideshowSelectedPlaylistNameForHost:(id)arg1;
- (short)_languageCodeForLocalizedName:(id)arg1;
- (long)_preferredTrackIDForMedia:(id)arg1 forType:(id)arg2;
- (void)_savePreferredTrackID:(long)arg1 forMedia:(id)arg2 forType:(id)arg3;
- (void)_removeSavedPreferredTrackIDsForType:(id)arg1;
@end
