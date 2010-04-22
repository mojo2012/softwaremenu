/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class BRAsyncTask, BRImage, BRWaitSpinnerControl, NSString;

@interface BRAsyncImageControl : BRControl
{
    id _imageProxy;
    BRWaitSpinnerControl *_spinner;
    BRImage *_image;
    BRImage *_defaultImage;
    BRAsyncTask *_imageProcessingTask;
    NSString *_imageID;
    BOOL _cropAndFill;
    BOOL _useLoadingSpinner;
    BOOL _loadFailure;
    BOOL _imageLoadRequested;
    BOOL _useLoadFailureImage;
    BOOL _loadOnActivation;
    BOOL _okToLoadImage;
    BOOL _useFadeInAnimation;
    int _requestedSize;
}

+ (id)imageControlWithImageProxy:(id)arg1;
- (id)initWithImageProxy:(id)arg1;
- (void)dealloc;
- (void)setLoadImageOnActivation:(BOOL)arg1;
- (void)loadImage;
- (void)cancelImageLoading;
- (void)controlWasActivated;
- (void)controlWasDeactivated;
- (id)imageProxy;
- (void)setDefaultImage:(id)arg1;
- (void)setUseLoadingSpinner:(BOOL)arg1;
- (void)setCropAndFill:(BOOL)arg1;
- (void)setUseLoadFailureImage:(BOOL)arg1;
- (void)setUseFadeInAnimation:(BOOL)arg1;
- (void)layoutSubcontrols;

@end
