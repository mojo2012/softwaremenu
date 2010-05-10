/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import "BRSimpleMenuItem.h"

@class NSDate, NSString;

@interface ATVSearchTerm : BRSimpleMenuItem
{
    NSString *_searchTerm;
    NSDate *_lastUsed;
}

+ (id)searchTermWithString:(id)arg1;
- (id)initWithSearchTerm:(id)arg1 date:(id)arg2;
- (void)dealloc;
- (id)searchTerm;
- (id)lastUsed;
- (void)updateLastUsed;
- (id)title;
- (id)rightJustifiedText;
- (int)titlePosition;
- (int)menuItemType;

@end
