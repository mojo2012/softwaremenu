/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class BRActionShelfControl, BRCoverArtPreviewControl, BRDividerControl;

@interface BRDetailedMediaControl : BRControl
{
    BRControl *_metadata;
    BRCoverArtPreviewControl *_image;
    BRControl *_textLine;
    BRControl *_previewBrowser;
    BRActionShelfControl *_actionShelf;
    BRDividerControl *_divider;
    id _metadataProvider;
    id _textLineProvider;
    id _previewBrowserProvider;
    int _style;
    BOOL _detailsTogglingEnabled;
    BOOL _autoRefreshMetadata;
}

- (id)init;
- (void)dealloc;
- (BOOL)brEventAction:(id)arg1;
- (struct CGRect)focusCursorFrame;
- (void)enableDetailsToggling;
- (void)setDetailControlStyle:(int)arg1;
- (int)detailControlStyle;
- (void)setImageProxy:(id)arg1;
- (void)setCoverArtPreviewControl:(id)arg1;
- (id)coverArtPreviewControl;
- (void)setTextLineProvider:(id)arg1;
- (void)setTextLine:(id)arg1;
- (id)textLineProvider;
- (void)setMetadataProvider:(id)arg1;
- (id)metadataProvider;
- (void)setDetailedMetadataControl:(id)arg1;
- (id)detailedMetadataControl;
- (void)setPreviewBrowserProvider:(id)arg1;
- (id)previewBrowserProvider;
- (void)setAutoRefreshMetadata:(BOOL)arg1;
- (void)setActionProviders:(id)arg1;
- (id)actionProviders;
- (void)setActionSelectionHandler:(id)arg1;
- (void)setActionStyle:(int)arg1;
- (void)setActionFocusedIndex:(long)arg1;
- (void)layoutSubcontrols;

@end
