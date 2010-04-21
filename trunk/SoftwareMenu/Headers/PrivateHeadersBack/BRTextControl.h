/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

#import "BRAXTitleChangeProtocol-Protocol.h"

@class NSAttributedString;

@interface BRTextControl : BRControl <BRAXTitleChangeProtocol>
{
    NSAttributedString *_string;
}

- (id)init;
- (void)dealloc;
- (void)setText:(id)arg1 withAttributes:(id)arg2;
- (void)setAttributedString:(id)arg1;
- (id)attributedString;
- (struct CGSize)renderedSize;
- (struct CGSize)renderedSizeWithMaxSize:(struct CGSize)arg1;
- (void)drawInContext:(struct CGContext *)arg1;
- (struct CGSize)preferredFrameSize;
- (id)axTitleText;
- (struct CGSize)sizeThatFits:(struct CGSize)arg1;

@end

