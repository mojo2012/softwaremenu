/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

#import "BRProvider-Protocol.h"

@class BRSeriesProvider, NSMutableArray, NSSet;

@interface BRSeriesMostRecentNoStoreProvider : NSObject <BRProvider>
{
    NSSet *_mediaTypes;
    BRSeriesProvider *_seriesProvider;
    id _controlFactory;
    BRSeriesProvider *_unwatchedProvider;
    NSMutableArray *_data;
    BOOL _storeAvailable;
    BOOL _needsUpdate;
    BOOL _initialized;
}

+ (id)providerForMediaTypes:(id)arg1 controlFactory:(id)arg2 filteringOutProvider:(id)arg3;
- (void)dealloc;
- (id)controlFactory;
- (long)dataCount;
- (id)dataAtIndex:(long)arg1;
- (id)hashForDataAtIndex:(long)arg1;

@end
