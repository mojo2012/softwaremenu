/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRImageManager.h>

@interface BRImageManager (Private)
- (void)_addWriteJobToQueue:(id)arg1 withImageID:(id)arg2 height:(int)arg3 width:(int)arg4 cropped:(BOOL)arg5;
- (void)_removeWriteJobFromQueue:(id)arg1;
- (void)_performWriteJob:(id)arg1;
- (void)_addLoadJobToQueue:(id)arg1;
- (void)_removeLoadJobFromQueue:(id)arg1;
- (void)_performLoadJob:(id)arg1;
- (BOOL)_updateExistingImageRecord:(id)arg1;
- (void)_writeImage:(id)arg1 named:(id)arg2 forSize:(struct CGSize)arg3 cropped:(BOOL)arg4;
- (id)_defaultResizingImageOptions;
- (void)_writeImageData:(id)arg1 withImageID:(id)arg2;
- (void)_removeRemoteImageRequestNamed:(id)arg1;
- (void)_removeCacheFile:(id)arg1;
- (void)_maintainImageCache:(id)arg1;
- (void)_imageLoadSucceeded:(id)arg1;
- (void)_imageLoadFailed:(id)arg1;
- (void)_postUpdateNotification:(id)arg1;
- (void)_postUnavailableImageNotification:(id)arg1;
- (void)_incrementCacheSize:(unsigned long long)arg1;
- (void)_decrementCacheSize:(unsigned long long)arg1;
- (BOOL)_isLoadJobQueued:(id)arg1;
- (id)_queuedLoadJobWithName:(id)arg1;
- (void)_terminateNotification:(id)arg1;
- (id)_writeIDForImageID:(id)arg1 cropped:(BOOL)arg2 size:(struct CGSize)arg3;
- (id)_cachedImageDirectoryPathForImageID:(id)arg1;
- (id)_cachedOriginalImagePathForImageID:(id)arg1;
- (id)_cachedResizedImageKeyForImageID:(id)arg1 forSize:(struct CGSize)arg2;
- (id)_cachedImagePathForImageID:(id)arg1 forSize:(struct CGSize)arg2;
- (id)_cachedCroppedImageKeyForImageID:(id)arg1 forSize:(struct CGSize)arg2;
- (id)_cachedCroppedImagePathForImageID:(id)arg1 forSize:(struct CGSize)arg2;
- (id)_imageFromWriteQueue:(id)arg1;
- (id)_extensionForImageID:(id)arg1;
@end
