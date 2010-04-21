/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRKeyboard.h>

@class BRControl, BRWaitSpinnerControl;

@interface BRKeyboardRomanSquare : BRKeyboard
{
    BRControl *_magnifyingGlassLayer;
    BRWaitSpinnerControl *_spinner;
}

- (void)dealloc;
- (void)startSpinning;
- (void)stopSpinning;
- (id)customizedTextEntryFieldControls;
- (void)customizedTextFieldControlsWereRemoved;
- (id)attributesForTextFieldLabel;
- (id)name;
- (id)actionKeyRows;
- (id)bottomRow;
- (id)actionKeysContainer;
- (void)setFocusToDefaultSwitchKeyboardGlyph:(id)arg1;
- (id)focusedControlAndRow:(id *)arg1;
- (BOOL)canShowLanguageSwitchButton;
- (id)actionDictionaryForKeyControl:(id)arg1;
- (id)_keyboardDataFileName;
- (float)_preferredGlyphWidth:(id)arg1;
- (float)_preferredGlyphHeight:(id)arg1;
- (void)_tagBottomKeyRow:(id)arg1;
- (int)_numberOfMainKeyRows;
- (int)_numberOfColumnsForMainKeyRowIndex:(int)arg1;
- (id)_preferredLayoutManagerForMainKeyRow:(id)arg1 index:(int)arg2;
- (float)_mainKeysContainerSpacingScale;
- (struct CGRect)backgroundFrame:(id)arg1 resolutionScale:(float)arg2;
- (struct CGRect)textFieldBackgroundFrame:(id)arg1 resolutionScale:(float)arg2;
- (struct CGRect)textFieldFrame:(id)arg1 resolutionScale:(float)arg2;
- (struct CGRect)tabControlFrame:(id)arg1 resolutionScale:(float)arg2;
- (struct CGRect)magnifyingGlassFrame:(id)arg1 resolutionScale:(float)arg2;
- (struct CGRect)spinnerFrame:(id)arg1 resolutionScale:(float)arg2;
- (struct CGSize)_minTextEntryControlSize:(id)arg1 resolutionScale:(float)arg2;
- (float)_topMostUIElementGap:(id)arg1 resolutionScale:(float)arg2;
- (struct CGSize)_textFieldBackgroundSize:(id)arg1 resolutionScale:(float)arg2;
- (float)_textFieldBackgroundBaseGap:(id)arg1 resolutionScale:(float)arg2;
- (float)_tabControlBaseGap:(id)arg1 resolutionScale:(float)arg2;
- (struct CGSize)_mainKeysContainerSize:(id)arg1 resolutionScale:(float)arg2;
- (float)_mainKeysContainerBaseGap:(id)arg1 resolutionScale:(float)arg2;
- (struct CGSize)_actionKeysContainerSize:(id)arg1 resolutionScale:(float)arg2;
- (float)_actionKeysContainerBaseGap:(id)arg1 resolutionScale:(float)arg2;

@end

