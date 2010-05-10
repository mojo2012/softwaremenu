/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class BRHeaderControl, BRScrollingTextBoxControl, NSAttributedString, NSString;

@interface BRScrollingTextControl : BRControl
{
    BRHeaderControl *_header;
    BRScrollingTextBoxControl *_textBox;
    BRControl *_buttonGrid;
    NSAttributedString *_attributedString;
    long _selectedIndex;
    NSString *_dialogIdentifier;
}

+ (int)postControlAsDialogWithTitle:(id)arg1 text:(id)arg2;
+ (int)postControlAsDialogWithTitle:(id)arg1 text:(id)arg2 firstButton:(id)arg3 secondButton:(id)arg4 thirdButton:(id)arg5 defaultFocus:(int)arg6;
+ (id)controlWithTitle:(id)arg1 text:(id)arg2 firstButton:(id)arg3 secondButton:(id)arg4 thirdButton:(id)arg5 defaultFocus:(int)arg6;
+ (id)controlWithTitle:(id)arg1 documentPath:(id)arg2 firstButton:(id)arg3 secondButton:(id)arg4 thirdButton:(id)arg5 defaultFocus:(int)arg6;
- (id)init;
- (void)dealloc;
- (void)setTitle:(id)arg1;
- (void)setText:(id)arg1;
- (void)setAttributedString:(id)arg1;
- (id)attributedString;
- (void)setDocumentPath:(id)arg1;
- (void)setDocumentPath:(id)arg1 encoding:(unsigned int)arg2;
- (void)addButtonWithTitle:(id)arg1 isDefaultFocus:(BOOL)arg2;
- (BOOL)brEventAction:(id)arg1;
- (void)setSelectionHandler:(id)arg1;
- (void)layoutSubcontrols;

@end
