/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

#import "BRDisplayInfoLoader-Protocol.h"

@interface ATVFlickrDisplayInfoLoader : NSObject <BRDisplayInfoLoader>
{
    id _object;
}

+ (id)displayInfoLoaderWithForObject:(id)arg1;
- (void)dealloc;
- (id)object;
- (void)setObject:(id)arg1;
- (void)loadDisplayInfo;
- (void)cancelLoadDisplayInfo;

@end

