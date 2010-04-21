/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

#import "BRProvider-Protocol.h"

@class NSDate, NSMutableArray, NSString;

@interface ATVDotMacProvider : NSObject <BRProvider>
{
    NSMutableArray *_data;
    id _controlFactory;
    NSDate *_lastUpdateDate;
    BOOL _updatePending;
    NSString *_uniqueID;
    BOOL _chainLoadingDisabled;
    BOOL _isTemporaryProvider;
}

+ (id)providerOfPersistentAccounts;
+ (BOOL)accountWithNameIsPersistent:(id)arg1;
- (id)initAsTemporaryProvider:(BOOL)arg1;
- (void)dealloc;
- (id)controlFactory;
- (long)dataCount;
- (id)dataAtIndex:(long)arg1;
- (id)hashForDataAtIndex:(long)arg1;
- (void)setChainLoadingDisabled:(BOOL)arg1;
- (BOOL)chainLoadingDisabled;
- (void)invalidate;
- (void)handleDataUpdate:(id)arg1 updateData:(id)arg2;
- (id)uniqueID;

@end

