/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRKeyboard.h>

@interface BRKeyboardRomanFull : BRKeyboard
{
}

- (id)init;
- (id)name;
- (int)mapVisualIndex:(int)arg1 toRow:(id)arg2;
- (BOOL)popupKeyboardShouldBeRightAlignedForKey:(id)arg1;
- (BOOL)canShowLanguageSwitchButton;
- (BOOL)requiresTextFieldLabel;
- (id)_keyboardDataFileName;
- (float)_preferredGlyphWidth:(id)arg1;
- (float)_preferredGlyphHeight:(id)arg1;
- (int)_numberOfMainKeyRows;
- (int)_numberOfColumnsForMainKeyRowIndex:(int)arg1;
- (id)_preferredLayoutManagerForMainKeyRow:(id)arg1 index:(int)arg2;
- (float)_mainKeysContainerSpacingScale;
- (struct CGSize)_minTextEntryControlSize:(id)arg1 resolutionScale:(float)arg2;
- (float)_topMostUIElementGap:(id)arg1 resolutionScale:(float)arg2;
- (struct CGSize)_textFieldBackgroundSize:(id)arg1 resolutionScale:(float)arg2;
- (float)_textFieldBackgroundBaseGap:(id)arg1 resolutionScale:(float)arg2;
- (struct CGSize)_mainKeysContainerSize:(id)arg1 resolutionScale:(float)arg2;
- (float)_mainKeysContainerBaseGap:(id)arg1 resolutionScale:(float)arg2;

@end
