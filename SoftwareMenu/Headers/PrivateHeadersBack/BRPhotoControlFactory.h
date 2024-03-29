/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "NSObject.h"

#import "BRControlFactory-Protocol.h"
#import "BRControlHeightFactory-Protocol.h"

@class NSDateFormatter;

@interface BRPhotoControlFactory : NSObject <BRControlFactory, BRControlHeightFactory>
{
    id _selectionHandler;
    NSDateFormatter *_formatter;
    BOOL _useMinimumImages;
    BOOL _useLocalProviders;
}

+ (id)standardFactory;
+ (id)mainMenuFactory;
- (id)initForMainMenu:(BOOL)arg1;
- (void)dealloc;
- (id)controlForData:(id)arg1 currentControl:(id)arg2 requestedBy:(id)arg3;
- (id)selectionHandler;
- (void)setSelectionHandler:(id)arg1;
- (float)heightForControlForData:(id)arg1 requestedBy:(id)arg2;
- (void)setUseMinimumImages:(BOOL)arg1;
- (BOOL)useMinumumImages;
- (id)formatter;

@end

