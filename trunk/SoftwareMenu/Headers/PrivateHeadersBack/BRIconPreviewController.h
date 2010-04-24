/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class BRImageControl, BRTextControl;

@interface BRIconPreviewController : BRControl
{
    BRTextControl *_message;
    BRTextControl *_instruction;
    BRImageControl *_image;
    float _iconHeightFactor;
    float _horizontalPosition;
    float _verticalPosition;
    float _messageVerticalPosition;
}

- (id)init;
- (void)dealloc;
- (void)layoutSubcontrols;
- (void)setMessage:(id)arg1;
- (void)setMessageVerticalPosition:(float)arg1;
- (void)setImage:(id)arg1;
- (void)setInstructions:(id)arg1;
- (void)setIconHeightFactor:(float)arg1;
- (void)setIconHorizontalPosition:(float)arg1;
- (void)setIconVerticalPosition:(float)arg1;

@end
