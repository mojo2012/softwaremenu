/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRKeyboardRomanSquare.h>

@class NSArray;

@interface BRKeyboardCandidates : BRKeyboardRomanSquare
{
    NSArray *_rawKeyboardDataStrings;
}

- (void)dealloc;
- (void)setRawKeyboardDataStrings:(id)arg1;
- (void)updateMainKeysContainer:(id)arg1;
- (id)attributesForTextFieldLabel;
- (id)name;
- (id)actionKeyRows;
- (id)bottomRow;
- (id)mainKeysContainer;
- (id)actionKeysContainer;
- (id)_keyboardDataFileName;
- (id)_rawKeyboardData;
- (float)_preferredGlyphHeight:(id)arg1;
- (int)_numberOfMainKeyRows;
- (int)_numberOfColumnsForMainKeyRowIndex:(int)arg1;
- (id)_preferredLayoutManagerForMainKeyRow:(id)arg1 index:(int)arg2;
- (id)_preferredMainKeysContainerLayoutManager;
- (int)_scrollDirectionForMainKeys;
- (float)_mainKeysContainerSpacingScale;

@end
