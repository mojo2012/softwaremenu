/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRDisplayManager.h>

@interface BRDisplayManager (ModeFilteringPrivate)
- (void)_nativeSizeForMode:(id)arg1 nativeWidth:(unsigned int *)arg2 nativeHeight:(unsigned int *)arg3 nativeInterlaced:(char *)arg4;
- (id)_safeModesFromModes:(id)arg1;
- (id)_supportedModes;
- (BOOL)_modeWithinLimits:(id)arg1;
- (BOOL)_shouldSwitchCurrentModeTo720PMode:(id *)arg1;
@end
