/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class BRImage, BRMediaPlayer, NSAttributedString, NSString, NSTimer;

@interface BRDescriptionOverlayControl : BRControl
{
    struct CGColor *_fillColor;
    BRMediaPlayer *_player;
    NSString *_imageID;
    BRImage *_image;
    BRImage *_ratingImage;
    NSAttributedString *_title;
    NSAttributedString *_publisher;
    NSAttributedString *_description;
    NSAttributedString *_pressAndHoldDescription;
    BOOL _showPressAndHoldDescription;
    NSTimer *_fadeTimer;
}

- (id)init;
- (void)dealloc;
- (void)setPlayer:(id)arg1;
- (BOOL)hasDescription;
- (void)hideOverlay;
- (void)showOverlayWithLongTimeout;
- (void)showOverlayWithLongTimeoutFromTouchRemote;
- (void)drawInContext:(struct CGContext *)arg1;

@end

