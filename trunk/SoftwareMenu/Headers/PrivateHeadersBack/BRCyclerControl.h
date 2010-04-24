/*
 *     Generated by class-dump 3.2 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <BackRow/BRControl.h>

@class NSDictionary, NSTimer;

@interface BRCyclerControl : BRControl
{
    id _provider;
    double _interval;
    double _startInterval;
    long _index;
    long _startIndex;
    BOOL _returnsToStart;
    NSTimer *_crossFadeTimer;
    BRControl *_control;
    NSDictionary *_subcontrolMetadata;
    BOOL _crossFadeOccurred;
}

+ (id)cyclerWithProvider:(id)arg1;
- (id)initWithProvider:(id)arg1;
- (void)dealloc;
- (void)controlWasActivated;
- (void)controlWasDeactivated;
- (void)controlWasFocused;
- (void)controlWasUnfocused;
- (void)setStartIndex:(long)arg1;
- (long)startIndex;
- (void)setReturnsToStart:(BOOL)arg1;
- (BOOL)returnsToStart;
- (void)setInterval:(double)arg1;
- (double)interval;
- (void)setStartInterval:(double)arg1;
- (double)startInterval;
- (void)setSubcontrolMetaData:(id)arg1;
- (id)subcontrolMetadata;
- (id)preferredActionForKey:(id)arg1;
- (void)layoutSubcontrols;

@end
