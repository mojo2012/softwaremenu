/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRSoundHandler.h>

@interface BRSoundHandler (BRSoundHandlerPrivate)
+ (BOOL)_audioDeviceIsAvailable;
- (unsigned long)_actionIDForAlertSound:(int)arg1;
- (void)_updateSoundEnabledState:(id)arg1;
- (BOOL)_isSoundEnabled;
- (void)_SSSCommandWatchTimerCallback:(id)arg1;
- (void)_playSound:(int)arg1;
- (void)_reloadSoundPreference;
@end
