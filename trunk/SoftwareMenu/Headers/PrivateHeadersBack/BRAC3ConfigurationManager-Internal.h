/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRAC3ConfigurationManager.h>

@interface BRAC3ConfigurationManager (Internal)
+ (long)_setShouldPerformSoftwareDecode:(BOOL)arg1 onTrack:(struct TrackType **)arg2;
+ (long)_getSoftwareDecodePreference:(char *)arg1 forTrack:(struct TrackType **)arg2;
- (long)_setMirroringEnabled:(BOOL)arg1;
- (long)_setPassthruEnabled:(BOOL)arg1;
- (long)_cloneTrack:(struct TrackType **)arg1 cloneShouldPerformSoftwareDecode:(BOOL)arg2 outputTrack:(struct TrackType ***)arg3;
@end
