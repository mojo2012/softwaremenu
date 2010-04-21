/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRImageLoader.h>

@interface BRImageLoader (ImageManagement)
- (void)_prepareImageForQueue:(id)arg1 withID:(id)arg2;
- (void)_enqueueImage:(id)arg1;
- (BOOL)_isQueuePrimed;
- (void)_primeQueue;
- (id)_pullNextImageProxy;
- (id)_pullNextImageProxyRandomly;
- (void)_promoteCandidateImageProxy:(id)arg1 toPendingImageProxyForImageWithID:(id)arg2;
- (void)_abandonPendingImageProxyForImageWithID:(id)arg1;
- (id)_pendingImageDictionaryForImageID:(id)arg1;
@end

