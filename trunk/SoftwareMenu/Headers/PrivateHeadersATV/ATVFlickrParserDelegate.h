/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "BRBaseParserDelegate.h"

@class NSMutableArray, NSMutableDictionary, NSString;

@interface ATVFlickrParserDelegate : BRBaseParserDelegate
{
    NSMutableDictionary *_errInfo;
    NSString *_userNSID;
    NSString *_userRealName;
    NSString *_userIconServer;
    NSString *_userIconFarm;
    NSMutableArray *_photoInfos;
    NSMutableArray *_photosetInfos;
    BOOL _photosetInfoCreated;
    int _curPhotosetInfoIndex;
    NSMutableArray *_contactInfos;
    NSMutableDictionary *_photoSizeInfo;
    long _photoCount;
}

+ (id)parserDelegate;
- (void)dealloc;
- (void)startErrWithAttributes:(id)arg1;
- (void)startUserWithAttributes:(id)arg1;
- (void)startPersonWithAttributes:(id)arg1;
- (void)endRealname;
- (void)endCount;
- (void)startPhotosWithAttributes:(id)arg1;
- (void)startPhotoWithAttributes:(id)arg1;
- (void)startSizeWithAttributes:(id)arg1;
- (void)startPhotosetWithAttributes:(id)arg1;
- (void)endPhotoset;
- (void)endTitle;
- (void)startContactWithAttributes:(id)arg1;
- (id)errInfo;
- (id)userNSID;
- (id)userRealName;
- (id)userIconServer;
- (id)userIconFarm;
- (long)photoCount;
- (id)photoInfos;
- (id)photosetInfos;
- (id)photosetInfosAlphabetically;
- (id)contactInfos;
- (id)largeImagePath;

@end
