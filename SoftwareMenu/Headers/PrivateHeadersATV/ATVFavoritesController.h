/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "BRController.h"

@class BRCursorControl;

@interface ATVFavoritesController : BRController
{
    int _itemType;
    BRCursorControl *_cursor;
}

- (id)initWithItemType:(int)arg1 error:(id *)arg2;
- (void)dealloc;
- (void)controlWasActivated;
- (void)controlWasDeactivated;
- (BOOL)isNetworkDependent;

@end
