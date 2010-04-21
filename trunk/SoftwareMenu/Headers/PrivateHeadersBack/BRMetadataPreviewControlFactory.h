/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

#import "BRControlFactory-Protocol.h"
#import "BRControlHeightFactory-Protocol.h"

@interface BRMetadataPreviewControlFactory : NSObject <BRControlFactory, BRControlHeightFactory>
{
}

+ (id)factory;
- (id)controlForData:(id)arg1 currentControl:(id)arg2 requestedBy:(id)arg3;
- (float)heightForControlForData:(id)arg1 requestedBy:(id)arg2;

@end

