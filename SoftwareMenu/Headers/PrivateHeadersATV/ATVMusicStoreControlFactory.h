/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

#import "BRControlFactory-Protocol.h"
#import "BRControlHeightFactory-Protocol.h"

@class NSArray;

@interface ATVMusicStoreControlFactory : NSObject <BRControlFactory, BRControlHeightFactory>
{
    NSArray *_populators;
    BOOL _forMainMenu;
}

+ (id)standardFactory;
+ (id)mainMenuFactory;
- (id)initForMainMenu:(BOOL)arg1;
- (void)dealloc;
- (void)registerPopulator:(Class)arg1;
- (id)controlForData:(id)arg1 currentControl:(id)arg2 requestedBy:(id)arg3;
- (float)heightForControlForData:(id)arg1 requestedBy:(id)arg2;

@end
