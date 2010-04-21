/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class BRDividerControl, BRHeaderControl, BRImageControl, BRReflectionControl, BRTextControl;

@interface BRAlertControl : BRControl
{
    id _eventDelegate;
    SEL _eventSelector;
    BRHeaderControl *_header;
    BRDividerControl *_divider;
    int _type;
    BRTextControl *_primary;
    BRTextControl *_secondary;
    BRImageControl *_image;
    BRReflectionControl *_reflection;
}

+ (id)alertForError:(id)arg1;
+ (id)alertOfType:(int)arg1 titled:(id)arg2 primaryText:(id)arg3 secondaryText:(id)arg4;
+ (id)alertOfType:(int)arg1;
- (id)init;
- (id)initWithType:(int)arg1;
- (id)initWithType:(int)arg1 titled:(id)arg2 primaryText:(id)arg3 secondaryText:(id)arg4;
- (void)dealloc;
- (void)controlWasActivated;
- (void)setType:(int)arg1;
- (void)setTitle:(id)arg1;
- (id)title;
- (void)setPrimaryText:(id)arg1;
- (void)setPrimaryText:(id)arg1 withAttributes:(id)arg2;
- (id)primaryText;
- (void)setSecondaryText:(id)arg1;
- (id)secondaryText;
- (void)setSecondaryText:(id)arg1 withAttributes:(id)arg2;
- (void)setImage:(id)arg1;
- (id)image;
- (void)layoutSubcontrols;

@end

